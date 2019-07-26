Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCB376ACA
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 16:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfGZNkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbfGZNj7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:39:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D79D222BF5;
        Fri, 26 Jul 2019 13:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148398;
        bh=6pfJv0Z3H6UEml4/RtAsomE5oH9gg2HYiIJovd7fvfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vnP06DDw6/V1a9TgG7pvlYgqhqqFMpAlAZTWaYQXg515zXRYt9Y/7VNCziSqMr+kO
         RcCLxvEXtYIpzKPy8ZVTFb932Nx2hmEJtBJySaPbDJJOddIja85gzzgBByhpjySihk
         ZdBa9fgu2pxdP6Gbu4e6YQzZW/0WferYgswofgEc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helen Koike <helen.koike@collabora.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 12/85] arm64: dts: rockchip: fix isp iommu clocks and power domain
Date:   Fri, 26 Jul 2019 09:38:22 -0400
Message-Id: <20190726133936.11177-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helen Koike <helen.koike@collabora.com>

[ Upstream commit c432a29d3fc9ee928caeca2f5cf68b3aebfa6817 ]

isp iommu requires wrapper variants of the clocks.
noc variants are always on and using the wrapper variants will activate
{A,H}CLK_ISP{0,1} due to the hierarchy.

Tested using the pending isp patch set (which is not upstream
yet). Without this patch, streaming from the isp stalls.

Also add the respective power domain and remove the "disabled" status.

Refer:
 RK3399 TRM v1.4 Fig. 2-4 RK3399 Clock Architecture Diagram
 RK3399 TRM v1.4 Fig. 8-1 RK3399 Power Domain Partition

Signed-off-by: Helen Koike <helen.koike@collabora.com>
Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index 196ac9b78076..89594a7276f4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1706,11 +1706,11 @@
 		reg = <0x0 0xff914000 0x0 0x100>, <0x0 0xff915000 0x0 0x100>;
 		interrupts = <GIC_SPI 43 IRQ_TYPE_LEVEL_HIGH 0>;
 		interrupt-names = "isp0_mmu";
-		clocks = <&cru ACLK_ISP0_NOC>, <&cru HCLK_ISP0_NOC>;
+		clocks = <&cru ACLK_ISP0_WRAPPER>, <&cru HCLK_ISP0_WRAPPER>;
 		clock-names = "aclk", "iface";
 		#iommu-cells = <0>;
+		power-domains = <&power RK3399_PD_ISP0>;
 		rockchip,disable-mmu-reset;
-		status = "disabled";
 	};
 
 	isp1_mmu: iommu@ff924000 {
@@ -1718,11 +1718,11 @@
 		reg = <0x0 0xff924000 0x0 0x100>, <0x0 0xff925000 0x0 0x100>;
 		interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH 0>;
 		interrupt-names = "isp1_mmu";
-		clocks = <&cru ACLK_ISP1_NOC>, <&cru HCLK_ISP1_NOC>;
+		clocks = <&cru ACLK_ISP1_WRAPPER>, <&cru HCLK_ISP1_WRAPPER>;
 		clock-names = "aclk", "iface";
 		#iommu-cells = <0>;
+		power-domains = <&power RK3399_PD_ISP1>;
 		rockchip,disable-mmu-reset;
-		status = "disabled";
 	};
 
 	hdmi_sound: hdmi-sound {
-- 
2.20.1

