Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B88B1677A4
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730324AbgBUHz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:55:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:54430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730314AbgBUHz1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:55:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12BA0222C4;
        Fri, 21 Feb 2020 07:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271726;
        bh=kpIYvkygOL80jCOC4mTASNNjnr+Ez++17Cyd5v07r7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6NDvZJD2Ni+CTBIGFKJAckcwRnOfd/UGMuBTVvwYqCEcAXnhdZzle2NEFjYIOwTh
         f6kOQwYcuiqF+lB5XqFq0psSxZLPAnrgfia5TkmUnVvNRcpC6Mi7JAPONDxlqZpNnb
         MSBVTS3JU8TZhCS0dxzWsBKJ3ock3hW5fiOrlb30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Jonker <jbx6244@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 238/399] arm64: dts: rockchip: add reg property to brcmf sub-nodes
Date:   Fri, 21 Feb 2020 08:39:23 +0100
Message-Id: <20200221072425.751806916@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit 96ff264bccb22175bbe2185a1eb5204ca3c5f03f ]

An experimental test with the command below gives this error:
rk3399-firefly.dt.yaml: dwmmc@fe310000: wifi@1:
'reg' is a required property
rk3399-orangepi.dt.yaml: dwmmc@fe310000: wifi@1:
'reg' is a required property
rk3399-khadas-edge.dt.yaml: dwmmc@fe310000: wifi@1:
'reg' is a required property
rk3399-khadas-edge-captain.dt.yaml: dwmmc@fe310000: wifi@1:
'reg' is a required property
rk3399-khadas-edge-v.dt.yaml: dwmmc@fe310000: wifi@1:
'reg' is a required property
So fix this by adding a reg property to the brcmf sub node.
Also add #address-cells and #size-cells to prevent more warnings.

make ARCH=arm64 dtbs_check
DT_SCHEMA_FILES=Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.yaml

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/20200110142128.13522-1-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-firefly.dts      | 3 +++
 arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi | 3 +++
 arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts     | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
index c706db0ee9ec6..76f5db696009b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
@@ -669,9 +669,12 @@
 	vqmmc-supply = &vcc1v8_s3;	/* IO line */
 	vmmc-supply = &vcc_sdio;	/* card's power */
 
+	#address-cells = <1>;
+	#size-cells = <0>;
 	status = "okay";
 
 	brcmf: wifi@1 {
+		reg = <1>;
 		compatible = "brcm,bcm4329-fmac";
 		interrupt-parent = <&gpio0>;
 		interrupts = <RK_PA3 GPIO_ACTIVE_HIGH>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi
index 4944d78a0a1cb..e87a04477440e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi
@@ -654,9 +654,12 @@
 	sd-uhs-sdr104;
 	vqmmc-supply = <&vcc1v8_s3>;
 	vmmc-supply = <&vccio_sd>;
+	#address-cells = <1>;
+	#size-cells = <0>;
 	status = "okay";
 
 	brcmf: wifi@1 {
+		reg = <1>;
 		compatible = "brcm,bcm4329-fmac";
 		interrupt-parent = <&gpio0>;
 		interrupts = <RK_PA3 GPIO_ACTIVE_HIGH>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts b/arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts
index 0541dfce924d6..9c659f3115c88 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts
@@ -648,9 +648,12 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&sdio0_bus4 &sdio0_cmd &sdio0_clk>;
 	sd-uhs-sdr104;
+	#address-cells = <1>;
+	#size-cells = <0>;
 	status = "okay";
 
 	brcmf: wifi@1 {
+		reg = <1>;
 		compatible = "brcm,bcm4329-fmac";
 		interrupt-parent = <&gpio0>;
 		interrupts = <RK_PA3 GPIO_ACTIVE_HIGH>;
-- 
2.20.1



