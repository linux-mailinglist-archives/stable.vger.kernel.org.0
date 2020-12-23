Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF352E1557
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgLWCVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:21:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729176AbgLWCVC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6899822A99;
        Wed, 23 Dec 2020 02:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690022;
        bh=UkGeKJkcCoTLxKNZoeNdLRsTAEj6DMtSyChkrv5bYHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftSi2EHDP/mzmb88YzPSF4HMdhiXt/IC2Ht+/DJqruPwqP474a8qhoYV0oX445UXI
         K/EJQickXfIxjS9tm3zZeaJAvx6ydL+nYa0yloHeorwNJu4Kc0uRsfGXAJxQGTBhcS
         XexhIuFfJkyD0fgDPyFdQybi19w21nAWgjwwSkEgnE8g9xbGau2Lr+sopl3VgJuqny
         hzboB40O2JYdwsCLqgCInRQU7Z4yitJebvJqNDAjBUBJxY1ME4cBLJ/BuyZn+hD5f7
         bDTRl5Ww5uzjlcMzuS3VR8ud9xNzm8kjbGoRMr/X7LWR2AGT38raJ9GoeiRUaBXwad
         Gv6DAmlr2BBEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 099/130] ARM: zynq: Fix leds subnode name for zc702/zybo-z7
Date:   Tue, 22 Dec 2020 21:17:42 -0500
Message-Id: <20201223021813.2791612-99-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

[ Upstream commit 38d1985fdfcf20dc246b552580479ae602f735d1 ]

Fix the leds subnode names to match (^led-[0-9a-f]$|led).

Similar change has been also done by commit 9a19a39ee48b ("arm64: dts:
zynqmp: Fix leds subnode name for zcu100/ultra96 v1").

The patch is fixing these warnings:
.../zynq-zc702.dt.yaml: leds: 'ds23' does not match any of the regexes:
'(^led-[0-9a-f]$|led)', 'pinctrl-[0-9]+'
>From schema: .../Documentation/devicetree/bindings/leds/leds-gpio.yaml
.../zynq-zybo-z7.dt.yaml: gpio-leds: 'ld4' does not match any of the
regexes: '(^led-[0-9a-f]$|led)', 'pinctrl-[0-9]+'
>From schema: .../Documentation/devicetree/bindings/leds/leds-gpio.yaml

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/607a66783b129294364abf09a6fc8abd241ff4ee.1606397101.git.michal.simek@xilinx.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/zynq-zc702.dts   | 2 +-
 arch/arm/boot/dts/zynq-zybo-z7.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index 27cd6cb52f1ba..10a7d0b8cf8b9 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -49,7 +49,7 @@ sw13 {
 	leds {
 		compatible = "gpio-leds";
 
-		ds23 {
+		led-ds23 {
 			label = "ds23";
 			gpios = <&gpio0 10 0>;
 			linux,default-trigger = "heartbeat";
diff --git a/arch/arm/boot/dts/zynq-zybo-z7.dts b/arch/arm/boot/dts/zynq-zybo-z7.dts
index 357b78a5c11b1..7b87e10d3953b 100644
--- a/arch/arm/boot/dts/zynq-zybo-z7.dts
+++ b/arch/arm/boot/dts/zynq-zybo-z7.dts
@@ -25,7 +25,7 @@ chosen {
 	gpio-leds {
 		compatible = "gpio-leds";
 
-		ld4 {
+		led-ld4 {
 			label = "zynq-zybo-z7:green:ld4";
 			gpios = <&gpio0 7 GPIO_ACTIVE_HIGH>;
 		};
-- 
2.27.0

