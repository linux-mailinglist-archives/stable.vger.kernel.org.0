Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33060226983
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbgGTQ04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732308AbgGTP7t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:59:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CB6A22CE3;
        Mon, 20 Jul 2020 15:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260788;
        bh=63C2BzO4C1F7uvfStR458+NxPuILGJ2wLEBMtiBq4e4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfAGVH4hC8evtYrs475y0N2Ign6Bz/NkvEZUu2fe46Rk0df4yqXyvSvmhbtX1WBCs
         J3hK1IKW3V1Cq/BeotHPB/fvRYyepTPhoIDwAc8i4s8AD/ae2HKCHsGmhwmX/RF5NJ
         nSr29gWEBNmlt34cLXQLYMSLf5qRhFVGCgmnc7Aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tero Kristo <t-kristo@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/215] ARM: OMAP4+: remove pdata quirks for omap4+ iommus
Date:   Mon, 20 Jul 2020 17:35:48 +0200
Message-Id: <20200720152823.349765045@linuxfoundation.org>
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

From: Tero Kristo <t-kristo@ti.com>

[ Upstream commit e4c4b540e1e6c21ff8b987e92b2bd170ee006a94 ]

IOMMU driver will be using ti-sysc bus driver for power management control
going forward, and the pdata quirks are not needed for anything anymore.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/pdata-quirks.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 247e3f8acffe6..5acd29cb8d749 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -311,16 +311,6 @@ static void __init omap3_pandora_legacy_init(void)
 }
 #endif /* CONFIG_ARCH_OMAP3 */
 
-#if defined(CONFIG_ARCH_OMAP4) || defined(CONFIG_SOC_OMAP5)
-static struct iommu_platform_data omap4_iommu_pdata = {
-	.reset_name = "mmu_cache",
-	.assert_reset = omap_device_assert_hardreset,
-	.deassert_reset = omap_device_deassert_hardreset,
-	.device_enable = omap_device_enable,
-	.device_idle = omap_device_idle,
-};
-#endif
-
 #if defined(CONFIG_SOC_AM33XX) || defined(CONFIG_SOC_AM43XX)
 static struct wkup_m3_platform_data wkup_m3_data = {
 	.reset_name = "wkup_m3",
@@ -543,10 +533,6 @@ static struct of_dev_auxdata omap_auxdata_lookup[] = {
 		       &wkup_m3_data),
 #endif
 #if defined(CONFIG_ARCH_OMAP4) || defined(CONFIG_SOC_OMAP5)
-	OF_DEV_AUXDATA("ti,omap4-iommu", 0x4a066000, "4a066000.mmu",
-		       &omap4_iommu_pdata),
-	OF_DEV_AUXDATA("ti,omap4-iommu", 0x55082000, "55082000.mmu",
-		       &omap4_iommu_pdata),
 	OF_DEV_AUXDATA("ti,omap4-smartreflex-iva", 0x4a0db000,
 		       "4a0db000.smartreflex", &omap_sr_pdata[OMAP_SR_IVA]),
 	OF_DEV_AUXDATA("ti,omap4-smartreflex-core", 0x4a0dd000,
-- 
2.25.1



