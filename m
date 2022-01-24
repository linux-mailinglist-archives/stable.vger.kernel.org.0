Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D87D4981BF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238670AbiAXOGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238648AbiAXOG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 09:06:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1B3C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 06:06:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1719E612F5
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 14:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2473C340E9;
        Mon, 24 Jan 2022 14:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643033188;
        bh=a4dYYJ6VC+Q1kubYKb2NANFKQom1XyfiwFC1ywwTNPs=;
        h=Subject:To:Cc:From:Date:From;
        b=M25NkzKCzHW3vweQEWWlyNiomX3ppAcv3upwk4TrJhREfQDw3Nq4Ht4zGRyX7g/tv
         AfgycnpLV0aILkq3zBA5kB6XTFzOfG7839G5T+iD2Tl+E/ZOQXTQwX7n1n6h/6qf+O
         WtQ++Npxwv3S9Tupc+6FpQns8bI8lQxNKHuqihyk=
Subject: FAILED: patch "[PATCH] mm/hmm.c: allow VM_MIXEDMAP to work with hmm_range_fault" failed to apply to 5.4-stable tree
To:     apopple@nvidia.com, Felix.Kuehling@amd.com,
        akpm@linux-foundation.org, jgg@nvidia.com, jglisse@redhat.com,
        jhubbard@nvidia.com, rcampbell@nvidia.com,
        torvalds@linux-foundation.org, ziy@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 15:06:15 +0100
Message-ID: <164303317518491@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 87c01d57fa23de82fff593a7d070933d08755801 Mon Sep 17 00:00:00 2001
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 14 Jan 2022 14:09:31 -0800
Subject: [PATCH] mm/hmm.c: allow VM_MIXEDMAP to work with hmm_range_fault

hmm_range_fault() can be used instead of get_user_pages() for devices
which allow faulting however unlike get_user_pages() it will return an
error when used on a VM_MIXEDMAP range.

To make hmm_range_fault() more closely match get_user_pages() remove
this restriction.  This requires dealing with the !ARCH_HAS_PTE_SPECIAL
case in hmm_vma_handle_pte().  Rather than replicating the logic of
vm_normal_page() call it directly and do a check for the zero pfn
similar to what get_user_pages() currently does.

Also add a test to hmm selftest to verify functionality.

Link: https://lkml.kernel.org/r/20211104012001.2555676-1-apopple@nvidia.com
Fixes: da4c3c735ea4 ("mm/hmm/mirror: helper to snapshot CPU page table")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index e2ce8f9b7605..767538089a62 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1086,9 +1086,33 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
 	return 0;
 }
 
+static int dmirror_fops_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	unsigned long addr;
+
+	for (addr = vma->vm_start; addr < vma->vm_end; addr += PAGE_SIZE) {
+		struct page *page;
+		int ret;
+
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!page)
+			return -ENOMEM;
+
+		ret = vm_insert_page(vma, addr, page);
+		if (ret) {
+			__free_page(page);
+			return ret;
+		}
+		put_page(page);
+	}
+
+	return 0;
+}
+
 static const struct file_operations dmirror_fops = {
 	.open		= dmirror_fops_open,
 	.release	= dmirror_fops_release,
+	.mmap		= dmirror_fops_mmap,
 	.unlocked_ioctl = dmirror_fops_unlocked_ioctl,
 	.llseek		= default_llseek,
 	.owner		= THIS_MODULE,
diff --git a/mm/hmm.c b/mm/hmm.c
index 842e26599238..bd56641c79d4 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -300,7 +300,8 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	 * Since each architecture defines a struct page for the zero page, just
 	 * fall through and treat it like a normal page.
 	 */
-	if (pte_special(pte) && !pte_devmap(pte) &&
+	if (!vm_normal_page(walk->vma, addr, pte) &&
+	    !pte_devmap(pte) &&
 	    !is_zero_pfn(pte_pfn(pte))) {
 		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
 			pte_unmap(ptep);
@@ -518,7 +519,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
 	struct hmm_range *range = hmm_vma_walk->range;
 	struct vm_area_struct *vma = walk->vma;
 
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP | VM_MIXEDMAP)) &&
+	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
 	    vma->vm_flags & VM_READ)
 		return 0;
 
diff --git a/tools/testing/selftests/vm/hmm-tests.c b/tools/testing/selftests/vm/hmm-tests.c
index 864f126ffd78..203323967b50 100644
--- a/tools/testing/selftests/vm/hmm-tests.c
+++ b/tools/testing/selftests/vm/hmm-tests.c
@@ -1248,6 +1248,48 @@ TEST_F(hmm, anon_teardown)
 	}
 }
 
+/*
+ * Test memory snapshot without faulting in pages accessed by the device.
+ */
+TEST_F(hmm, mixedmap)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned char *m;
+	int ret;
+
+	npages = 1;
+	size = npages << self->page_shift;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = size;
+	buffer->mirror = malloc(npages);
+	ASSERT_NE(buffer->mirror, NULL);
+
+
+	/* Reserve a range of addresses. */
+	buffer->ptr = mmap(NULL, size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE,
+			   self->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	/* Simulate a device snapshotting CPU pagetables. */
+	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_SNAPSHOT, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device saw. */
+	m = buffer->mirror;
+	ASSERT_EQ(m[0], HMM_DMIRROR_PROT_READ);
+
+	hmm_buffer_free(buffer);
+}
+
 /*
  * Test memory snapshot without faulting in pages accessed by the device.
  */

