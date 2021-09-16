Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5833140E085
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237040AbhIPQVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:21:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241186AbhIPQPT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:15:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95210613C8;
        Thu, 16 Sep 2021 16:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808678;
        bh=CprO/CsqZviOI+h8Tjvfuxh1ImMiZiWVKrMB/8yCSUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvKRhd3aU5Iz0iZlD3olrf+v50X/MmzVY1edDoSFOJUYb+C69K2UDz/CT8i94Fy1M
         PfB+ZtJKnUPwauLgDfOK9JUMKJRzeqcnvdEq/L0iqUAAQM3dvXkAZ58JS6YmGVtU9q
         BCBZ4ymW2OP17G3Kly5W/b6R6qP73utmnnxTb5nE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/306] bus: fsl-mc: fix mmio base address for child DPRCs
Date:   Thu, 16 Sep 2021 17:58:04 +0200
Message-Id: <20210916155758.780448513@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

[ Upstream commit 8990f96a012f42543005b07d9e482694192e9309 ]

Some versions of the MC firmware wrongly report 0 for register base
address of the DPMCP associated with child DPRC objects thus rendering
them unusable. This is particularly troublesome in ACPI boot scenarios
where the legacy way of extracting this base address from the device
tree does not apply.
Given that DPMCPs share the same base address, workaround this by using
the base address extracted from the root DPRC container.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Link: https://lore.kernel.org/r/20210715140718.8513-8-laurentiu.tudor@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index 806766b1b45f..e329cdd7156c 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -64,6 +64,8 @@ struct fsl_mc_addr_translation_range {
 #define MC_FAPR_PL	BIT(18)
 #define MC_FAPR_BMT	BIT(17)
 
+static phys_addr_t mc_portal_base_phys_addr;
+
 /**
  * fsl_mc_bus_match - device to driver matching callback
  * @dev: the fsl-mc device to match against
@@ -597,14 +599,30 @@ static int fsl_mc_device_get_mmio_regions(struct fsl_mc_device *mc_dev,
 		 * If base address is in the region_desc use it otherwise
 		 * revert to old mechanism
 		 */
-		if (region_desc.base_address)
+		if (region_desc.base_address) {
 			regions[i].start = region_desc.base_address +
 						region_desc.base_offset;
-		else
+		} else {
 			error = translate_mc_addr(mc_dev, mc_region_type,
 					  region_desc.base_offset,
 					  &regions[i].start);
 
+			/*
+			 * Some versions of the MC firmware wrongly report
+			 * 0 for register base address of the DPMCP associated
+			 * with child DPRC objects thus rendering them unusable.
+			 * This is particularly troublesome in ACPI boot
+			 * scenarios where the legacy way of extracting this
+			 * base address from the device tree does not apply.
+			 * Given that DPMCPs share the same base address,
+			 * workaround this by using the base address extracted
+			 * from the root DPRC container.
+			 */
+			if (is_fsl_mc_bus_dprc(mc_dev) &&
+			    regions[i].start == region_desc.base_offset)
+				regions[i].start += mc_portal_base_phys_addr;
+		}
+
 		if (error < 0) {
 			dev_err(parent_dev,
 				"Invalid MC offset: %#x (for %s.%d\'s region %d)\n",
@@ -996,6 +1014,8 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
 	plat_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	mc_portal_phys_addr = plat_res->start;
 	mc_portal_size = resource_size(plat_res);
+	mc_portal_base_phys_addr = mc_portal_phys_addr & ~0x3ffffff;
+
 	error = fsl_create_mc_io(&pdev->dev, mc_portal_phys_addr,
 				 mc_portal_size, NULL,
 				 FSL_MC_IO_ATOMIC_CONTEXT_PORTAL, &mc_io);
-- 
2.30.2



