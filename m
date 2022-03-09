Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270B74D3461
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbiCIQY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238164AbiCIQVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:21:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4629A149979;
        Wed,  9 Mar 2022 08:19:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1B9EB82221;
        Wed,  9 Mar 2022 16:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1831C340E8;
        Wed,  9 Mar 2022 16:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842794;
        bh=Y/AzchoFpdLn6g8WkJT0uKS4BVm0X//JoewFAWcfMvk=;
        h=From:To:Cc:Subject:Date:From;
        b=XSV6AM7vzZFLqYyU1n7HWW6ahG9lO2FniA14hp8whdwYWh4c3K2cAKv2FTKJJBzCj
         B9nWQvn2CiS/hyXrv4nsWBAaWnUY44Kqkc8yaEsgF04VNGzByzm07boG4sh/QZt6mv
         rzjlrLSqq01qnziQwHsmt2FueQvcdiwT5xiiK0iWEPvf7b2YLqQ3tIfI5HFzuCXEiC
         Xm6g1QL2KBh/gHCccjSKtHp1wSI9tyuQc6kbr7qCYUs2ZlvZvxPmF55xIr1wtnNqlw
         Z44tCVTqZfD4VsASYpPbUIXXo5fiqrsGXVCjsdc9K1xMv4zpXF2P2oTqi6VdsmCw5V
         u+I/f0a+ZPieQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quentin Schulz <quentin.schulz@theobroma-systems.com>,
        Quentin Schulz <foss+kernel@0leil.net>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        jakob.unterwurzacher@theobroma-systems.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 01/24] arm64: dts: rockchip: fix rk3399-puma-haikou USB OTG mode
Date:   Wed,  9 Mar 2022 11:19:20 -0500
Message-Id: <20220309161946.136122-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

[ Upstream commit ed2c66a95c0c5669880aa93d0d34c6e9694b4cbd ]

The micro USB3.0 port available on the Haikou evaluation kit for Puma
RK3399-Q7 SoM supports dual-role model (aka drd or OTG) but its support
was broken until now because of missing logic around the ID pin.

This adds proper support for USB OTG on Puma Haikou by "connecting" the
GPIO used for USB ID to the USB3 controller device.

Cc: Quentin Schulz <foss+kernel@0leil.net>
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://lore.kernel.org/r/20220120125156.16217-1-quentin.schulz@theobroma-systems.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/rockchip/rk3399-puma-haikou.dts |  1 +
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts b/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
index 292bb7e80cf3..3ae5d727e367 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
@@ -232,6 +232,7 @@ &usbdrd3_0 {
 
 &usbdrd_dwc3_0 {
 	dr_mode = "otg";
+	extcon = <&extcon_usb3>;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index fb67db4619ea..002ece51c3ba 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -25,6 +25,13 @@ module_led: led-0 {
 		};
 	};
 
+	extcon_usb3: extcon-usb3 {
+		compatible = "linux,extcon-usb-gpio";
+		id-gpio = <&gpio1 RK_PC2 GPIO_ACTIVE_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&usb3_id>;
+	};
+
 	clkin_gmac: external-gmac-clock {
 		compatible = "fixed-clock";
 		clock-frequency = <125000000>;
@@ -422,6 +429,13 @@ vcc5v0_host_en: vcc5v0-host-en {
 			  <4 RK_PA3 RK_FUNC_GPIO &pcfg_pull_none>;
 		};
 	};
+
+	usb3 {
+		usb3_id: usb3-id {
+			rockchip,pins =
+			  <1 RK_PC2 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+	};
 };
 
 &sdhci {
-- 
2.34.1

