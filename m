Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B327F404A1D
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237690AbhIILot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:44:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238358AbhIILnc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:43:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BAF761241;
        Thu,  9 Sep 2021 11:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187729;
        bh=Xd7MZANyqt8Ww7NcsQ0jrgVGIB/rsdRloUtv60kMlBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0woNcqeWDAGiVq+TanhhGXERozfl3NXG+vatYaPH9aq9pxmBA2oQmE04+ovLweUb
         DFrs55RUekfN7ZPqGo3VfchNW3OXjsQ+gyTbofvV94It1DyML1+vJcQdeNRw73a0hZ
         Cvmnz2XMfN4BOrOvSVFBsCAhy9kbjC4ylWWoTkQlfMZ2wA1LJ60y8N6OSuo+UVwKD3
         l56XHjL7m/08RqHB8fhTuucSDHYqHKqvfOCaP7DdHqGUv89Mz7rfUM3ZJzcBGr1UFK
         0JbvIi2TZxH0GRcvjcS+rRdi8WuVRa9H0yV5HvVahIJa6iLt6tg1/3D1KOI6PttSgb
         khMJv3S+iLdWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 049/252] bus: fsl-mc: fix mmio base address for child DPRCs
Date:   Thu,  9 Sep 2021 07:37:43 -0400
Message-Id: <20210909114106.141462-49-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ffec838450f3..32b2b6d9bde0 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -68,6 +68,8 @@ struct fsl_mc_addr_translation_range {
 #define MC_FAPR_PL	BIT(18)
 #define MC_FAPR_BMT	BIT(17)
 
+static phys_addr_t mc_portal_base_phys_addr;
+
 /**
  * fsl_mc_bus_match - device to driver matching callback
  * @dev: the fsl-mc device to match against
@@ -703,14 +705,30 @@ static int fsl_mc_device_get_mmio_regions(struct fsl_mc_device *mc_dev,
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
@@ -1126,6 +1144,8 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
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

