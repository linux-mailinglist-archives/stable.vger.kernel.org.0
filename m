Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC645F5E88
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 04:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJFCB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 22:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiJFCBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 22:01:25 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5973437184
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 19:01:24 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 78so551809pgb.13
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 19:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gaikai-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=/bJ6Ot7VHNqG6fD6NCI1uSX1c2aopkFB+w2rPel+p1s=;
        b=ctlHKDyOtF0nxEuctT7DgPrpkyX4qzfyeZQ6ConnEVtjOsvjkzhDEQnjpro/RO9mNK
         AHMecbmHa+0xbVuzEvd31qJD07l30VXlYHvrMFE60SSJ/6U6XjulnFLVK9hKWIEBdSlM
         YzPEJLAVzFDZRxB7RHTxDJRimrHp7ReYXswy/w9AcFwfRGBOSspwaH09pR2qb7CyaiNu
         4I4zn3/u2JR2fNAP3ESDHuxONPZwYIS2BNTjXvmL3KA/lOq+9S3q/9dlW37EGA0wh4oq
         jN53SJneQ21H3e8ht1v+uZ5Xb4Uw8HrWS3ZkkujvrxdAZaJUyTqKadhb0k7E2IuMr3AJ
         OmcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=/bJ6Ot7VHNqG6fD6NCI1uSX1c2aopkFB+w2rPel+p1s=;
        b=c4M7WD7M7y7d/YFX8q2Epme5hbm5RHzYnIkZVvzueZjdUsLO8VU5QaG5Vmr5Ck2om0
         V5j4+p0y6rj7UZEIeLxvlLrevP/AOjGbN3FXu4J0ggP4b6AG9OwXjSRSWRIF3Ucr7Kxv
         H5pVwLemkx1NFod/tBci91jGchTKVQZgxGu+4Erce6ve7rxSLQur/SV8TL0n5C9SxrZE
         xanbPffDrBvYwUq0VutNHIQzUBqyn26Ql4fE/vAkKL+d62VRTx8sp4MIrGlINZjZsE4g
         /futXiFBIx8+GgpZ1+E0y2ewYG/3a/ILLr/zPcOrB4EBCeF1qstHbIlZen+MLY4oIwbU
         dMRw==
X-Gm-Message-State: ACrzQf3SCr51XnAWOsGpUXXSw9i+oKFF0HyeVQE6O5b5Srrg7ruxlD8d
        qF8POMmPFdtzW/tJZgR+KvGTNNYSWVMgGQ==
X-Google-Smtp-Source: AMsMyM5IXlVnVz8/oFnEGLFscJYRfuksgyfelOI6tmkU18ZD3YZOGfcXFpqajj+zhYGyidrCmauN8w==
X-Received: by 2002:a05:6a00:1907:b0:557:e83b:1671 with SMTP id y7-20020a056a00190700b00557e83b1671mr2299999pfi.65.1665021683865;
        Wed, 05 Oct 2022 19:01:23 -0700 (PDT)
Received: from localhost.localdomain (23-122-157-100.lightspeed.irvnca.sbcglobal.net. [23.122.157.100])
        by smtp.gmail.com with ESMTPSA id r20-20020a63e514000000b00456f77f6dd7sm449568pgh.44.2022.10.05.19.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 19:01:22 -0700 (PDT)
From:   Roderick Colenbrander <roderick@gaikai.com>
X-Google-Original-From: Roderick Colenbrander <roderick.colenbrander@sony.com>
To:     thunderbird2k@gmail.com
Cc:     Roderick Colenbrander <roderick.colenbrander@sony.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] HID: playstation: stop DualSense output work on remove.
Date:   Wed,  5 Oct 2022 19:01:17 -0700
Message-Id: <20221006020117.132398-1-roderick.colenbrander@sony.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ensure we don't schedule any new output work on removal and wait
for any existing work to complete. If we don't do this e.g. rumble
work can get queued during deletion and we trigger a kernel crash.

Signed-off-by: Roderick Colenbrander <roderick.colenbrander@sony.com>
CC: stable@vger.kernel.org
---
 drivers/hid/hid-playstation.c | 41 ++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-playstation.c b/drivers/hid/hid-playstation.c
index 40050eb85c0a..d727cd2bf44e 100644
--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -46,6 +46,7 @@ struct ps_device {
 	uint32_t fw_version;
 
 	int (*parse_report)(struct ps_device *dev, struct hid_report *report, u8 *data, int size);
+	void (*remove)(struct ps_device *dev);
 };
 
 /* Calibration data for playstation motion sensors. */
@@ -174,6 +175,7 @@ struct dualsense {
 	struct led_classdev player_leds[5];
 
 	struct work_struct output_worker;
+	bool output_worker_initialized;
 	void *output_report_dmabuf;
 	uint8_t output_seq; /* Sequence number for output report. */
 };
