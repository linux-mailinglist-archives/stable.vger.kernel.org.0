Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A673ADBC02
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 06:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729636AbfJREyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 00:54:05 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35217 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfJRExy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 00:53:54 -0400
Received: by mail-pl1-f193.google.com with SMTP id c3so2249180plo.2;
        Thu, 17 Oct 2019 21:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JNvDqC31WTWdI2vpSAPtpYynuJNNNTYl8P0mHvHLMNk=;
        b=IYTVyaw4C9oBzL+7mOyH7VFzP20az+ts6hbtvsVnXIWzQjm+ppeVosbblAdJYMzyXO
         I5ySkabTrYIu71JT/oLm10CmVQNxy7JUvfKgQSe1CTTyUMwGiEhe7m5oZ+YgH9cWydBE
         IDDEWvFEdnBZQXi+KYd3vpAJCpuHsDcidlquMM+hsgk5bE2IJ2njN4YnKDQRmpQlnC3r
         p20wP8peXRSf9V7dRjbC8bdn/8elPZfGp+DKjm2kjB+VHqD57lk8i05ZFQ9lBS0rwY7M
         m9Dpu4vonPmTHFlk7B8u40nwAA83fJOGKow5EFfqP0QxulRmfwfuPkqdbE4FWxonW4z3
         f8Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JNvDqC31WTWdI2vpSAPtpYynuJNNNTYl8P0mHvHLMNk=;
        b=IXhYvdJ8fUcK5L4tRmEjfYU+++B7E5mOMyvMm/bPsOkkcBH1Au6pbH69H37i9MbLaK
         35qmrjGNhQ3pzi5b5Js0NYKSiEPj/vABOZVUp9ltU8FrxMAfNvGjyDdzq38R25reU6j+
         6N8mbeQjA5gggJ5Hb0/kLpFrldxWbr9EIMjSEYMi4Rzrufx64vqsVgqdlPpWrgWTyoGJ
         /1IRfy/wQHvcghG1XmAVPq3vSa7Kkl4wzg3nLjP1S9/VHo1lpCOdesr2sNGVwyO1WxUJ
         i93DZtXLKTqM1ZEYD1vYfcOjUba4GWSJr1QFz23lqHv7YS60aXFYXYuERDDCKBq52p/5
         2+LA==
X-Gm-Message-State: APjAAAW0kmZ3NZ8aRMbrLcQ0lP/rdtkgcdc0MAeoE76CZA7jqhnRPPcp
        zR45BNBZg6q1jucgxN6dyOFPtcBN+e8=
X-Google-Smtp-Source: APXvYqyK1y01wydsFJcLUX52fuVNf1rbAwNe2Kgq8tlf4HAFeD9RwxPa0/AfHGZuhADnxHmeOWjyHw==
X-Received: by 2002:a17:902:101:: with SMTP id 1mr7757492plb.170.1571373944591;
        Thu, 17 Oct 2019 21:45:44 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id b3sm3696445pjp.13.2019.10.17.21.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 21:45:43 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-input@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Henrik Rydberg <rydberg@bitmath.org>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v3 3/3] HID: logitech-hidpp: do all FF cleanup in hidpp_ff_destroy()
Date:   Thu, 17 Oct 2019 21:45:17 -0700
Message-Id: <20191018044517.6430-4-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191018044517.6430-1-andrew.smirnov@gmail.com>
References: <20191018044517.6430-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

All of the FF-related resources belong to corresponding FF device, so
they should be freed as a part of hidpp_ff_destroy() to avoid
potential race condidions.

Fixes: ff21a635dd1a ("HID: logitech-hidpp: Force feedback support for the Logitech G920")
Suggested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Henrik Rydberg <rydberg@bitmath.org>
Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
Cc: Austin Palmer <austinp@valvesoftware.com>
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org # 5.2+
---
 drivers/hid/hid-logitech-hidpp.c | 33 +++++---------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 6e669eb7dc69..8e91e2f06cb4 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -2078,7 +2078,12 @@ static DEVICE_ATTR(range, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH, hidpp
 static void hidpp_ff_destroy(struct ff_device *ff)
 {
 	struct hidpp_ff_private_data *data = ff->private;
+	struct hid_device *hid = data->hidpp->hid_dev;
 
+	hid_info(hid, "Unloading HID++ force feedback.\n");
+
+	device_remove_file(&hid->dev, &dev_attr_range);
+	destroy_workqueue(data->wq);
 	kfree(data->effect_ids);
 }
 
@@ -2170,31 +2175,6 @@ static int hidpp_ff_init(struct hidpp_device *hidpp,
 	return 0;
 }
 
-static int hidpp_ff_deinit(struct hid_device *hid)
-{
-	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
-	struct input_dev *dev = hidinput->input;
-	struct hidpp_ff_private_data *data;
-
-	if (!dev) {
-		hid_err(hid, "Struct input_dev not found!\n");
-		return -EINVAL;
-	}
-
-	hid_info(hid, "Unloading HID++ force feedback.\n");
-	data = dev->ff->private;
-	if (!data) {
-		hid_err(hid, "Private data not found!\n");
-		return -EINVAL;
-	}
-
-	destroy_workqueue(data->wq);
-	device_remove_file(&hid->dev, &dev_attr_range);
-
-	return 0;
-}
-
-
 /* ************************************************************************** */
 /*                                                                            */
 /* Device Support                                                             */
@@ -3713,9 +3693,6 @@ static void hidpp_remove(struct hid_device *hdev)
 
 	sysfs_remove_group(&hdev->dev.kobj, &ps_attribute_group);
 
-	if (hidpp->quirks & HIDPP_QUIRK_CLASS_G920)
-		hidpp_ff_deinit(hdev);
-
 	hid_hw_stop(hdev);
 	cancel_work_sync(&hidpp->work);
 	mutex_destroy(&hidpp->send_mutex);
-- 
2.21.0

