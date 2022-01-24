Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD4849918C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352367AbiAXULp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:11:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36238 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354486AbiAXUJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:09:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5E5E6091B;
        Mon, 24 Jan 2022 20:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9B7C340E5;
        Mon, 24 Jan 2022 20:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054963;
        bh=8VJ5DOh9GMO1apj0w6QDm4S3TRwOpzb1AAjkoMUZWbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+Y6pZvUUF4a2IPKoLRyk3jzCbQZhXa22sfMhaCjHGB1kcHQWlZ4dC3HTNpCdtCaM
         vyuYJMKTnx3zUJT31RtTXq7NwQD3cOZ/Nn5Tvvue7zCq1gN33m98ZkJORUy6ds1zXK
         jo6IFy3KaKleXuoq4kNWzNS7PJY2BIfnjXaMi9vY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alistair Popple <apopple@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>, Zi Yan <ziy@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 560/563] mm/hmm.c: allow VM_MIXEDMAP to work with hmm_range_fault
Date:   Mon, 24 Jan 2022 19:45:25 +0100
Message-Id: <20220124184043.818421244@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alistair Popple <apopple@nvidia.com>

commit 87c01d57fa23de82fff593a7d070933d08755801 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_hmm.c                         |   24 ++++++++++++++++++
 mm/hmm.c                               |    5 ++-
 tools/testing/selftests/vm/hmm-tests.c |   42 +++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 2 deletions(-)

--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -965,9 +965,33 @@ static long dmirror_fops_unlocked_ioctl(
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
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -296,7 +296,8 @@ static int hmm_vma_handle_pte(struct mm_
 	 * Since each architecture defines a struct page for the zero page, just
 	 * fall through and treat it like a normal page.
 	 */
-	if (pte_special(pte) && !pte_devmap(pte) &&
+	if (!vm_normal_page(walk->vma, addr, pte) &&
+	    !pte_devmap(pte) &&
 	    !is_zero_pfn(pte_pfn(pte))) {
 		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
 			pte_unmap(ptep);
@@ -514,7 +515,7 @@ static int hmm_vma_walk_test(unsigned lo
 	struct hmm_range *range = hmm_vma_walk->range;
 	struct vm_area_struct *vma = walk->vma;
 
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP | VM_MIXEDMAP)) &&
+	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
 	    vma->vm_flags & VM_READ)
 		return 0;
 
--- a/tools/testing/selftests/vm/hmm-tests.c
+++ b/tools/testing/selftests/vm/hmm-tests.c
@@ -1245,6 +1245,48 @@ TEST_F(hmm, anon_teardown)
 /*
  * Test memory snapshot without faulting in pages accessed by the device.
  */
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
+/*
+ * Test memory snapshot without faulting in pages accessed by the device.
+ */
 TEST_F(hmm2, snapshot)
 {
 	struct hmm_buffer *buffer;


