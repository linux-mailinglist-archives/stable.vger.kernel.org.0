Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F44F41A7AE
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239237AbhI1F6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239110AbhI1F6P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD9F46124B;
        Tue, 28 Sep 2021 05:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808591;
        bh=yF8soBrMZR/O7Es8zvvSXK1ACmyYAeIPeI9GI8SIN4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BR9Mz7tNJIpOMx5qLmLL20V6J+CCbJqnzz19y6p25N+bWH6doUl3rEufMzt3szdUr
         MMpPdsax7GWcFfEBdnMBV4XDW877gtglxayrFvk3zQ0Znp0y7jjIMIbg1zqCrb3iPG
         JTI0rh8X7/Ape0kSmKx0fT6brfXHpwiQ/hx8wHHcMa+yC4aabMKJLJRtWZ8fkwtE2X
         spJM3WqZzgsGzNF1F2W5g2pR6rMj0pPPhnsolXYKtitgWQaSyEfnfgP9BkdEGM5UGl
         l65tTf6tnqeBbJau43qA+ewWkEEv5+uXGFfuTrQxqipWlRFuDfkmQ8V7LxgIFUq9e8
         jLfUbw/orNoEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Beulich <jbeulich@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>, boris.ostrovsky@oracle.com,
        xen-devel@lists.xenproject.org, iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.14 29/40] swiotlb-xen: ensure to issue well-formed XENMEM_exchange requests
Date:   Tue, 28 Sep 2021 01:55:13 -0400
Message-Id: <20210928055524.172051-29-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit 9074c79b62b6e0d91d7f716c6e4e9968eaf9e043 ]

While the hypervisor hasn't been enforcing this, we would still better
avoid issuing requests with GFNs not aligned to the requested order.
Instead of altering the value also in the call to panic(), drop it
there for being static and hence easy to determine without being part
of the panic message.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Link: https://lore.kernel.org/r/7b3998e3-1233-4e5a-89ec-d740e77eb166@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/swiotlb-xen.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index dbb18dc956f3..de4f55154d49 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -232,10 +232,11 @@ void __init xen_swiotlb_init_early(void)
 	/*
 	 * Get IO TLB memory from any location.
 	 */
-	start = memblock_alloc(PAGE_ALIGN(bytes), PAGE_SIZE);
+	start = memblock_alloc(PAGE_ALIGN(bytes),
+			       IO_TLB_SEGSIZE << IO_TLB_SHIFT);
 	if (!start)
-		panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
-		      __func__, PAGE_ALIGN(bytes), PAGE_SIZE);
+		panic("%s: Failed to allocate %lu bytes\n",
+		      __func__, PAGE_ALIGN(bytes));
 
 	/*
 	 * And replace that memory with pages under 4GB.
-- 
2.33.0

