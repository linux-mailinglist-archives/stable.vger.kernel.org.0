Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62670590838
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 23:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbiHKVo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 17:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234938AbiHKVo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 17:44:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACE69FAAE;
        Thu, 11 Aug 2022 14:44:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EB6CB822C3;
        Thu, 11 Aug 2022 21:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CC2C433C1;
        Thu, 11 Aug 2022 21:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660254264;
        bh=Qu7Wl7TVPdndjitZrIXXGx6VNQ7QivK+8oNdmm4tiIM=;
        h=Date:To:From:Subject:From;
        b=jJrtJZNntpELrZvnZQRXolZJmWrWO2gQVxueQbV0EaYS0tqNIRwgmjyagdDngI+Nz
         YRO5eafQNCNgQvUr2VzeptBhdeJQ40g/lD0LkYWHhsFLLZyO+WyglpWwzvFkkIV2Ej
         lfkmC6/rPrfEbkQjelu92xIUA8smtYEozaXEw2+M=
Date:   Thu, 11 Aug 2022 14:44:23 -0700
To:     mm-commits@vger.kernel.org, xemul@parallels.com,
        stable@vger.kernel.org, songmuchun@bytedance.com,
        pfeiner@google.com, peterx@redhat.com, n-horiguchi@ah.jp.nec.com,
        mike.kravetz@oracle.com, kirill.shutemov@linux.intel.com,
        jamieliu@google.com, hughd@google.com, gorcunov@openvz.org,
        bhelgaas@google.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-hugetlb-not-supporting-softdirty-tracking.patch added to mm-hotfixes-unstable branch
Message-Id: <20220811214423.E9CC2C433C1@smtp.kernel.org>
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
     Subject: mm/hugetlb: fix hugetlb not supporting softdirty tracking
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-hugetlb-not-supporting-softdirty-tracking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-hugetlb-not-supporting-softdirty-tracking.patch

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
Subject: mm/hugetlb: fix hugetlb not supporting softdirty tracking
Date: Thu, 11 Aug 2022 12:34:34 +0200

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
---

 mm/mmap.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-hugetlb-fix-hugetlb-not-supporting-softdirty-tracking
+++ a/mm/mmap.c
@@ -1646,8 +1646,11 @@ int vma_wants_writenotify(struct vm_area
 	    pgprot_val(vm_pgprot_modify(vm_page_prot, vm_flags)))
 		return 0;
 
-	/* Do we need to track softdirty? */
-	if (vma_soft_dirty_enabled(vma))
+	/*
+	 * Do we need to track softdirty? hugetlb does not support softdirty
+	 * tracking yet.
+	 */
+	if (vma_soft_dirty_enabled(vma) && !is_vm_hugetlb_page(vma))
 		return 1;
 
 	/* Specialty mapping? */
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-fix-foll_force-cow-security-issue-and-remove-foll_cow.patch
mm-hugetlb-fix-hugetlb-not-supporting-softdirty-tracking.patch
mm-hugetlb-support-write-faults-in-shared-mappings.patch

