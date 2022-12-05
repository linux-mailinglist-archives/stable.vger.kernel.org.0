Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55FDD643375
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbiLETgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234510AbiLETgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:36:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4778D17A96
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:33:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB8D5B811F3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28123C433C1;
        Mon,  5 Dec 2022 19:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268778;
        bh=hQHuqteUKcNzGKTh2KUNyAHHmISifaE/8HG6Lrrw4KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KwS01QKtDxDeqg8ICygq6apbf7cOjGX+QTe6Q44D2ydf1PNEADv3Hic0z5ZXoNACQ
         +iPwuSDRIJVyRU3AXj8Ed0dmrDUEWDMW3Fzgi5Y/T+92tddXu3QGpXWUpHWodaZLns
         QRig3C3xStX2SVHoVExIcRE5954N6tcf31tnvcYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
        syzbot+c2c79c6d6eddc5262b77@syzkaller.appspotmail.com,
        Steven Price <steven.price@arm.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/120] arm64: mte: Avoid setting PG_mte_tagged if no tags cleared or restored
Date:   Mon,  5 Dec 2022 20:09:01 +0100
Message-Id: <20221205190806.571868750@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

[ Upstream commit a8e5e5146ad08d794c58252bab00b261045ef16d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/mte.c | 9 +++++++--
 arch/arm64/mm/mteswap.c | 7 ++++++-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index dacca0684ea3..a3898bac5ae6 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -53,7 +53,12 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
 	 * the new page->flags are visible before the tags were updated.
 	 */
 	smp_wmb();
-	mte_clear_page_tags(page_address(page));
+	/*
+	 * Test PG_mte_tagged again in case it was racing with another
+	 * set_pte_at().
+	 */
+	if (!test_and_set_bit(PG_mte_tagged, &page->flags))
+		mte_clear_page_tags(page_address(page));
 }
 
 void mte_sync_tags(pte_t old_pte, pte_t pte)
@@ -69,7 +74,7 @@ void mte_sync_tags(pte_t old_pte, pte_t pte)
 
 	/* if PG_mte_tagged is set, tags have already been initialised */
 	for (i = 0; i < nr_pages; i++, page++) {
-		if (!test_and_set_bit(PG_mte_tagged, &page->flags))
+		if (!test_bit(PG_mte_tagged, &page->flags))
 			mte_sync_page_tags(page, old_pte, check_swap,
 					   pte_is_tagged);
 	}
diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
index 7c4ef56265ee..fd6cabc6d033 100644
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -62,7 +62,12 @@ bool mte_restore_tags(swp_entry_t entry, struct page *page)
 	 * the new page->flags are visible before the tags were updated.
 	 */
 	smp_wmb();
-	mte_restore_page_tags(page_address(page), tags);
+	/*
+	 * Test PG_mte_tagged again in case it was racing with another
+	 * set_pte_at().
+	 */
+	if (!test_and_set_bit(PG_mte_tagged, &page->flags))
+		mte_restore_page_tags(page_address(page), tags);
 
 	return true;
 }
-- 
2.35.1



