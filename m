Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD564F2D46
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245120AbiDEJL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244682AbiDEIwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1DF60FC;
        Tue,  5 Apr 2022 01:42:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D14760FFC;
        Tue,  5 Apr 2022 08:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174DDC385A5;
        Tue,  5 Apr 2022 08:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148119;
        bh=I2JAoJ6L2MyLQSfbG24VYRUmwL7cj5CvhiW63FNGGLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rwiQugN+zV3sMNgI/zdFNjuowJs4CYLDlNa8xFwen1UtCOsYTDHqYT2bole5ofpVL
         +PDJ0U8i4yvMuQU+jGV+UDip7dPn2VEtHc1m8rT++CjjHrsIqzF1OQsLUvMFi64eJ6
         ++ninSzhxAGQzON1aricEcglkYpVAP3Vw36RrAws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Drew Fustini <dfustini@baylibre.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0241/1017] clocksource/drivers/timer-ti-dm: Fix regression from errata i940 fix
Date:   Tue,  5 Apr 2022 09:19:14 +0200
Message-Id: <20220405070401.411177862@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Drew Fustini <dfustini@baylibre.com>

[ Upstream commit bceaae3bac0ce27c549bb050336d8d08abc2ee54 ]

The existing fix for errata i940 causes a conflict for IPU2 which is
using timer 3 and 4. From arch/arm/boot/dts/dra7-ipu-dsp-common.dtsi:

  &ipu2 {
          mboxes = <&mailbox6 &mbox_ipu2_ipc3x>;
          ti,timers = <&timer3>;
          ti,watchdog-timers = <&timer4>, <&timer9>;
  };

The conflict was noticed when booting mainline on the BeagleBoard X15
which has a TI AM5728 SoC:

  remoteproc remoteproc1: 55020000.ipu is available
  remoteproc remoteproc1: powering up 55020000.ipu
  remoteproc remoteproc1: Booting fw image dra7-ipu2-fw.xem4
  omap-rproc 55020000.ipu: could not get timer platform device
  omap-rproc 55020000.ipu: omap_rproc_enable_timers failed: -19
  remoteproc remoteproc1: can't start rproc 55020000.ipu: -19

This change modifies the errata fix to instead use timer 15 and 16 which
resolves the timer conflict.

It does not appear to introduce any latency regression. Results from
cyclictest with original errata fix using dmtimer 3 and 4:

  # cyclictest --mlockall --smp --priority=80 --interval=200 --distance=0
  policy: fifo: loadavg: 0.02 0.03 0.05

  T: 0 ( 1449) P:80 I:200 C: 800368 Min:   0 Act:   32 Avg:   22 Max:  128
  T: 1 ( 1450) P:80 I:200 C: 800301 Min:   0 Act:   12 Avg:   23 Max:   70

The results after the change to dmtimer 15 and 16:

  # cyclictest --mlockall --smp --priority=80 --interval=200 --distance=0
  policy: fifo: loadavg: 0.36 0.19 0.07

  T: 0 ( 1711) P:80 I:200 C: 759599 Min:   0 Act:    6 Avg:   22 Max:  108
  T: 1 ( 1712) P:80 I:200 C: 759539 Min:   0 Act:   19 Avg:   23 Max:   79

Fixes: 25de4ce5ed02 ("clocksource/drivers/timer-ti-dm: Handle dra7 timer wrap errata i940")
Link: https://lore.kernel.org/linux-omap/YfWsG0p6to3IJuvE@x1/
Suggested-by: Suman Anna <s-anna@ti.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Drew Fustini <dfustini@baylibre.com>
Link: https://lore.kernel.org/r/20220204053503.1409162-1-dfustini@baylibre.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dra7-l4.dtsi             | 5 ++---
 arch/arm/boot/dts/dra7.dtsi                | 8 ++++----
 drivers/clocksource/timer-ti-dm-systimer.c | 4 ++--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/dra7-l4.dtsi b/arch/arm/boot/dts/dra7-l4.dtsi
index 956a26d52a4c..0a11bacffc1f 100644
--- a/arch/arm/boot/dts/dra7-l4.dtsi
+++ b/arch/arm/boot/dts/dra7-l4.dtsi
@@ -3482,8 +3482,7 @@
 				ti,timer-pwm;
 			};
 		};
-
-		target-module@2c000 {			/* 0x4882c000, ap 17 02.0 */
+		timer15_target: target-module@2c000 {	/* 0x4882c000, ap 17 02.0 */
 			compatible = "ti,sysc-omap4-timer", "ti,sysc";
 			reg = <0x2c000 0x4>,
 			      <0x2c010 0x4>;
@@ -3511,7 +3510,7 @@
 			};
 		};
 
-		target-module@2e000 {			/* 0x4882e000, ap 19 14.0 */
+		timer16_target: target-module@2e000 {	/* 0x4882e000, ap 19 14.0 */
 			compatible = "ti,sysc-omap4-timer", "ti,sysc";
 			reg = <0x2e000 0x4>,
 			      <0x2e010 0x4>;
diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 6b485cbed8d5..8f7ffe2f66e9 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -1339,20 +1339,20 @@
 };
 
 /* Local timers, see ARM architected timer wrap erratum i940 */
-&timer3_target {
+&timer15_target {
 	ti,no-reset-on-init;
 	ti,no-idle;
 	timer@0 {
-		assigned-clocks = <&l4per_clkctrl DRA7_L4PER_TIMER3_CLKCTRL 24>;
+		assigned-clocks = <&l4per3_clkctrl DRA7_L4PER3_TIMER15_CLKCTRL 24>;
 		assigned-clock-parents = <&timer_sys_clk_div>;
 	};
 };
 
-&timer4_target {
+&timer16_target {
 	ti,no-reset-on-init;
 	ti,no-idle;
 	timer@0 {
-		assigned-clocks = <&l4per_clkctrl DRA7_L4PER_TIMER4_CLKCTRL 24>;
+		assigned-clocks = <&l4per3_clkctrl DRA7_L4PER3_TIMER16_CLKCTRL 24>;
 		assigned-clock-parents = <&timer_sys_clk_div>;
 	};
 };
diff --git a/drivers/clocksource/timer-ti-dm-systimer.c b/drivers/clocksource/timer-ti-dm-systimer.c
index 1fccb457fcc5..2737407ff069 100644
--- a/drivers/clocksource/timer-ti-dm-systimer.c
+++ b/drivers/clocksource/timer-ti-dm-systimer.c
@@ -694,9 +694,9 @@ static int __init dmtimer_percpu_quirk_init(struct device_node *np, u32 pa)
 		return 0;
 	}
 
-	if (pa == 0x48034000)		/* dra7 dmtimer3 */
+	if (pa == 0x4882c000)           /* dra7 dmtimer15 */
 		return dmtimer_percpu_timer_init(np, 0);
-	else if (pa == 0x48036000)	/* dra7 dmtimer4 */
+	else if (pa == 0x4882e000)      /* dra7 dmtimer16 */
 		return dmtimer_percpu_timer_init(np, 1);
 
 	return 0;
-- 
2.34.1



