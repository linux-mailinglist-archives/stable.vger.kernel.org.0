Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 336CFCAB20
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388892AbfJCQQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:16:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388886AbfJCQQB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:16:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9CBA2054F;
        Thu,  3 Oct 2019 16:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119360;
        bh=oQUUreUDYQHQk1iKn9p/xFlfXzQbV7DA5p78Im2qQj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hbxY5d7cwSWuy/Tcnn8q7kzwDdjXiGGvStoY1UeDKY0MsRGJ/RZntrkVdvQDqVbIo
         JIJlhnJOFLwoy3ZiHEghOMXr0wm7sruG+Zy6JQnSvJDnIm7wCbaoWRPm8qY/dmK6yd
         kDmkWwHHV1yBWguABDTPlvpd3XggxlXLs8HCUKvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Jackson <ian.jackson@citrix.com>,
        Julien Grall <julien.grall@arm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Avaneesh Kumar Dwivedi <akdwived@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 029/211] firmware: qcom_scm: Use proper types for dma mappings
Date:   Thu,  3 Oct 2019 17:51:35 +0200
Message-Id: <20191003154453.914717417@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
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
index e778af766fae3..98c987188835b 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/cpumask.h>
 #include <linux/export.h>
+#include <linux/dma-direct.h>
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -449,6 +450,7 @@ int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 	phys_addr_t mem_to_map_phys;
 	phys_addr_t dest_phys;
 	phys_addr_t ptr_phys;
+	dma_addr_t ptr_dma;
 	size_t mem_to_map_sz;
 	size_t dest_sz;
 	size_t src_sz;
@@ -466,9 +468,10 @@ int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 	ptr_sz = ALIGN(src_sz, SZ_64) + ALIGN(mem_to_map_sz, SZ_64) +
 			ALIGN(dest_sz, SZ_64);
 
-	ptr = dma_alloc_coherent(__scm->dev, ptr_sz, &ptr_phys, GFP_KERNEL);
+	ptr = dma_alloc_coherent(__scm->dev, ptr_sz, &ptr_dma, GFP_KERNEL);
 	if (!ptr)
 		return -ENOMEM;
+	ptr_phys = dma_to_phys(__scm->dev, ptr_dma);
 
 	/* Fill source vmid detail */
 	src = ptr;
@@ -498,7 +501,7 @@ int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 
 	ret = __qcom_scm_assign_mem(__scm->dev, mem_to_map_phys, mem_to_map_sz,
 				    ptr_phys, src_sz, dest_phys, dest_sz);
-	dma_free_coherent(__scm->dev, ALIGN(ptr_sz, SZ_64), ptr, ptr_phys);
+	dma_free_coherent(__scm->dev, ptr_sz, ptr, ptr_dma);
 	if (ret) {
 		dev_err(__scm->dev,
 			"Assign memory protection call failed %d.\n", ret);
-- 
2.20.1



