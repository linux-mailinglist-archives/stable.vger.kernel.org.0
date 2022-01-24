Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C57F499E43
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1588136AbiAXWbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584640AbiAXWVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157BFC0424EF;
        Mon, 24 Jan 2022 12:52:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A807D60907;
        Mon, 24 Jan 2022 20:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4DCC340E5;
        Mon, 24 Jan 2022 20:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057534;
        bh=8ni2Qb1gdwnoxG6Yoqx7ckQ60AVfkgHrHpUVlMKZax8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0vTfZ1YDP0fGaJ04EKArWDytLSN4etv1n5g29/TVSQM22gpucJ48btJKkZF50h8v7
         3S3PRADKSA+D/rKOCGQcNSs3ksDVcrFKC7zRL+xsANaIDDv2AsqGogUdG0OXjgvufJ
         O/G1vQtkMtFc5+VmsMLowJYcVXH3ca0dr+MgkMyM=
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
Subject: [PATCH 5.15 844/846] mm/hmm.c: allow VM_MIXEDMAP to work with hmm_range_fault
Date:   Mon, 24 Jan 2022 19:46:01 +0100
Message-Id: <20220124184130.016535793@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
@@ -1087,9 +1087,33 @@ static long dmirror_fops_unlocked_ioctl(
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
@@ -300,7 +300,8 @@ static int hmm_vma_handle_pte(struct mm_
 	 * Since each architecture defines a struct page for the zero page, just
 	 * fall through and treat it like a normal page.
 	 */
-	if (pte_special(pte) && !pte_devmap(pte) &&
+	if (!vm_normal_page(walk->vma, addr, pte) &&
+	    !pte_devmap(pte) &&
 	    !is_zero_pfn(pte_pfn(pte))) {
 		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
 			pte_unmap(ptep);
@@ -518,7 +519,7 @@ static int hmm_vma_walk_test(unsigned lo
 	struct hmm_range *range = hmm_vma_walk->range;
 	struct vm_area_struct *vma = walk->vma;
 
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP | VM_MIXEDMAP)) &&
+	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
 	    vma->vm_flags & VM_READ)
 		return 0;
 
--- a/tools/testing/selftests/vm/hmm-tests.c
+++ b/tools/testing/selftests/vm/hmm-tests.c
@@ -1251,6 +1251,48 @@ TEST_F(hmm, anon_teardown)
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


