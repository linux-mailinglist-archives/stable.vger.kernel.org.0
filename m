Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11A631748FA
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 20:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbgB2TqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 14:46:04 -0500
Received: from mo4-p03-ob.smtp.rzone.de ([81.169.146.173]:12629 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbgB2TqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 14:46:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1583005560;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=cbu3cwPJXmVmA+rD98QPSqibW/Upw3v7qSOxPCEDup0=;
        b=Ky6COF5BDoGpObz+78DX7Lv+icpHwYIjAJxFxwZ4tROCh+VUKTqaVhLrdJndbtPf2F
        F2k9LTfCPlPr5oQELwFnJEbNhHIk7Cm33XW7z4PwxXAQM45i+eRq70esiOrflaplZFVt
        Ib3dVUU9rReZP8V4vOgI5bhlvlVXw4JjmSevlcwbInMUl3d4TpnTU5tr1/JM9bqpyo85
        DMTeT0LYyYTOVKrzX3Q86cKXAFbjq0LwG1YbmQG2LJ5ZssYXRj00wN92bduc06fgoK0v
        Hg1wnk03JLsX+MCY0u1Iyoc2mMkeCp3GE3CayfXg9H7pjMQ4nM60R4XbGQg4AHpGyFCI
        Y6RA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH6HGqvi2w="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.2.0 DYNA|AUTH)
        with ESMTPSA id y0a02cw1TJjp6m4
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 29 Feb 2020 20:45:51 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     Paul Boddie <paul@boddie.org.uk>,
        Paul Cercueil <paul@crapouillou.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com, stable@vger.kernel.org
Subject: [PATCH v5 3/5] MIPS: DTS: CI20: fix interrupt for pcf8563 RTC
Date:   Sat, 29 Feb 2020 20:45:46 +0100
Message-Id: <32910df46c8723097830e002a13580904ac74a65.1583005548.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1583005548.git.hns@goldelico.com>
References: <cover.1583005548.git.hns@goldelico.com>
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
index ae391e0cd38a..0251ca154ccb 100644
--- a/arch/mips/boot/dts/ingenic/ci20.dts
+++ b/arch/mips/boot/dts/ingenic/ci20.dts
@@ -4,6 +4,7 @@
 #include "jz4780.dtsi"
 #include <dt-bindings/clock/ingenic,tcu.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/regulator/active-semi,8865-regulator.h>
 
 / {
@@ -283,7 +284,9 @@ Optional input supply properties:
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

