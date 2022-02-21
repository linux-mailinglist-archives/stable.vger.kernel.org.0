Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24814BE802
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348607AbiBUJWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:22:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349881AbiBUJVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:21:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7F9FEF;
        Mon, 21 Feb 2022 01:09:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D89A160B2A;
        Mon, 21 Feb 2022 09:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2477C340E9;
        Mon, 21 Feb 2022 09:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434552;
        bh=vHXmZrYjVOaObrg4ML6zdoLWrXLbnePNNkLvDDJKdQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CIKB7ZeiRqYtq0TGuau6FFo983mFAwVlsh6TNkzDSreX0OYllmcIdzhNIZ9NQd9TQ
         nLObIWi2NeoC7oo12EDAQ7AXN4BrgIgOX9IBTpibKVaARhXk0hGQVVA6Vhplyz1zxx
         YzVkOiTDAHqZS1HYoVgZ9puWfwroP3VAU9svK97w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.15 015/196] HID: i2c-hid: goodix: Fix a lockdep splat
Date:   Mon, 21 Feb 2022 09:47:27 +0100
Message-Id: <20220221084931.406610632@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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

From: Daniel Thompson <daniel.thompson@linaro.org>

commit 2787710f73fcce4a9bdab540aaf1aef778a27462 upstream.

I'm was on the receiving end of a lockdep splat from this driver and after
scratching my head I couldn't be entirely sure it was a false positive
given we would also have to think about whether the regulator locking is
safe (since the notifier is called whilst holding regulator locks which
are also needed for regulator_is_enabled() ).

Regardless of whether it is a real bug or not, the mutex isn't needed.
We can use reference counting tricks instead to avoid races with the
notifier calls.

The observed splat follows:

------------------------------------------------------
kworker/u16:3/127 is trying to acquire lock:
ffff00008021fb20 (&ihid_goodix->regulator_mutex){+.+.}-{4:4}, at: ihid_goodix_vdd_notify+0x30/0x94

but task is already holding lock:
ffff0000835c60c0 (&(&rdev->notifier)->rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x30/0x70

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&(&rdev->notifier)->rwsem){++++}-{4:4}:
       down_write+0x68/0x8c
       blocking_notifier_chain_register+0x54/0x70
       regulator_register_notifier+0x1c/0x24
       devm_regulator_register_notifier+0x58/0x98
       i2c_hid_of_goodix_probe+0xdc/0x158
       i2c_device_probe+0x25d/0x270
       really_probe+0x174/0x2cc
       __driver_probe_device+0xc0/0xd8
       driver_probe_device+0x50/0xe4
       __device_attach_driver+0xa8/0xc0
       bus_for_each_drv+0x9c/0xc0
       __device_attach_async_helper+0x6c/0xbc
       async_run_entry_fn+0x38/0x100
       process_one_work+0x294/0x438
       worker_thread+0x180/0x258
       kthread+0x120/0x130
       ret_from_fork+0x10/0x20

-> #0 (&ihid_goodix->regulator_mutex){+.+.}-{4:4}:
       __lock_acquire+0xd24/0xfe8
       lock_acquire+0x288/0x2f4
       __mutex_lock+0xa0/0x338
       mutex_lock_nested+0x3c/0x5c
       ihid_goodix_vdd_notify+0x30/0x94
       notifier_call_chain+0x6c/0x8c
       blocking_notifier_call_chain+0x48/0x70
       _notifier_call_chain.isra.0+0x18/0x20
       _regulator_enable+0xc0/0x178
       regulator_enable+0x40/0x7c
       goodix_i2c_hid_power_up+0x18/0x20
       i2c_hid_core_power_up.isra.0+0x1c/0x2c
       i2c_hid_core_probe+0xd8/0x3d4
       i2c_hid_of_goodix_probe+0x14c/0x158
       i2c_device_probe+0x25c/0x270
       really_probe+0x174/0x2cc
       __driver_probe_device+0xc0/0xd8
       driver_probe_device+0x50/0xe4
       __device_attach_driver+0xa8/0xc0
       bus_for_each_drv+0x9c/0xc0
       __device_attach_async_helper+0x6c/0xbc
       async_run_entry_fn+0x38/0x100
       process_one_work+0x294/0x438
       worker_thread+0x180/0x258
       kthread+0x120/0x130
       ret_from_fork+0x10/0x20

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&(&rdev->notifier)->rwsem);
                               lock(&ihid_goodix->regulator_mutex);
                               lock(&(&rdev->notifier)->rwsem);
  lock(&ihid_goodix->regulator_mutex);

 *** DEADLOCK ***

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Fixes: 18eeef46d359 ("HID: i2c-hid: goodix: Tie the reset line to true state of the regulator")
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/i2c-hid/i2c-hid-of-goodix.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

