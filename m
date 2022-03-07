Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3534CF6AC
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237977AbiCGJmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238722AbiCGJin (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:38:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2C84E3AE;
        Mon,  7 Mar 2022 01:33:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62387B810BF;
        Mon,  7 Mar 2022 09:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1B6C340F3;
        Mon,  7 Mar 2022 09:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645594;
        bh=B67qt1s9/yhVlYKNjUE5sEKW8kaB1jXEWKvNU9m/iuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=im6knJVWgwqkBPAFw22OBYwd8HhEhxZL9671xDId4bGHMX0QWdH8x4pIV7iNkwWsz
         lrI7vmeG9TfUxMQVbSvHePcizVEl+I5+3gm1uA9HLcW1k8TyJGdNAbMMaD1AEq/j8P
         GfrDNKjLkMCPhtBeTRPGx+JS6UlbZGPUU2QUPrJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anthoine Bourgeois <anthoine.bourgeois@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/105] ARM: dts: switch timer config to common devkit8000 devicetree
Date:   Mon,  7 Mar 2022 10:19:25 +0100
Message-Id: <20220307091646.485585151@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
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

[ Upstream commit 64324ef337d0caa5798fa8fa3f6bbfbd3245868a ]

This patch allow lcd43 and lcd70 flavors to benefit from timer
evolution.

Fixes: e428e250fde6 ("ARM: dts: Configure system timers for omap3")
Signed-off-by: Anthoine Bourgeois <anthoine.bourgeois@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm/boot/dts/omap3-devkit8000-common.dtsi | 33 +++++++++++++++++++
 arch/arm/boot/dts/omap3-devkit8000.dts        | 33 -------------------
 2 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-devkit8000-common.dtsi b/arch/arm/boot/dts/omap3-devkit8000-common.dtsi
index 2c19d6e255bd..0df2b1dd07f6 100644
--- a/arch/arm/boot/dts/omap3-devkit8000-common.dtsi
+++ b/arch/arm/boot/dts/omap3-devkit8000-common.dtsi
@@ -158,6 +158,39 @@
 	status = "disabled";
 };
 
+/* Unusable as clocksource because of unreliable oscillator */
+&counter32k {
+	status = "disabled";
+};
+
+/* Unusable as clockevent because if unreliable oscillator, allow to idle */
+&timer1_target {
+	/delete-property/ti,no-reset-on-init;
+	/delete-property/ti,no-idle;
+	timer@0 {
+		/delete-property/ti,timer-alwon;
+	};
+};
+
+/* Preferred always-on timer for clocksource */
+&timer12_target {
+	ti,no-reset-on-init;
+	ti,no-idle;
+	timer@0 {
+		/* Always clocked by secure_32k_fck */
+	};
+};
+
+/* Preferred timer for clockevent */
+&timer2_target {
+	ti,no-reset-on-init;
+	ti,no-idle;
+	timer@0 {
+		assigned-clocks = <&gpt2_fck>;
+		assigned-clock-parents = <&sys_ck>;
+	};
+};
+
 &twl_gpio {
 	ti,use-leds;
 	/*
diff --git a/arch/arm/boot/dts/omap3-devkit8000.dts b/arch/arm/boot/dts/omap3-devkit8000.dts
index c2995a280729..162d0726b008 100644
--- a/arch/arm/boot/dts/omap3-devkit8000.dts
+++ b/arch/arm/boot/dts/omap3-devkit8000.dts
@@ -14,36 +14,3 @@
 		display2 = &tv0;
 	};
 };
-
-/* Unusable as clocksource because of unreliable oscillator */
-&counter32k {
-	status = "disabled";
-};
-
-/* Unusable as clockevent because if unreliable oscillator, allow to idle */
-&timer1_target {
-	/delete-property/ti,no-reset-on-init;
-	/delete-property/ti,no-idle;
-	timer@0 {
-		/delete-property/ti,timer-alwon;
-	};
-};
-
-/* Preferred always-on timer for clocksource */
-&timer12_target {
-	ti,no-reset-on-init;
-	ti,no-idle;
-	timer@0 {
-		/* Always clocked by secure_32k_fck */
-	};
-};
-
-/* Preferred timer for clockevent */
-&timer2_target {
-	ti,no-reset-on-init;
-	ti,no-idle;
-	timer@0 {
-		assigned-clocks = <&gpt2_fck>;
-		assigned-clock-parents = <&sys_ck>;
-	};
-};
-- 
2.34.1



