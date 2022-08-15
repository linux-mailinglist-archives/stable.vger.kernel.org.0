Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06FAB5943A9
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349969AbiHOWir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351215AbiHOWht (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:37:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9475131A20;
        Mon, 15 Aug 2022 12:50:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE173B80EA9;
        Mon, 15 Aug 2022 19:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9965C433C1;
        Mon, 15 Aug 2022 19:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593050;
        bh=fPVeWMC/ovYGoOxF8Dy4nU7X5WfCiJFMiv7uIN3LPTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1eDhbKoXyNMXWnxO5OpfRG2K0q8lE/2yGQ7TZaZvoWjIUsXjnwcKU5WUiVGiSnvP/
         1C+mlf2qwrkGsJ/sJb7F94GWF9/ctva9SzRdG1EkflBtqnyKSzja8L3TUZyUIEWySP
         gwzYLfpKZL33Eg+O8sPnPiOoToaN+i7yswLau/Yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0205/1157] ARM: dts: imx7-colibri: add usb dual-role switching using extcon
Date:   Mon, 15 Aug 2022 19:52:41 +0200
Message-Id: <20220815180447.856894359@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philippe Schenker <philippe.schenker@toradex.com>

[ Upstream commit 136f88458d829987548b3321e7122e05acd78dd9 ]

Add USB dual-role switching using extcon.

Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>
Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi | 8 ++++++++
 arch/arm/boot/dts/imx7-colibri.dtsi         | 5 ++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi b/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi
index d6fa74222960..17ad9065646d 100644
--- a/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi
+++ b/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi
@@ -20,6 +20,13 @@ clk16m: clk16m {
 		clock-frequency = <16000000>;
 	};
 
+	extcon_usbc_det: usbc-det {
+		compatible = "linux,extcon-usb-gpio";
+		id-gpio = <&gpio7 14 GPIO_ACTIVE_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_usbc_det>;
+	};
+
 	gpio-keys {
 		compatible = "gpio-keys";
 		pinctrl-names = "default";
@@ -141,6 +148,7 @@ &uart3 {
 };
 
 &usbotg1 {
+	extcon = <0>, <&extcon_usbc_det>;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/imx7-colibri.dtsi b/arch/arm/boot/dts/imx7-colibri.dtsi
index e20b0977f38f..4146564c3e4b 100644
--- a/arch/arm/boot/dts/imx7-colibri.dtsi
+++ b/arch/arm/boot/dts/imx7-colibri.dtsi
@@ -497,7 +497,7 @@ &uart3 {
 };
 
 &usbotg1 {
-	dr_mode = "host";
+	dr_mode = "otg";
 };
 
 &usdhc1 {
@@ -525,8 +525,7 @@ &usdhc3 {
 
 &iomuxc {
 	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_gpio1 &pinctrl_gpio2 &pinctrl_gpio3 &pinctrl_gpio4
-		     &pinctrl_usbc_det>;
+	pinctrl-0 = <&pinctrl_gpio1 &pinctrl_gpio2 &pinctrl_gpio3 &pinctrl_gpio4>;
 
 	/*
 	 * Atmel MXT touchsceen + Capacitive Touch Adapter
-- 
2.35.1



