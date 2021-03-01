Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F62C328638
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237051AbhCARGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:06:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236361AbhCAQ7K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:59:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DD5764FEC;
        Mon,  1 Mar 2021 16:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616663;
        bh=7bmUylwCmFDCO3RBeR0FrqKbR3jqsXbJXNa2pLEdlLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcraBztv1ZlBwxSjbnTnrIvZEfuKgk7MYyADPVjl5LNRPMKhAuYxsK2iNjQeumfbq
         Ng0TM5XmfTKMWBWs9y+xCffSi5IpMEIoubVX/SxLCF07coljH1mMflI1IEc/0U1hTD
         HC/wgypOeuokTbuJjhqu8P0ZL/17mDsxvOLPNb8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rosen Penev <rosenp@gmail.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/247] ARM: dts: armada388-helios4: assign pinctrl to each fan
Date:   Mon,  1 Mar 2021 17:11:12 +0100
Message-Id: <20210301161034.219829753@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 46ecdfc1830eaa40a11d7f832089c82b0e67ea96 ]

Split up the pins for each fan. This is needed in order to control them

Fixes: ced8025b569e ("ARM: dts: armada388-helios4")

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-388-helios4.dts | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/armada-388-helios4.dts b/arch/arm/boot/dts/armada-388-helios4.dts
index e0fa1391948c1..a94758090fb0d 100644
--- a/arch/arm/boot/dts/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/armada-388-helios4.dts
@@ -127,11 +127,15 @@
 	fan1: j10-pwm {
 		compatible = "pwm-fan";
 		pwms = <&gpio1 9 40000>;	/* Target freq:25 kHz */
+		pinctrl-names = "default";
+		pinctrl-0 = <&helios_fan1_pins>;
 	};
 
 	fan2: j17-pwm {
 		compatible = "pwm-fan";
 		pwms = <&gpio1 23 40000>;	/* Target freq:25 kHz */
+		pinctrl-names = "default";
+		pinctrl-0 = <&helios_fan2_pins>;
 	};
 
 	usb2_phy: usb2-phy {
@@ -307,9 +311,12 @@
 						       "mpp54";
 					marvell,function = "gpio";
 				};
-				helios_fan_pins: helios-fan-pins {
-					marvell,pins = "mpp41", "mpp43",
-						       "mpp48", "mpp55";
+				helios_fan1_pins: helios_fan1_pins {
+					marvell,pins = "mpp41", "mpp43";
+					marvell,function = "gpio";
+				};
+				helios_fan2_pins: helios_fan2_pins {
+					marvell,pins = "mpp48", "mpp55";
 					marvell,function = "gpio";
 				};
 				microsom_spi1_cs_pins: spi1-cs-pins {
-- 
2.27.0



