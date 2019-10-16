Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3567BD9930
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 20:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436619AbfJPSaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 14:30:03 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34163 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436612AbfJPSaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 14:30:00 -0400
Received: by mail-pl1-f194.google.com with SMTP id k7so11677582pll.1;
        Wed, 16 Oct 2019 11:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4o2nRnrGmqJtA/J2E1Lis+BBBesb9H7tV/2Ne53kdSQ=;
        b=RKtHCtJ1HuSGd9wh2Thc2aoaLdL7DEMZoF2gkZE6URaDLFBN/TnL4wFXLUpvETEO/b
         zPtVUTCLIisvIfNnoLjBHDvYK4/jGJH1Lc2DPLWWYNh/7+oIr3MPDcsPS3JTBfICgTqy
         GgPhJ1Y+WSAO8wIIOK4VgbkHxLlSmp2XNyII6tYsZ2DWGni4Bn/9JAarMlToRcl3qBvO
         ilXwaKeQMzQygcMqUqtyi2q5mro42UK5oBOvYuLYMSXMVGrOcIe0pvuHeIr9X/SYK5Hp
         i3G6XKDg3lzge9ZRtIXBsHT4PuDe5X20SuK0JtGe7IoWmK5CN1ayHMVA0pKuz766TyCU
         pTSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4o2nRnrGmqJtA/J2E1Lis+BBBesb9H7tV/2Ne53kdSQ=;
        b=ADiGI/ffUyxvelfnuAVzt/nioSXMntoK1ORHhFFgVs8PLSePM+EpAY3xQGCsGzMQQL
         /aykGnJ8WcpUZUenqbcYXPgA3omVhsNb82+ZwyNsFi9Ta1byo6l0gDdN6M5CuNKzSRHX
         ZjMLT6HlCd5NVhTrjmOe321VkATLUvCPjmigTaT9uHRfFEL0lwUPs7AUxjjUYKInuUde
         gOC8V56FKagSA9q0V0iMGP3RH84p1wxMzZrWJNC4g7+S4xNYNT3UnnWsmFZ0a76cJeAR
         tsux0hwRGYCxTAoI+9+x3EwLog2w52rj09CWCW8JCiEWp7SUp3dkF0UOSqoAm7g0NSgB
         rUbA==
X-Gm-Message-State: APjAAAWxAd5U4alhEgNWJYWjQGgBpTAL0WYOQseRvVTMBp50obnkrtqT
        VFhuW1xjS3V5PlTk0Fgpx5g3p8ZGDiw=
X-Google-Smtp-Source: APXvYqyc7LqnMdiRhMCp01pG2CYxy9bh7AF43xp1ON/ofqiZ/ejmNnhsXwvIUkUnV4EXPcoNHAZFtg==
X-Received: by 2002:a17:902:778a:: with SMTP id o10mr41858030pll.93.1571250599437;
        Wed, 16 Oct 2019 11:29:59 -0700 (PDT)
Received: from localhost.localdomain ([2607:fb90:8061:1b46:c3ff:7f12:48ed:6323])
        by smtp.gmail.com with ESMTPSA id z4sm2980127pjt.17.2019.10.16.11.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 11:29:58 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-input@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Henrik Rydberg <rydberg@bitmath.org>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2 3/3] HID: logitech-hidpp: do all FF cleanup in hidpp_ff_destroy()
Date:   Wed, 16 Oct 2019 11:29:35 -0700
Message-Id: <20191016182935.5616-4-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191016182935.5616-1-andrew.smirnov@gmail.com>
References: <20191016182935.5616-1-andrew.smirnov@gmail.com>
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
Cc: stable@vger.kernel.org # 4.9+
---
 drivers/hid/hid-logitech-hidpp.c | 33 +++++---------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 8c4be991f387..2524b5104573 100644
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

