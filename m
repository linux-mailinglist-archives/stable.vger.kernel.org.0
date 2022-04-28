Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDBE75138EB
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 17:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349433AbiD1PqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 11:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349448AbiD1PqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 11:46:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A58B715C;
        Thu, 28 Apr 2022 08:42:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF1FC61F95;
        Thu, 28 Apr 2022 15:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F3DC385AA;
        Thu, 28 Apr 2022 15:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651160566;
        bh=4dKNV+ceiLtd6M4VTt7w+2x33yEvnPjHequM8WdzUY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ndhhVA0zXP0WKVFtbkSbktkcOBNoTftoBdq4wF6SHbEtuWfWziLbWN05RUXoEPHMH
         M3tiFUjiIFRjJ+c9hC+k8+BXuliPMVMvD9WfQMUep2NNI2htsWKKElWyw83RvnXrsU
         gI6I8IePYVp65dcSW2vnN+8fk5VvW+sGOYm9VVg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>, Yang Shi <shy828301@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH AUTOSEL 14/14] mm/thp: fix NR_FILE_MAPPED accounting in page_*_file_rmap()
Date:   Thu, 28 Apr 2022 17:42:22 +0200
Message-Id: <20220428154222.1230793-14-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
References: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4320; i=gregkh@linuxfoundation.org; h=from:subject; bh=DY9PobJ+iVCOW4dJoQet7IIvSJy1rG7kl8G4mbSfMDg=; b=owGbwMvMwCRo6H6F97bub03G02pJDElZW++tOOTj5W0tkVux6LONokf0tOCAnWxPfbl+8a1Ov5XE NO1tRywLgyATg6yYIsuXbTxH91ccUvQytD0NM4eVCWQIAxenAExk8iGGBY0ME0XPNm/Ul1RreRU4ma ecd3JQJsOCS/NeH5qxYWqa+NofpXpXd8+MDfSfCAA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit 5d543f13e2f5580828de885c751d68a35b6a493d upstream.

NR_FILE_MAPPED accounting in mm/rmap.c (for /proc/meminfo "Mapped" and
/proc/vmstat "nr_mapped" and the memcg's memory.stat "mapped_file") is
slightly flawed for file or shmem huge pages.

It is well thought out, and looks convincing, but there's a racy case when
the careful counting in page_remove_file_rmap() (without page lock) gets
discarded.  So that in a workload like two "make -j20" kernel builds under
memory pressure, with cc1 on hugepage text, "Mapped" can easily grow by a
spurious 5MB or more on each iteration, ending up implausibly bigger than
most other numbers in /proc/meminfo.  And, hypothetically, might grow to
the point of seriously interfering in mm/vmscan.c's heuristics, which do
take NR_FILE_MAPPED into some consideration.

Fixed by moving the __mod_lruvec_page_state() down to where it will not be
missed before return (and I've grown a bit tired of that oft-repeated
but-not-everywhere comment on the __ness: it gets lost in the move here).

Does page_add_file_rmap() need the same change?  I suspect not, because
page lock is held in all relevant cases, and its skipping case looks safe;
but it's much easier to be sure, if we do make the same change.

Link: https://lkml.kernel.org/r/e02e52a1-8550-a57c-ed29-f51191ea2375@google.com
Fixes: dd78fedde4b9 ("rmap: support file thp")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/rmap.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 444d0d958aff..fa09b5eaff34 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1239,14 +1239,14 @@ void page_add_new_anon_rmap(struct page *page,
  */
 void page_add_file_rmap(struct page *page, bool compound)
 {
-	int i, nr = 1;
+	int i, nr = 0;
 
 	VM_BUG_ON_PAGE(compound && !PageTransHuge(page), page);
 	lock_page_memcg(page);
 	if (compound && PageTransHuge(page)) {
 		int nr_pages = thp_nr_pages(page);
 
-		for (i = 0, nr = 0; i < nr_pages; i++) {
+		for (i = 0; i < nr_pages; i++) {
 			if (atomic_inc_and_test(&page[i]._mapcount))
 				nr++;
 		}
@@ -1279,17 +1279,18 @@ void page_add_file_rmap(struct page *page, bool compound)
 			if (PageMlocked(page))
 				clear_page_mlock(head);
 		}
-		if (!atomic_inc_and_test(&page->_mapcount))
-			goto out;
+		if (atomic_inc_and_test(&page->_mapcount))
+			nr++;
 	}
-	__mod_lruvec_page_state(page, NR_FILE_MAPPED, nr);
 out:
+	if (nr)
+		__mod_lruvec_page_state(page, NR_FILE_MAPPED, nr);
 	unlock_page_memcg(page);
 }
 
 static void page_remove_file_rmap(struct page *page, bool compound)
 {
-	int i, nr = 1;
+	int i, nr = 0;
 
 	VM_BUG_ON_PAGE(compound && !PageHead(page), page);
 
@@ -1304,12 +1305,12 @@ static void page_remove_file_rmap(struct page *page, bool compound)
 	if (compound && PageTransHuge(page)) {
 		int nr_pages = thp_nr_pages(page);
 
-		for (i = 0, nr = 0; i < nr_pages; i++) {
+		for (i = 0; i < nr_pages; i++) {
 			if (atomic_add_negative(-1, &page[i]._mapcount))
 				nr++;
 		}
 		if (!atomic_add_negative(-1, compound_mapcount_ptr(page)))
-			return;
+			goto out;
 		if (PageSwapBacked(page))
 			__mod_lruvec_page_state(page, NR_SHMEM_PMDMAPPED,
 						-nr_pages);
@@ -1317,16 +1318,13 @@ static void page_remove_file_rmap(struct page *page, bool compound)
 			__mod_lruvec_page_state(page, NR_FILE_PMDMAPPED,
 						-nr_pages);
 	} else {
-		if (!atomic_add_negative(-1, &page->_mapcount))
-			return;
+		if (atomic_add_negative(-1, &page->_mapcount))
+			nr++;
 	}
 
-	/*
-	 * We use the irq-unsafe __{inc|mod}_lruvec_page_state because
-	 * these counters are not modified in interrupt context, and
-	 * pte lock(a spinlock) is held, which implies preemption disabled.
-	 */
-	__mod_lruvec_page_state(page, NR_FILE_MAPPED, -nr);
+out:
+	if (nr)
+		__mod_lruvec_page_state(page, NR_FILE_MAPPED, -nr);
 
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
-- 
2.36.0

