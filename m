Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655C822697F
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgGTQ0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732321AbgGTP7z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:59:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 989C120773;
        Mon, 20 Jul 2020 15:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260794;
        bh=Bm/lQlmxc451a2USTrKvsSDu6xFrgYucqoQNjCRXdXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmEgQZmZUySLWbGeanishgo8QV6zljHN8EE2QXB6vyhL4FNuZfgfOE2SsC8XiFOk0
         5PAGLHPYVdRAYUPY7uO06BOK1vaJy3sfdAHUXsS6gX2xhBVZ9e8OLWi7gFNITzUT2V
         L9Uf4OsL7q/ixR18I8+S6Zjp7wlpGXsvjjZOUSTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/215] ARM: OMAP2+: use separate IOMMU pdata to fix DRA7 IPU1 boot
Date:   Mon, 20 Jul 2020 17:35:50 +0200
Message-Id: <20200720152823.447175373@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

[ Upstream commit 4601832f40501efc3c2fd264a5a69bd1ac17d520 ]

The IPU1 MMU has been using common IOMMU pdata quirks defined and
used by all IPU IOMMU devices on OMAP4 and beyond. Separate out the
pdata for IPU1 MMU with the additional .set_pwrdm_constraint ops
plugged in, so that the IPU1 power domain can be restricted to ON
state during the boot and active period of the IPU1 remote processor.
This eliminates the pre-conditions for the IPU1 boot issue as
described in commit afe518400bdb ("iommu/omap: fix boot issue on
remoteprocs with AMMU/Unicache").

NOTE:
1. RET is not a valid target power domain state on DRA7 platforms,
   and IPU power domain is normally programmed for OFF. The IPU1
   still fails to boot though, and an unclearable l3_noc error is
   thrown currently on 4.14 kernel without this fix. This behavior
   is slightly different from previous 4.9 LTS kernel.
2. The fix is currently applied only to IPU1 on DRA7xx SoC, as the
   other affected processors on OMAP4/OMAP5/DRA7 are in domains
   that are not entering RET. IPU2 on DRA7 is in CORE power domain
   which is only programmed for ON power state. The fix can be easily
   scaled if these domains do hit RET in the future.
3. The issue was not seen on current DRA7 platforms if any of the
   DSP remote processors were booted and using one of the GPTimers
   5, 6, 7 or 8 on previous 4.9 LTS kernel. This was due to the
   errata fix for i874 implemented in commit 1cbabcb9807e ("ARM:
   DRA7: clockdomain: Implement timer workaround for errata i874")
   which keeps the IPU1 power domain from entering RET when the
   timers are active. But the timer workaround did not make any
   difference on 4.14 kernel, and an l3_noc error was seen still
   without this fix.

Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/pdata-quirks.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 5acd29cb8d749..ca07e310d9ed5 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -44,6 +44,17 @@ struct pdata_init {
 static struct of_dev_auxdata omap_auxdata_lookup[];
 static struct twl4030_gpio_platform_data twl_gpio_auxdata;
 
+#if IS_ENABLED(CONFIG_OMAP_IOMMU)
+int omap_iommu_set_pwrdm_constraint(struct platform_device *pdev, bool request,
+				    u8 *pwrst);
+#else
+static inline int omap_iommu_set_pwrdm_constraint(struct platform_device *pdev,
+						  bool request, u8 *pwrst)
+{
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_MACH_NOKIA_N8X0
 static void __init omap2420_n8x0_legacy_init(void)
 {
@@ -326,6 +337,10 @@ static void __init omap5_uevm_legacy_init(void)
 #endif
 
 #ifdef CONFIG_SOC_DRA7XX
+static struct iommu_platform_data dra7_ipu1_dsp_iommu_pdata = {
+	.set_pwrdm_constraint = omap_iommu_set_pwrdm_constraint,
+};
+
 static struct omap_hsmmc_platform_data dra7_hsmmc_data_mmc1;
 static struct omap_hsmmc_platform_data dra7_hsmmc_data_mmc2;
 static struct omap_hsmmc_platform_data dra7_hsmmc_data_mmc3;
@@ -547,6 +562,12 @@ static struct of_dev_auxdata omap_auxdata_lookup[] = {
 		       &dra7_hsmmc_data_mmc2),
 	OF_DEV_AUXDATA("ti,dra7-hsmmc", 0x480ad000, "480ad000.mmc",
 		       &dra7_hsmmc_data_mmc3),
+	OF_DEV_AUXDATA("ti,dra7-dsp-iommu", 0x40d01000, "40d01000.mmu",
+		       &dra7_ipu1_dsp_iommu_pdata),
+	OF_DEV_AUXDATA("ti,dra7-dsp-iommu", 0x41501000, "41501000.mmu",
+		       &dra7_ipu1_dsp_iommu_pdata),
+	OF_DEV_AUXDATA("ti,dra7-iommu", 0x58882000, "58882000.mmu",
+		       &dra7_ipu1_dsp_iommu_pdata),
 #endif
 	/* Common auxdata */
 	OF_DEV_AUXDATA("ti,sysc", 0, NULL, &ti_sysc_pdata),
-- 
2.25.1



