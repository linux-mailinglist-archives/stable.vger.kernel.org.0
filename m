Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8C3491562
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343514AbiARC1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:27:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42696 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245470AbiARCZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:25:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38D836110F;
        Tue, 18 Jan 2022 02:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A0DC36AE3;
        Tue, 18 Jan 2022 02:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472745;
        bh=Chc9JxYeropHxv0l4lx9PHgC5dJsgohvIR5/56p+Y3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmsB62sFKiLBR0QBOKBjBnU+vOFtu7md2pG6qsu/thRDv1Sn17zivykXr+15L1i1d
         kVonbab5nbEsNS5EUZgyH7Ucv837ThmYRHKnqvLnTOoFsEl8lVH/g3N/zV/+gz4TnU
         Zq3H2JccaIukpDKiTRA2U7ay+0bjGB+5aVnciKwigyN695VK8tNq+RPzP5g/nTs8W1
         y33HVMzFU6/mcRX3v4CwIHHIh2wkwUZrfoXEUcGqNqMrYnuLnio9m6y70AreNFTcyb
         TUcy73MuQM64F7vyT+P/cVTLBpAk6j6RwY67khTFyqb19xwKm/AJxeMn/0XNjTJbL3
         g4GjQxDd0v8yQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jagan Teki <jagan@amarulasolutions.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        knaerzche@gmail.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 119/217] arm64: dts: rockchip: Fix Bluetooth on ROCK Pi 4 boards
Date:   Mon, 17 Jan 2022 21:18:02 -0500
Message-Id: <20220118021940.1942199-119-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -35,13 +35,16 @@ &uart0 {
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
@@ -34,13 +34,16 @@ &uart0 {
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
@@ -35,14 +35,17 @@ &uart0 {
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

