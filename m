Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3839C5FFEB5
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 12:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiJPKsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 06:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJPKs3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 06:48:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0413CBF0
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 03:48:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B16CB80C63
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 10:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850D2C433D6;
        Sun, 16 Oct 2022 10:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665917306;
        bh=mdVqMDS0CBJV8J3vGb7WLK572wxVpZGOvVwb+TS5nj0=;
        h=Subject:To:Cc:From:Date:From;
        b=GdPnw5DpMM5mrUlbstJDDznLULq4QuNYqBf3hLgdc5BBxLrJxnXIGdk7xLixq7Ug8
         McwmaY3LGlys7wnON2GARpBofG3ll7GLjEBhVNVJmRkM/bxTGLaLV8NveiF1xIs0Q0
         CPEtoaIRWCgr05d06rB0XQnFJOyiR7+wjnWXqCb0=
Subject: FAILED: patch "[PATCH] arm64: mte: Avoid setting PG_mte_tagged if no tags cleared or" failed to apply to 5.15-stable tree
To:     catalin.marinas@arm.com, andreyknvl@gmail.com,
        stable@vger.kernel.org, steven.price@arm.com,
        vincenzo.frascino@arm.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 12:49:03 +0200
Message-ID: <166591734323359@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

a8e5e5146ad0 ("arm64: mte: Avoid setting PG_mte_tagged if no tags cleared or restored")
20794545c146 ("arm64: kasan: Revert "arm64: mte: reset the page tag in page->flags"")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a8e5e5146ad08d794c58252bab00b261045ef16d Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 6 Oct 2022 17:33:54 +0100
Subject: [PATCH] arm64: mte: Avoid setting PG_mte_tagged if no tags cleared or
 restored

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

diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index aca88470fb69..7467217c1eaf 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -48,7 +48,12 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
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
@@ -64,7 +69,7 @@ void mte_sync_tags(pte_t old_pte, pte_t pte)
 
 	/* if PG_mte_tagged is set, tags have already been initialised */
 	for (i = 0; i < nr_pages; i++, page++) {
-		if (!test_and_set_bit(PG_mte_tagged, &page->flags))
+		if (!test_bit(PG_mte_tagged, &page->flags))
 			mte_sync_page_tags(page, old_pte, check_swap,
 					   pte_is_tagged);
 	}
diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
index 4334dec93bd4..bed803d8e158 100644
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -53,7 +53,12 @@ bool mte_restore_tags(swp_entry_t entry, struct page *page)
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