--- a/drivers/hid/i2c-hid/i2c-hid-of-goodix.c
+++ b/drivers/hid/i2c-hid/i2c-hid-of-goodix.c
@@ -27,7 +27,6 @@ struct i2c_hid_of_goodix {
 
 	struct regulator *vdd;
 	struct notifier_block nb;
-	struct mutex regulator_mutex;
 	struct gpio_desc *reset_gpio;
 	const struct goodix_i2c_hid_timing_data *timings;
 };
@@ -67,8 +66,6 @@ static int ihid_goodix_vdd_notify(struct
 		container_of(nb, struct i2c_hid_of_goodix, nb);
 	int ret = NOTIFY_OK;
 
-	mutex_lock(&ihid_goodix->regulator_mutex);
-
 	switch (event) {
 	case REGULATOR_EVENT_PRE_DISABLE:
 		gpiod_set_value_cansleep(ihid_goodix->reset_gpio, 1);
@@ -87,8 +84,6 @@ static int ihid_goodix_vdd_notify(struct
 		break;
 	}
 
-	mutex_unlock(&ihid_goodix->regulator_mutex);
-
 	return ret;
 }
 
@@ -102,8 +97,6 @@ static int i2c_hid_of_goodix_probe(struc
 	if (!ihid_goodix)
 		return -ENOMEM;
 
-	mutex_init(&ihid_goodix->regulator_mutex);
-
 	ihid_goodix->ops.power_up = goodix_i2c_hid_power_up;
 	ihid_goodix->ops.power_down = goodix_i2c_hid_power_down;
 
@@ -130,25 +123,28 @@ static int i2c_hid_of_goodix_probe(struc
 	 *   long. Holding the controller in reset apparently draws extra
 	 *   power.
 	 */
-	mutex_lock(&ihid_goodix->regulator_mutex);
 	ihid_goodix->nb.notifier_call = ihid_goodix_vdd_notify;
 	ret = devm_regulator_register_notifier(ihid_goodix->vdd, &ihid_goodix->nb);
-	if (ret) {
-		mutex_unlock(&ihid_goodix->regulator_mutex);
+	if (ret)
 		return dev_err_probe(&client->dev, ret,
 			"regulator notifier request failed\n");
-	}
 
 	/*
 	 * If someone else is holding the regulator on (or the regulator is
 	 * an always-on one) we might never be told to deassert reset. Do it
-	 * now. Here we'll assume that someone else might have _just
-	 * barely_ turned the regulator on so we'll do the full
-	 * "post_power_delay" just in case.
+	 * now... and temporarily bump the regulator reference count just to
+	 * make sure it is impossible for this to race with our own notifier!
+	 * We also assume that someone else might have _just barely_ turned
+	 * the regulator on so we'll do the full "post_power_delay" just in
+	 * case.
 	 */
-	if (ihid_goodix->reset_gpio && regulator_is_enabled(ihid_goodix->vdd))
+	if (ihid_goodix->reset_gpio && regulator_is_enabled(ihid_goodix->vdd)) {
+		ret = regulator_enable(ihid_goodix->vdd);
+		if (ret)
+			return ret;
 		goodix_i2c_hid_deassert_reset(ihid_goodix, true);
-	mutex_unlock(&ihid_goodix->regulator_mutex);
+		regulator_disable(ihid_goodix->vdd);
+	}
 
 	return i2c_hid_core_probe(client, &ihid_goodix->ops, 0x0001, 0);
 }


