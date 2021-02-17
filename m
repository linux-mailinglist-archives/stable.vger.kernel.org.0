Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D1D31D8B2
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 12:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhBQLoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 06:44:07 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:43096 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbhBQLoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 06:44:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613562239; x=1645098239;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Jl4y3ZlhMvzv9b8hTjQYiNoHCcntFG8rcdnKDae4ZZA=;
  b=ZLVG1tMGGqEmAnc2tFhUJ1ghENTeXgIuBsJTj/Oe7VRzAhJLwGgpXpuf
   84AQpvq1tuaMGjTvAI2FTJKReGkvPuXSpxTaK6NsTbGLuYHnNg/6ShHtJ
   ftMMPToVrDYxDiUbxfZdFv/F8Bt/E08E95/AjhUVq50mx1yoaIlFz7JLr
   hfdl9hkI/FngYm0UCuADZuhY5EDMIQy04oPaaZhF0wRttXubUVL2BMw/7
   pYgV6bFgriu6WsqSe13EjUGYcGv/gxIZmQQkLixJhf7oAVVoPh8SKolis
   9HA9L5oibDJSGuWkmDNPfTpFP1yuEEVh3tpmdBKA+SRAFBR50MPTbGzGT
   w==;
IronPort-SDR: pMa6jG/6ubIZ+l+HnJRHa4XfI1mfHsGwgQKSQYTCFSzocE7f/kgBJ55lOCiP9iBCw33eAEoagx
 rtJkl85HwTnulow9kmiQwdGPqJlvjoGb9xo51f6vh07vaQtGA3jz4p1IfW1oTaSY5VTsduZegk
 Td0mv9BTmYCjhRQvS5GNxdffnLK1isLq05a5Sd0xjMCIVsM6YoasMiwKoS5RceSFxvi3vuEjXQ
 TNq17n+bqPPrVGJoa0UX7znn1JpkJDQDb0qmEBDwuhXZ6e2+iTQO3CmJ3xtyfyJqyooUiqcbQ/
 xEo=
X-IronPort-AV: E=Sophos;i="5.81,184,1610434800"; 
   d="scan'208";a="44425857"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Feb 2021 04:42:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 17 Feb 2021 04:42:40 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 17 Feb 2021 04:42:37 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>
CC:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] ARM: dts: at91-sama5d27_som1: fix phy address to 7
Date:   Wed, 17 Feb 2021 12:38:08 +0100
Message-ID: <20210217113808.21804-1-nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

Fix the phy address to 7 for Ethernet PHY on SAMA5D27 SOM1. No
connection established if phy address 0 is used.

The board uses the 24 pins version of the KSZ8081RNA part, KSZ8081RNA
pin 16 REFCLK as PHYAD bit [2] has weak internal pull-down.  But at
reset, connected to PD09 of the MPU it's connected with an internal
pull-up forming PHYAD[2:0] = 7.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Fixes: 2f61929eb10a ("ARM: dts: at91: at91-sama5d27_som1: fix PHY ID")
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: <stable@vger.kernel.org> # 4.14+
---
 arch/arm/boot/dts/at91-sama5d27_som1.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d27_som1.dtsi b/arch/arm/boot/dts/at91-sama5d27_som1.dtsi
index 1b1163858b1d..e3251f3e3eaa 100644
--- a/arch/arm/boot/dts/at91-sama5d27_som1.dtsi
+++ b/arch/arm/boot/dts/at91-sama5d27_som1.dtsi
@@ -84,8 +84,8 @@ macb0: ethernet@f8008000 {
 				pinctrl-0 = <&pinctrl_macb0_default>;
 				phy-mode = "rmii";
 
-				ethernet-phy@0 {
-					reg = <0x0>;
+				ethernet-phy@7 {
+					reg = <0x7>;
 					interrupt-parent = <&pioA>;
 					interrupts = <PIN_PD31 IRQ_TYPE_LEVEL_LOW>;
 					pinctrl-names = "default";
-- 
2.30.0

