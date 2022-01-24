Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552B74999A8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455916AbiAXVgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:36:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39110 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441926AbiAXVZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:25:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C393B8121C;
        Mon, 24 Jan 2022 21:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776FAC340E4;
        Mon, 24 Jan 2022 21:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059504;
        bh=ogVrOynjJInkjAmfKe6hnKYsopbVCDm3RpXJSJ1b72Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iGsW5KXwOI7h5ycHBEcdk5m3XwKoXgzNqh/OUwj2dWw07BtUNXQxbu5BulO56iVH1
         ASmUbh/Pq3bjiOnIbzL1ppNcItM+Qk0jc8egeC2xlx9IjmH/FNarg2xaWsmdx51saY
         WUHxsIEjVrLw0ww3sUZx+MprpMwCWHgGO477tCJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jagan Teki <jagan@amarulasolutions.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0637/1039] arm64: dts: rockchip: Fix Bluetooth on ROCK Pi 4 boards
Date:   Mon, 24 Jan 2022 19:40:26 +0100
Message-Id: <20220124184146.756351667@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jagan Teki <jagan@amarulasolutions.com>

[ Upstream commit f471b1b2db0819917c54099ab68349ad6a7e9e19 ]

This patch fixes the Bluetooth on ROCK Pi 4 boards.

ROCK Pi 4 boards has BCM4345C5 and now it is supported
on Mainline Linux, brcm,bcm43438-bt still working but
observed the BT Audio issues with latest test.

So, use the BCM4345C5 compatible and its associated
properties like clock-names as lpo and max-speed.

Attach vbat and vddio supply rails as well.

Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
Link: https://lore.kernel.org/r/20211112142359.320798-1-jagan@amarulasolutions.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4b-plus.dts | 7 +++++--
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4b.dts      | 7 +++++--
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4c.dts      | 7 +++++--
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4b-plus.dts b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4b-plus.dts
index dfad13d2ab249..5bd2b8db3d51a 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4b-plus.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4b-plus.dts
@@ -35,13 +35,16 @@
 	status = "okay";
 
 	bluetooth {
-		compatible = "brcm,bcm43438-bt";
+		compatible = "brcm,bcm4345c5";
 		clocks = <&rk808 1>;
-		clock-names = "ext_clock";
+		clock-names = "lpo";
 		device-wakeup-gpios = <&gpio2 RK_PD3 GPIO_ACTIVE_HIGH>;
 		host-wakeup-gpios = <&gpio0 RK_PA4 GPIO_ACTIVE_HIGH>;
 		shutdown-gpios = <&gpio0 RK_PB1 GPIO_ACTIVE_HIGH>;
+		max-speed = <1500000>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&bt_host_wake_l &bt_wake_l &bt_enable_h>;
+		vbat-supply = <&vcc3v3_sys>;
+		vddio-supply = <&vcc_1v8>;
 	};
 };
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4b.dts b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4b.dts
index 6c63e617063c9..cf48746a3ad81 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4b.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4b.dts
@@ -34,13 +34,16 @@
 	status = "okay";
 
 	bluetooth {
-		compatible = "brcm,bcm43438-bt";
+		compatible = "brcm,bcm4345c5";
 		clocks = <&rk808 1>;
-		clock-names = "ext_clock";
+		clock-names = "lpo";
 		device-wakeup-gpios = <&gpio2 RK_PD3 GPIO_ACTIVE_HIGH>;
 		host-wakeup-gpios = <&gpio0 RK_PA4 GPIO_ACTIVE_HIGH>;
 		shutdown-gpios = <&gpio0 RK_PB1 GPIO_ACTIVE_HIGH>;
+		max-speed = <1500000>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&bt_host_wake_l &bt_wake_l &bt_enable_h>;
+		vbat-supply = <&vcc3v3_sys>;
+		vddio-supply = <&vcc_1v8>;
 	};
 };
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4c.dts b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4c.dts
index 99169bcd51c03..57ddf55ee6930 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4c.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4c.dts
@@ -35,14 +35,17 @@
 	status = "okay";
 
 	bluetooth {
-		compatible = "brcm,bcm43438-bt";
+		compatible = "brcm,bcm4345c5";
 		clocks = <&rk808 1>;
-		clock-names = "ext_clock";
+		clock-names = "lpo";
 		device-wakeup-gpios = <&gpio2 RK_PD3 GPIO_ACTIVE_HIGH>;
 		host-wakeup-gpios = <&gpio0 RK_PA4 GPIO_ACTIVE_HIGH>;
 		shutdown-gpios = <&gpio0 RK_PB1 GPIO_ACTIVE_HIGH>;
+		max-speed = <1500000>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&bt_host_wake_l &bt_wake_l &bt_enable_h>;
+		vbat-supply = <&vcc3v3_sys>;
+		vddio-supply = <&vcc_1v8>;
 	};
 };
 
-- 
2.34.1



