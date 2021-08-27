Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5633F3F9AFC
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 16:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbhH0OlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 10:41:12 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:9944 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231327AbhH0OlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 10:41:10 -0400
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A2npoUagCEbajKHeHnHDuQbZJ3XBQXr8ji2hC?=
 =?us-ascii?q?6mlwRA09TyX4raCTdZsguCMc5Ax6ZJhCo7G90cu7Lk80nKQdieIs1N+ZLWrbUQ?=
 =?us-ascii?q?CTQL2Kg7GN/wHd?=
X-IronPort-AV: E=Sophos;i="5.84,356,1620662400"; 
   d="scan'208";a="113573694"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 27 Aug 2021 22:40:18 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id F288C4D0DC6D;
        Fri, 27 Aug 2021 22:40:14 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 27 Aug 2021 22:40:15 +0800
Received: from localhost.localdomain (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 27 Aug 2021 22:40:14 +0800
From:   Li Zhijian <lizhijian@cn.fujitsu.com>
To:     <linux-mm@kvack.org>, <linux-rdma@vger.kernel.org>,
        <akpm@linux-foundation.org>, <jglisse@redhat.com>, <jgg@ziepe.ca>
CC:     <yishaih@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Li Zhijian <lizhijian@cn.fujitsu.com>, <stable@vger.kernel.org>
Subject: [PATCH] mm/hmm: bypass devmap pte when all pfn requested flags are fulfilled
Date:   Fri, 27 Aug 2021 22:45:00 +0800
Message-ID: <20210827144500.2148-1-lizhijian@cn.fujitsu.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: F288C4D0DC6D.AEC5F
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
Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
---
 mm/hmm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/hmm.c b/mm/hmm.c
index fad6be2bf072..4766bdefb6c3 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -294,6 +294,12 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	if (required_fault)
 		goto fault;
 
+	/*
+	 * just bypass devmap pte such as DAX page when all pfn requested
+	 * flags(pfn_req_flags) are fulfilled.
+	 */
+	if (pte_devmap(pte))
+		goto out;
 	/*
 	 * Since each architecture defines a struct page for the zero page, just
 	 * fall through and treat it like a normal page.
@@ -307,6 +313,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		return 0;
 	}
 
+out:
 	*hmm_pfn = pte_pfn(pte) | cpu_flags;
 	return 0;
 
-- 
2.31.1



