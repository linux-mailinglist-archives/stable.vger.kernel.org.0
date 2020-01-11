Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B486C138021
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbgAKK0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:26:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:58732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729047AbgAKK0U (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:26:20 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC58A2082E;
        Sat, 11 Jan 2020 10:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738379;
        bh=COBC09XpNymQw6b0tBfDvAq6aOaIfPtQHpnj8ZBaIzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+cNUK1kVQVnmsBnxDNPC0yZseApGcypw7uzalVLUCBIJpRY22VrbF9Nyr7PtNu2K
         +xHkPNqshd5OuT6i1qKIzBCpmoU4PQcaBh37LbhUz1KlcsLIq3QUt3ErFiOV5gQf4D
         EF/Rgq6ScMVTLcoFitKlNjW0aFNsgdmCayQjqGjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Wandun <chenwandun@huawei.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/165] habanalabs: remove variable val set but not used
Date:   Sat, 11 Jan 2020 10:50:01 +0100
Message-Id: <20200111094928.031788029@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Wandun <chenwandun@huawei.com>

[ Upstream commit 68a1fdf2451f38b4ada0607eb6e1303f8a02e0b7 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/misc/habanalabs/goya/goya.c: In function goya_pldm_init_cpu:
drivers/misc/habanalabs/goya/goya.c:2195:6: warning: variable val set but not used [-Wunused-but-set-variable]
drivers/misc/habanalabs/goya/goya.c: In function goya_hw_init:
drivers/misc/habanalabs/goya/goya.c:2505:6: warning: variable val set but not used [-Wunused-but-set-variable]

Fixes: 9494a8dd8d22 ("habanalabs: add h/w queues module")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/goya/goya.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index 6fba14b81f90..fe3574a83b7c 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -2171,7 +2171,7 @@ static int goya_push_linux_to_device(struct hl_device *hdev)
 
 static int goya_pldm_init_cpu(struct hl_device *hdev)
 {
-	u32 val, unit_rst_val;
+	u32 unit_rst_val;
 	int rc;
 
 	/* Must initialize SRAM scrambler before pushing u-boot to SRAM */
@@ -2179,14 +2179,14 @@ static int goya_pldm_init_cpu(struct hl_device *hdev)
 
 	/* Put ARM cores into reset */
 	WREG32(mmCPU_CA53_CFG_ARM_RST_CONTROL, CPU_RESET_ASSERT);
-	val = RREG32(mmCPU_CA53_CFG_ARM_RST_CONTROL);
+	RREG32(mmCPU_CA53_CFG_ARM_RST_CONTROL);
 
 	/* Reset the CA53 MACRO */
 	unit_rst_val = RREG32(mmPSOC_GLOBAL_CONF_UNIT_RST_N);
 	WREG32(mmPSOC_GLOBAL_CONF_UNIT_RST_N, CA53_RESET);
-	val = RREG32(mmPSOC_GLOBAL_CONF_UNIT_RST_N);
+	RREG32(mmPSOC_GLOBAL_CONF_UNIT_RST_N);
 	WREG32(mmPSOC_GLOBAL_CONF_UNIT_RST_N, unit_rst_val);
-	val = RREG32(mmPSOC_GLOBAL_CONF_UNIT_RST_N);
+	RREG32(mmPSOC_GLOBAL_CONF_UNIT_RST_N);
 
 	rc = goya_push_uboot_to_device(hdev);
 	if (rc)
@@ -2207,7 +2207,7 @@ static int goya_pldm_init_cpu(struct hl_device *hdev)
 	/* Release ARM core 0 from reset */
 	WREG32(mmCPU_CA53_CFG_ARM_RST_CONTROL,
 					CPU_RESET_CORE0_DEASSERT);
-	val = RREG32(mmCPU_CA53_CFG_ARM_RST_CONTROL);
+	RREG32(mmCPU_CA53_CFG_ARM_RST_CONTROL);
 
 	return 0;
 }
@@ -2475,13 +2475,12 @@ int goya_mmu_init(struct hl_device *hdev)
 static int goya_hw_init(struct hl_device *hdev)
 {
 	struct asic_fixed_properties *prop = &hdev->asic_prop;
-	u32 val;
 	int rc;
 
 	dev_info(hdev->dev, "Starting initialization of H/W\n");
 
 	/* Perform read from the device to make sure device is up */
-	val = RREG32(mmPCIE_DBI_DEVICE_ID_VENDOR_ID_REG);
+	RREG32(mmPCIE_DBI_DEVICE_ID_VENDOR_ID_REG);
 
 	/*
 	 * Let's mark in the H/W that we have reached this point. We check
@@ -2533,7 +2532,7 @@ static int goya_hw_init(struct hl_device *hdev)
 		goto disable_queues;
 
 	/* Perform read from the device to flush all MSI-X configuration */
-	val = RREG32(mmPCIE_DBI_DEVICE_ID_VENDOR_ID_REG);
+	RREG32(mmPCIE_DBI_DEVICE_ID_VENDOR_ID_REG);
 
 	return 0;
 
-- 
2.20.1



