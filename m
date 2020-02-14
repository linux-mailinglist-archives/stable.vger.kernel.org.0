Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5F615F356
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393078AbgBNSKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:10:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:32936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730852AbgBNPxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:53:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A60A724676;
        Fri, 14 Feb 2020 15:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695618;
        bh=gUEGfpV552sDu9X3kZ+5/zD3JhIkLGBT0fJ533BkoeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kthkcr7qlEBFntUjaLOLVX6TKiACvCTyMzWygK7z7OD4RVs8LaPsfru5ECYF7XJWK
         tRAsXPShHrCdUXbovT4kH+B4OeDmaJirrHpUEZ+4vxIkmLMQktId7ql06MwI3fxOZP
         JriROeaGnT5MX1XGELEJYx793/XsD7Ra2sETQ//s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 218/542] ARM: OMAP2+: Add workaround for DRA7 DSP MStandby errata i879
Date:   Fri, 14 Feb 2020 10:43:30 -0500
Message-Id: <20200214154854.6746-218-sashal@kernel.org>
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

[ Upstream commit 2f14101a1d760db72393910d481fbf7768c44530 ]

Errata Title:
i879: DSP MStandby requires CD_EMU in SW_WKUP

Description:
The DSP requires the internal emulation clock to be actively toggling
in order to successfully enter a low power mode via execution of the
IDLE instruction and PRCM MStandby/Idle handshake. This assumes that
other prerequisites and software sequence are followed.

Workaround:
The emulation clock to the DSP is free-running anytime CCS is connected
via JTAG debugger to the DSP subsystem or when the CD_EMU clock domain
is set in SW_WKUP mode. The CD_EMU domain can be set in SW_WKUP mode
via the CM_EMU_CLKSTCTRL [1:0]CLKTRCTRL field.

Implementation:
This patch implements this workaround by denying the HW_AUTO mode
for the EMU clockdomain during the power-up of any DSP processor
and re-enabling the HW_AUTO mode during the shutdown of the last
DSP processor (actually done during the enabling and disabling of
the respective DSP MDMA MMUs). Reference counting has to be used to
manage the independent sequencing between the multiple DSP processors.

This switching is done at runtime rather than a static clockdomain
flags value to meet the target power domain state for the EMU power
domain during suspend.

Note that the DSP MStandby behavior is not consistent across all
boards prior to this fix. Please see commit 45f871eec6c0 ("ARM:
OMAP2+: Extend DRA7 IPU1 MMU pdata quirks to DSP MDMA MMUs") for
details.

Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/omap-iommu.c | 43 +++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-omap2/omap-iommu.c
index f1a6ece8108e4..78247e6f4a720 100644
--- a/arch/arm/mach-omap2/omap-iommu.c
+++ b/arch/arm/mach-omap2/omap-iommu.c
@@ -11,14 +11,43 @@
 
 #include "omap_hwmod.h"
 #include "omap_device.h"
+#include "clockdomain.h"
 #include "powerdomain.h"
 
+static void omap_iommu_dra7_emu_swsup_config(struct platform_device *pdev,
+					     bool enable)
+{
+	static struct clockdomain *emu_clkdm;
+	static DEFINE_SPINLOCK(emu_lock);
+	static atomic_t count;
+	struct device_node *np = pdev->dev.of_node;
+
+	if (!of_device_is_compatible(np, "ti,dra7-dsp-iommu"))
+		return;
+
+	if (!emu_clkdm) {
+		emu_clkdm = clkdm_lookup("emu_clkdm");
+		if (WARN_ON_ONCE(!emu_clkdm))
+			return;
+	}
+
+	spin_lock(&emu_lock);
+
+	if (enable && (atomic_inc_return(&count) == 1))
+		clkdm_deny_idle(emu_clkdm);
+	else if (!enable && (atomic_dec_return(&count) == 0))
+		clkdm_allow_idle(emu_clkdm);
+
+	spin_unlock(&emu_lock);
+}
+
 int omap_iommu_set_pwrdm_constraint(struct platform_device *pdev, bool request,
 				    u8 *pwrst)
 {
 	struct powerdomain *pwrdm;
 	struct omap_device *od;
 	u8 next_pwrst;
+	int ret = 0;
 
 	od = to_omap_device(pdev);
 	if (!od)
@@ -31,13 +60,21 @@ int omap_iommu_set_pwrdm_constraint(struct platform_device *pdev, bool request,
 	if (!pwrdm)
 		return -EINVAL;
 
-	if (request)
+	if (request) {
 		*pwrst = pwrdm_read_next_pwrst(pwrdm);
+		omap_iommu_dra7_emu_swsup_config(pdev, true);
+	}
 
 	if (*pwrst > PWRDM_POWER_RET)
-		return 0;
+		goto out;
 
 	next_pwrst = request ? PWRDM_POWER_ON : *pwrst;
 
-	return pwrdm_set_next_pwrst(pwrdm, next_pwrst);
+	ret = pwrdm_set_next_pwrst(pwrdm, next_pwrst);
+
+out:
+	if (!request)
+		omap_iommu_dra7_emu_swsup_config(pdev, false);
+
+	return ret;
 }
-- 
2.20.1

