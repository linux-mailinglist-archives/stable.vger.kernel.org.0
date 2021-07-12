Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6D43C5552
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355540AbhGLIJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353477AbhGLICV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51D3861CAD;
        Mon, 12 Jul 2021 07:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076519;
        bh=AIOPfH24hhUJkgG8XEbKVrO6oMG2vKVXkiAziocDX9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1yr5WXeoyAWMzHutrKhP/6xyDyDRhdHP//EcmqSXkr6g1o1mW6i6/RwKI7onkEiMA
         tq977/vh6wcrD2YwhJgUE/1DdHCPZkH8nQzNykgUFj68sAHM3uwtfoIMiOTaz7c9hb
         +qTWk2fMiz5oDPdFcVbJZNFVBO3YXjISa58AaCv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jussi Maki <joamaki@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 678/800] iommu/amd: Tidy up DMA ops init
Date:   Mon, 12 Jul 2021 08:11:41 +0200
Message-Id: <20210712061039.025767783@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit be227f8e99a663d097536e9f9bc935fb26bdbc41 ]

Now that DMA ops are part of the core API via iommu-dma, fold the
vestigial remains of the IOMMU_DMA_OPS init state into the IOMMU API
phase, and clean up a few other leftovers. This should also close the
race window wherein bus_set_iommu() effectively makes the DMA ops state
visible before its nominal initialisation - it seems this was previously
fairly benign, but since commit a250c23f15c2 ("iommu: remove
DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE") it can now lead to the strict flush
queue policy inadvertently being picked for default domains allocated
during that window, with a corresponding unexpected perfomance impact.

Reported-by: Jussi Maki <joamaki@gmail.com>
Tested-by: Jussi Maki <joamaki@gmail.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Fixes: a250c23f15c2 ("iommu: remove DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE")
Link: https://lore.kernel.org/r/665db61e23ff8d54ac5eb391bef520b3a803fcb9.1622727974.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu.h |  2 --
 drivers/iommu/amd/init.c      |  5 -----
 drivers/iommu/amd/iommu.c     | 31 +++++++++++++------------------
 3 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 55dd38d814d9..416815a525d6 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -11,8 +11,6 @@
 
 #include "amd_iommu_types.h"
 
-extern int amd_iommu_init_dma_ops(void);
-extern int amd_iommu_init_passthrough(void);
 extern irqreturn_t amd_iommu_int_thread(int irq, void *data);
 extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
 extern void amd_iommu_apply_erratum_63(u16 devid);
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 1ded8a69c246..5ff7e5364ef4 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -231,7 +231,6 @@ enum iommu_init_state {
 	IOMMU_ENABLED,
 	IOMMU_PCI_INIT,
 	IOMMU_INTERRUPTS_EN,
-	IOMMU_DMA_OPS,
 	IOMMU_INITIALIZED,
 	IOMMU_NOT_FOUND,
 	IOMMU_INIT_ERROR,
@@ -2895,10 +2894,6 @@ static int __init state_next(void)
 		init_state = ret ? IOMMU_INIT_ERROR : IOMMU_INTERRUPTS_EN;
 		break;
 	case IOMMU_INTERRUPTS_EN:
-		ret = amd_iommu_init_dma_ops();
-		init_state = ret ? IOMMU_INIT_ERROR : IOMMU_DMA_OPS;
-		break;
-	case IOMMU_DMA_OPS:
 		init_state = IOMMU_INITIALIZED;
 		break;
 	case IOMMU_INITIALIZED:
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 3ac42bbdefc6..c46dde88a132 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -30,7 +30,6 @@
 #include <linux/msi.h>
 #include <linux/irqdomain.h>
 #include <linux/percpu.h>
-#include <linux/iova.h>
 #include <linux/io-pgtable.h>
 #include <asm/irq_remapping.h>
 #include <asm/io_apic.h>
@@ -1773,13 +1772,22 @@ void amd_iommu_domain_update(struct protection_domain *domain)
 	amd_iommu_domain_flush_complete(domain);
 }
 
+static void __init amd_iommu_init_dma_ops(void)
+{
+	swiotlb = (iommu_default_passthrough() || sme_me_mask) ? 1 : 0;
+
+	if (amd_iommu_unmap_flush)
+		pr_info("IO/TLB flush on unmap enabled\n");
+	else
+		pr_info("Lazy IO/TLB flushing enabled\n");
+	iommu_set_dma_strict(amd_iommu_unmap_flush);
+}
+
 int __init amd_iommu_init_api(void)
 {
-	int ret, err = 0;
+	int err = 0;
 
-	ret = iova_cache_get();
-	if (ret)
-		return ret;
+	amd_iommu_init_dma_ops();
 
 	err = bus_set_iommu(&pci_bus_type, &amd_iommu_ops);
 	if (err)
@@ -1796,19 +1804,6 @@ int __init amd_iommu_init_api(void)
 	return 0;
 }
 
-int __init amd_iommu_init_dma_ops(void)
-{
-	swiotlb        = (iommu_default_passthrough() || sme_me_mask) ? 1 : 0;
-
-	if (amd_iommu_unmap_flush)
-		pr_info("IO/TLB flush on unmap enabled\n");
-	else
-		pr_info("Lazy IO/TLB flushing enabled\n");
-	iommu_set_dma_strict(amd_iommu_unmap_flush);
-	return 0;
-
-}
-
 /*****************************************************************************
  *
  * The following functions belong to the exported interface of AMD IOMMU
-- 
2.30.2



