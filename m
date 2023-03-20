Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FA06C185E
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbjCTPXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbjCTPX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:23:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FAC305EB
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:16:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A1ED3CE12DA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D03CC433EF;
        Mon, 20 Mar 2023 15:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325402;
        bh=98+Q1BV12Rd6K+mcQVW9onstFbXaXP6InYdQpX8JPOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gj0Z6Ts2zILTvi9oCVeqIk5p+pTD6hgN/G83rIIOxnn7l1q+sQObQb0lxk1wNBK69
         44yn5hDMH39nIR0Kjv5x8G7fppP4gFofVS1+RS6KymEvzmykDP98fOSJl6KSgZIw/2
         fkwtxBGgvipfAw86lr8QGVU6YYlHdJO8CpL5o4jU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, Shaohua Li <shli@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 100/115] mm/userfaultfd: propagate uffd-wp bit when PTE-mapping the huge zeropage
Date:   Mon, 20 Mar 2023 15:55:12 +0100
Message-Id: <20230320145453.614829215@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
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

From: David Hildenbrand <david@redhat.com>

commit 42b2af2c9b7eede8ef21d0943f84d135e21a32a3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1926,7 +1926,7 @@ static void __split_huge_zero_page_pmd(s
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pgtable_t pgtable;
-	pmd_t _pmd;
+	pmd_t _pmd, old_pmd;
 	int i;
 
 	/*
@@ -1937,7 +1937,7 @@ static void __split_huge_zero_page_pmd(s
 	 *
 	 * See Documentation/vm/mmu_notifier.rst
 	 */
-	pmdp_huge_clear_flush(vma, haddr, pmd);
+	old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
 
 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 	pmd_populate(mm, &_pmd, pgtable);
@@ -1946,6 +1946,8 @@ static void __split_huge_zero_page_pmd(s
 		pte_t *pte, entry;
 		entry = pfn_pte(my_zero_pfn(haddr), vma->vm_page_prot);
 		entry = pte_mkspecial(entry);
+		if (pmd_uffd_wp(old_pmd))
+			entry = pte_mkuffd_wp(entry);
 		pte = pte_offset_map(&_pmd, haddr);
 		VM_BUG_ON(!pte_none(*pte));
 		set_pte_at(mm, haddr, pte, entry);


