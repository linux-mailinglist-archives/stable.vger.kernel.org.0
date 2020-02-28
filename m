Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0A9173F17
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 19:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgB1SDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 13:03:12 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.84]:23906 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbgB1SDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 13:03:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1582912984;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=ItYS6TsJvFioMBqs67FFOOhOrYJwPj1dlbMUcSJyNfQ=;
        b=fqW+GlnsiF1UmXjichB+5m3uZ3UfO8xHsXNe2JF6lXulx9qDAPikPY1hEKMnlj7Hfm
        r2A13CAeJ7VgSl1pV90t7lpkY4ZFfxHGEfZBuvHlBbIRNnWzaRDwDwyTcFGqAA9GQdx/
        GTHTP1hUvxrDOY8Li21v7eF5STTCIL9NiXI9cNeeX6m+RFTQLsZi/HMRW5gZtbYGJccP
        P+rFpnGd2YeGpal4LpMPpQvq+49TssahkPbcbz2ei6QlvkBW6qbgT2d3t6+sDliuNsAj
        ypWWP1eWlE0an68ACo/874LqNm42dWjHugGhhac/zaMhLxBVQpRIcSPyXHpOR1WOGIlX
        R/sw==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH6G1+ULkA="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.2.0 DYNA|AUTH)
        with ESMTPSA id y0a02cw1SI2t2JM
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 28 Feb 2020 19:02:55 +0100 (CET)
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
Subject: [PATCH v4 3/5] MIPS: DTS: CI20: fix interrupt for pcf8563 RTC
Date:   Fri, 28 Feb 2020 19:02:51 +0100
Message-Id: <0d78eedcbe1ebfdb2a427c04beca2c3c5ba1bfc5.1582912972.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1582912972.git.hns@goldelico.com>
References: <cover.1582912972.git.hns@goldelico.com>
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
---
 arch/mips/boot/dts/ingenic/ci20.dts | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/mips/boot/dts/ingenic/ci20.dts b/arch/mips/boot/dts/ingenic/ci20.dts
index 44741e927d2b..0251ca154ccb 100644
--- a/arch/mips/boot/dts/ingenic/ci20.dts
+++ b/arch/mips/boot/dts/ingenic/ci20.dts
@@ -284,7 +284,9 @@ Optional input supply properties:
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

