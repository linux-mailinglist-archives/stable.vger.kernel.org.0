Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B7640E835
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345432AbhIPRiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344627AbhIPRf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:35:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51F6461503;
        Thu, 16 Sep 2021 16:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810956;
        bh=ZvSQ1OUU86gLrsEgQH4jnCOte73nf4mNFHcHdG57YMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KK2B30FzhXDef5JfBuEtCL3Nqpqo3aAYg13JoR+eMhWsrTFPc6+38OzZGk6KIPX6P
         KMbm5SnHg/0GOBifZxJ44u2R2hnKPdBaHIyu9+CeFwQr6UjN+KnAwQAuHj1vV0sBPR
         I5SDTt0puUAzFCnj3z2yrbjwcsWdby8pbBtV6xtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 303/432] arm64: dts: imx8mm-venice-gw71xx: fix USB OTG VBUS
Date:   Thu, 16 Sep 2021 18:00:52 +0200
Message-Id: <20210916155821.093034366@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit bd306fdb4e60bcb1d7ea5431a74092803d3784a6 ]

The GW71xx has a USB Type-C connector with USB 2.0 signaling. GPIO1_12
is the power-enable to the TPS25821 Source controller and power switch
responsible for monitoring the CC pins and enabling VBUS. Therefore
GPIO1_12 must always be enabled and the vbus output enable from the
IMX8MM can be ignored.

To fix USB OTG VBUS enable a pull-up on GPIO1_12 to always power the
TPS25821 and change the regulator output to GPIO1_10 which is
unconnected.

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
index 905b68a3daa5..8e4a0ce99790 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
@@ -46,7 +46,7 @@ reg_usb_otg1_vbus: regulator-usb-otg1 {
 		pinctrl-0 = <&pinctrl_reg_usb1_en>;
 		compatible = "regulator-fixed";
 		regulator-name = "usb_otg1_vbus";
-		gpio = <&gpio1 12 GPIO_ACTIVE_HIGH>;
+		gpio = <&gpio1 10 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 		regulator-min-microvolt = <5000000>;
 		regulator-max-microvolt = <5000000>;
@@ -156,7 +156,8 @@ MX8MM_IOMUXC_GPIO1_IO15_GPIO1_IO15	0x41
 
 	pinctrl_reg_usb1_en: regusb1grp {
 		fsl,pins = <
-			MX8MM_IOMUXC_GPIO1_IO12_GPIO1_IO12	0x41
+			MX8MM_IOMUXC_GPIO1_IO10_GPIO1_IO10	0x41
+			MX8MM_IOMUXC_GPIO1_IO12_GPIO1_IO12	0x141
 			MX8MM_IOMUXC_GPIO1_IO13_USB1_OTG_OC	0x41
 		>;
 	};
-- 
2.30.2



