Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15B2313F971
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731590AbgAPTZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:25:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:35768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730101AbgAPQwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:52:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20D7E2073A;
        Thu, 16 Jan 2020 16:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193557;
        bh=ih2gnmgItQFLMhY5RSN4tZvX7fs5Sa/mH/Wd0Wfpllc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nB22gdPyqHxHYRqkwwRIuOmfi9ATMWO0XJZ4d2KcQI+tDdXkO2CmRGlO46ZllRY0W
         bsUPGuFc16YKEBUIXxMiaKf0sLiQpvAjh9GhBVRIhkR9Ig5Irhi1EDE+lx/eibMmZg
         eGuYVCt52363fRo9bkJ95xPzkVUIjOhANCvLuFaw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 103/205] arm64: dts: allwinner: a64: Re-add PMU node
Date:   Thu, 16 Jan 2020 11:41:18 -0500
Message-Id: <20200116164300.6705-103-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 6b832a148717f1718f57805a9a4aa7f092582d15 ]

As it was found recently, the Performance Monitoring Unit (PMU) on the
Allwinner A64 SoC was not generating (the right) interrupts. With the
SPI numbers from the manual the kernel did not receive any overflow
interrupts, so perf was not happy at all.
It turns out that the numbers were just off by 4, so the PMU interrupts
are from 148 to 151, not from 152 to 155 as the manual describes.

This was found by playing around with U-Boot, which typically does not
use interrupts, so the GIC is fully available for experimentation:
With *every* PPI and SPI enabled, an overflowing PMU cycle counter was
found to set a bit in one of the GICD_ISPENDR registers, with careful
counting this was determined to be number 148.

Tested with perf record and perf top on a Pine64-LTS. Also tested with
tasksetting to every core to confirm the assignment between IRQs and
cores.

This somewhat "revert-fixes" commit ed3e9406bcbc ("arm64: dts: allwinner:
a64: Drop PMU node").

Fixes: 34a97fcc71c2 ("arm64: dts: allwinner: a64: Add PMU node")
Fixes: ed3e9406bcbc ("arm64: dts: allwinner: a64: Drop PMU node")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
index 70f4cce6be43..ba41c1b85887 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -142,6 +142,15 @@
 		clock-output-names = "ext-osc32k";
 	};
 
+	pmu {
+		compatible = "arm,cortex-a53-pmu";
+		interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-affinity = <&cpu0>, <&cpu1>, <&cpu2>, <&cpu3>;
+	};
+
 	psci {
 		compatible = "arm,psci-0.2";
 		method = "smc";
-- 
2.20.1

