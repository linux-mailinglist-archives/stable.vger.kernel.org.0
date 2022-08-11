Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCD0590839
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 23:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbiHKVob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 17:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbiHKVo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 17:44:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695D6A00D0;
        Thu, 11 Aug 2022 14:44:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4A0361491;
        Thu, 11 Aug 2022 21:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D3CC433D7;
        Thu, 11 Aug 2022 21:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660254266;
        bh=Zo+nZ1eJlv7mFysgWh+CTQaFNC78JLrCO36+pCeo5ds=;
        h=Date:To:From:Subject:From;
        b=jdjS7diir8NhXOz4fPFYpM6HwS3SqHApPTpnYzTsEtYbMRBEHUtFwXg0JcDs3EULA
         k0PlVHSm8cyxExubhjAJaxZx9GZJVr9W2eoPp7VlvXETsql7L+EnX1VhH7yovhGJ93
         NGOOdB+dD+tWRQV9SWkvCNMiMA3/VmurzcoQhd0s=
Date:   Thu, 11 Aug 2022 14:44:25 -0700
To:     mm-commits@vger.kernel.org, xemul@parallels.com,
        stable@vger.kernel.org, songmuchun@bytedance.com,
        pfeiner@google.com, peterx@redhat.com, n-horiguchi@ah.jp.nec.com,
        mike.kravetz@oracle.com, kirill.shutemov@linux.intel.com,
        jamieliu@google.com, hughd@google.com, gorcunov@openvz.org,
        bhelgaas@google.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-support-write-faults-in-shared-mappings.patch added to mm-hotfixes-unstable branch
Message-Id: <20220811214426.45D3CC433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: support write-faults in shared mappings
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-support-write-faults-in-shared-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-support-write-faults-in-shared-mappings.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/hugetlb: support write-faults in shared mappings
Date: Thu, 11 Aug 2022 12:34:35 +0200

If we ever get a write-fault on a write-protected page in a shared
mapping, we'd be in trouble (again).  Instead, we can simply map the page
writable.

And in fact, there is even a way right now to trigger that code via
uffd-wp ever since we stared to support it for shmem in 5.19:

