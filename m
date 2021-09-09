Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E1E40428E
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 03:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348778AbhIIBLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 21:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232144AbhIIBLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 21:11:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16B4E6113C;
        Thu,  9 Sep 2021 01:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631149803;
        bh=PJ4NEu+MkoH6d2xqP5XNeV8XRIRgMGM90hfwQfpLDAk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rycjUxSUm5zP0JhlJWXH5LLGMBz0jzUi2rEv6UjN5l0juF7aqix4aVT00Lj94r0XW
         rf8x91UFa/mMR8bOYVsrqL1jgrla9DQO8eYqajVp8nQfM1wQGTGRgxiy/j8bJ+sn3o
         LIUfI7MLArsSuND7TXlLxmiQFWSqV53aup+kNSqU=
Date:   Wed, 08 Sep 2021 18:10:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, jgg@nvidia.com,
        linux-mm@kvack.org, lizhijian@cn.fujitsu.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 1/8] mm/hmm: bypass devmap pte when all pfn
 requested flags are fulfilled
Message-ID: <20210909011002.YtOxlcd0s%akpm@linux-foundation.org>
In-Reply-To: <20210908180859.d523d4bb4ad8eec11c61500d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
