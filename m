Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6508C15F359
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388960AbgBNSKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:10:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:32992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731306AbgBNPxk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:53:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFECA2468F;
        Fri, 14 Feb 2020 15:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695619;
        bh=umkV5fwuqprToRUAnQrW6cSjJXWD2Elo4G15T2wuuk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ualH+9EKmxPq9hC6vZdDtIAemCOgG9U6zjVU6kUllZuX0MjQLGW82zX8tQpkTRIes
         YpeBv8fqP8F0k/YTToXTELXHGyWxbKUkJ1RMJML+hCOvUdgi+UfzL3er4I64qyZbmw
         Y/euPdSrpRKu+ocqkX3TfWGs+Vz4v3C5PtpCxE5w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 219/542] ARM: OMAP2+: use separate IOMMU pdata to fix DRA7 IPU1 boot
Date:   Fri, 14 Feb 2020 10:43:31 -0500
Message-Id: <20200214154854.6746-219-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 7a79bcc02a11b..c3be1db9685cd 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -43,6 +43,17 @@ struct pdata_init {
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
@@ -286,6 +297,10 @@ static void __init omap5_uevm_legacy_init(void)
 #endif
 
 #ifdef CONFIG_SOC_DRA7XX
+static struct iommu_platform_data dra7_ipu1_dsp_iommu_pdata = {
+	.set_pwrdm_constraint = omap_iommu_set_pwrdm_constraint,
+};
+
 static struct omap_hsmmc_platform_data dra7_hsmmc_data_mmc1;
 static struct omap_hsmmc_platform_data dra7_hsmmc_data_mmc2;
 static struct omap_hsmmc_platform_data dra7_hsmmc_data_mmc3;
@@ -517,6 +532,12 @@ static struct of_dev_auxdata omap_auxdata_lookup[] = {
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
2.20.1

