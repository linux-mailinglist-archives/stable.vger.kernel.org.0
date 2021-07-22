Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3C33D2876
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhGVP5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:57:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232923AbhGVP5C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:57:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6B3E60FDA;
        Thu, 22 Jul 2021 16:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971857;
        bh=NcBccA72PeBQL0og7hYVpxXbQTmDaR+wUbVLEYA4chU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cu+1onvJwTYFsu0U3R6eeQSy7LvYwlFmVxjEjN7wZpi5zz7HSXPy/O+U9D3ncdtXg
         o+F1A8XgDwzcAHLuWzcMdnXkGkuGee5hBJfBnDhbK5wwEAahFeW3E5cF2p+OikMWhf
         NuA8A+pSZb3LSOOMm4AgMhniHu8x9XZRh5fFV5C0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/125] ARM: dts: stm32: move stmmac axi config in ethernet node on stm32mp15
Date:   Thu, 22 Jul 2021 18:30:45 +0200
Message-Id: <20210722155626.507141560@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@foss.st.com>

[ Upstream commit fb1406335c067be074eab38206cf9abfdce2fb0b ]

It fixes the following warning seen running "make dtbs_check W=1"

Warning (simple_bus_reg): /soc/stmmac-axi-config: missing or empty
reg/ranges property

Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp151.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp151.dtsi b/arch/arm/boot/dts/stm32mp151.dtsi
index 84757901cd8d..b479016fef00 100644
--- a/arch/arm/boot/dts/stm32mp151.dtsi
+++ b/arch/arm/boot/dts/stm32mp151.dtsi
@@ -1395,12 +1395,6 @@
 			status = "disabled";
 		};
 
-		stmmac_axi_config_0: stmmac-axi-config {
-			snps,wr_osr_lmt = <0x7>;
-			snps,rd_osr_lmt = <0x7>;
-			snps,blen = <0 0 0 0 16 8 4>;
-		};
-
 		ethernet0: ethernet@5800a000 {
 			compatible = "st,stm32mp1-dwmac", "snps,dwmac-4.20a";
 			reg = <0x5800a000 0x2000>;
@@ -1424,6 +1418,12 @@
 			snps,axi-config = <&stmmac_axi_config_0>;
 			snps,tso;
 			status = "disabled";
+
+			stmmac_axi_config_0: stmmac-axi-config {
+				snps,wr_osr_lmt = <0x7>;
+				snps,rd_osr_lmt = <0x7>;
+				snps,blen = <0 0 0 0 16 8 4>;
+			};
 		};
 
 		usbh_ohci: usbh-ohci@5800c000 {
-- 
2.30.2



