Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8681B3F2E
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbgDVKf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:35:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730345AbgDVKXa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:23:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 663C12076B;
        Wed, 22 Apr 2020 10:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551009;
        bh=ZhmmQ2uQggeQBv8vRD13OM1tsKFrpXqz7RaKpwCXUT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSXhpD56Zo0A2niQua7v2n5L5b173GC6kWMmz9mR3GfbsZdzKeJuL1JC3JK4khUhX
         1wKaGmkl9YMQdl48OYRtoAsx+Plq4PGTt7Ze4tCXaiNN43yGUGPQOWTXCYZ+W29Xp1
         3rkQuD53Jvn/eWw8nn6VypfhfDlHE1UY/yedgNNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 062/166] arm64: tegra: Fix Tegra194 PCIe compatible string
Date:   Wed, 22 Apr 2020 11:56:29 +0200
Message-Id: <20200422095055.477818565@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



