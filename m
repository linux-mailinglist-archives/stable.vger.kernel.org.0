Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F39464A156
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbiLLNip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbiLLNh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:37:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE37BCE4
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:37:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48DEE6106F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44DEC433EF;
        Mon, 12 Dec 2022 13:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852256;
        bh=Ul3RsEuzdnXmuIUuvGNnAF23Ti2hrg9ktnfRVmMzPzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+ksemGc/OV2QxGMwKheWxFGbTT1QyToLiuLFCs6djtALNOmqLwIeBwxyF4uLq4W8
         9RRoZ185qK9RR5U92sIB+7vpSsjc4jt9MYC8rgk5An9kYyoSzCQNH7bAuis0rHJepF
         n4PQP6PGNxJ5yn9RBXrGlfWSspj+TMLaUMnCnepg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mike Kravetz <mike.kravetz@oracle.com>,
        Wei Chen <harperchen1110@gmail.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Mina Almasry <almasrymina@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 045/157] hugetlb: dont delete vma_lock in hugetlb MADV_DONTNEED processing
Date:   Mon, 12 Dec 2022 14:16:33 +0100
Message-Id: <20221212130936.358448651@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mike Kravetz <mike.kravetz@oracle.com>

commit 04ada095dcfc4ae359418053c0be94453bdf1e84 upstream.

madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear page
tables associated with the address range.  For hugetlb vmas,
zap_page_range will call __unmap_hugepage_range_final.  However,
__unmap_hugepage_range_final assumes the passed vma is about to be removed
and deletes the vma_lock to prevent pmd sharing as the vma is on the way
out.  In the case of madvise(MADV_DONTNEED) the vma remains, but the
missing vma_lock prevents pmd sharing and could potentially lead to issues
with truncation/fault races.

This issue was originally reported here [1] as a BUG triggered in
page_try_dup_anon_rmap.  Prior to the introduction of the hugetlb
vma_lock, __unmap_hugepage_range_final cleared the VM_MAYSHARE flag to
prevent pmd sharing.  Subsequent faults on this vma were confused as
VM_MAYSHARE indicates a sharable vma, but was not set so page_mapping was
not set in new pages added to the page table.  This resulted in pages that
appeared anonymous in a VM_SHARED vma and triggered the BUG.

Address issue by adding a new zap flag ZAP_FLAG_UNMAP to indicate an unmap
call from unmap_vmas().  This is used to indicate the 'final' unmapping of
a hugetlb vma.  When called via MADV_DONTNEED, this flag is not set and
the vm_lock is not deleted.

NOTE - Prior to the introduction of the huegtlb vma_lock in v6.1,  this
       issue is addressed by not clearing the VM_MAYSHARE flag when
       __unmap_hugepage_range_final is called in the MADV_DONTNEED case.

[1] https://lore.kernel.org/lkml/CAO4mrfdLMXsao9RF4fUE8-Wfde8xmjsKrTNMNC9wjUb6JudD0g@mail.gmail.com/

Link: https://lkml.kernel.org/r/20221114235507.294320-3-mike.kravetz@oracle.com
Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm.h |  2 ++
 mm/hugetlb.c       | 25 ++++++++++++++-----------
 mm/memory.c        |  2 +-
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index df804bf5f4a5..4ff52127a6b8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1794,6 +1794,8 @@ struct zap_details {
  * default, the flag is not set.
  */
 #define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
+/* Set in unmap_vmas() to indicate a final unmap call.  Only used by hugetlb */
+#define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))
 
 #ifdef CONFIG_MMU
 extern bool can_do_mlock(void);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index dbb558e71e9e..022a3bfafec4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5145,17 +5145,20 @@ void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 {
 	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
 
-	/*
-	 * Clear this flag so that x86's huge_pmd_share page_table_shareable
-	 * test will fail on a vma being torn down, and not grab a page table
-	 * on its way out.  We're lucky that the flag has such an appropriate
-	 * name, and can in fact be safely cleared here. We could clear it
-	 * before the __unmap_hugepage_range above, but all that's necessary
-	 * is to clear it before releasing the i_mmap_rwsem. This works
-	 * because in the context this is called, the VMA is about to be
-	 * destroyed and the i_mmap_rwsem is held.
-	 */
-	vma->vm_flags &= ~VM_MAYSHARE;
+	if (zap_flags & ZAP_FLAG_UNMAP) {	/* final unmap */
+		/*
+		 * Clear this flag so that x86's huge_pmd_share
+		 * page_table_shareable test will fail on a vma being torn
+		 * down, and not grab a page table on its way out.  We're lucky
+		 * that the flag has such an appropriate name, and can in fact
+		 * be safely cleared here. We could clear it before the
+		 * __unmap_hugepage_range above, but all that's necessary
+		 * is to clear it before releasing the i_mmap_rwsem. This works
+		 * because in the context this is called, the VMA is about to
+		 * be destroyed and the i_mmap_rwsem is held.
+		 */
+		vma->vm_flags &= ~VM_MAYSHARE;
+	}
 }
 
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
diff --git a/mm/memory.c b/mm/memory.c
index 68d5b3dcec2e..a0fdaa74091f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1712,7 +1712,7 @@ void unmap_vmas(struct mmu_gather *tlb,
 {
 	struct mmu_notifier_range range;
 	struct zap_details details = {
-		.zap_flags = ZAP_FLAG_DROP_MARKER,
+		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
 		/* Careful - we need to zap private pages too! */
 		.even_cows = true,
 	};
-- 
2.35.1



