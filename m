Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFC33FCE9D
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 22:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbhHaUgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 16:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230236AbhHaUgi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Aug 2021 16:36:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6F606103A;
        Tue, 31 Aug 2021 20:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630442142;
        bh=s85S8KQXJOb7b1xa7D+f7KxhW9Tjq4i09HM2JGNUPg8=;
        h=Date:From:To:Subject:From;
        b=Co8RIRTdtMUHvmbSciQ2jKc61oCL71nvG8zE6WkSY/bS6DP9nxw4uFw5fy9oyWfGT
         beLndQ5KJXWwIu6E/dvBorN9oc5QZX2IpB8t65aoC3j/LE5O7qA7tezASjnGrKdsnO
         k4vQ4ZggcrUfAM+/sFcAC9Zse9m+DdjNzZ0Sq3HM=
Date:   Tue, 31 Aug 2021 13:35:42 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, jgg@nvidia.com, lizhijian@cn.fujitsu.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  +
 mm-hmm-bypass-devmap-pte-when-all-pfn-requested-flags-are-fulfilled.patch
 added to -mm tree
Message-ID: <20210831203542.aBJpj84ci%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hmm: bypass devmap pte when all pfn requested flags are fulfilled
has been added to the -mm tree.  Its filename is
     mm-hmm-bypass-devmap-pte-when-all-pfn-requested-flags-are-fulfilled.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-bypass-devmap-pte-when-all-pfn-requested-flags-are-fulfilled.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-bypass-devmap-pte-when-all-pfn-requested-flags-are-fulfilled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Zhijian <lizhijian@cn.fujitsu.com>
Subject: mm/hmm: bypass devmap pte when all pfn requested flags are fulfilled

Previously, we noticed the one rpma example was failed[1] since
36f30e486d, where it will use ODP feature to do RDMA WRITE between fsdax
files.

After digging into the code, we found hmm_vma_handle_pte() will still
return EFAULT even though all the its requesting flags has been fulfilled.
That's because a DAX page will be marked as (_PAGE_SPECIAL | PAGE_DEVMAP)
by pte_mkdevmap().

[1]: https://github.com/pmem/rpma/issues/1142

Link: https://lkml.kernel.org/r/20210830094232.203029-1-lizhijian@cn.fujitsu.com
Fixes: 405506274922 ("mm/hmm: add missing call to hmm_pte_need_fault in HMM_PFN_SPECIAL handling")
Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/hmm.c~mm-hmm-bypass-devmap-pte-when-all-pfn-requested-flags-are-fulfilled
+++ a/mm/hmm.c
@@ -295,10 +295,13 @@ static int hmm_vma_handle_pte(struct mm_
 		goto fault;
 
 	/*
+	 * Bypass devmap pte such as DAX page when all pfn requested
+	 * flags(pfn_req_flags) are fulfilled.
 	 * Since each architecture defines a struct page for the zero page, just
 	 * fall through and treat it like a normal page.
 	 */
-	if (pte_special(pte) && !is_zero_pfn(pte_pfn(pte))) {
+	if (pte_special(pte) && !pte_devmap(pte) &&
+	    !is_zero_pfn(pte_pfn(pte))) {
 		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
 			pte_unmap(ptep);
 			return -EFAULT;
_

Patches currently in -mm which might be from lizhijian@cn.fujitsu.com are

mm-hmm-bypass-devmap-pte-when-all-pfn-requested-flags-are-fulfilled.patch

