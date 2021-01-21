Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D8F2FF50E
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 20:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbhAUTsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 14:48:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbhAUSro (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 13:47:44 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AA6C06174A;
        Thu, 21 Jan 2021 10:46:58 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id m6so2048398pfm.6;
        Thu, 21 Jan 2021 10:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DV+WyTHcLGBdAEm6DifZ+9dUcvJgKflailcNHBr+Tfo=;
        b=kNJLrFZfILTqRRlm8iNz1uUmVGITt0RJNRtt4wpNPQU+/qKdfBFAT1Ghhd605PrMle
         ltvpWzhjEP/aYf6duGWtPgcjYwtid1Fno6OV8Qt2J81O+v3ceEEZrREORw9oxazA1Y0F
         etX0qn7e6NYP8cDu2ZW90lwZrJR5ov5a5wIhOfGf3swcoto5nZRObbXTgqsZFbZI30WU
         De158HrarRogQbEqq2MxArc4IkA1H3iDNFVEXgQQ1MvV6lFsELhaFsC1AvDcXcrP1n85
         JD/HUb5fMUs3OU/PDM1520GKdAKfKwx0UXHPuDjkDtKoUzPKHLxu/vbdJRPiFpu2LFz8
         O7NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DV+WyTHcLGBdAEm6DifZ+9dUcvJgKflailcNHBr+Tfo=;
        b=A2yre98ACQdgl7pe5T8znGFoh0WoE6EmrHMAIEZWVuheXMkrAbkJ2hS9LRg8271RzC
         mq97XApJlw/hduRxdDTRP9Ix7yjZ0A9b1LPrRGKnVABdavLrwiz8QfeZCF9A52aamsMT
         fgv01CF1nrFOxIDdKWyOOatPY9O2OjICo+Q0HQ0Mhb1MrRMByxlyMzxpVm89MoM8Vd3R
         Dcr8YpWaFOARPTJZRQynBIqWyq/g7SNXyZWnHHY7Duo8y5vzUJDkdiUFTNf2sMEIyOzC
         v3CGnSEC8DKVmfoseUayYtTaBwhQPFoc76NOcCJ9Ro5AIopklZAQgsek5fELWgx0ABhx
         irIQ==
X-Gm-Message-State: AOAM531iv72e//ZaWLkA6i8q0DY+oPJu/Q//SFpY/oJEVY3bd9GbI4p6
        FBCGWAzJA8RH5b2ZdNUleNuLCxKyjtt8KIf6
X-Google-Smtp-Source: ABdhPJwYeGf1DLU8V+guJbuIG1u7QKLsPh3RlSayzCkHm/8bTJxhOSGoz6wMOqMfeUjw2UhnlheCGQ==
X-Received: by 2002:a63:464a:: with SMTP id v10mr624584pgk.393.1611254817525;
        Thu, 21 Jan 2021 10:46:57 -0800 (PST)
Received: from horus.lan (71-34-80-131.ptld.qwest.net. [71.34.80.131])
        by smtp.gmail.com with ESMTPSA id fh7sm6556714pjb.43.2021.01.21.10.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 10:46:56 -0800 (PST)
From:   Jason Gerecke <killertofu@gmail.com>
X-Google-Original-From: Jason Gerecke <jason.gerecke@wacom.com>
To:     linux-input@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jason Gerecke <jason.gerecke@wacom.com>, stable@vger.kernel.org,
        Ping Cheng <ping.cheng@wacom.com>
Subject: [PATCH] HID: wacom: Correct NULL dereference on AES pen proximity
Date:   Thu, 21 Jan 2021 10:46:49 -0800
Message-Id: <20210121184649.157189-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The recent commit to fix a memory leak introduced an inadvertant NULL
pointer dereference. The `wacom_wac->pen_fifo` variable was never
intialized, resuling in a crash whenever functions tried to use it.
Since the FIFO is only used by AES pens (to buffer events from pen
proximity until the hardware reports the pen serial number) this would
have been easily overlooked without testing an AES device.

This patch converts `wacom_wac->pen_fifo` over to a pointer (since the
call to `devres_alloc` allocates memory for us) and ensures that we assign
it to point to the allocated and initalized `pen_fifo` before the function
returns.

Link: https://github.com/linuxwacom/input-wacom/issues/230
Fixes: 37309f47e2f5 ("HID: wacom: Fix memory leakage caused by kfifo_alloc")
CC: stable@vger.kernel.org # v4.19+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Tested-by: Ping Cheng <ping.cheng@wacom.com>
---
 drivers/hid/wacom_sys.c | 7 ++++---
 drivers/hid/wacom_wac.h | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index e8acd235db2a..aa9e48876ced 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -147,9 +147,9 @@ static int wacom_wac_pen_serial_enforce(struct hid_device *hdev,
 	}
 
 	if (flush)
-		wacom_wac_queue_flush(hdev, &wacom_wac->pen_fifo);
+		wacom_wac_queue_flush(hdev, wacom_wac->pen_fifo);
 	else if (insert)
-		wacom_wac_queue_insert(hdev, &wacom_wac->pen_fifo,
+		wacom_wac_queue_insert(hdev, wacom_wac->pen_fifo,
 				       raw_data, report_size);
 
 	return insert && !flush;
@@ -1280,7 +1280,7 @@ static void wacom_devm_kfifo_release(struct device *dev, void *res)
 static int wacom_devm_kfifo_alloc(struct wacom *wacom)
 {
 	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
-	struct kfifo_rec_ptr_2 *pen_fifo = &wacom_wac->pen_fifo;
+	struct kfifo_rec_ptr_2 *pen_fifo;
 	int error;
 
 	pen_fifo = devres_alloc(wacom_devm_kfifo_release,
@@ -1297,6 +1297,7 @@ static int wacom_devm_kfifo_alloc(struct wacom *wacom)
 	}
 
 	devres_add(&wacom->hdev->dev, pen_fifo);
+	wacom_wac->pen_fifo = pen_fifo;
 
 	return 0;
 }
diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
index da612b6e9c77..195910dd2154 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -342,7 +342,7 @@ struct wacom_wac {
 	struct input_dev *pen_input;
 	struct input_dev *touch_input;
 	struct input_dev *pad_input;
-	struct kfifo_rec_ptr_2 pen_fifo;
+	struct kfifo_rec_ptr_2 *pen_fifo;
 	int pid;
 	int num_contacts_left;
 	u8 bt_features;
-- 
2.30.0

