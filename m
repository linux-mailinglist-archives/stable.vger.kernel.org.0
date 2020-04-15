Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1E61AA09C
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369412AbgDOM3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:29:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409108AbgDOLo5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:44:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03E8C206A2;
        Wed, 15 Apr 2020 11:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951096;
        bh=FuwEmhHqtJHJQqebXlx5aIR78KRZjDzvHcsUNRBbHZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvsHBAimPdePTFw1iPblY5fNZjUxANklhs6HMVjasRQ8G9hRmprSO99cvPF28imNt
         x7NWT8ko4LJY2Ys0BCa7mnfAWR+RjqEA2e2oJNE3oYp21bKk/6yKtYMafPj3RFFgsp
         6tx87mygpU5sxWLeDnmqU+5HEeMJNW9uLXrVD680=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/84] arm64: tegra: Fix Tegra194 PCIe compatible string
Date:   Wed, 15 Apr 2020 07:43:29 -0400
Message-Id: <20200415114442.14166-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
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
index 57adcbb7352d6..457b815d57f40 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -1151,7 +1151,7 @@
 	};
 
 	pcie@14100000 {
-		compatible = "nvidia,tegra194-pcie", "snps,dw-pcie";
+		compatible = "nvidia,tegra194-pcie";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX1A>;
 		reg = <0x00 0x14100000 0x0 0x00020000   /* appl registers (128K)      */
 		       0x00 0x30000000 0x0 0x00040000   /* configuration space (256K) */
@@ -1197,7 +1197,7 @@
 	};
 
 	pcie@14120000 {
-		compatible = "nvidia,tegra194-pcie", "snps,dw-pcie";
+		compatible = "nvidia,tegra194-pcie";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX1A>;
 		reg = <0x00 0x14120000 0x0 0x00020000   /* appl registers (128K)      */
 		       0x00 0x32000000 0x0 0x00040000   /* configuration space (256K) */
@@ -1243,7 +1243,7 @@
 	};
 
 	pcie@14140000 {
-		compatible = "nvidia,tegra194-pcie", "snps,dw-pcie";
+		compatible = "nvidia,tegra194-pcie";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX1A>;
 		reg = <0x00 0x14140000 0x0 0x00020000   /* appl registers (128K)      */
 		       0x00 0x34000000 0x0 0x00040000   /* configuration space (256K) */
@@ -1289,7 +1289,7 @@
 	};
 
 	pcie@14160000 {
-		compatible = "nvidia,tegra194-pcie", "snps,dw-pcie";
+		compatible = "nvidia,tegra194-pcie";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX4A>;
 		reg = <0x00 0x14160000 0x0 0x00020000   /* appl registers (128K)      */
 		       0x00 0x36000000 0x0 0x00040000   /* configuration space (256K) */
@@ -1335,7 +1335,7 @@
 	};
 
 	pcie@14180000 {
-		compatible = "nvidia,tegra194-pcie", "snps,dw-pcie";
+		compatible = "nvidia,tegra194-pcie";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8B>;
 		reg = <0x00 0x14180000 0x0 0x00020000   /* appl registers (128K)      */
 		       0x00 0x38000000 0x0 0x00040000   /* configuration space (256K) */
@@ -1381,7 +1381,7 @@
 	};
 
 	pcie@141a0000 {
-		compatible = "nvidia,tegra194-pcie", "snps,dw-pcie";
+		compatible = "nvidia,tegra194-pcie";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8A>;
 		reg = <0x00 0x141a0000 0x0 0x00020000   /* appl registers (128K)      */
 		       0x00 0x3a000000 0x0 0x00040000   /* configuration space (256K) */
-- 
2.20.1

