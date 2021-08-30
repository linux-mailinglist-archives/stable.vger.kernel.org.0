Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56EE3FB338
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 11:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235983AbhH3Jis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 05:38:48 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:13351 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S235618AbhH3Jir (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 05:38:47 -0400
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AA0PzNKx7ks14I/NMf67UKrPwPb1zdoMgy1kn?=
 =?us-ascii?q?xilNoH1uE/Bw8vrE9sjzuiWE6wr5J0tQ++xoVJPsfZq+z/BICOsqXYtKNTOO0F?=
 =?us-ascii?q?dAR7sM0WKN+VHd8iTFh4tg6Zs=3D?=
X-IronPort-AV: E=Sophos;i="5.84,363,1620662400"; 
   d="scan'208";a="113710097"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 30 Aug 2021 17:37:52 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id 0E9BE4D0DC65;
        Mon, 30 Aug 2021 17:37:49 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Mon, 30 Aug 2021 17:37:45 +0800
Received: from localhost.localdomain (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Mon, 30 Aug 2021 17:37:42 +0800
From:   Li Zhijian <lizhijian@cn.fujitsu.com>
To:     <linux-mm@kvack.org>, <linux-rdma@vger.kernel.org>,
        <akpm@linux-foundation.org>, <jglisse@redhat.com>, <jgg@ziepe.ca>,
        <hch@infradead.org>
CC:     <yishaih@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Li Zhijian <lizhijian@cn.fujitsu.com>, <stable@vger.kernel.org>
Subject: [PATCH v3] mm/hmm: bypass devmap pte when all pfn requested flags are fulfilled
Date:   Mon, 30 Aug 2021 17:42:32 +0800
Message-ID: <20210830094232.203029-1-lizhijian@cn.fujitsu.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 0E9BE4D0DC65.AFF69
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
V3: adjust the checking order
---
 mm/hmm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index fad6be2bf072..842e26599238 100644
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
+	if (pte_special(pte) && !pte_devmap(pte) &&
+	    !is_zero_pfn(pte_pfn(pte))) {
 		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
 			pte_unmap(ptep);
 			return -EFAULT;
-- 
2.31.1



