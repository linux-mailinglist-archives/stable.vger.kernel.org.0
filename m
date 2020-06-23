Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6A220637C
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390330AbgFWUZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390584AbgFWUZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:25:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4974320702;
        Tue, 23 Jun 2020 20:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943947;
        bh=7tn3+LkNzV8RzkZITVnbZCfoVAFQL/OCfYXaY1Yzibc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q1ryKc6Vcw6FaVxDReokF1bCq5jCLaE2RhDODaEF4WESF5DfLdXBFIm+P25fnL4ny
         I63QWJy5qQ+4xr5e3Rf5CvezNyZy3308BfRt00Igw9ayuAIQ/U0OUlsOLrj0AbT852
         onsb0eRqd7OwrXeV4n2Cp3YcRvxPlUwnYHlRE4yQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/314] firmware: qcom_scm: fix bogous abuse of dma-direct internals
Date:   Tue, 23 Jun 2020 21:54:51 +0200
Message-Id: <20200623195343.436160469@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 459b1f86f1cba7de813fbc335df476c111feec22 ]

As far as the device is concerned the dma address is the physical
address.  There is no need to convert it to a physical address,
especially not using dma-direct internals that are not available
to drivers and which will interact badly with IOMMUs.  Last but not
least the commit introducing it claimed to just fix a type issue,
but actually changed behavior.

Fixes: 6e37ccf78a532 ("firmware: qcom_scm: Use proper types for dma mappings")
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20200414123136.441454-1-hch@lst.de
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom_scm.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index 4802ab170fe51..b9fdc20b4eb9b 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -9,7 +9,6 @@
 #include <linux/init.h>
 #include <linux/cpumask.h>
 #include <linux/export.h>
-#include <linux/dma-direct.h>
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -441,8 +440,7 @@ int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 	struct qcom_scm_mem_map_info *mem_to_map;
 	phys_addr_t mem_to_map_phys;
 	phys_addr_t dest_phys;
-	phys_addr_t ptr_phys;
-	dma_addr_t ptr_dma;
+	dma_addr_t ptr_phys;
 	size_t mem_to_map_sz;
 	size_t dest_sz;
 	size_t src_sz;
@@ -459,10 +457,9 @@ int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 	ptr_sz = ALIGN(src_sz, SZ_64) + ALIGN(mem_to_map_sz, SZ_64) +
 			ALIGN(dest_sz, SZ_64);
 
-	ptr = dma_alloc_coherent(__scm->dev, ptr_sz, &ptr_dma, GFP_KERNEL);
+	ptr = dma_alloc_coherent(__scm->dev, ptr_sz, &ptr_phys, GFP_KERNEL);
 	if (!ptr)
 		return -ENOMEM;
-	ptr_phys = dma_to_phys(__scm->dev, ptr_dma);
 
 	/* Fill source vmid detail */
 	src = ptr;
@@ -490,7 +487,7 @@ int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 
 	ret = __qcom_scm_assign_mem(__scm->dev, mem_to_map_phys, mem_to_map_sz,
 				    ptr_phys, src_sz, dest_phys, dest_sz);
-	dma_free_coherent(__scm->dev, ptr_sz, ptr, ptr_dma);
+	dma_free_coherent(__scm->dev, ptr_sz, ptr, ptr_phys);
 	if (ret) {
 		dev_err(__scm->dev,
 			"Assign memory protection call failed %d\n", ret);
-- 
2.25.1



