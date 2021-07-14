Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A723C8F7D
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238430AbhGNTwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239897AbhGNTt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C541F61419;
        Wed, 14 Jul 2021 19:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291875;
        bh=S8f7hXnO7LbGpXhz0IeSZWpMMMzugPoTBMCiQn49kGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgiCtHXishu7V6kCOLFW1B9xTif0gRPuInXztBYjNfIdw3nJ93OVV8eRevo3O9lIv
         2VZ9idQWpcPxKfPfu1A34g91Ra3if6DsI2jJavaWNU/CG7qkJtOSTeU7oLctlMhoM+
         22cyCW2OqpQ9YvAWpQETOvOQdO8mdDqJ4w3Sl8K8p6mP1ALZZkO5DWf97B+ewrYBUv
         rUk0kwrYEggh60l3d15mxjJivQbWL7GA2MBbbiGDadeHTx8LF0Gp01o5HzLJcfy0Of
         Mjpk7zdZUGtUBItT5RX7qF5Z6bBJN509D9OqvZKhODNkkVcEO1AFdHz2KHBZGFo4/j
         ay4hgdvP0tD1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 61/88] ARM: dts: stm32: move stmmac axi config in ethernet node on stm32mp15
Date:   Wed, 14 Jul 2021 15:42:36 -0400
Message-Id: <20210714194303.54028-61-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -1395,12 +1395,6 @@ crc1: crc@58009000 {
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
@@ -1424,6 +1418,12 @@ ethernet0: ethernet@5800a000 {
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

