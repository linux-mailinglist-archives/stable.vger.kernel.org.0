Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624B53C8DD9
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbhGNTpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237088AbhGNTpM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:45:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78981613F8;
        Wed, 14 Jul 2021 19:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291705;
        bh=9Nk3/spMfVozeWDhx63OJP8tGztlAFpk4J1r7m/We0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nl3XUHv+NWmR0G07h4hxNrq50Vwk27PHjzPfWJrdkAovJmEyUKYgYE1oQAZXuZvpw
         hcEMhvFam0/2pixof601VewyWVfF+Y19Mm2mcYvKq+e1KzGgh71cdAsmxI8y4400Bb
         f6mgCigEHxy16ojSJ45VXn/7qbJbEkGFPGHG2/0dHZRw5OUL5n9J7gsRebQaPZ/T71
         tULsjz14LbBGsAUSq+ynbEWBGGWJ7tzYAzCGxeaCrcSbmthfmHOmcTjpM9PZnoEVhu
         5ewY6XksViltvi9qABvOqIpzpq1meT3ftOUcQvWPITIUPqpfib1uCDB/j4bahoDfFx
         TEYFPt1QZcOYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 049/102] arm64: tegra: Add PMU node for Tegra194
Date:   Wed, 14 Jul 2021 15:39:42 -0400
Message-Id: <20210714194036.53141-49-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit 9e79e58f330ea4860f2ced65a8a35dfb05fc03c1 ]

Populate the device-tree node for the PMU device on Tegra194. This also
fixes the following warning that is observed on booting Tegra194.

 ERR KERN kvm: pmu event creation failed -2

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra194.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index 9449156fae39..2e40b6047283 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -2345,6 +2345,20 @@ l3c: l3-cache {
 		};
 	};
 
+	pmu {
+		compatible = "arm,armv8-pmuv3";
+		interrupts = <GIC_SPI 384 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 385 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 386 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 387 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 388 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 389 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 390 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 391 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-affinity = <&cpu0_0 &cpu0_1 &cpu1_0 &cpu1_1
+				      &cpu2_0 &cpu2_1 &cpu3_0 &cpu3_1>;
+	};
+
 	psci {
 		compatible = "arm,psci-1.0";
 		status = "okay";
-- 
2.30.2

