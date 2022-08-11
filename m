Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368EF58FAB8
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 12:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbiHKKev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 06:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234569AbiHKKer (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 06:34:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 591298A6FD
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 03:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660214085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=puIeEE5EBQVmYFlkdO7BnHuthpubncB97aYdL9X76dA=;
        b=LhgjZvd6wohEdd0FACUXF9xbYIOfDZZ6Uy6ZTTF2bz6f7XuknOaHINedfLoNosdkP/bCM9
        pp8O73/0WKXFw/LurUoy6IZtb1HpVNbvttMAq8TGOTRxk940Rs+2FsfzFbqsLYH8depgcr
        4YL0iPDEX2eCIA0fmmw2mGVtskt43LI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-wP32eH3zPkuZKfT6rHCuMA-1; Thu, 11 Aug 2022 06:34:41 -0400
X-MC-Unique: wP32eH3zPkuZKfT6rHCuMA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08E3A8039BA;
        Thu, 11 Aug 2022 10:34:41 +0000 (UTC)
Received: from t480s.fritz.box (unknown [10.39.193.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BECA1492C3B;
        Thu, 11 Aug 2022 10:34:39 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/2] mm/hugetlb: support write-faults in shared mappings
Date:   Thu, 11 Aug 2022 12:34:35 +0200
Message-Id: <20220811103435.188481-3-david@redhat.com>
In-Reply-To: <20220811103435.188481-1-david@redhat.com>
References: <20220811103435.188481-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we ever get a write-fault on a write-protected page in a shared mapping,
we'd be in trouble (again). Instead, we can simply map the page writable.

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
unregistering and consequently keeps the PTE writeprotected. Reason for
this is to avoid the additional overhead when unregistering. Note
that this is the case also for !hugetlb and that we will end up with
writable PTEs that still have the uffd-wp PTE bit set once we return
from hugetlb_wp(). I'm not touching the uffd-wp PTE bit for now, because it
seems to be a generic thing -- wp_page_reuse() also doesn't clear it.

VM_MAYSHARE handling in hugetlb_fault() for FAULT_FLAG_WRITE
indicates that MAP_SHARED handling was at least envisioned, but could never
have worked as expected.

While at it, make sure that we never end up in hugetlb_wp() on write
faults without VM_WRITE, because we don't support maybe_mkwrite()
semantics as commonly used in the !hugetlb case -- for example, in
wp_page_reuse().

Note that there is no need to do any kind of reservation in hugetlb_fault()
in this case ... because we already have a hugetlb page mapped R/O
that we will simply map writable and we are not dealing with COW/unsharing.

Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
Cc: <stable@vger.kernel.org> # v5.19
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/hugetlb.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0aee2f3ae15c..2480ba627aa5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5241,6 +5241,21 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
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
 
@@ -5781,12 +5796,11 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
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
@@ -5794,9 +5808,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		/* Just decrements count, does not deallocate */
 		vma_end_reservation(h, vma, haddr);
 
-		if (!(vma->vm_flags & VM_MAYSHARE))
-			pagecache_page = hugetlbfs_pagecache_page(h,
-								vma, haddr);
+		pagecache_page = hugetlbfs_pagecache_page(h, vma, haddr);
 	}
 
 	ptl = huge_pte_lock(h, mm, ptep);
-- 
2.35.3

