Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01908603CF9
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbiJSIzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbiJSIxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:53:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97CCB1C7;
        Wed, 19 Oct 2022 01:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 091EA617D6;
        Wed, 19 Oct 2022 08:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDC4C433C1;
        Wed, 19 Oct 2022 08:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168865;
        bh=je0W2XLdwrvLTtP83c1MCms7oFNpxun5DNxSf+R8vrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUXjKpV8yX6ffgMhn2TCcJzVJBmMryNxHqIDfeQRWDwSV+0/wzHUxrTVgz+oM8/vv
         QAytusM2xVrS2YzJ9310Pyyj5CAmvroEoZDVXZOILriTY80bEoM5re+os3HGZZOxuO
         U7C4aLPHCgmOdFoDug4KdichjIPTB4f2uiT2nzPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        syzbot+c2c79c6d6eddc5262b77@syzkaller.appspotmail.com,
        Steven Price <steven.price@arm.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 6.0 080/862] arm64: mte: Avoid setting PG_mte_tagged if no tags cleared or restored
Date:   Wed, 19 Oct 2022 10:22:47 +0200
Message-Id: <20221019083253.465868363@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

commit a8e5e5146ad08d794c58252bab00b261045ef16d upstream.

Prior to commit 69e3b846d8a7 ("arm64: mte: Sync tags for pages where PTE
is untagged"), mte_sync_tags() was only called for pte_tagged() entries
(those mapped with PROT_MTE). Therefore mte_sync_tags() could safely use
test_and_set_bit(PG_mte_tagged, &page->flags) without inadvertently
setting PG_mte_tagged on an untagged page.

The above commit was required as guests may enable MTE without any
control at the stage 2 mapping, nor a PROT_MTE mapping in the VMM.
However, the side-effect was that any page with a PTE that looked like
swap (or migration) was getting PG_mte_tagged set automatically. A
subsequent page copy (e.g. migration) copied the tags to the destination
page even if the tags were owned by KASAN.

This issue was masked by the page_kasan_tag_reset() call introduced in
commit e5b8d9218951 ("arm64: mte: reset the page tag in page->flags").
When this commit was reverted (20794545c146), KASAN started reporting
access faults because the overriding tags in a page did not match the
original page->flags (with CONFIG_KASAN_HW_TAGS=y):

  BUG: KASAN: invalid-access in copy_page+0x10/0xd0 arch/arm64/lib/copy_page.S:26
  Read at addr f5ff000017f2e000 by task syz-executor.1/2218
  Pointer tag: [f5], memory tag: [f2]

Move the PG_mte_tagged bit setting from mte_sync_tags() to the actual
place where tags are cleared (mte_sync_page_tags()) or restored
(mte_restore_tags()).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: syzbot+c2c79c6d6eddc5262b77@syzkaller.appspotmail.com
Fixes: 69e3b846d8a7 ("arm64: mte: Sync tags for pages where PTE is untagged")
Cc: <stable@vger.kernel.org> # 5.14.x
Cc: Steven Price <steven.price@arm.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/0000000000004387dc05e5888ae5@google.com/
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20221006163354.3194102-1-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/mte.c |    9 +++++++--
 arch/arm64/mm/mteswap.c |    7 ++++++-
 2 files changed, 13 insertions(+), 3 deletions(-)

--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -48,7 +48,12 @@ static void mte_sync_page_tags(struct pa
 	if (!pte_is_tagged)
 		return;
 
-	mte_clear_page_tags(page_address(page));
+	/*
+	 * Test PG_mte_tagged again in case it was racing with another
+	 * set_pte_at().
+	 */
+	if (!test_and_set_bit(PG_mte_tagged, &page->flags))
+		mte_clear_page_tags(page_address(page));
 }
 
 void mte_sync_tags(pte_t old_pte, pte_t pte)
@@ -64,7 +69,7 @@ void mte_sync_tags(pte_t old_pte, pte_t
 
 	/* if PG_mte_tagged is set, tags have already been initialised */
 	for (i = 0; i < nr_pages; i++, page++) {
-		if (!test_and_set_bit(PG_mte_tagged, &page->flags))
+		if (!test_bit(PG_mte_tagged, &page->flags))
 			mte_sync_page_tags(page, old_pte, check_swap,
 					   pte_is_tagged);
 	}
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -53,7 +53,12 @@ bool mte_restore_tags(swp_entry_t entry,
 	if (!tags)
 		return false;
 
-	mte_restore_page_tags(page_address(page), tags);
+	/*
+	 * Test PG_mte_tagged again in case it was racing with another
+	 * set_pte_at().
+	 */
+	if (!test_and_set_bit(PG_mte_tagged, &page->flags))
+		mte_restore_page_tags(page_address(page), tags);
 
 	return true;
 }


