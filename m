Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 649EBF4960
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389761AbfKHMCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:02:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388148AbfKHLmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:42:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87439222C5;
        Fri,  8 Nov 2019 11:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213375;
        bh=jSGFsiKCQFZBLSEAsjsqgfDUw/IFfM12cjJ2KDf7CbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvvv4hqxrIF3SsUrIENelz8BGnmuk/l8GD16SaoEdXmeuLJlX+3hnyIsJFwZIFoWM
         C+CrGibob3vq1EsN6PeRXZos6u+sjQEY2Q+cwJjopbXhWhu7bVPwP8LmVUqREOgrE8
         pJIpIsMPotLu6+DPd/awFiJB9b/Lj0/5YYTv8GN8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 200/205] ARM: dts: rockchip: Fix erroneous SPI bus dtc warnings on rk3036
Date:   Fri,  8 Nov 2019 06:37:47 -0500
Message-Id: <20191108113752.12502-200-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 131c3eb428ccd5f0c784b9edb4f72ec296a045d2 ]

dtc has new checks for SPI buses. The rk3036 dts file has a node named
spi' which causes false positive warnings. As the node is a pinctrl child
node, change the node name to be 'spi-pins' to fix the warnings.

arch/arm/boot/dts/rk3036-evb.dtb: Warning (spi_bus_bridge): /pinctrl/spi: incorrect #address-cells for SPI bus
arch/arm/boot/dts/rk3036-kylin.dtb: Warning (spi_bus_bridge): /pinctrl/spi: incorrect #address-cells for SPI bus
arch/arm/boot/dts/rk3036-evb.dtb: Warning (spi_bus_bridge): /pinctrl/spi: incorrect #size-cells for SPI bus
arch/arm/boot/dts/rk3036-kylin.dtb: Warning (spi_bus_bridge): /pinctrl/spi: incorrect #size-cells for SPI bus

Cc: Heiko Stuebner <heiko@sntech.de>
Cc: linux-rockchip@lists.infradead.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3036.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3036.dtsi b/arch/arm/boot/dts/rk3036.dtsi
index 67f57200d9a06..d560fc4051c5f 100644
--- a/arch/arm/boot/dts/rk3036.dtsi
+++ b/arch/arm/boot/dts/rk3036.dtsi
@@ -733,7 +733,7 @@
 			/* no rts / cts for uart2 */
 		};
 
-		spi {
+		spi-pins {
 			spi_txd:spi-txd {
 				rockchip,pins = <1 29 RK_FUNC_3 &pcfg_pull_default>;
 			};
-- 
2.20.1

