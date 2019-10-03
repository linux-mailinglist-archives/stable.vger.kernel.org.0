Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958B6CAACD
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388792AbfJCRON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:14:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391270AbfJCQ1e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:27:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3944520867;
        Thu,  3 Oct 2019 16:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120052;
        bh=Va9nDflhvZE8l4fVYvtxdcbe6XHlni19RRugg5yBB5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xVl0KY6RenQLemDd7c9YwIhEkIvVKGEHt4k09TdOa6HeoctUdGi+57KJVRsvkO5Xx
         f9Gl2hn+M1ZIjo0q7AR6bMyw/q2zdOQFsblJGzXtwdk2Pmg+XWh4+0G1MYrugnOel/
         mYXYyMaZ+SjPJOUeVBsdPFIpN6YFjgGl8BeVMhbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Jackson <ian.jackson@citrix.com>,
        Julien Grall <julien.grall@arm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Avaneesh Kumar Dwivedi <akdwived@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 041/313] firmware: qcom_scm: Use proper types for dma mappings
Date:   Thu,  3 Oct 2019 17:50:19 +0200
Message-Id: <20191003154537.261502495@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



