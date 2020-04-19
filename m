Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289F31AFC94
	for <lists+stable@lfdr.de>; Sun, 19 Apr 2020 19:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgDSRMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Apr 2020 13:12:47 -0400
Received: from v6.sk ([167.172.42.174]:44022 "EHLO v6.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbgDSRMj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Apr 2020 13:12:39 -0400
Received: from localhost (v6.sk [IPv6:::1])
        by v6.sk (Postfix) with ESMTP id 6EFA3610BE;
        Sun, 19 Apr 2020 17:12:38 +0000 (UTC)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     soc@kernel.org
Cc:     Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        linux-kernel@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>,
        stable@vger.kernel.org
Subject: [PATCH 15/15] ARM: dts: mmp3-dell-ariel: Fix the SPI devices
Date:   Sun, 19 Apr 2020 19:11:57 +0200
Message-Id: <20200419171157.672999-16-lkundrak@v3.sk>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200419171157.672999-1-lkundrak@v3.sk>
References: <20200419171157.672999-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I've managed to get about everything wrong while digging these out of
OEM's board file.

Correct the bus numbers, the exact model of the NOR flash, polarity of
the chip selects and align the SPI frequency with the data sheet.

Tested that it works now, with a slight fix to the PXA SSP driver.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: <stable@vger.kernel.org>
---
 arch/arm/boot/dts/mmp3-dell-ariel.dts | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/mmp3-dell-ariel.dts b/arch/arm/boot/dts/mmp3-dell-ariel.dts
index 15449c72c042b..b0ec14c421641 100644
--- a/arch/arm/boot/dts/mmp3-dell-ariel.dts
+++ b/arch/arm/boot/dts/mmp3-dell-ariel.dts
@@ -98,19 +98,19 @@ &twsi4 {
 	status = "okay";
 };
 
-&ssp3 {
+&ssp1 {
 	status = "okay";
-	cs-gpios = <&gpio 46 GPIO_ACTIVE_HIGH>;
+	cs-gpios = <&gpio 46 GPIO_ACTIVE_LOW>;
 
 	firmware-flash@0 {
-		compatible = "st,m25p80", "jedec,spi-nor";
+		compatible = "winbond,w25q32", "jedec,spi-nor";
 		reg = <0>;
-		spi-max-frequency = <40000000>;
+		spi-max-frequency = <104000000>;
 		m25p,fast-read;
 	};
 };
 
-&ssp4 {
-	cs-gpios = <&gpio 56 GPIO_ACTIVE_HIGH>;
+&ssp2 {
+	cs-gpios = <&gpio 56 GPIO_ACTIVE_LOW>;
 	status = "okay";
 };
-- 
2.26.0

