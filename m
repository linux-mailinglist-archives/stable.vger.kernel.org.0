Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9881AA3FB
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370688AbgDONPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897032AbgDOLfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:35:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A23720737;
        Wed, 15 Apr 2020 11:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950515;
        bh=ZhmmQ2uQggeQBv8vRD13OM1tsKFrpXqz7RaKpwCXUT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q99amnyvGewC+rN8aRmSBpPwXShqNTwpeAPuNmD2T0y7DkBi+8KH7b+0vHUiuIIxG
         /SOt4Yonzs2kAJWu4MpAQPsKmsNXNLixOj4lEKuE6WZUTESSCfA2Hys2DBuS6Kxn45
         lrtO528fL/lpOlny3ztP9em9OOpavAw5ufE3qKcw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 025/129] arm64: tegra: Fix Tegra194 PCIe compatible string
Date:   Wed, 15 Apr 2020 07:33:00 -0400
Message-Id: <20200415113445.11881-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit f9f711efd441ad0d22874be49986d92121862335 ]

If the kernel configuration option CONFIG_PCIE_DW_PLAT_HOST is enabled
then this can cause the kernel to incorrectly probe the generic
designware PCIe platform driver instead of the Tegra194 designware PCIe
driver. This causes a boot failure on Tegra194 because the necessary
configuration to access the hardware is not performed.

The order in which the compatible strings are populated in Device-Tree
is not relevant in this case, because the kernel will attempt to probe
the device as soon as a driver is loaded and if the generic designware
PCIe driver is loaded first, then this driver will be probed first.
Therefore, to fix this problem, remove the "snps,dw-pcie" string from
the compatible string as we never want this driver to be probe on
Tegra194.

Fixes: 2602c32f15e7 ("arm64: tegra: Add P2U and PCIe controller nodes to Tegra194 DT")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/pci/nvidia,tegra194-pcie.txt |  2 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi             | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/nvidia,tegra194-pcie.txt b/Documentation/devicetree/bindings/pci/nvidia,tegra194-pcie.txt
index b739f92da58e5..1f90eb39870be 100644
--- a/Documentation/devicetree/bindings/pci/nvidia,tegra194-pcie.txt
+++ b/Documentation/devicetree/bindings/pci/nvidia,tegra194-pcie.txt
@@ -118,7 +118,7 @@ Tegra194:
 --------
 
 	pcie@14180000 {
-		compatible = "nvidia,tegra194-pcie", "snps,dw-pcie";
+		compatible = "nvidia,tegra194-pcie";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8B>;
 		reg = <0x00 0x14180000 0x0 0x00020000   /* appl registers (128K)      */
 		       0x00 0x38000000 0x0 0x00040000   /* configuration space (256K) */
diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index 844e7fac30c58..a8f024662e60e 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -1208,7 +1208,7 @@
 	};
 
 	pcie@14100000 {
-		compatible = "nvidia,tegra194-pcie", "snps,dw-pcie";
+		compatible = "nvidia,tegra194-pcie";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX1A>;
 		reg = <0x00 0x14100000 0x0 0x00020000   /* appl registers (128K)      */
 		       0x00 0x30000000 0x0 0x00040000   /* configuration space (256K) */
@@ -1253,7 +1253,7 @@
 	};
 
 	pcie@14120000 {
-		compatible = "nvidia,tegra194-pcie", "snps,dw-pcie";
+		compatible = "nvidia,tegra194-pcie";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX1A>;
 		reg = <0x00 0x14120000 0x0 0x00020000   /* appl registers (128K)      */
 		       0x00 0x32000000 0x0 0x00040000   /* configuration space (256K) */
@@ -1298,7 +1298,7 @@
 	};
 
 	pcie@14140000 {
-		compatible = "nvidia,tegra194-pcie", "snps,dw-pcie";
+		compatible = "nvidia,tegra194-pcie";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX1A>;
 		reg = <0x00 0x14140000 0x0 0x00020000   /* appl registers (128K)      */
 		       0x00 0x34000000 0x0 0x00040000   /* configuration space (256K) */
@@ -1343,7 +1343,7 @@
 	};
 
 	pcie@14160000 {
-		compatible = "nvidia,tegra194-pcie", "snps,dw-pcie";
+		compatible = "nvidia,tegra194-pcie";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX4A>;
 		reg = <0x00 0x14160000 0x0 0x00020000   /* appl registers (128K)      */
 		       0x00 0x36000000 0x0 0x00040000   /* configuration space (256K) */
@@ -1388,7 +1388,7 @@
 	};
 
 	pcie@14180000 {
-		compatible = "nvidia,tegra194-pcie", "snps,dw-pcie";
+		compatible = "nvidia,tegra194-pcie";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8B>;
 		reg = <0x00 0x14180000 0x0 0x00020000   /* appl registers (128K)      */
 		       0x00 0x38000000 0x0 0x00040000   /* configuration space (256K) */
@@ -1433,7 +1433,7 @@
 	};
 
 	pcie@141a0000 {
-		compatible = "nvidia,tegra194-pcie", "snps,dw-pcie";
+		compatible = "nvidia,tegra194-pcie";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8A>;
 		reg = <0x00 0x141a0000 0x0 0x00020000   /* appl registers (128K)      */
 		       0x00 0x3a000000 0x0 0x00040000   /* configuration space (256K) */
-- 
2.20.1

