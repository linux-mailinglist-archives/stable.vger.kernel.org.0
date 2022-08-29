Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864935A4960
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiH2LYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbiH2LXK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:23:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC345C95D;
        Mon, 29 Aug 2022 04:14:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7808B80FA7;
        Mon, 29 Aug 2022 11:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC98C433D6;
        Mon, 29 Aug 2022 11:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771659;
        bh=MaFDrlC2VtmaCzh6Vod92cDJBAkryZgJvboxsy9HS+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQyv+w7YriT67OC2jOjs1uJJX6K9z/hvwsvdTDbur4t5SxPP/9ES66+tAqHLbB2UF
         bniKC1U0ueoukWJ1W2ZxlaPpeHOkrLTRlaqIxzDDkxfEW8aC9vwCS9SPXa76IrH1WH
         tYTAXtOkmokB1jRqzPaOR3P9DBl4bqMskUL6d1jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Peter Feiner <pfeiner@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Jamie Liu <jamieliu@google.com>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 121/136] mm/hugetlb: fix hugetlb not supporting softdirty tracking
Date:   Mon, 29 Aug 2022 12:59:48 +0200
Message-Id: <20220829105809.643780113@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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

commit f96f7a40874d7c746680c0b9f57cef2262ae551f upstream.

Patch series "mm/hugetlb: fix write-fault handling for shared mappings", v2.

I observed that hugetlb does not support/expect write-faults in shared
mappings that would have to map the R/O-mapped page writable -- and I
found two case where we could currently get such faults and would
erroneously map an anon page into a shared mapping.

Reproducers part of the patches.

I propose to backport both fixes to stable trees.  The first fix needs a
small adjustment.


This patch (of 2):

Staring at hugetlb_wp(), one might wonder where all the logic for shared
mappings is when stumbling over a write-protected page in a shared
mapping.  In fact, there is none, and so far we thought we could get away
with that because e.g., mprotect() should always do the right thing and
map all pages directly writable.

Looks like we were wrong:

--------------------------------------------------------------------------
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <errno.h>
 #include <sys/mman.h>

 #define HUGETLB_SIZE (2 * 1024 * 1024u)

 static void clear_softdirty(void)
 {
         int fd = open("/proc/self/clear_refs", O_WRONLY);
         const char *ctrl = "4";
         int ret;

         if (fd < 0) {
                 fprintf(stderr, "open(clear_refs) failed\n");
                 exit(1);
         }
         ret = write(fd, ctrl, strlen(ctrl));
         if (ret != strlen(ctrl)) {
                 fprintf(stderr, "write(clear_refs) failed\n");
                 exit(1);
         }
         close(fd);
 }

 int main(int argc, char **argv)
 {
         char *map;
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

         if (mprotect(map, HUGETLB_SIZE, PROT_READ)) {
                 fprintf(stderr, "mmprotect() failed\n");
                 return -errno;
         }

         clear_softdirty();

         if (mprotect(map, HUGETLB_SIZE, PROT_READ|PROT_WRITE)) {
                 fprintf(stderr, "mmprotect() failed\n");
                 return -errno;
         }

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

Reason in this particular case is that vma_wants_writenotify() will
return "true", removing VM_SHARED in vma_set_page_prot() to map pages
write-protected. Let's teach vma_wants_writenotify() that hugetlb does not
support softdirty tracking.

Link: https://lkml.kernel.org/r/20220811103435.188481-1-david@redhat.com
Link: https://lkml.kernel.org/r/20220811103435.188481-2-david@redhat.com
Fixes: 64e455079e1b ("mm: softdirty: enable write notifications on VMAs after VM_SOFTDIRTY cleared")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Jamie Liu <jamieliu@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>	[3.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1684,8 +1684,12 @@ int vma_wants_writenotify(struct vm_area
 	    pgprot_val(vm_pgprot_modify(vm_page_prot, vm_flags)))
 		return 0;
 
-	/* Do we need to track softdirty? */
-	if (IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) && !(vm_flags & VM_SOFTDIRTY))
+	/*
+	 * Do we need to track softdirty? hugetlb does not support softdirty
+	 * tracking yet.
+	 */
+	if (IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) && !(vm_flags & VM_SOFTDIRTY) &&
+	    !is_vm_hugetlb_page(vma))
 		return 1;
 
 	/* Specialty mapping? */


