Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFF91A543
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 00:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfEJWem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 18:34:42 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41910 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbfEJWem (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 18:34:42 -0400
Received: by mail-pg1-f194.google.com with SMTP id z3so3651182pgp.8;
        Fri, 10 May 2019 15:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=X50fW+pml6XSlMG3iikOcC6HOpNkii6b+z99gmbRhAE=;
        b=qHmuXMJQQdoguUqvvtNjrrco7bQ5bopKljNjE1muh96iIJHeNWKoV2RrPSRbxm9VE2
         2PihJ/QuTxgnlPs5RQjV9Qkh8zEhCWVb9OKxHKmbcMUhyB+sQ3mzIp0VM3gJ9yqi53mG
         QQj36yxPTAJydryJnL3M8ghlpVtIhx7wL9146R1J3yWwPq+Vm2B5R1O6q1WjUTPniKZj
         iPUWGtyq8+hf4xFcn0q8zxGK6di/k6T/k9ebZP+h3IxtPuDQOd208y7zoqWXXgzSetN3
         aWYSY82OPXoigusGJPU/GIm89jA5r7r1hWBg3Uevpj4fkZimECa6yerrfCu6yW2Z9bbM
         7nzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=X50fW+pml6XSlMG3iikOcC6HOpNkii6b+z99gmbRhAE=;
        b=Ob15wfU/wi+QKZSJA9mTjvJbQRwdV3J1menn+qc2cfH18bf1LvSgeAEn0awyAz33ha
         YoL0eslu544J2Ht42yoqjXrSL0jROhB05K/TzAvNE6KxGdBVnWH/fSz4GbB5cHOBU4Di
         Uh2HQyuAK12wvwjt4zlknvMmsOJxJhSZEUabZCB7si2UFQXu179UkcgzEwDKQ884u71L
         GfEnDY/nzd24/dvN84hT8wtkRz7n58Oey3dpQMzg5BJu/3IGPPBM73ssGKVY78StX+pi
         01Zp++a7opZ3ylKOSz7ulTrAp5Z7d0eA5n4+r+mipWntx+Fn7bE3qecLD2YXDEGSwy4b
         QrKA==
X-Gm-Message-State: APjAAAUk4OG0G5js+5BZHWKaSz2suDGDrlf9HRKDpXCUygnYN8W4WaVL
        3xt4bwCMk54fEopukQCAJ/Ho3/yA
X-Google-Smtp-Source: APXvYqzJFLtS2Z8Qs88TKDShDkYrCKQs/vTaYwaKAuO0+3n6GBDKKmsR/xGCw8AvPHXb4E6UcodN1g==
X-Received: by 2002:aa7:9ab0:: with SMTP id x16mr10175594pfi.201.1557527680928;
        Fri, 10 May 2019 15:34:40 -0700 (PDT)
Received: from west.Home ([97.115.133.135])
        by smtp.googlemail.com with ESMTPSA id n13sm7192405pgh.6.2019.05.10.15.34.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 10 May 2019 15:34:39 -0700 (PDT)
From:   Aaron Armstrong Skomra <skomra@gmail.com>
X-Google-Original-From: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
To:     linux-input@vger.kernel.org, jikos@kernel.org,
        benjamin.tissoires@redhat.com, pinglinux@gmail.com,
        jason.gerecke@wacom.com
Cc:     Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        "# v4 . 17+" <stable@vger.kernel.org>
Subject: [PATCH 2/4] HID: wacom: generic: Correct pad syncing
Date:   Fri, 10 May 2019 15:34:17 -0700
Message-Id: <1557527659-9417-1-git-send-email-aaron.skomra@wacom.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Only sync the pad once per report, not once per collection.
Also avoid syncing the pad on battery reports.

Fixes: f8b6a74719b5 ("HID: wacom: generic: Support multiple tools per report")
Cc: <stable@vger.kernel.org> # v4.17+
Signed-off-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
---
 drivers/hid/wacom_wac.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 10cce2ca6301..e172c7dda68c 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2121,14 +2121,12 @@ static void wacom_wac_pad_report(struct hid_device *hdev,
 	bool active = wacom_wac->hid_data.inrange_state != 0;
 
 	/* report prox for expresskey events */
-	if ((wacom_equivalent_usage(field->physical) == HID_DG_TABLETFUNCTIONKEY) &&
-	    wacom_wac->hid_data.pad_input_event_flag) {
+	if (wacom_wac->hid_data.pad_input_event_flag) {
 		input_event(input, EV_ABS, ABS_MISC, active ? PAD_DEVICE_ID : 0);
 		input_sync(input);
 		if (!active)
 			wacom_wac->hid_data.pad_input_event_flag = false;
 	}
-
 }
 
 static void wacom_wac_pen_usage_mapping(struct hid_device *hdev,
@@ -2704,9 +2702,7 @@ static int wacom_wac_collection(struct hid_device *hdev, struct hid_report *repo
 	if (report->type != HID_INPUT_REPORT)
 		return -1;
 
-	if (WACOM_PAD_FIELD(field) && wacom->wacom_wac.pad_input)
-		wacom_wac_pad_report(hdev, report, field);
-	else if (WACOM_PEN_FIELD(field) && wacom->wacom_wac.pen_input)
+	if (WACOM_PEN_FIELD(field) && wacom->wacom_wac.pen_input)
 		wacom_wac_pen_report(hdev, report);
 	else if (WACOM_FINGER_FIELD(field) && wacom->wacom_wac.touch_input)
 		wacom_wac_finger_report(hdev, report);
@@ -2720,7 +2716,7 @@ void wacom_wac_report(struct hid_device *hdev, struct hid_report *report)
 	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
 	struct hid_field *field;
 	bool pad_in_hid_field = false, pen_in_hid_field = false,
-		finger_in_hid_field = false;
+		finger_in_hid_field = false, true_pad = false;
 	int r;
 	int prev_collection = -1;
 
@@ -2736,6 +2732,8 @@ void wacom_wac_report(struct hid_device *hdev, struct hid_report *report)
 			pen_in_hid_field = true;
 		if (WACOM_FINGER_FIELD(field))
 			finger_in_hid_field = true;
+		if (wacom_equivalent_usage(field->physical) == HID_DG_TABLETFUNCTIONKEY)
+			true_pad = true;
 	}
 
 	wacom_wac_battery_pre_report(hdev, report);
@@ -2759,6 +2757,9 @@ void wacom_wac_report(struct hid_device *hdev, struct hid_report *report)
 	}
 
 	wacom_wac_battery_report(hdev, report);
+
+	if (true_pad && wacom->wacom_wac.pad_input)
+		wacom_wac_pad_report(hdev, report, field);
 }
 
 static int wacom_bpt_touch(struct wacom_wac *wacom)
-- 
2.7.4

