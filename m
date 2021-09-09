Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3535A404C05
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242337AbhIILz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242959AbhIILw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:52:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5506861359;
        Thu,  9 Sep 2021 11:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187869;
        bh=ZvSQ1OUU86gLrsEgQH4jnCOte73nf4mNFHcHdG57YMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wd4Oig6A7r2Vk9zSnnRWFf8RHc5J28xgLKXcg8wN4z5vS4oBhm2m8Jipwu/Rf81L9
         zx8i/XgagAdMH+PasDMYTjY4h0gSvSMAsE+8+MPIK6JqNYvvKxnWWiesQ/jfyAaaGo
         mFL6ooDy1jijmZbJvtOpGjI/uwXZm6wjv54MwSaEKjfZOFLsJAJPYEXKQ7fqJMz+8l
         tkKw4gdO2qeZ/gAAvXWkw9UNgmxyaGV001Y90mSKiItZKocUAoEMPF7IN5sdpPJILA
         MkSXRqh8MNch0ZsrIC3vutlG0eK2gsJefj+Xy6Oq+tYlxZ1CtpHQB/2a5gs8nKVVAs
         CqxxKBsfsMX7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 155/252] arm64: dts: imx8mm-venice-gw71xx: fix USB OTG VBUS
Date:   Thu,  9 Sep 2021 07:39:29 -0400
Message-Id: <20210909114106.141462-155-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