@@ -299,6 +301,7 @@ static const struct {int x; int y; } ps_gamepad_hat_mapping[] = {
 	{0, 0},
 };
 
+static inline void dualsense_schedule_work(struct dualsense *ds);
 static void dualsense_set_lightbar(struct dualsense *ds, uint8_t red, uint8_t green, uint8_t blue);
 
 /*
@@ -789,6 +792,7 @@ static int dualsense_get_calibration_data(struct dualsense *ds)
 	return ret;
 }
 
+
 static int dualsense_get_firmware_info(struct dualsense *ds)
 {
 	uint8_t *buf;
@@ -878,7 +882,7 @@ static int dualsense_player_led_set_brightness(struct led_classdev *led, enum le
 	ds->update_player_leds = true;
 	spin_unlock_irqrestore(&ds->base.lock, flags);
 
-	schedule_work(&ds->output_worker);
+	dualsense_schedule_work(ds);
 
 	return 0;
 }
@@ -922,6 +926,16 @@ static void dualsense_init_output_report(struct dualsense *ds, struct dualsense_
 	}
 }
 
+static inline void dualsense_schedule_work(struct dualsense *ds)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ds->base.lock, flags);
+	if (ds->output_worker_initialized)
+		schedule_work(&ds->output_worker);
+	spin_unlock_irqrestore(&ds->base.lock, flags);
+}
+
 /*
  * Helper function to send DualSense output reports. Applies a CRC at the end of a report
  * for Bluetooth reports.
@@ -1082,7 +1096,7 @@ static int dualsense_parse_report(struct ps_device *ps_dev, struct hid_report *r
 		spin_unlock_irqrestore(&ps_dev->lock, flags);
 
 		/* Schedule updating of microphone state at hardware level. */
-		schedule_work(&ds->output_worker);
+		dualsense_schedule_work(ds);
 	}
 	ds->last_btn_mic_state = btn_mic_state;
 
@@ -1197,10 +1211,22 @@ static int dualsense_play_effect(struct input_dev *dev, void *data, struct ff_ef
 	ds->motor_right = effect->u.rumble.weak_magnitude / 256;
 	spin_unlock_irqrestore(&ds->base.lock, flags);
 
-	schedule_work(&ds->output_worker);
+	dualsense_schedule_work(ds);
 	return 0;
 }
 
+static void dualsense_remove(struct ps_device *ps_dev)
+{
+	struct dualsense *ds = container_of(ps_dev, struct dualsense, base);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ds->base.lock, flags);
+	ds->output_worker_initialized = false;
+	spin_unlock_irqrestore(&ds->base.lock, flags);
+
+	cancel_work_sync(&ds->output_worker);
+}
+
 static int dualsense_reset_leds(struct dualsense *ds)
 {
 	struct dualsense_output_report report;
@@ -1237,7 +1263,7 @@ static void dualsense_set_lightbar(struct dualsense *ds, uint8_t red, uint8_t gr
 	ds->lightbar_blue = blue;
 	spin_unlock_irqrestore(&ds->base.lock, flags);
 
-	schedule_work(&ds->output_worker);
+	dualsense_schedule_work(ds);
 }
 
 static void dualsense_set_player_leds(struct dualsense *ds)
@@ -1260,7 +1286,7 @@ static void dualsense_set_player_leds(struct dualsense *ds)
 
 	ds->update_player_leds = true;
 	ds->player_leds_state = player_ids[player_id];
-	schedule_work(&ds->output_worker);
+	dualsense_schedule_work(ds);
 }
 
 static struct ps_device *dualsense_create(struct hid_device *hdev)
@@ -1299,7 +1325,9 @@ static struct ps_device *dualsense_create(struct hid_device *hdev)
 	ps_dev->battery_capacity = 100; /* initial value until parse_report. */
 	ps_dev->battery_status = POWER_SUPPLY_STATUS_UNKNOWN;
 	ps_dev->parse_report = dualsense_parse_report;
+	ps_dev->remove = dualsense_remove;
 	INIT_WORK(&ds->output_worker, dualsense_output_worker);
+	ds->output_worker_initialized = true;
 	hid_set_drvdata(hdev, ds);
 
 	max_output_report_size = sizeof(struct dualsense_output_report_bt);
@@ -1461,6 +1489,9 @@ static void ps_remove(struct hid_device *hdev)
 	ps_devices_list_remove(dev);
 	ps_device_release_player_id(dev);
 
+	if (dev->remove)
+		dev->remove(dev);
+
 	hid_hw_close(hdev);
 	hid_hw_stop(hdev);
 }
-- 
2.37.3

