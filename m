Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863703287CB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238520AbhCAR2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:28:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238161AbhCARXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:23:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A69164ED6;
        Mon,  1 Mar 2021 16:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617355;
        bh=xerIsFzExni5txIsBkbguWWcNbi1jFUFSRXEiM48xBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMiyv14p4FmVjp6AI6kfhH/UlRE6YCcKFR5zy65+g5KbD/1izpEX44ZL5NunvMk2F
         CyITp/Jzag5sq0jHxNcLW8TrDR5gvMHS0Qt3blqWYWb6YiZZJ8M1SnGppaCV0iVMGM
         aEku7YtWyJqMtjNyXIx+7lxhbomOs6cE/tz2G6u0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rosen Penev <rosenp@gmail.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/340] ARM: dts: armada388-helios4: assign pinctrl to LEDs
Date:   Mon,  1 Mar 2021 17:09:49 +0100
Message-Id: <20210301161050.547676900@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit e011c9025a4691b5c734029577a920bd6c320994 ]

Split up the pins to match earlier definitions. Allows LEDs to flash
properly.

Fixes: ced8025b569e ("ARM: dts: armada388-helios4")

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-388-helios4.dts | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/armada-388-helios4.dts b/arch/arm/boot/dts/armada-388-helios4.dts
index 705adfa8c680f..e0fa1391948c1 100644
--- a/arch/arm/boot/dts/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/armada-388-helios4.dts
@@ -70,6 +70,9 @@
 
 	system-leds {
 		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <&helios_system_led_pins>;
+
 		status-led {
 			label = "helios4:green:status";
 			gpios = <&gpio0 24 GPIO_ACTIVE_LOW>;
@@ -86,6 +89,9 @@
 
 	io-leds {
 		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <&helios_io_led_pins>;
+
 		sata1-led {
 			label = "helios4:green:ata1";
 			gpios = <&gpio1 17 GPIO_ACTIVE_LOW>;
@@ -291,9 +297,12 @@
 						       "mpp39", "mpp40";
 					marvell,function = "sd0";
 				};
-				helios_led_pins: helios-led-pins {
-					marvell,pins = "mpp24", "mpp25",
-						       "mpp49", "mpp50",
+				helios_system_led_pins: helios-system-led-pins {
+					marvell,pins = "mpp24", "mpp25";
+					marvell,function = "gpio";
+				};
+				helios_io_led_pins: helios-io-led-pins {
+					marvell,pins = "mpp49", "mpp50",
 						       "mpp52", "mpp53",
 						       "mpp54";
 					marvell,function = "gpio";
-- 
2.27.0



