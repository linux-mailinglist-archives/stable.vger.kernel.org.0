Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8AA1014F0
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbfKSFi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:38:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:32846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729113AbfKSFiz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:38:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C146720721;
        Tue, 19 Nov 2019 05:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141933;
        bh=ZPjfq3pUDu+AsWiU2zu9iZRPXobWVshwV8XGX7wGb6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SVyNcVHuQZ8wVHiROT40+wMeVOIMchaJEQf7f8mhfZWQTEaffLL8PYx/FZHhkoIFy
         i+1CN8a7rFSx3Bq49ujGPFP7h1gqpUvv8lBTUWwVjj+lQYobNSA9I9CA03YenydFEi
         t91wAOfMNgJo8cl5IKE8YXZbJE9MOlLHhY2j5C8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 330/422] ARM: dts: rockchip: explicitly set vcc_sd0 pin to gpio on rk3188-radxarock
Date:   Tue, 19 Nov 2019 06:18:47 +0100
Message-Id: <20191119051420.401740360@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit a2df0984e73fd9e1dad5fc3f1c307ec3de395e30 ]

It is good practice to make the setting of gpio-pinctrls explicitly in the
devicetree, and in this case even necessary.
Rockchip boards start with iomux settings set to gpio for most pins and
while the linux pinctrl driver also implicitly sets the gpio function if
a pin is requested as gpio that is not necessarily true for other drivers.

The issue in question stems from uboot, where the sdmmc_pwr pin is set
to function 1 (sdmmc-power) by the bootrom when reading the 1st-stage
loader. The regulator controlled by the pin is active-low though, so
when the dwmmc hw-block sets its enabled bit, it actually disables the
regulator. By changing the pin back to gpio we fix that behaviour.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3188-radxarock.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/rk3188-radxarock.dts b/arch/arm/boot/dts/rk3188-radxarock.dts
index 45fd2b302dda1..4a2890618f6fc 100644
--- a/arch/arm/boot/dts/rk3188-radxarock.dts
+++ b/arch/arm/boot/dts/rk3188-radxarock.dts
@@ -93,6 +93,8 @@
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
 		gpio = <&gpio3 RK_PA1 GPIO_ACTIVE_LOW>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&sdmmc_pwr>;
 		startup-delay-us = <100000>;
 		vin-supply = <&vcc_io>;
 	};
@@ -315,6 +317,12 @@
 		};
 	};
 
+	sd0 {
+		sdmmc_pwr: sdmmc-pwr {
+			rockchip,pins = <RK_GPIO3 1 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+	};
+
 	usb {
 		host_vbus_drv: host-vbus-drv {
 			rockchip,pins = <0 3 RK_FUNC_GPIO &pcfg_pull_none>;
-- 
2.20.1



