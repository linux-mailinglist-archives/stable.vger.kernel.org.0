Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A3B3FA2A5
	for <lists+stable@lfdr.de>; Sat, 28 Aug 2021 02:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhH1BAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 21:00:45 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:47504 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232693AbhH1BAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 21:00:44 -0400
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AEQLKFazEJguRdXz/ox3XKrPwEL1zdoMgy1kn?=
 =?us-ascii?q?xilNoH1uA6ilfqWV8cjzuiWbtN9vYhsdcLy7WZVoIkmskKKdg7NhXotKNTOO0A?=
 =?us-ascii?q?SVxepZnOnfKlPbexHWx6p00KdMV+xEAsTsMF4St63HyTj9P9E+4NTvysyVuds?=
 =?us-ascii?q?=3D?=
X-IronPort-AV: E=Sophos;i="5.84,358,1620662400"; 
   d="scan'208";a="113590778"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Aug 2021 08:59:53 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id 33F9B4D0D4BC;
        Sat, 28 Aug 2021 08:59:52 +0800 (CST)
Received: from G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Sat, 28 Aug 2021 08:59:51 +0800
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Sat, 28 Aug 2021 08:59:52 +0800
Received: from localhost.localdomain (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Sat, 28 Aug 2021 08:59:50 +0800
From:   Li Zhijian <lizhijian@cn.fujitsu.com>
To:     <linux-mm@kvack.org>, <linux-rdma@vger.kernel.org>,
        <akpm@linux-foundation.org>, <jglisse@redhat.com>, <jgg@ziepe.ca>,
        <hch@infradead.org>
CC:     <yishaih@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Li Zhijian <lizhijian@cn.fujitsu.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] mm/hmm: bypass devmap pte when all pfn requested flags are fulfilled
Date:   Sat, 28 Aug 2021 09:04:41 +0800
Message-ID: <20210828010441.3702-1-lizhijian@cn.fujitsu.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 33F9B4D0D4BC.AE3AF
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Previously, we noticed the one rpma example was failed[1] since 36f30e486d,
where it will use ODP feature to do RDMA WRITE between fsdax files.

After digging into the code, we found hmm_vma_handle_pte() will still
return EFAULT even though all the its requesting flags has been
fulfilled. That's because a DAX page will be marked as
(_PAGE_SPECIAL | PAGE_DEVMAP) by pte_mkdevmap().

[1]: https://github.com/pmem/rpma/issues/1142

CC: stable@vger.kernel.org
Fixes: 405506274922 ("mm/hmm: add missing call to hmm_pte_need_fault in HMM_PFN_SPECIAL handling")
Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
---
 mm/hmm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index fad6be2bf072..d324fb1a5352 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -295,10 +295,13 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		goto fault;
 
 	/*
+	 * Bypass devmap pte such as DAX page when all pfn requested
+	 * flags(pfn_req_flags) are fulfilled.
 	 * Since each architecture defines a struct page for the zero page, just
 	 * fall through and treat it like a normal page.
 	 */
-	if (pte_special(pte) && !is_zero_pfn(pte_pfn(pte))) {
+	if (!pte_devmap(pte) && pte_special(pte) &&
+	    !is_zero_pfn(pte_pfn(pte))) {
 		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
 			pte_unmap(ptep);
 			return -EFAULT;
-- 
2.31.1



