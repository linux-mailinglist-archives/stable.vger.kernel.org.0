Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723932CE1DF
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 23:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbgLCWhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 17:37:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:56882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbgLCWg7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 17:36:59 -0500
Date:   Thu, 03 Dec 2020 14:36:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607034978;
        bh=oj0M9lxP/IkXeFDeOE9ImAvzkTFCj436yGpAocLn87Y=;
        h=From:To:Subject:From;
        b=GTwMUqyHbfiN/kYVXZNQpOX12qslOeHx1D8CKXweabqmbzUvLEOeBJ+HsdLl2Va5z
         hmwubJl3LuGB1zDo4YxqYbhwDEPtlXm3RxkwPRxKHJAdQDl+W0Kds92+y9RbW+P2oo
         f/UhyBECI+62LrJBdGNurnVykRLGK6CJolQTOIr8=
From:   akpm@linux-foundation.org
To:     david@redhat.com, hushiyuan@huawei.com, jgg@ziepe.ca,
        linmiaohe@huawei.com, liuzixian4@huawei.com,
        louhongxiang@huawei.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject:  +
 fix-mmap-return-value-when-vma-is-merged-after-call_mmap.patch added to -mm
 tree
Message-ID: <20201203223617.JyvaFW_Z5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: fix mmap return value when vma is merged after call_mmap()
has been added to the -mm tree.  Its filename is
     fix-mmap-return-value-when-vma-is-merged-after-call_mmap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fix-mmap-return-value-when-vma-is-merged-after-call_mmap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fix-mmap-return-value-when-vma-is-merged-after-call_mmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liu Zixian <liuzixian4@huawei.com>
Subject: mm/mmap.c: fix mmap return value when vma is merged after call_mmap()

On success, mmap should return the begin address of newly mapped area, but
patch "mm: mmap: merge vma after call_mmap() if possible" set vm_start of
newly merged vma to return value addr.  Users of mmap will get wrong
address if vma is merged after call_mmap().  We fix this by moving the
assignment to addr before merging vma.

Link: https://lkml.kernel.org/r/20201203085350.22624-1-liuzixian4@huawei.com
Fixes: d70cec898324 ("mm: mmap: merge vma after call_mmap() if possible")
Signed-off-by: Liu Zixian <liuzixian4@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hongxiang Lou <louhongxiang@huawei.com>
Cc: Hu Shiyuan <hushiyuan@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/mm/mmap.c~fix-mmap-return-value-when-vma-is-merged-after-call_mmap
+++ a/mm/mmap.c
@@ -1808,6 +1808,17 @@ unsigned long mmap_region(struct file *f
 		if (error)
 			goto unmap_and_free_vma;
 
+		/* Can addr have changed??
+		 *
+		 * Answer: Yes, several device drivers can do it in their
+		 *         f_op->mmap method. -DaveM
+		 * Bug: If addr is changed, prev, rb_link, rb_parent should
+		 *      be updated for vma_link()
+		 */
+		WARN_ON_ONCE(addr != vma->vm_start);
+
+		addr = vma->vm_start;
+
 		/* If vm_flags changed after call_mmap(), we should try merge vma again
 		 * as we may succeed this time.
 		 */
@@ -1822,25 +1833,12 @@ unsigned long mmap_region(struct file *f
 				fput(vma->vm_file);
 				vm_area_free(vma);
 				vma = merge;
-				/* Update vm_flags and possible addr to pick up the change. We don't
-				 * warn here if addr changed as the vma is not linked by vma_link().
-				 */
-				addr = vma->vm_start;
+				/* Update vm_flags to pick up the change. */
 				vm_flags = vma->vm_flags;
 				goto unmap_writable;
 			}
 		}
 
-		/* Can addr have changed??
-		 *
-		 * Answer: Yes, several device drivers can do it in their
-		 *         f_op->mmap method. -DaveM
-		 * Bug: If addr is changed, prev, rb_link, rb_parent should
-		 *      be updated for vma_link()
-		 */
-		WARN_ON_ONCE(addr != vma->vm_start);
-
-		addr = vma->vm_start;
 		vm_flags = vma->vm_flags;
 	} else if (vm_flags & VM_SHARED) {
 		error = shmem_zero_setup(vma);
_

Patches currently in -mm which might be from liuzixian4@huawei.com are

fix-mmap-return-value-when-vma-is-merged-after-call_mmap.patch

