Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7829F4C940
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 10:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730401AbfFTISS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 04:18:18 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11518 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfFTISS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 04:18:18 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d0b41480001>; Thu, 20 Jun 2019 01:18:16 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 20 Jun 2019 01:18:17 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 20 Jun 2019 01:18:17 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL103.nvidia.com
 (172.20.187.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 20 Jun
 2019 08:18:16 +0000
Received: from hqnvemgw01.nvidia.com (172.20.150.20) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 20 Jun 2019 08:18:16 +0000
Received: from moonraker.nvidia.com (Not Verified[10.21.132.148]) by hqnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5d0b41470002>; Thu, 20 Jun 2019 01:18:16 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC:     <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/3] arm64: tegra: Fix AGIC register range
Date:   Thu, 20 Jun 2019 09:17:00 +0100
Message-ID: <20190620081702.17209-2-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620081702.17209-1-jonathanh@nvidia.com>
References: <20190620081702.17209-1-jonathanh@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1561018696; bh=AFWbg5jHWgDuhe1K+3FnMNM26/5yFQ71F6D5eMqY7+8=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=SjUgDKdHcWadQA0jGkdW9zLhjKICCJ2s+KBdmiy0Cixd5uM3C3uLGl6pYB9rqphmN
         dydNUtci5cccMstt45mc3jgfpWtA8B1cYZcgcb+hl5+S/VReuukiv3uCUMXIFQP69F
         8xihO3kyBsh6Dp3gHLgwohqbWKwK5+4GZlpTO47iwl08AAS7H1gdMpHgTQE7JU8Kkv
         L1EgBWQ21sU36sRTa2q0oUKwZw4HSKhWmWLHfjDcawy1LI3jGuAViBlk8Vkj41h8tF
         ulQdjxKkNgMVGJga5htT8r25HKeR+y5ZvarJCxrSWXkwXi//QD3AmptBvIyCEjaMzt
         +IChI4oO3w3DA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Tegra AGIC interrupt controller is an ARM GIC400 interrupt
controller. Per the ARM GIC device-tree binding, the first address
region is for the GIC distributor registers and the second address
region is for the GIC CPU interface registers. The address space for
the distributor registers is 4kB, but currently this is incorrectly
defined as 8kB for the Tegra AGIC and overlaps with the CPU interface
registers. Correct the address space for the distributor to be 4kB.

Cc: stable@vger.kernel.org
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra210.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210.dtsi b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
index edf27fe2f10e..ec762b3455b4 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
@@ -1258,7 +1258,7 @@
 			compatible = "nvidia,tegra210-agic";
 			#interrupt-cells = <3>;
 			interrupt-controller;
-			reg = <0x702f9000 0x2000>,
+			reg = <0x702f9000 0x1000>,
 			      <0x702fa000 0x2000>;
 			interrupts = <GIC_SPI 102 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
 			clocks = <&tegra_car TEGRA210_CLK_APE>;
-- 
2.17.1

