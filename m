Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B40BA659
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392484AbfIVStk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:49:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392475AbfIVStj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:49:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5401A208C2;
        Sun, 22 Sep 2019 18:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178178;
        bh=Va9nDflhvZE8l4fVYvtxdcbe6XHlni19RRugg5yBB5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RfBhuQ04waaA0TrkhJukY8MrPEhu+u2pLtnna29JG5ANWnCCZU4SwhAw8uWKRPIAk
         atPu0LEqVpe7gCojD4eoSA4g0dQTlyUM3c2WPCU8MgiVZOtgTiu8f9jP9Y0RZiVi/a
         +3t1gUSs/o+dOEAdZSaZmYspVhmGYuWPo9/K2fPc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Boyd <swboyd@chromium.org>,
        Ian Jackson <ian.jackson@citrix.com>,
        Julien Grall <julien.grall@arm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Avaneesh Kumar Dwivedi <akdwived@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 009/185] firmware: qcom_scm: Use proper types for dma mappings
Date:   Sun, 22 Sep 2019 14:46:27 -0400
Message-Id: <20190922184924.32534-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 6e37ccf78a53296c6c7bf426065762c27829eb84 ]

We need to use the proper types and convert between physical addresses
and dma addresses here to avoid mismatch warnings. This is especially
important on systems with a different size for dma addresses and
physical addresses. Otherwise, we get the following warning:

  drivers/firmware/qcom_scm.c: In function "qcom_scm_assign_mem":
  drivers/firmware/qcom_scm.c:469:47: error: passing argument 3 of "dma_alloc_coherent" from incompatible pointer type [-Werror=incompatible-pointer-types]

We also fix the size argument to dma_free_coherent() because that size
doesn't need to be aligned after it's already aligned on the allocation
size. In fact, dma debugging expects the same arguments to be passed to
both the allocation and freeing sides of the functions so changing the
size is incorrect regardless.

Reported-by: Ian Jackson <ian.jackson@citrix.com>
Cc: Ian Jackson <ian.jackson@citrix.com>
Cc: Julien Grall <julien.grall@arm.com>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Avaneesh Kumar Dwivedi <akdwived@codeaurora.org>
Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom_scm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index 2ddc118dba1b4..74b84244a0db8 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -9,6 +9,7 @@
 #include <linux/init.h>
 #include <linux/cpumask.h>
 #include <linux/export.h>
+#include <linux/dma-direct.h>
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -440,6 +441,7 @@ int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 	phys_addr_t mem_to_map_phys;
 	phys_addr_t dest_phys;
 	phys_addr_t ptr_phys;
+	dma_addr_t ptr_dma;
 	size_t mem_to_map_sz;
 	size_t dest_sz;
 	size_t src_sz;
@@ -457,9 +459,10 @@ int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 	ptr_sz = ALIGN(src_sz, SZ_64) + ALIGN(mem_to_map_sz, SZ_64) +
 			ALIGN(dest_sz, SZ_64);
 
-	ptr = dma_alloc_coherent(__scm->dev, ptr_sz, &ptr_phys, GFP_KERNEL);
+	ptr = dma_alloc_coherent(__scm->dev, ptr_sz, &ptr_dma, GFP_KERNEL);
 	if (!ptr)
 		return -ENOMEM;
+	ptr_phys = dma_to_phys(__scm->dev, ptr_dma);
 
 	/* Fill source vmid detail */
 	src = ptr;
@@ -489,7 +492,7 @@ int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 
 	ret = __qcom_scm_assign_mem(__scm->dev, mem_to_map_phys, mem_to_map_sz,
 				    ptr_phys, src_sz, dest_phys, dest_sz);
-	dma_free_coherent(__scm->dev, ALIGN(ptr_sz, SZ_64), ptr, ptr_phys);
+	dma_free_coherent(__scm->dev, ptr_sz, ptr, ptr_dma);
 	if (ret) {
 		dev_err(__scm->dev,
 			"Assign memory protection call failed %d.\n", ret);
-- 
2.20.1

