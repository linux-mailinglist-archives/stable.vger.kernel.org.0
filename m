Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28C82474C2
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387537AbgHQTO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:14:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387473AbgHQPkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:40:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5053023134;
        Mon, 17 Aug 2020 15:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678800;
        bh=/cuD2ZRHke61dcElaO4+21/PDcRJpbABFxPbMOpsJZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4+vxnFmRkQqfpWKjGJhG6ASD5VoOgplMPENxbRmev91oKDGXj8QpKatQoZJPrvls
         K7vUTX/Kk9WMr/Rp8CMHfKTuU/c/sGa22tslr09/V0EsrFFI8UZEuJ+D3ql4nr4gBZ
         gInB8YXkLWFuEmj+w/hWB9ypNEeF7Yu/ulZT51Fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.8 459/464] s390/gmap: improve THP splitting
Date:   Mon, 17 Aug 2020 17:16:52 +0200
Message-Id: <20200817143855.761687827@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit ba925fa35057a062ac98c3e8138b013ce4ce351c upstream.

During s390_enable_sie(), we need to take care of splitting all qemu user
process THP mappings. This is currently done with follow_page(FOLL_SPLIT),
by simply iterating over all vma ranges, with PAGE_SIZE increment.

This logic is sub-optimal and can result in a lot of unnecessary overhead,
especially when using qemu and ASAN with large shadow map. Ilya reported
significant system slow-down with one CPU busy for a long time and overall
unresponsiveness.

Fix this by using walk_page_vma() and directly calling split_huge_pmd()
only for present pmds, which greatly reduces overhead.

Cc: <stable@vger.kernel.org> # v5.4+
Reported-by: Ilya Leoshkevich <iii@linux.ibm.com>
Tested-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/mm/gmap.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2485,23 +2485,36 @@ void gmap_sync_dirty_log_pmd(struct gmap
 }
 EXPORT_SYMBOL_GPL(gmap_sync_dirty_log_pmd);
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static int thp_split_walk_pmd_entry(pmd_t *pmd, unsigned long addr,
+				    unsigned long end, struct mm_walk *walk)
+{
+	struct vm_area_struct *vma = walk->vma;
+
+	split_huge_pmd(vma, pmd, addr);
+	return 0;
+}
+
+static const struct mm_walk_ops thp_split_walk_ops = {
+	.pmd_entry	= thp_split_walk_pmd_entry,
+};
+
 static inline void thp_split_mm(struct mm_struct *mm)
 {
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	struct vm_area_struct *vma;
-	unsigned long addr;
 
 	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
-		for (addr = vma->vm_start;
-		     addr < vma->vm_end;
-		     addr += PAGE_SIZE)
-			follow_page(vma, addr, FOLL_SPLIT);
 		vma->vm_flags &= ~VM_HUGEPAGE;
 		vma->vm_flags |= VM_NOHUGEPAGE;
+		walk_page_vma(vma, &thp_split_walk_ops, NULL);
 	}
 	mm->def_flags |= VM_NOHUGEPAGE;
-#endif
 }
+#else
+static inline void thp_split_mm(struct mm_struct *mm)
+{
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 /*
  * Remove all empty zero pages from the mapping for lazy refaulting


