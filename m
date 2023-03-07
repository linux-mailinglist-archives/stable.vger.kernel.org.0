Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CE66AF418
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbjCGTN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbjCGTMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:12:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B73B53D9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:56:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4436461531
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D88C433EF;
        Tue,  7 Mar 2023 18:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215404;
        bh=7kLTaSQ8pxMlbLNsfKnicbmuYg/+q5pq/i7tK+wQkag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OkRAHer4VX1Bnkdj+nTD8ToSDfY86xk4qINCSVWHsUzBLAPxSNyX5JFbyPgmzcJGl
         vS/awWnlaWmyqKoSVlxJ80Jj5qgHc+fCER+S0wglBVLzo0JgphtNXrPqcy0yW6XoEH
         ntFLjE5cBvkytlc4977hcT/yqRe9GDCVXBAXYLPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 250/567] HID: bigben: use spinlock to protect concurrent accesses
Date:   Tue,  7 Mar 2023 17:59:46 +0100
Message-Id: <20230307165916.796758912@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit 9fefb6201c4f8dd9f58c581b2a66e5cde2895ea2 ]

bigben driver has a worker that may access data concurrently.
Proct the accesses using a spinlock.

Fixes: 256a90ed9e46 ("HID: hid-bigbenff: driver for BigBen Interactive PS3OFMINIPAD gamepad")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Link: https://lore.kernel.org/r/20230125-hid-unregister-leds-v4-1-7860c5763c38@diag.uniroma1.it
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-bigbenff.c | 52 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-bigbenff.c b/drivers/hid/hid-bigbenff.c
index e8b16665860d6..ed3d2d7bc1dd4 100644
--- a/drivers/hid/hid-bigbenff.c
+++ b/drivers/hid/hid-bigbenff.c
@@ -174,6 +174,7 @@ static __u8 pid0902_rdesc_fixed[] = {
 struct bigben_device {
 	struct hid_device *hid;
 	struct hid_report *report;
+	spinlock_t lock;
 	bool removed;
 	u8 led_state;         /* LED1 = 1 .. LED4 = 8 */
 	u8 right_motor_on;    /* right motor off/on 0/1 */
@@ -190,12 +191,27 @@ static void bigben_worker(struct work_struct *work)
 	struct bigben_device *bigben = container_of(work,
 		struct bigben_device, worker);
 	struct hid_field *report_field = bigben->report->field[0];
+	bool do_work_led = false;
+	bool do_work_ff = false;
+	u8 *buf;
+	u32 len;
+	unsigned long flags;
 
 	if (bigben->removed || !report_field)
 		return;
 
+	buf = hid_alloc_report_buf(bigben->report, GFP_KERNEL);
+	if (!buf)
+		return;
+
+	len = hid_report_len(bigben->report);
+
+	/* LED work */
+	spin_lock_irqsave(&bigben->lock, flags);
+
 	if (bigben->work_led) {
 		bigben->work_led = false;
+		do_work_led = true;
 		report_field->value[0] = 0x01; /* 1 = led message */
 		report_field->value[1] = 0x08; /* reserved value, always 8 */
 		report_field->value[2] = bigben->led_state;
@@ -204,11 +220,22 @@ static void bigben_worker(struct work_struct *work)
 		report_field->value[5] = 0x00; /* padding */
 		report_field->value[6] = 0x00; /* padding */
 		report_field->value[7] = 0x00; /* padding */
-		hid_hw_request(bigben->hid, bigben->report, HID_REQ_SET_REPORT);
+		hid_output_report(bigben->report, buf);
+	}
+
+	spin_unlock_irqrestore(&bigben->lock, flags);
+
+	if (do_work_led) {
+		hid_hw_raw_request(bigben->hid, bigben->report->id, buf, len,
+				   bigben->report->type, HID_REQ_SET_REPORT);
 	}
 
+	/* FF work */
+	spin_lock_irqsave(&bigben->lock, flags);
+
 	if (bigben->work_ff) {
 		bigben->work_ff = false;
+		do_work_ff = true;
 		report_field->value[0] = 0x02; /* 2 = rumble effect message */
 		report_field->value[1] = 0x08; /* reserved value, always 8 */
 		report_field->value[2] = bigben->right_motor_on;
@@ -217,8 +244,17 @@ static void bigben_worker(struct work_struct *work)
 		report_field->value[5] = 0x00; /* padding */
 		report_field->value[6] = 0x00; /* padding */
 		report_field->value[7] = 0x00; /* padding */
-		hid_hw_request(bigben->hid, bigben->report, HID_REQ_SET_REPORT);
+		hid_output_report(bigben->report, buf);
+	}
+
+	spin_unlock_irqrestore(&bigben->lock, flags);
+
+	if (do_work_ff) {
+		hid_hw_raw_request(bigben->hid, bigben->report->id, buf, len,
+				   bigben->report->type, HID_REQ_SET_REPORT);
 	}
+
+	kfree(buf);
 }
 
 static int hid_bigben_play_effect(struct input_dev *dev, void *data,
@@ -228,6 +264,7 @@ static int hid_bigben_play_effect(struct input_dev *dev, void *data,
 	struct bigben_device *bigben = hid_get_drvdata(hid);
 	u8 right_motor_on;
 	u8 left_motor_force;
+	unsigned long flags;
 
 	if (!bigben) {
 		hid_err(hid, "no device data\n");
@@ -242,9 +279,12 @@ static int hid_bigben_play_effect(struct input_dev *dev, void *data,
 
 	if (right_motor_on != bigben->right_motor_on ||
 			left_motor_force != bigben->left_motor_force) {
+		spin_lock_irqsave(&bigben->lock, flags);
 		bigben->right_motor_on   = right_motor_on;
 		bigben->left_motor_force = left_motor_force;
 		bigben->work_ff = true;
+		spin_unlock_irqrestore(&bigben->lock, flags);
+
 		schedule_work(&bigben->worker);
 	}
 
@@ -259,6 +299,7 @@ static void bigben_set_led(struct led_classdev *led,
 	struct bigben_device *bigben = hid_get_drvdata(hid);
 	int n;
 	bool work;
+	unsigned long flags;
 
 	if (!bigben) {
 		hid_err(hid, "no device data\n");
@@ -267,6 +308,7 @@ static void bigben_set_led(struct led_classdev *led,
 
 	for (n = 0; n < NUM_LEDS; n++) {
 		if (led == bigben->leds[n]) {
+			spin_lock_irqsave(&bigben->lock, flags);
 			if (value == LED_OFF) {
 				work = (bigben->led_state & BIT(n));
 				bigben->led_state &= ~BIT(n);
@@ -274,6 +316,7 @@ static void bigben_set_led(struct led_classdev *led,
 				work = !(bigben->led_state & BIT(n));
 				bigben->led_state |= BIT(n);
 			}
+			spin_unlock_irqrestore(&bigben->lock, flags);
 
 			if (work) {
 				bigben->work_led = true;
@@ -307,8 +350,12 @@ static enum led_brightness bigben_get_led(struct led_classdev *led)
 static void bigben_remove(struct hid_device *hid)
 {
 	struct bigben_device *bigben = hid_get_drvdata(hid);
+	unsigned long flags;
 
+	spin_lock_irqsave(&bigben->lock, flags);
 	bigben->removed = true;
+	spin_unlock_irqrestore(&bigben->lock, flags);
+
 	cancel_work_sync(&bigben->worker);
 	hid_hw_stop(hid);
 }
@@ -362,6 +409,7 @@ static int bigben_probe(struct hid_device *hid,
 	set_bit(FF_RUMBLE, hidinput->input->ffbit);
 
 	INIT_WORK(&bigben->worker, bigben_worker);
+	spin_lock_init(&bigben->lock);
 
 	error = input_ff_create_memless(hidinput->input, NULL,
 		hid_bigben_play_effect);
-- 
2.39.2



