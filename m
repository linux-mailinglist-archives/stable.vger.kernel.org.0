Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3C25A4970
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbiH2LZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbiH2LYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:24:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA04E5F986;
        Mon, 29 Aug 2022 04:15:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C69A0B80F92;
        Mon, 29 Aug 2022 11:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1FCC433C1;
        Mon, 29 Aug 2022 11:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771258;
        bh=+6fmvp2c8S1VZMDzHF7AuaBHo0zZ6cBpda3+aSMaIfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ldMTFut+R0y7pUj3gHrXs8ssZFHHooCU00NNtY3JHz9LYT+6vTiaus6xd4eU0Lpgk
         bOur0TBtJEf4SNxoyBRjkvLJRYnS0r/hNa1f6F+gVJptZkGAzmIWKkafflEdSe/MqI
         bp4CwEW7ghjgl+8z/e5HKulFd8lgkBu4EqWENXcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        Jamie Liu <jamieliu@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 010/158] mm/hugetlb: support write-faults in shared mappings
Date:   Mon, 29 Aug 2022 12:57:40 +0200
Message-Id: <20220829105809.263492648@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit 1d8d14641fd94a01b20a4abbf2749fd8eddcf57b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5232,6 +5232,21 @@ static vm_fault_t hugetlb_wp(struct mm_s
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
 
@@ -5766,12 +5781,11 @@ vm_fault_t hugetlb_fault(struct mm_struc
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
@@ -5779,9 +5793,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		/* Just decrements count, does not deallocate */
 		vma_end_reservation(h, vma, haddr);
 
-		if (!(vma->vm_flags & VM_MAYSHARE))
-			pagecache_page = hugetlbfs_pagecache_page(h,
-								vma, haddr);
+		pagecache_page = hugetlbfs_pagecache_page(h, vma, haddr);
 	}
 
 	ptl = huge_pte_lock(h, mm, ptep);


