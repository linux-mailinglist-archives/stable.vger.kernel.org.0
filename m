Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D799340E4CE
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244627AbhIPRFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347993AbhIPRBJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:01:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5453F61AFC;
        Thu, 16 Sep 2021 16:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809991;
        bh=IJKP0UOwGNAsWCUOhenYOs6dc+NNB1BXv5lIKAXqvbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4V6jclxz15G897Jca7I/1r98zMbfAEOkD8bIr2nYDJCWQeZB8ist7TEtt6Hu78mM
         pGEa71Lsb985c6gRC1yAfW8NGpHybUFCjkUgoNwZGhcFYfrUmNHYXg/h7RhD5qTN9o
         HkODLn9hEzgBnpsbzlIUr5Iynv49pVUuMfvwh6Eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Zhijian <lizhijian@cn.fujitsu.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.13 359/380] mm/hmm: bypass devmap pte when all pfn requested flags are fulfilled
Date:   Thu, 16 Sep 2021 18:01:56 +0200
Message-Id: <20210916155816.274515951@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Zhijian <lizhijian@cn.fujitsu.com>

commit 4b42fb213678d2b6a9eeea92a9be200f23e49583 upstream.

Previously, we noticed the one rpma example was failed[1] since commit
36f30e486dce ("IB/core: Improve ODP to use hmm_range_fault()"), where it
will use ODP feature to do RDMA WRITE between fsdax files.

After digging into the code, we found hmm_vma_handle_pte() will still
return EFAULT even though all the its requesting flags has been
fulfilled.  That's because a DAX page will be marked as (_PAGE_SPECIAL |
PAGE_DEVMAP) by pte_mkdevmap().

Link: https://github.com/pmem/rpma/issues/1142 [1]
Link: https://lkml.kernel.org/r/20210830094232.203029-1-lizhijian@cn.fujitsu.com
Fixes: 405506274922 ("mm/hmm: add missing call to hmm_pte_need_fault in HMM_PFN_SPECIAL handling")
Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hmm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -291,10 +291,13 @@ static int hmm_vma_handle_pte(struct mm_
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


