Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B596D373245
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 00:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbhEDWWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 18:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232456AbhEDWWa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 May 2021 18:22:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B929B613DD;
        Tue,  4 May 2021 22:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620166895;
        bh=X7Ht3HoHp6+OxEyPcAFA0l0DoNTSFJeRWwwbsQlUYxA=;
        h=Date:From:To:Subject:From;
        b=uVC7sGJcm+sY9BN1nK3gVUcUcpJH3/cTFAliLguAPxUzyMm5EBtzGhL+s8VFB7Bcb
         hfstNJwMdnira036WL45FXf7tv+aSnNCUAWfNSWd7ugAuGnpywc7ELEjq6lti3klZh
         5j8HHfmhQ0WpWmqt+s7N3GleR3e4QGgvNxA+qsq8=
Date:   Tue, 04 May 2021 15:21:34 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, joel@joelfernandes.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        stable@vger.kernel.org
Subject:  + mm-hugetlb-fix-cow-where-page-writtable-in-child.patch
 added to -mm tree
Message-ID: <20210504222134.OVXQ7jyUz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix cow where page writtable in child
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-cow-where-page-writtable-in-child.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-cow-where-page-writtable-in-child.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-cow-where-page-writtable-in-child.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: fix cow where page writtable in child

When rework early cow of pinned hugetlb pages, we moved huge_ptep_get()
upper but overlooked a side effect that the huge_ptep_get() will fetch the
pte after wr-protection.  After moving it upwards, we need explicit
wr-protect of child pte or we will keep the write bit set in the child
process, which could cause data corrution where the child can write to the
original page directly.

This issue can also be exposed by "memfd_test hugetlbfs" kselftest.

Link: https://lkml.kernel.org/r/20210503234356.9097-3-peterx@redhat.com
Fixes: 4eae4efa2c299 ("hugetlb: do early cow when page pinned on src mm")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~mm-hugetlb-fix-cow-where-page-writtable-in-child
+++ a/mm/hugetlb.c
@@ -3898,6 +3898,7 @@ again:
 				 * See Documentation/vm/mmu_notifier.rst
 				 */
 				huge_ptep_set_wrprotect(src, addr, src_pte);
+				entry = huge_pte_wrprotect(entry);
 			}
 
 			page_dup_rmap(ptepage, true);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-f_seal_future_write.patch
mm-hugetlb-fix-cow-where-page-writtable-in-child.patch
hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch
hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled-fix.patch
mm-hugetlb-move-flush_hugetlb_tlb_range-into-hugetlbh.patch
hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp.patch
userfaultfd-add-minor-fault-registration-mode-fix.patch

