Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE4F2CD268
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 10:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgLCJVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 04:21:11 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:5975 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgLCJVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 04:21:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606987270; x=1638523270;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cEtZG8CzappP1JMZACxHlWy5D0g972poZlbDDstlN+M=;
  b=gT7e28F7xsDrl5ZZZDsN81eJOdMflGPHb2ZHhJFQPieQFi5A/jhsdpsV
   nsqqMJXVRhDrz9ZrUNiIpVMr5WPpG8iV0Bz3w7w8Agnf30PpN+6r4SHmz
   rAEHAdbClzk+73Pwxbjq8qLfISaKKQrlubTOZZeJmdfrqtnjjUm0jJewg
   Bvio6Ap/Tg99HFrUbSF8UbYRkiPZpmZzb4xDdpUd/vONeE7UZ9fJnFSZi
   PVAeI9KV4ggesv04RUjaBHBkAdJu954URl0x+vJIWu0Q1AYW7ddq4Ye9O
   TYyKWhuV/MM3UdmCz53ItDFXuzQeUGgPgs6Z1ueLAHNgL8WXX/AuqFYtX
   A==;
IronPort-SDR: GRX9KEdt50jeDyuZjGYMEpOWe7Nr8rTP3+o059LFntscDJOUGIqWA/SulD4EME081M4J2ZSYA7
 gXV5vOSjqA7ejzl2Jux+w1gxjbXjOmPj5T+x60/JJ0rLI7+/8A9VsV1MlYsGe3MEGDJHn/XXAj
 uLBU7T3xe4K2IW3LinMpwZ38GVE4+tZfwE205Npg7CjYHrGjeZaom9Av+gzInE4JN+o14Ow0Zo
 etxxPwP+si5k53hGw6nkxLi/soYTgIG1jJ0s4hlDCqjsoAzrbTjdDwKzeLWEzLSRKizB+7GGA3
 KBc=
X-IronPort-AV: E=Sophos;i="5.78,389,1599548400"; 
   d="scan'208";a="101252675"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Dec 2020 02:20:04 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 02:20:04 -0700
Received: from ness.microchip.com (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 3 Dec 2020 02:20:01 -0700
From:   <nicolas.ferre@microchip.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Dan Sneddon <dan.sneddon@microchip.com>,
        Cristian Birsan <cristian.birsan@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] ARM: dts: at91: sama5d2: fix CAN message ram offset and size
Date:   Thu, 3 Dec 2020 10:19:49 +0100
Message-ID: <20201203091949.9015-1-nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

CAN0 and CAN1 instances share the same message ram configured
at 0x210000 on sama5d2 Linux systems.
According to current configuration of CAN0, we need 0x1c00 bytes
so that the CAN1 don't overlap its message ram:
64 x RX FIFO0 elements => 64 x 72 bytes
32 x TXE (TX Event FIFO) elements => 32 x 8 bytes
32 x TXB (TX Buffer) elements => 32 x 72 bytes
So a total of 7168 bytes (0x1C00).

Fix offset to match this needed size.
Make the CAN0 message ram ioremap match exactly this size so that is
easily understandable.  Adapt CAN1 size accordingly.

Reported-by: Dan Sneddon <dan.sneddon@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Tested-by: Cristian Birsan <cristian.birsan@microchip.com>
Fixes: bc6d5d7666b7 ("ARM: dts: at91: sama5d2: add m_can nodes")
Cc: stable@vger.kernel.org # v4.13+
---
 arch/arm/boot/dts/sama5d2.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d2.dtsi b/arch/arm/boot/dts/sama5d2.dtsi
index 2ddc85dff8ce..8f3c40e5b7ca 100644
--- a/arch/arm/boot/dts/sama5d2.dtsi
+++ b/arch/arm/boot/dts/sama5d2.dtsi
@@ -724,7 +724,7 @@ AT91_XDMAC_DT_PERID(31))>,
 
 			can0: can@f8054000 {
 				compatible = "bosch,m_can";
-				reg = <0xf8054000 0x4000>, <0x210000 0x4000>;
+				reg = <0xf8054000 0x4000>, <0x210000 0x1c00>;
 				reg-names = "m_can", "message_ram";
 				interrupts = <56 IRQ_TYPE_LEVEL_HIGH 7>,
 					     <64 IRQ_TYPE_LEVEL_HIGH 7>;
@@ -1130,7 +1130,7 @@ AT91_XDMAC_DT_PERID(33))>,
 
 			can1: can@fc050000 {
 				compatible = "bosch,m_can";
-				reg = <0xfc050000 0x4000>, <0x210000 0x4000>;
+				reg = <0xfc050000 0x4000>, <0x210000 0x3800>;
 				reg-names = "m_can", "message_ram";
 				interrupts = <57 IRQ_TYPE_LEVEL_HIGH 7>,
 					     <65 IRQ_TYPE_LEVEL_HIGH 7>;
@@ -1140,7 +1140,7 @@ can1: can@fc050000 {
 				assigned-clocks = <&pmc PMC_TYPE_GCK 57>;
 				assigned-clock-parents = <&pmc PMC_TYPE_CORE PMC_UTMI>;
 				assigned-clock-rates = <40000000>;
-				bosch,mram-cfg = <0x1100 0 0 64 0 0 32 32>;
+				bosch,mram-cfg = <0x1c00 0 0 64 0 0 32 32>;
 				status = "disabled";
 			};
 
-- 
2.29.2

