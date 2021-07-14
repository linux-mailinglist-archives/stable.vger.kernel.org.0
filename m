Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0EEA3C8E39
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237500AbhGNTq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:46:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237545AbhGNTqG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:46:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AFF06140C;
        Wed, 14 Jul 2021 19:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291749;
        bh=D+Vn7BHciUU72abRGv2PgNL21V8jbuLfrDPCzZQpGEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gyy5zYtjjqp+h3Duf1Gb6ulNQ7rdFz6ILTE3Rvc17UuLmwWxmxnxcCTz5obV/to/j
         nwXKgJ7haoLaEgoc/gNdpuaEpvsbiqiDAifm/eprab8kHOkgv8BASK4pa6jBNP8Qla
         pMvbVSb1Gk8+MZzxse/rh/ba7Hb3bKQ4AMud+pM8RWJI85j4/KS1Akgy9TiiiQOx6S
         q2WQWjlS+quE2BboZHG/s3Rlk1c9jxms8yg2X6egmJVgfIPyS9TnHF8VOCq8svrQ9U
         5Y7TzLSyLwvwPDyv4G6hQ1Fpu1iP2vgA4IcH1TWGx4wDRFkH1D2ICV4IQPYnDDjs1y
         Enti/7KmNAnhw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Punit Agrawal <punitagrawal@gmail.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 079/102] arm64: dts: rockchip: Update RK3399 PCI host bridge window to 32-bit address memory
Date:   Wed, 14 Jul 2021 15:40:12 -0400
Message-Id: <20210714194036.53141-79-sashal@kernel.org>
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

From: Punit Agrawal <punitagrawal@gmail.com>

[ Upstream commit 8efe01b4386ab38a36b99cfdc1dc02c38a8898c3 ]

The PCIe host bridge on RK3399 advertises a single 64-bit memory
address range even though it lies entirely below 4GB.

Previously the OF PCI range parser treated 64-bit ranges more
leniently (i.e., as 32-bit), but since commit 9d57e61bf723 ("of/pci:
Add IORESOURCE_MEM_64 to resource flags for 64-bit memory addresses")
the code takes a stricter view and treats the ranges as advertised in
the device tree (i.e, as 64-bit).

The change in behaviour causes failure when allocating bus addresses
to devices connected behind a PCI-to-PCI bridge that require
non-prefetchable memory ranges. The allocation failure was observed
for certain Samsung NVMe drives connected to RockPro64 boards.

Update the host bridge window attributes to treat it as 32-bit address
memory. This fixes the allocation failure observed since commit
9d57e61bf723.

Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Link: https://lore.kernel.org/r/7a1e2ebc-f7d8-8431-d844-41a9c36a8911@arm.com
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Punit Agrawal <punitagrawal@gmail.com>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Link: https://lore.kernel.org/r/20210607112856.3499682-5-punitagrawal@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index b265cc1b558d..62846464a885 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -230,7 +230,7 @@ pcie0: pcie@f8000000 {
 		       <&pcie_phy 2>, <&pcie_phy 3>;
 		phy-names = "pcie-phy-0", "pcie-phy-1",
 			    "pcie-phy-2", "pcie-phy-3";
-		ranges = <0x83000000 0x0 0xfa000000 0x0 0xfa000000 0x0 0x1e00000>,
+		ranges = <0x82000000 0x0 0xfa000000 0x0 0xfa000000 0x0 0x1e00000>,
 			 <0x81000000 0x0 0xfbe00000 0x0 0xfbe00000 0x0 0x100000>;
 		resets = <&cru SRST_PCIE_CORE>, <&cru SRST_PCIE_MGMT>,
 			 <&cru SRST_PCIE_MGMT_STICKY>, <&cru SRST_PCIE_PIPE>,
-- 
2.30.2

