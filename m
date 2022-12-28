Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92247658153
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbiL1Q1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbiL1Q0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:26:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C571CFC6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:23:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14AA5B8188A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A95BC433D2;
        Wed, 28 Dec 2022 16:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244587;
        bh=klFy7AXjHXGz564pvfCV6fTFf/FUGAlNJIEEtUEHjlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLKL3/2RBRSrSq2XnDYJ3Q5qVIm3HAYPCXcnYrK6qwgN5tneGtB16Uw05ZFSoub2w
         tbcfIYysgUwKTETTxwvat3TSXvFdD3caR5ebPAxp5ed1XctcsTid6kYrkDY0c2BWuH
         ky1NKdZNiTaq5IZjAD5m4Jcj579Pa39Ocw1YyLuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0737/1073] led: qcom-lpg: Fix sleeping in atomic
Date:   Wed, 28 Dec 2022 15:38:45 +0100
Message-Id: <20221228144348.043370408@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 3031993b3474794ecb71b6f969a3e60e4bda9d8a ]

lpg_brighness_set() function can sleep, while led's brightness_set()
callback must be non-blocking. Change LPG driver to use
brightness_set_blocking() instead.

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:580
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/0
preempt_count: 101, expected: 0
INFO: lockdep is turned off.
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W          6.1.0-rc1-00014-gbe99b089c6fc-dirty #85
Hardware name: Qualcomm Technologies, Inc. DB820c (DT)
Call trace:
 dump_backtrace.part.0+0xe4/0xf0
 show_stack+0x18/0x40
 dump_stack_lvl+0x88/0xb4
 dump_stack+0x18/0x34
 __might_resched+0x170/0x254
 __might_sleep+0x48/0x9c
 __mutex_lock+0x4c/0x400
 mutex_lock_nested+0x2c/0x40
 lpg_brightness_single_set+0x40/0x90
 led_set_brightness_nosleep+0x34/0x60
 led_heartbeat_function+0x80/0x170
 call_timer_fn+0xb8/0x340
 __run_timers.part.0+0x20c/0x254
 run_timer_softirq+0x3c/0x7c
 _stext+0x14c/0x578
 ____do_softirq+0x10/0x20
 call_on_irq_stack+0x2c/0x5c
 do_softirq_own_stack+0x1c/0x30
 __irq_exit_rcu+0x164/0x170
 irq_exit_rcu+0x10/0x40
 el1_interrupt+0x38/0x50
 el1h_64_irq_handler+0x18/0x2c
 el1h_64_irq+0x64/0x68
 cpuidle_enter_state+0xc8/0x380
 cpuidle_enter+0x38/0x50
 do_idle+0x244/0x2d0
 cpu_startup_entry+0x24/0x30
 rest_init+0x128/0x1a0
 arch_post_acpi_subsys_init+0x0/0x18
 start_kernel+0x6f4/0x734
 __primary_switched+0xbc/0xc4

Fixes: 24e2d05d1b68 ("leds: Add driver for Qualcomm LPG")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/rgb/leds-qcom-lpg.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/leds/rgb/leds-qcom-lpg.c b/drivers/leds/rgb/leds-qcom-lpg.c
index 02f51cc61837..c1a56259226f 100644
--- a/drivers/leds/rgb/leds-qcom-lpg.c
+++ b/drivers/leds/rgb/leds-qcom-lpg.c
@@ -602,8 +602,8 @@ static void lpg_brightness_set(struct lpg_led *led, struct led_classdev *cdev,
 		lpg_lut_sync(lpg, lut_mask);
 }
 
-static void lpg_brightness_single_set(struct led_classdev *cdev,
-				      enum led_brightness value)
+static int lpg_brightness_single_set(struct led_classdev *cdev,
+				     enum led_brightness value)
 {
 	struct lpg_led *led = container_of(cdev, struct lpg_led, cdev);
 	struct mc_subled info;
@@ -614,10 +614,12 @@ static void lpg_brightness_single_set(struct led_classdev *cdev,
 	lpg_brightness_set(led, cdev, &info);
 
 	mutex_unlock(&led->lpg->lock);
+
+	return 0;
 }
 
-static void lpg_brightness_mc_set(struct led_classdev *cdev,
-				  enum led_brightness value)
+static int lpg_brightness_mc_set(struct led_classdev *cdev,
+				 enum led_brightness value)
 {
 	struct led_classdev_mc *mc = lcdev_to_mccdev(cdev);
 	struct lpg_led *led = container_of(mc, struct lpg_led, mcdev);
@@ -628,6 +630,8 @@ static void lpg_brightness_mc_set(struct led_classdev *cdev,
 	lpg_brightness_set(led, cdev, mc->subled_info);
 
 	mutex_unlock(&led->lpg->lock);
+
+	return 0;
 }
 
 static int lpg_blink_set(struct lpg_led *led,
@@ -1118,7 +1122,7 @@ static int lpg_add_led(struct lpg *lpg, struct device_node *np)
 		led->mcdev.num_colors = num_channels;
 
 		cdev = &led->mcdev.led_cdev;
-		cdev->brightness_set = lpg_brightness_mc_set;
+		cdev->brightness_set_blocking = lpg_brightness_mc_set;
 		cdev->blink_set = lpg_blink_mc_set;
 
 		/* Register pattern accessors only if we have a LUT block */
@@ -1132,7 +1136,7 @@ static int lpg_add_led(struct lpg *lpg, struct device_node *np)
 			return ret;
 
 		cdev = &led->cdev;
-		cdev->brightness_set = lpg_brightness_single_set;
+		cdev->brightness_set_blocking = lpg_brightness_single_set;
 		cdev->blink_set = lpg_blink_single_set;
 
 		/* Register pattern accessors only if we have a LUT block */
@@ -1151,7 +1155,7 @@ static int lpg_add_led(struct lpg *lpg, struct device_node *np)
 	else
 		cdev->brightness = LED_OFF;
 
-	cdev->brightness_set(cdev, cdev->brightness);
+	cdev->brightness_set_blocking(cdev, cdev->brightness);
 
 	init_data.fwnode = of_fwnode_handle(np);
 
-- 
2.35.1