--------------------------------------------------------------------------
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <errno.h>
 #include <sys/mman.h>
 #include <sys/syscall.h>
 #include <sys/ioctl.h>
 #include <linux/userfaultfd.h>

 #define HUGETLB_SIZE (2 * 1024 * 1024u)

 static char *map;
 int uffd;

 static int temp_setup_uffd(void)
 {
 	struct uffdio_api uffdio_api;
 	struct uffdio_register uffdio_register;
 	struct uffdio_writeprotect uffd_writeprotect;
 	struct uffdio_range uffd_range;

 	uffd = syscall(__NR_userfaultfd,
 		       O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY);
 	if (uffd < 0) {
 		fprintf(stderr, "syscall() failed: %d\n", errno);
 		return -errno;
 	}

 	uffdio_api.api = UFFD_API;
 	uffdio_api.features = UFFD_FEATURE_PAGEFAULT_FLAG_WP;
 	if (ioctl(uffd, UFFDIO_API, &uffdio_api) < 0) {
 		fprintf(stderr, "UFFDIO_API failed: %d\n", errno);
 		return -errno;
 	}

 	if (!(uffdio_api.features & UFFD_FEATURE_PAGEFAULT_FLAG_WP)) {
 		fprintf(stderr, "UFFD_FEATURE_WRITEPROTECT missing\n");
 		return -ENOSYS;
 	}

 	/* Register UFFD-WP */
 	uffdio_register.range.start = (unsigned long) map;
 	uffdio_register.range.len = HUGETLB_SIZE;
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_WP;
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) < 0) {
 		fprintf(stderr, "UFFDIO_REGISTER failed: %d\n", errno);
 		return -errno;
 	}

 	/* Writeprotect a single page. */
 	uffd_writeprotect.range.start = (unsigned long) map;
 	uffd_writeprotect.range.len = HUGETLB_SIZE;
 	uffd_writeprotect.mode = UFFDIO_WRITEPROTECT_MODE_WP;
 	if (ioctl(uffd, UFFDIO_WRITEPROTECT, &uffd_writeprotect)) {
 		fprintf(stderr, "UFFDIO_WRITEPROTECT failed: %d\n", errno);
 		return -errno;
 	}

 	/* Unregister UFFD-WP without prior writeunprotection. */
 	uffd_range.start = (unsigned long) map;
 	uffd_range.len = HUGETLB_SIZE;
 	if (ioctl(uffd, UFFDIO_UNREGISTER, &uffd_range)) {
 		fprintf(stderr, "UFFDIO_UNREGISTER failed: %d\n", errno);
 		return -errno;
 	}

 	return 0;
 }

 int main(int argc, char **argv)
 {
 	int fd;

 	fd = open("/dev/hugepages/tmp", O_RDWR | O_CREAT);
 	if (!fd) {
 		fprintf(stderr, "open() failed\n");
 		return -errno;
 	}
 	if (ftruncate(fd, HUGETLB_SIZE)) {
 		fprintf(stderr, "ftruncate() failed\n");
 		return -errno;
 	}

 	map = mmap(NULL, HUGETLB_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
 	if (map == MAP_FAILED) {
 		fprintf(stderr, "mmap() failed\n");
 		return -errno;
 	}

 	*map = 0;

 	if (temp_setup_uffd())
 		return 1;

 	*map = 0;

 	return 0;
 }
--------------------------------------------------------------------------

Above test fails with SIGBUS when there is only a single free hugetlb page.
 # echo 1 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
 # ./test
 Bus error (core dumped)

And worse, with sufficient free hugetlb pages it will map an anonymous page
into a shared mapping, for example, messing up accounting during unmap
and breaking MAP_SHARED semantics:
 # echo 2 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
 # ./test
 # cat /proc/meminfo | grep HugePages_
 HugePages_Total:       2
 HugePages_Free:        1
 HugePages_Rsvd:    18446744073709551615
 HugePages_Surp:        0

Reason is that uffd-wp doesn't clear the uffd-wp PTE bit when
unregistering and consequently keeps the PTE writeprotected.  Reason for
this is to avoid the additional overhead when unregistering.  Note that
this is the case also for !hugetlb and that we will end up with writable
PTEs that still have the uffd-wp PTE bit set once we return from
hugetlb_wp().  I'm not touching the uffd-wp PTE bit for now, because it
seems to be a generic thing -- wp_page_reuse() also doesn't clear it.

VM_MAYSHARE handling in hugetlb_fault() for FAULT_FLAG_WRITE indicates
that MAP_SHARED handling was at least envisioned, but could never have
worked as expected.

While at it, make sure that we never end up in hugetlb_wp() on write
faults without VM_WRITE, because we don't support maybe_mkwrite()
semantics as commonly used in the !hugetlb case -- for example, in
wp_page_reuse().

Note that there is no need to do any kind of reservation in
hugetlb_fault() in this case ...  because we already have a hugetlb page
mapped R/O that we will simply map writable and we are not dealing with
COW/unsharing.

Link: https://lkml.kernel.org/r/20220811103435.188481-3-david@redhat.com
Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>	[5.19]

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jamie Liu <jamieliu@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-support-write-faults-in-shared-mappings
+++ a/mm/hugetlb.c
@@ -5241,6 +5241,21 @@ static vm_fault_t hugetlb_wp(struct mm_s
 	VM_BUG_ON(unshare && (flags & FOLL_WRITE));
 	VM_BUG_ON(!unshare && !(flags & FOLL_WRITE));
 
+	/*
+	 * hugetlb does not support FOLL_FORCE-style write faults that keep the
+	 * PTE mapped R/O such as maybe_mkwrite() would do.
+	 */
+	if (WARN_ON_ONCE(!unshare && !(vma->vm_flags & VM_WRITE)))
+		return VM_FAULT_SIGSEGV;
+
+	/* Let's take out MAP_SHARED mappings first. */
+	if (vma->vm_flags & VM_MAYSHARE) {
+		if (unlikely(unshare))
+			return 0;
+		set_huge_ptep_writable(vma, haddr, ptep);
+		return 0;
+	}
+
 	pte = huge_ptep_get(ptep);
 	old_page = pte_page(pte);
 
@@ -5781,12 +5796,11 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	 * If we are going to COW/unshare the mapping later, we examine the
 	 * pending reservations for this page now. This will ensure that any
 	 * allocations necessary to record that reservation occur outside the
-	 * spinlock. For private mappings, we also lookup the pagecache
-	 * page now as it is used to determine if a reservation has been
-	 * consumed.
+	 * spinlock. Also lookup the pagecache page now as it is used to
+	 * determine if a reservation has been consumed.
 	 */
 	if ((flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) &&
-	    !huge_pte_write(entry)) {
+	    !(vma->vm_flags & VM_MAYSHARE) && !huge_pte_write(entry)) {
 		if (vma_needs_reservation(h, vma, haddr) < 0) {
 			ret = VM_FAULT_OOM;
 			goto out_mutex;
@@ -5794,9 +5808,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		/* Just decrements count, does not deallocate */
 		vma_end_reservation(h, vma, haddr);
 
-		if (!(vma->vm_flags & VM_MAYSHARE))
-			pagecache_page = hugetlbfs_pagecache_page(h,
-								vma, haddr);
+		pagecache_page = hugetlbfs_pagecache_page(h, vma, haddr);
 	}
 
 	ptl = huge_pte_lock(h, mm, ptep);
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-fix-foll_force-cow-security-issue-and-remove-foll_cow.patch
mm-hugetlb-fix-hugetlb-not-supporting-softdirty-tracking.patch
mm-hugetlb-support-write-faults-in-shared-mappings.patch

