Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E760CDB40
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 07:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfJGFNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 01:13:02 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34646 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfJGFNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 01:13:00 -0400
Received: by mail-pg1-f195.google.com with SMTP id y35so7482722pgl.1;
        Sun, 06 Oct 2019 22:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nEqYcxr8VTklLjPr6joLE4pwqMopckDYUKFfIpNXBME=;
        b=LsKZRUQ4dO/ZiuXXRB9G+xjGweDsZqpVXBy1tavOoKwBM/3QG+r+CBjzep8yX+y9l3
         VQ3PkWzaQU2KowY5h6St4ZmdyrqvevZGVAXub0yZmJDXxcWoFGY86VNQgmZM7SGdaU21
         g/6R+UePA3PuZwV0rWo4xWiXLa3E+lZj4qke879I2GTJQQFR0RJJvwh77fl2/1NhKuOk
         5wkn5dDoyl4KdyTKhPNrO4t5U08CeEUZ03XqzTyfQM/G25tEZHHTkzTDMhp59ICsqVvj
         mTtxwwk9yZsojX86abnzu8FzJ40vPsbu0nWq8x+zIdBi1qcC7DLtKtTOHDODdwCdbRMx
         80Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nEqYcxr8VTklLjPr6joLE4pwqMopckDYUKFfIpNXBME=;
        b=sy20FuuIrDUHAddJCYdSkVpz0tWwDTHZ9rWVb8IluBnNv591jueRMbU1RUJT86/MvG
         QQIydyBil3dBNBGtwO5SL5rOFFaxWLBpeVJ8hnECBbcdpO3zmPMrKdn+XsTLtU/xJX1w
         OQUdMr59K5z5Ri5ffQwU+GLcTJhz4utoT+nJ1QDRx8QumFzOccw9RHM+vhhCsh0g2yVP
         uCkQ0l4xXFXycUnPx5qjZUnPt7WpV+VcYjPNrKfnFdYp0D6PGqomAnSvB2sWFaH6gJ2p
         7b0S84qm0zbq7KGmVHHgS+xVSyKZrzrk4e1X++tf061V1HqUolshZ07Ew6VGgSzOQVBo
         etzg==
X-Gm-Message-State: APjAAAXT1INHS9h8cq6riRGymXgZWK4EZvDBVO5/xTPqmV6MtFPSmmOt
        br5LIxS7pX0Ej9NLUhWbYAyAJOUfKi8=
X-Google-Smtp-Source: APXvYqxfac+rxYcUVMzMQzH0IdMK8ubxCzXncEy0dqKYJ5FvHVmxKWprnZc9P4qDNslGcKU1SDfsgg==
X-Received: by 2002:a63:1765:: with SMTP id 37mr28565575pgx.121.1570425179172;
        Sun, 06 Oct 2019 22:12:59 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id v133sm2209680pgb.74.2019.10.06.22.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Oct 2019 22:12:58 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-input@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Sam Bazely <sambazley@fastmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/3] HID: logitech-hidpp: use devres to manage FF private data
Date:   Sun,  6 Oct 2019 22:12:38 -0700
Message-Id: <20191007051240.4410-2-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191007051240.4410-1-andrew.smirnov@gmail.com>
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

To simplify resource management in commit that follows as well as to
save a couple of extra kfree()s and simplify hidpp_ff_deinit() switch
driver code to use devres to manage the life-cycle of FF private data.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Henrik Rydberg <rydberg@bitmath.org>
Cc: Sam Bazely <sambazley@fastmail.com>
Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
Cc: Austin Palmer <austinp@valvesoftware.com>
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---
 drivers/hid/hid-logitech-hidpp.c | 53 +++++++++++++++++---------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 0179f7ed77e5..58eb928224e5 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -2079,6 +2079,11 @@ static void hidpp_ff_destroy(struct ff_device *ff)
 	struct hidpp_ff_private_data *data = ff->private;
 
 	kfree(data->effect_ids);
+	/*
+	 * Set private to NULL to prevent input_ff_destroy() from
+	 * freeing our devres allocated memory
+	 */
+	ff->private = NULL;
 }
 
 static int hidpp_ff_init(struct hidpp_device *hidpp, u8 feature_index)
@@ -2090,7 +2095,7 @@ static int hidpp_ff_init(struct hidpp_device *hidpp, u8 feature_index)
 	const u16 bcdDevice = le16_to_cpu(udesc->bcdDevice);
 	struct ff_device *ff;
 	struct hidpp_report response;
-	struct hidpp_ff_private_data *data;
+	struct hidpp_ff_private_data *data = hidpp->private_data;
 	int error, j, num_slots;
 	u8 version;
 
@@ -2129,18 +2134,13 @@ static int hidpp_ff_init(struct hidpp_device *hidpp, u8 feature_index)
 		return error;
 	}
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
 	data->effect_ids = kcalloc(num_slots, sizeof(int), GFP_KERNEL);
-	if (!data->effect_ids) {
-		kfree(data);
+	if (!data->effect_ids)
 		return -ENOMEM;
-	}
+
 	data->wq = create_singlethread_workqueue("hidpp-ff-sendqueue");
 	if (!data->wq) {
 		kfree(data->effect_ids);
-		kfree(data);
 		return -ENOMEM;
 	}
 
@@ -2199,28 +2199,15 @@ static int hidpp_ff_init(struct hidpp_device *hidpp, u8 feature_index)
 	return 0;
 }
 
-static int hidpp_ff_deinit(struct hid_device *hid)
+static void hidpp_ff_deinit(struct hid_device *hid)
 {
-	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
-	struct input_dev *dev = hidinput->input;
-	struct hidpp_ff_private_data *data;
-
-	if (!dev) {
-		hid_err(hid, "Struct input_dev not found!\n");
-		return -EINVAL;
-	}
+	struct hidpp_device *hidpp = hid_get_drvdata(hid);
+	struct hidpp_ff_private_data *data = hidpp->private_data;
 
 	hid_info(hid, "Unloading HID++ force feedback.\n");
-	data = dev->ff->private;
-	if (!data) {
-		hid_err(hid, "Private data not found!\n");
-		return -EINVAL;
-	}
 
 	destroy_workqueue(data->wq);
 	device_remove_file(&hid->dev, &dev_attr_range);
-
-	return 0;
 }
 
 
@@ -2725,6 +2712,20 @@ static int k400_connect(struct hid_device *hdev, bool connected)
 
 #define HIDPP_PAGE_G920_FORCE_FEEDBACK			0x8123
 
+static int g920_allocate(struct hid_device *hdev)
+{
+	struct hidpp_device *hidpp = hid_get_drvdata(hdev);
+	struct hidpp_ff_private_data *data;
+
+	data = devm_kzalloc(&hdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	hidpp->private_data = data;
+
+	return 0;
+}
+
 static int g920_get_config(struct hidpp_device *hidpp)
 {
 	u8 feature_type;
@@ -3561,6 +3562,10 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		ret = k400_allocate(hdev);
 		if (ret)
 			return ret;
+	} else if (hidpp->quirks & HIDPP_QUIRK_CLASS_G920) {
+		ret = g920_allocate(hdev);
+		if (ret)
+			return ret;
 	}
 
 	INIT_WORK(&hidpp->work, delayed_work_cb);
-- 
2.21.0

