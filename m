Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC1059785C
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 23:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242153AbiHQU6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 16:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242128AbiHQU5Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 16:57:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4826AB431;
        Wed, 17 Aug 2022 13:57:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4B52B81F69;
        Wed, 17 Aug 2022 20:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963DCC433D7;
        Wed, 17 Aug 2022 20:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660769834;
        bh=mjXcQDnb3hbG98qgUEjRDWRgcUMXoEfckFtI5f2ExAE=;
        h=Date:To:From:Subject:From;
        b=tDEcNZgNlxunPTMJgoUUhUh1QjN9ZBDdhXSFiImcIl8Nko9oUuL0QudMnEV+isc6P
         fOBDKIiMwMGOaQk4WGYYZipiydPlbZF3IvUGkJ6L4DW8YfgvY/9UZAWMHnZ+M2zlUX
         zoFYdIK52MobusHUQqOQYwQBTEapwSOfWaxPj0N0=
Date:   Wed, 17 Aug 2022 13:57:13 -0700
To:     mm-commits@vger.kernel.org, xemul@parallels.com,
        stable@vger.kernel.org, songmuchun@bytedance.com,
        pfeiner@google.com, peterx@redhat.com, n-horiguchi@ah.jp.nec.com,
        mike.kravetz@oracle.com, kirill.shutemov@linux.intel.com,
        jamieliu@google.com, hughd@google.com, gorcunov@openvz.org,
        bhelgaas@google.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-support-write-faults-in-shared-mappings.patch removed from -mm tree
Message-Id: <20220817205714.963DCC433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: support write-faults in shared mappings
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-support-write-faults-in-shared-mappings.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: <stable@vger.kernel.org>	[5.19]
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


