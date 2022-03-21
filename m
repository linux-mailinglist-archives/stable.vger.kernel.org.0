Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A524E3361
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 23:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbiCUWzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 18:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiCUWzX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 18:55:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7903B2A14;
        Mon, 21 Mar 2022 15:37:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D747B81A66;
        Mon, 21 Mar 2022 21:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F2BC340F0;
        Mon, 21 Mar 2022 21:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647899590;
        bh=/yE+Sme9P6DeiwPLI0+q7oIXGmD4IVHQHa6leBP2hnE=;
        h=From:To:Cc:Subject:Date:From;
        b=M6yBvafZ3D2xuVh5WZt4BgylGkT5tEJcTybhGdLp+VQIvWc8tBYvQFSFHtLF7n0NX
         cwa4Ry4I6O+/6/3Z+I/D7Iltcfd90XpOH4D6SJj/JjvZkDfMr5FnHjKwj7evAyQ1dj
         SM+VBB0/9x6HDBT+/uq3xl6zBd8ff7WhDoC4vgJqJOUCDmMjA31J7RwsG+ROPt6Jz7
         J1zuMtuKyXJ5TWGHbzxrkwKgiyKoeO1e8ns0Aif+xcTlQToyHZZXJY38CN1fbmInDC
         ZPDRzh8kfrUqIkodRGl5e2xB2Z5m5JcZxEpajz6QYmPYX5PiyYKs640oXw+yLO7jjd
         HPPNSSiH6Ux3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, nikita@trvn.ru,
        song.bao.hua@hisilicon.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 1/4] Input: zinitix - do not report shadow fingers
Date:   Mon, 21 Mar 2022 17:53:02 -0400
Message-Id: <20220321215308.490358-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit e941dc13fd3717122207d74539ab95da07ef797f ]

I observed the following problem with the BT404 touch pad
running the Phosh UI:

When e.g. typing on the virtual keyboard pressing "g" would
produce "ggg".

After some analysis it turns out the firmware reports that three
fingers hit that coordinate at the same time, finger 0, 2 and
4 (of the five available 0,1,2,3,4).

DOWN
  Zinitix-TS 3-0020: finger 0 down (246, 395)
  Zinitix-TS 3-0020: finger 1 up (0, 0)
  Zinitix-TS 3-0020: finger 2 down (246, 395)
  Zinitix-TS 3-0020: finger 3 up (0, 0)
  Zinitix-TS 3-0020: finger 4 down (246, 395)
UP
  Zinitix-TS 3-0020: finger 0 up (246, 395)
  Zinitix-TS 3-0020: finger 2 up (246, 395)
  Zinitix-TS 3-0020: finger 4 up (246, 395)

This is one touch and release: i.e. this is all reported on
touch (down) and release.

There is a field in the struct touch_event called finger_cnt
which is actually a bitmask of the fingers active in the
event.

Rename this field finger_mask as this matches the use contents
better, then use for_each_set_bit() to iterate over just the
fingers that are actally active.

Factor out a finger reporting function zinitix_report_fingers()
to handle all fingers.

Also be more careful in reporting finger down/up: we were
reporting every event with input_mt_report_slot_state(..., true);
but this should only be reported on finger down or move,
not on finger up, so also add code to check p->sub_status
to see what is happening and report correctly.

After this my Zinitix BT404 touchscreen report fingers
flawlessly.

The vendor drive I have notably does not use the "finger_cnt"
and contains obviously incorrect code like this:

  if (touch_dev->touch_info.finger_cnt > MAX_SUPPORTED_FINGER_NUM)
      touch_dev->touch_info.finger_cnt = MAX_SUPPORTED_FINGER_NUM;

As MAX_SUPPORTED_FINGER_NUM is an ordinal and the field is
a bitmask this seems quite confused.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220228233017.2270599-1-linus.walleij@linaro.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/zinitix.c | 44 +++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/input/touchscreen/zinitix.c b/drivers/input/touchscreen/zinitix.c
index 6df6f07f1ac6..17b10b81c713 100644
--- a/drivers/input/touchscreen/zinitix.c
+++ b/drivers/input/touchscreen/zinitix.c
@@ -135,7 +135,7 @@ struct point_coord {
 
 struct touch_event {
 	__le16	status;
-	u8	finger_cnt;
+	u8	finger_mask;
 	u8	time_stamp;
 	struct point_coord point_coord[MAX_SUPPORTED_FINGER_NUM];
 };
@@ -311,11 +311,32 @@ static int zinitix_send_power_on_sequence(struct bt541_ts_data *bt541)
 static void zinitix_report_finger(struct bt541_ts_data *bt541, int slot,
 				  const struct point_coord *p)
 {
+	u16 x, y;
+
+	if (unlikely(!(p->sub_status &
+		       (SUB_BIT_UP | SUB_BIT_DOWN | SUB_BIT_MOVE)))) {
+		dev_dbg(&bt541->client->dev, "unknown finger event %#02x\n",
+			p->sub_status);
+		return;
+	}
+
+	x = le16_to_cpu(p->x);
+	y = le16_to_cpu(p->y);
+
 	input_mt_slot(bt541->input_dev, slot);
-	input_mt_report_slot_state(bt541->input_dev, MT_TOOL_FINGER, true);
-	touchscreen_report_pos(bt541->input_dev, &bt541->prop,
-			       le16_to_cpu(p->x), le16_to_cpu(p->y), true);
-	input_report_abs(bt541->input_dev, ABS_MT_TOUCH_MAJOR, p->width);
+	if (input_mt_report_slot_state(bt541->input_dev, MT_TOOL_FINGER,
+				       !(p->sub_status & SUB_BIT_UP))) {
+		touchscreen_report_pos(bt541->input_dev,
+				       &bt541->prop, x, y, true);
+		input_report_abs(bt541->input_dev,
+				 ABS_MT_TOUCH_MAJOR, p->width);
+		dev_dbg(&bt541->client->dev, "finger %d %s (%u, %u)\n",
+			slot, p->sub_status & SUB_BIT_DOWN ? "down" : "move",
+			x, y);
+	} else {
+		dev_dbg(&bt541->client->dev, "finger %d up (%u, %u)\n",
+			slot, x, y);
+	}
 }
 
 static irqreturn_t zinitix_ts_irq_handler(int irq, void *bt541_handler)
@@ -323,6 +344,7 @@ static irqreturn_t zinitix_ts_irq_handler(int irq, void *bt541_handler)
 	struct bt541_ts_data *bt541 = bt541_handler;
 	struct i2c_client *client = bt541->client;
 	struct touch_event touch_event;
+	unsigned long finger_mask;
 	int error;
 	int i;
 
@@ -335,10 +357,14 @@ static irqreturn_t zinitix_ts_irq_handler(int irq, void *bt541_handler)
 		goto out;
 	}
 
-	for (i = 0; i < MAX_SUPPORTED_FINGER_NUM; i++)
-		if (touch_event.point_coord[i].sub_status & SUB_BIT_EXIST)
-			zinitix_report_finger(bt541, i,
-					      &touch_event.point_coord[i]);
+	finger_mask = touch_event.finger_mask;
+	for_each_set_bit(i, &finger_mask, MAX_SUPPORTED_FINGER_NUM) {
+		const struct point_coord *p = &touch_event.point_coord[i];
+
+		/* Only process contacts that are actually reported */
+		if (p->sub_status & SUB_BIT_EXIST)
+			zinitix_report_finger(bt541, i, p);
+	}
 
 	input_mt_sync_frame(bt541->input_dev);
 	input_sync(bt541->input_dev);
-- 
2.34.1

