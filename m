Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C092160657
	for <lists+stable@lfdr.de>; Sun, 16 Feb 2020 21:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgBPU1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Feb 2020 15:27:05 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.80]:16399 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgBPU1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Feb 2020 15:27:05 -0500
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Feb 2020 15:27:04 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1581884823;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=wI8pUHIdAJxIBDjRh4I5Jzx0DshutQiLtIOlLY20Yj0=;
        b=kv5UPHkWrQwHho44g+UBi/dDzJ5wdi84tGSIZ7pBjIkH6KGn1cZYfVvPw93wrvWQUF
        LFw5fqedRRyPJJR32YsL8d1VzL9Y9n5MRV9wd//Xoy4SnmkGz1XELm85PKM97CY47DGo
        SWqpB+BAqNFeqHMFYGnc7/6F9+NTdwOWwwqwe/c8FqpxOPFai+ll5DFWGXh2IAx4LlDC
        8b1gOVcfzZuY4bf+vnsI2L59JLQFoSeC8gJMQpsRrbJOxgqFgRwVk/UFm6m4iJhNkSDg
        WEOCj3mKarUNsdLqPBv6uQQblwFkOuS2DYbEK5yGPukODuQpPPdnWiwp5chXx/CFhzZO
        JlhA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1OAA2UNf2M0OoPPevMB"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id U06217w1GKL4Jr4
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 16 Feb 2020 21:21:04 +0100 (CET)
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
        Krzysztof Kozlowski <krzk@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com, stable@vger.kernel.org
Subject: [PATCH v3 4/6] MIPS: DTS: CI20: fix interrupt for pcf8563 RTC
Date:   Sun, 16 Feb 2020 21:20:58 +0100
Message-Id: <787070d6036123c05e6b25b37744fdf2a3191d77.1581884459.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1581884459.git.hns@goldelico.com>
References: <cover.1581884459.git.hns@goldelico.com>
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
index 4f48bc16fb52..1ab55be707af 100644
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

