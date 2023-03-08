Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D4A6AFBB9
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 02:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjCHBFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 20:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjCHBFb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 20:05:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB785A6D4;
        Tue,  7 Mar 2023 17:05:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 223A8B81B2F;
        Wed,  8 Mar 2023 01:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD499C433EF;
        Wed,  8 Mar 2023 01:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678237527;
        bh=W6x39h3HEuZh6fXKUTMq0Vz6v7l8KHlzSFvg4EiTC88=;
        h=Date:To:From:Subject:From;
        b=NDSFnXW32alilzeSERTM0wCn41k2NHZgdzBdS91Sr/ahArHc1qzdEKxZAZQqdPdLA
         r45HWsJbvItf5DayRIAyQK3eIzl3HltsZreYrk+/3MYzJRxROwYAmx8O6iZD04pWyW
         tsFT6axcEO/GrZvKZMcJeSvHGz2d/mA0IaF5lg6Q=
Date:   Tue, 07 Mar 2023 17:05:27 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, shli@fb.com,
        rppt@linux.vnet.ibm.com, peterx@redhat.com, jglisse@redhat.com,
        aarcange@redhat.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-userfaultfd-propagate-uffd-wp-bit-when-pte-mapping-the-huge-zeropage.patch removed from -mm tree
Message-Id: <20230308010527.CD499C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/userfaultfd: propagate uffd-wp bit when PTE-mapping the huge zeropage
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-propagate-uffd-wp-bit-when-pte-mapping-the-huge-zeropage.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/userfaultfd: propagate uffd-wp bit when PTE-mapping the huge zeropage
Date: Thu, 2 Mar 2023 18:54:23 +0100

Currently, we'd lose the userfaultfd-wp marker when PTE-mapping a huge
zeropage, resulting in the next write faults in the PMD range not
triggering uffd-wp events.

Various actions (partial MADV_DONTNEED, partial mremap, partial munmap,
partial mprotect) could trigger this.  However, most importantly,
un-protecting a single sub-page from the userfaultfd-wp handler when
processing a uffd-wp event will PTE-map the shared huge zeropage and lose
the uffd-wp bit for the remainder of the PMD.

Let's properly propagate the uffd-wp bit to the PMDs.

 #define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <stdint.h>
 #include <stdbool.h>
 #include <inttypes.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <errno.h>
 #include <poll.h>
 #include <pthread.h>
 #include <sys/mman.h>
 #include <sys/syscall.h>
 #include <sys/ioctl.h>
 #include <linux/userfaultfd.h>

 static size_t pagesize;
 static int uffd;
 static volatile bool uffd_triggered;

 #define barrier() __asm__ __volatile__("": : :"memory")

 static void uffd_wp_range(char *start, size_t size, bool wp)
 {
 	struct uffdio_writeprotect uffd_writeprotect;

 	uffd_writeprotect.range.start = (unsigned long) start;
 	uffd_writeprotect.range.len = size;
 	if (wp) {
 		uffd_writeprotect.mode = UFFDIO_WRITEPROTECT_MODE_WP;
 	} else {
 		uffd_writeprotect.mode = 0;
 	}
 	if (ioctl(uffd, UFFDIO_WRITEPROTECT, &uffd_writeprotect)) {
 		fprintf(stderr, "UFFDIO_WRITEPROTECT failed: %d\n", errno);
 		exit(1);
 	}
 }

 static void *uffd_thread_fn(void *arg)
 {
 	static struct uffd_msg msg;
 	ssize_t nread;

 	while (1) {
 		struct pollfd pollfd;
 		int nready;

 		pollfd.fd = uffd;
 		pollfd.events = POLLIN;
 		nready = poll(&pollfd, 1, -1);
 		if (nready == -1) {
 			fprintf(stderr, "poll() failed: %d\n", errno);
 			exit(1);
 		}

 		nread = read(uffd, &msg, sizeof(msg));
 		if (nread <= 0)
 			continue;

 		if (msg.event != UFFD_EVENT_PAGEFAULT ||
 		    !(msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WP)) {
 			printf("FAIL: wrong uffd-wp event fired\n");
 			exit(1);
 		}

 		/* un-protect the single page. */
 		uffd_triggered = true;
 		uffd_wp_range((char *)(uintptr_t)msg.arg.pagefault.address,
 			      pagesize, false);
 	}
 	return arg;
 }

 static int setup_uffd(char *map, size_t size)
 {
 	struct uffdio_api uffdio_api;
 	struct uffdio_register uffdio_register;
 	pthread_t thread;

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

 	uffdio_register.range.start = (unsigned long) map;
 	uffdio_register.range.len = size;
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_WP;
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) < 0) {
 		fprintf(stderr, "UFFDIO_REGISTER failed: %d\n", errno);
 		return -errno;
 	}

 	pthread_create(&thread, NULL, uffd_thread_fn, NULL);

 	return 0;
 }

 int main(void)
 {
 	const size_t size = 4 * 1024 * 1024ull;
 	char *map, *cur;

 	pagesize = getpagesize();

 	map = mmap(NULL, size, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANON, -1, 0);
 	if (map == MAP_FAILED) {
 		fprintf(stderr, "mmap() failed\n");
 		return -errno;
 	}

 	if (madvise(map, size, MADV_HUGEPAGE)) {
 		fprintf(stderr, "MADV_HUGEPAGE failed\n");
 		return -errno;
 	}

 	if (setup_uffd(map, size))
 		return 1;

 	/* Read the whole range, populating zeropages. */
 	madvise(map, size, MADV_POPULATE_READ);

 	/* Write-protect the whole range. */
 	uffd_wp_range(map, size, true);

 	/* Make sure uffd-wp triggers on each page. */
 	for (cur = map; cur < map + size; cur += pagesize) {
 		uffd_triggered = false;

 		barrier();
 		/* Trigger a write fault. */
 		*cur = 1;
 		barrier();

 		if (!uffd_triggered) {
 			printf("FAIL: uffd-wp did not trigger\n");
 			return 1;
 		}
 	}

 	printf("PASS: uffd-wp triggered\n");
 	return 0;
 }

Link: https://lkml.kernel.org/r/20230302175423.589164-1-david@redhat.com
Fixes: e06f1e1dd499 ("userfaultfd: wp: enabled write protection in userfaultfd API")
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/huge_memory.c~mm-userfaultfd-propagate-uffd-wp-bit-when-pte-mapping-the-huge-zeropage
+++ a/mm/huge_memory.c
@@ -2037,7 +2037,7 @@ static void __split_huge_zero_page_pmd(s
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pgtable_t pgtable;
-	pmd_t _pmd;
+	pmd_t _pmd, old_pmd;
 	int i;
 
 	/*
@@ -2048,7 +2048,7 @@ static void __split_huge_zero_page_pmd(s
 	 *
 	 * See Documentation/mm/mmu_notifier.rst
 	 */
-	pmdp_huge_clear_flush(vma, haddr, pmd);
+	old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
 
 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 	pmd_populate(mm, &_pmd, pgtable);
@@ -2057,6 +2057,8 @@ static void __split_huge_zero_page_pmd(s
 		pte_t *pte, entry;
 		entry = pfn_pte(my_zero_pfn(haddr), vma->vm_page_prot);
 		entry = pte_mkspecial(entry);
+		if (pmd_uffd_wp(old_pmd))
+			entry = pte_mkuffd_wp(entry);
 		pte = pte_offset_map(&_pmd, haddr);
 		VM_BUG_ON(!pte_none(*pte));
 		set_pte_at(mm, haddr, pte, entry);
_

Patches currently in -mm which might be from david@redhat.com are


