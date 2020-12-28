Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0FF2E3E73
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502298AbgL1O2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:28:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:35994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502267AbgL1O2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:28:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B69E20731;
        Mon, 28 Dec 2020 14:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165647;
        bh=tdGdLUZfsF7tFpOXL0/+HJPdzx8bUH55MqPcJijOdC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3Ij4Xz9M3EloWeIkbfn1N325A+4dNTL7Fnqw+2nZujW1s/74rlvduscV/eqxgDfQ
         iyrYrkR5mfQD4mbbuNfJ2mUeyEDLTCweiB5bg2/xhC0TPE1n1aBEr2o5PAEX5QVfOf
         wh348XKQoJb75Zi8bXRiTpn3zJjAjsp57Rq4owBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Sneddon <dan.sneddon@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Cristian Birsan <cristian.birsan@microchip.com>
Subject: [PATCH 5.10 604/717] ARM: dts: at91: sama5d2: fix CAN message ram offset and size
Date:   Mon, 28 Dec 2020 13:50:02 +0100
Message-Id: <20201228125049.845682248@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

commit 85b8350ae99d1300eb6dc072459246c2649a8e50 upstream.

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

Fixes: bc6d5d7666b7 ("ARM: dts: at91: sama5d2: add m_can nodes")
Reported-by: Dan Sneddon <dan.sneddon@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Tested-by: Cristian Birsan <cristian.birsan@microchip.com>
Cc: stable@vger.kernel.org # v4.13+
Link: https://lore.kernel.org/r/20201203091949.9015-1-nicolas.ferre@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/sama5d2.dtsi |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/boot/dts/sama5d2.dtsi
+++ b/arch/arm/boot/dts/sama5d2.dtsi
@@ -725,7 +725,7 @@
 
 			can0: can@f8054000 {
 				compatible = "bosch,m_can";
-				reg = <0xf8054000 0x4000>, <0x210000 0x4000>;
+				reg = <0xf8054000 0x4000>, <0x210000 0x1c00>;
 				reg-names = "m_can", "message_ram";
 				interrupts = <56 IRQ_TYPE_LEVEL_HIGH 7>,
 					     <64 IRQ_TYPE_LEVEL_HIGH 7>;
@@ -1131,7 +1131,7 @@
 
 			can1: can@fc050000 {
 				compatible = "bosch,m_can";
-				reg = <0xfc050000 0x4000>, <0x210000 0x4000>;
+				reg = <0xfc050000 0x4000>, <0x210000 0x3800>;
 				reg-names = "m_can", "message_ram";
 				interrupts = <57 IRQ_TYPE_LEVEL_HIGH 7>,
 					     <65 IRQ_TYPE_LEVEL_HIGH 7>;
@@ -1141,7 +1141,7 @@
 				assigned-clocks = <&pmc PMC_TYPE_GCK 57>;
 				assigned-clock-parents = <&pmc PMC_TYPE_CORE PMC_UTMI>;
 				assigned-clock-rates = <40000000>;
-				bosch,mram-cfg = <0x1100 0 0 64 0 0 32 32>;
+				bosch,mram-cfg = <0x1c00 0 0 64 0 0 32 32>;
 				status = "disabled";
 			};
 


