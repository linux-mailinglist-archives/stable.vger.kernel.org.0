Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD8DEA0BE
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbfJ3PwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:52:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727900AbfJ3Pv6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:51:58 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC22F21734;
        Wed, 30 Oct 2019 15:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450717;
        bh=Y61ZJb/1fN2SECbdyVM3niqERKXBoze0HLnOYjt7n5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsi7pjTLOUKDpYM0J2zcJ9v+/UNLatmSsjlN0FYbfgXtYAB4Oiojyk7utcyN11kxX
         1dmiRMEWuVFUeVOelEq/QM/IkmHTq8cDpZsU/yH+YoG5yETW75kfdz24hRd9RKPkRn
         fkVmyatWADrQgeCe3EHBujqrDnd779zi1wbmCiTU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Eyal Reizer <eyalr@ti.com>, Guy Mishol <guym@ti.com>,
        John Stultz <john.stultz@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 33/81] ARM: dts: Use level interrupt for omap4 & 5 wlcore
Date:   Wed, 30 Oct 2019 11:48:39 -0400
Message-Id: <20191030154928.9432-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 087a2b7ec973f6f30f6e7b72cb50b6f7734ffdd2 ]

Commit 572cf7d7b07d ("ARM: dts: Improve omap l4per idling with wlcore edge
sensitive interrupt") changed wlcore interrupts to use edge interrupt based
on what's specified in the wl1835mod.pdf data sheet.

However, there are still cases where we can have lost interrupts as
described in omap_gpio_unidle(). And using a level interrupt instead of edge
interrupt helps as we avoid the check for untriggered GPIO interrupts in
omap_gpio_unidle().

And with commit e6818d29ea15 ("gpio: gpio-omap: configure edge detection
for level IRQs for idle wakeup") GPIOs idle just fine with level interrupts.

Let's change omap4 and 5 wlcore users back to using level interrupt
instead of edge interrupt. Let's not change the others as I've only seen
this on omap4 and 5, probably because the other SoCs don't have l4per idle
independent of the CPUs.

Fixes: 572cf7d7b07d ("ARM: dts: Improve omap l4per idling with wlcore edge sensitive interrupt")
Depends-on: e6818d29ea15 ("gpio: gpio-omap: configure edge detection for level IRQs for idle wakeup")
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: Eyal Reizer <eyalr@ti.com>
Cc: Guy Mishol <guym@ti.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap4-droid4-xt894.dts       | 2 +-
 arch/arm/boot/dts/omap4-panda-common.dtsi      | 2 +-
 arch/arm/boot/dts/omap4-sdp.dts                | 2 +-
 arch/arm/boot/dts/omap4-var-som-om44-wlan.dtsi | 2 +-
 arch/arm/boot/dts/omap5-board-common.dtsi      | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-droid4-xt894.dts b/arch/arm/boot/dts/omap4-droid4-xt894.dts
index 4454449de00c0..a40fe8d49da64 100644
--- a/arch/arm/boot/dts/omap4-droid4-xt894.dts
+++ b/arch/arm/boot/dts/omap4-droid4-xt894.dts
@@ -369,7 +369,7 @@
 		compatible = "ti,wl1285", "ti,wl1283";
 		reg = <2>;
 		/* gpio_100 with gpmc_wait2 pad as wakeirq */
-		interrupts-extended = <&gpio4 4 IRQ_TYPE_EDGE_RISING>,
+		interrupts-extended = <&gpio4 4 IRQ_TYPE_LEVEL_HIGH>,
 				      <&omap4_pmx_core 0x4e>;
 		interrupt-names = "irq", "wakeup";
 		ref-clock-frequency = <26000000>;
diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index 14be2ecb62b1f..55ea8b6189af5 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -474,7 +474,7 @@
 		compatible = "ti,wl1271";
 		reg = <2>;
 		/* gpio_53 with gpmc_ncs3 pad as wakeup */
-		interrupts-extended = <&gpio2 21 IRQ_TYPE_EDGE_RISING>,
+		interrupts-extended = <&gpio2 21 IRQ_TYPE_LEVEL_HIGH>,
 				      <&omap4_pmx_core 0x3a>;
 		interrupt-names = "irq", "wakeup";
 		ref-clock-frequency = <38400000>;
diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
index 3c274965ff40a..91480ac1f3286 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -512,7 +512,7 @@
 		compatible = "ti,wl1281";
 		reg = <2>;
 		interrupt-parent = <&gpio1>;
-		interrupts = <21 IRQ_TYPE_EDGE_RISING>; /* gpio 53 */
+		interrupts = <21 IRQ_TYPE_LEVEL_HIGH>; /* gpio 53 */
 		ref-clock-frequency = <26000000>;
 		tcxo-clock-frequency = <26000000>;
 	};
diff --git a/arch/arm/boot/dts/omap4-var-som-om44-wlan.dtsi b/arch/arm/boot/dts/omap4-var-som-om44-wlan.dtsi
index 6dbbc9b3229cc..d0032213101e6 100644
--- a/arch/arm/boot/dts/omap4-var-som-om44-wlan.dtsi
+++ b/arch/arm/boot/dts/omap4-var-som-om44-wlan.dtsi
@@ -69,7 +69,7 @@
 		compatible = "ti,wl1271";
 		reg = <2>;
 		interrupt-parent = <&gpio2>;
-		interrupts = <9 IRQ_TYPE_EDGE_RISING>; /* gpio 41 */
+		interrupts = <9 IRQ_TYPE_LEVEL_HIGH>; /* gpio 41 */
 		ref-clock-frequency = <38400000>;
 	};
 };
diff --git a/arch/arm/boot/dts/omap5-board-common.dtsi b/arch/arm/boot/dts/omap5-board-common.dtsi
index 7fff555ee3943..68ac04641bdb1 100644
--- a/arch/arm/boot/dts/omap5-board-common.dtsi
+++ b/arch/arm/boot/dts/omap5-board-common.dtsi
@@ -362,7 +362,7 @@
 		pinctrl-names = "default";
 		pinctrl-0 = <&wlcore_irq_pin>;
 		interrupt-parent = <&gpio1>;
-		interrupts = <14 IRQ_TYPE_EDGE_RISING>;	/* gpio 14 */
+		interrupts = <14 IRQ_TYPE_LEVEL_HIGH>;	/* gpio 14 */
 		ref-clock-frequency = <26000000>;
 	};
 };
-- 
2.20.1

