Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9043C4DC6D7
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbiCQM4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234233AbiCQMzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:55:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24879F3BD;
        Thu, 17 Mar 2022 05:53:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ED5C61584;
        Thu, 17 Mar 2022 12:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37187C340F3;
        Thu, 17 Mar 2022 12:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521633;
        bh=WB/A9z0bllwl5fTK4cuQmxEQkRdoAy5zWdRVr5axPS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bo1vnoUo3gL405reGq15VEhZ0aDMKERl28d2cA1IxrhG18McIcC0JGpnL8dF1xs5t
         KJoIKOd1MClB6YQ/vqfJRzBlfZSHw2cxCso4NrXU0GZNTbEGYx7SP6i1Drz3T4CBPQ
         UwixKnIWbVAHruprvOv0ijUQEyClXLxAZcWi56b0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Schulz <foss+kernel@0leil.net>,
        Quentin Schulz <quentin.schulz@theobroma-systems.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 03/28] arm64: dts: rockchip: fix rk3399-puma-haikou USB OTG mode
Date:   Thu, 17 Mar 2022 13:45:54 +0100
Message-Id: <20220317124526.868575839@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124526.768423926@linuxfoundation.org>
References: <20220317124526.768423926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -232,6 +232,7 @@
 
 &usbdrd_dwc3_0 {
 	dr_mode = "otg";
+	extcon = <&extcon_usb3>;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index fb67db4619ea..002ece51c3ba 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -25,6 +25,13 @@
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
@@ -422,6 +429,13 @@
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



