Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A22F17C455
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 18:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgCFR2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 12:28:34 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.167]:26418 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgCFR2e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 12:28:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1583515712;
        s=strato-dkim-0002; d=goldelico.com;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=tVQAslT/TFNnxCSyYl7NIy3Si2ivti62femj/MqcD0s=;
        b=N+kkYKvxfdiH6Q6+drkdap0WPnB5Oqvcjq4gvIF5vW7T5vX0Y9H6ON+eIqm19cPOOA
        n1cXWTycFUF7x6jPbOaHZNhoevAAs4KMDsqWh05em99MZITunt2IqQBtRz0NGiBCXosi
        x8EaqFAuDo2h+t8XvN/Hx6+UTc0bHDnD44L6U3L2P2j/mFG1bQC/1OFSH1z1rlTStIiD
        gOHIuonenn/kvV2/hp3/dkGc1oQnwVoWtXRvYt/+4Ci+srXKvPqXMiSt/drVA8f0TcjJ
        o4VUBIFa17xZ/5mwUQZE8P9RI8PBpdl64HAsYOQmLkpo518Nxt4s2ykZH7dz9rLxdW9X
        hVQg==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH6GQjzrz4="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.2.0 DYNA|AUTH)
        with ESMTPSA id y0a02cw26HSVZtT
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 6 Mar 2020 18:28:31 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     Paul Cercueil <paul@crapouillou.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        "H. Nikolaus Schaller" <hns@goldelico.com>, stable@vger.kernel.org
Subject: [PATCH v6] MIPS: DTS: CI20: fix interrupt for pcf8563 RTC
Date:   Fri,  6 Mar 2020 18:28:30 +0100
Message-Id: <7fbde64be07dc3c78343890e6597c1b2636d4815.1583515710.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Interrupts should not be specified by interrupt line but by
gpio parent and reference.

Fixes: 73f2b940474d ("MIPS: CI20: DTS: Add I2C nodes")
Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
---
 arch/mips/boot/dts/ingenic/ci20.dts | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/mips/boot/dts/ingenic/ci20.dts b/arch/mips/boot/dts/ingenic/ci20.dts
index 8b5fb635c66f..c340f947baa0 100644
--- a/arch/mips/boot/dts/ingenic/ci20.dts
+++ b/arch/mips/boot/dts/ingenic/ci20.dts
@@ -4,6 +4,7 @@
 #include "jz4780.dtsi"
 #include <dt-bindings/clock/ingenic,tcu.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/regulator/active-semi,8865-regulator.h>
 
 / {
@@ -270,7 +271,9 @@
 		rtc@51 {
 			compatible = "nxp,pcf8563";
 			reg = <0x51>;
-			interrupts = <110>;
+
+			interrupt-parent = <&gpf>;
+			interrupts = <30 IRQ_TYPE_LEVEL_LOW>;
 		};
 };
 
-- 
2.23.0

