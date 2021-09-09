Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA534405E90
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 23:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348075AbhIIVH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 17:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347720AbhIIVHQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 17:07:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F3CD611C1;
        Thu,  9 Sep 2021 21:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221566;
        bh=6OznrfSU8CgvppHSBKHoQeb/Tp2FUsfTE/w9TN4Dld4=;
        h=Date:From:To:Subject:From;
        b=kOjoXiw7hTSsCfd5TTxfmUWabvBpvviHikZTThZ3brJVKqrnQKPS0zhYP8dv1bbRc
         ryxRViqERVjN2xuHMHZjOsou8BqElOtWjmm2jyumFwEB3+Qmu9AdnXbbx33I8aI9a/
         cHxRvnscFnmPMV9quTakT4gbe5avHZLgL2yfKMCk=
Date:   Thu, 09 Sep 2021 14:06:06 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, jgg@nvidia.com, lizhijian@cn.fujitsu.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged]
 mm-hmm-bypass-devmap-pte-when-all-pfn-requested-flags-are-fulfilled.patch
 removed from -mm tree
Message-ID: <20210909210606.XTkF9krFI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hmm: bypass devmap pte when all pfn requested flags are fulfilled
has been removed from the -mm tree.  Its filename was
     mm-hmm-bypass-devmap-pte-when-all-pfn-requested-flags-are-fulfilled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


