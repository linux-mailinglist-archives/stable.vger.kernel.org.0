Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA774CF88B
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238580AbiCGJ4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238752AbiCGJzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:55:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19D479394;
        Mon,  7 Mar 2022 01:45:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACE9861374;
        Mon,  7 Mar 2022 09:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB05FC36AF9;
        Mon,  7 Mar 2022 09:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646336;
        bh=vlwTNAYAgE8F9s04cHSroX9szAOlz5Ksx8YUDyM/b/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYrrIcXwid/no8KQUyKfBbrYIdaykNagHV9mIIQSVwLmuNmXQ3vhsDu95XWpViYz/
         RXVVvGkSzErNgroWuNd2z/X6MlXf8spCKFFfDbn/qgoQ9OcWUQl6WBv92Ofu9k3u4a
         /kQ3FDuCBo02nQMnTS/CEpHJYCeJTO3sA/8HlrBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anthoine Bourgeois <anthoine.bourgeois@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 209/262] ARM: dts: Use 32KiHz oscillator on devkit8000
Date:   Mon,  7 Mar 2022 10:19:13 +0100
Message-Id: <20220307091708.739826971@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthoine Bourgeois <anthoine.bourgeois@gmail.com>

[ Upstream commit 8840f5460a23759403f1f2860429dcbcc2f04a65 ]

Devkit8000 board seems to always used 32k_counter as clocksource.
Restore this behavior.

If clocksource is back to 32k_counter, timer12 is now the clockevent
source (as before) and timer2 is not longer needed here.

This commit fixes the same issue observed with commit 23885389dbbb
("ARM: dts: Fix timer regression for beagleboard revision c") when sleep
is blocked until hitting keys over serial console.

Fixes: aba1ad05da08 ("clocksource/drivers/timer-ti-dm: Add clockevent and clocksource support")
Fixes: e428e250fde6 ("ARM: dts: Configure system timers for omap3")
Signed-off-by: Anthoine Bourgeois <anthoine.bourgeois@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap3-devkit8000-common.dtsi | 17 +----------------
 drivers/clocksource/timer-ti-dm-systimer.c     |  3 +--
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-devkit8000-common.dtsi b/arch/arm/boot/dts/omap3-devkit8000-common.dtsi
index 0df2b1dd07f6..6883ccb45600 100644
--- a/arch/arm/boot/dts/omap3-devkit8000-common.dtsi
+++ b/arch/arm/boot/dts/omap3-devkit8000-common.dtsi
@@ -158,11 +158,6 @@
 	status = "disabled";
 };
 
-/* Unusable as clocksource because of unreliable oscillator */
-&counter32k {
-	status = "disabled";
-};
-
 /* Unusable as clockevent because if unreliable oscillator, allow to idle */
 &timer1_target {
 	/delete-property/ti,no-reset-on-init;
@@ -172,7 +167,7 @@
 	};
 };
 
-/* Preferred always-on timer for clocksource */
+/* Preferred timer for clockevent */
 &timer12_target {
 	ti,no-reset-on-init;
 	ti,no-idle;
@@ -181,16 +176,6 @@
 	};
 };
 
-/* Preferred timer for clockevent */
-&timer2_target {
-	ti,no-reset-on-init;
-	ti,no-idle;
-	timer@0 {
-		assigned-clocks = <&gpt2_fck>;
-		assigned-clock-parents = <&sys_ck>;
-	};
-};
-
 &twl_gpio {
 	ti,use-leds;
 	/*
diff --git a/drivers/clocksource/timer-ti-dm-systimer.c b/drivers/clocksource/timer-ti-dm-systimer.c
index 5c40ca1d4740..1fccb457fcc5 100644
--- a/drivers/clocksource/timer-ti-dm-systimer.c
+++ b/drivers/clocksource/timer-ti-dm-systimer.c
@@ -241,8 +241,7 @@ static void __init dmtimer_systimer_assign_alwon(void)
 	bool quirk_unreliable_oscillator = false;
 
 	/* Quirk unreliable 32 KiHz oscillator with incomplete dts */
-	if (of_machine_is_compatible("ti,omap3-beagle-ab4") ||
-	    of_machine_is_compatible("timll,omap3-devkit8000")) {
+	if (of_machine_is_compatible("ti,omap3-beagle-ab4")) {
 		quirk_unreliable_oscillator = true;
 		counter_32k = -ENODEV;
 	}
-- 
2.34.1



