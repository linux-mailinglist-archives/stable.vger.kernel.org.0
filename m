Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACE48EEE46
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390402AbfKDWJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:09:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390397AbfKDWJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:09:23 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77456214E0;
        Mon,  4 Nov 2019 22:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905363;
        bh=HsjLLNLxmIouDxnqA72L8QoEOFGWsul04f9vi88c2XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KplFXULk2n0JhAAmKZkIs4rbLpF54lwcfuec6WrtuPpDkfqGZTR7T4yV5OlANRlmn
         V7cck/a43vpfHJkGkISo4AfZWWyrNlB6JLlTn7BQF8udyf5scekDoDPMHMif3E+Je6
         KnsT5rqgz+eozTBGlw5O1WpD6GqZ/HBvb6Vk8q84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Henrik Rydberg <rydberg@bitmath.org>,
        "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 5.3 120/163] HID: logitech-hidpp: do all FF cleanup in hidpp_ff_destroy()
Date:   Mon,  4 Nov 2019 22:45:10 +0100
Message-Id: <20191104212148.906389283@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Smirnov <andrew.smirnov@gmail.com>

commit 08c453f6d073f069cf8e30e03cd3c16262c9b953 upstream.

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
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-logitech-hidpp.c |   33 +++++----------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -2078,7 +2078,12 @@ static DEVICE_ATTR(range, S_IRUSR | S_IW
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
 
@@ -2170,31 +2175,6 @@ static int hidpp_ff_init(struct hidpp_de
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
@@ -3713,9 +3693,6 @@ static void hidpp_remove(struct hid_devi
 
 	sysfs_remove_group(&hdev->dev.kobj, &ps_attribute_group);
 
-	if (hidpp->quirks & HIDPP_QUIRK_CLASS_G920)
-		hidpp_ff_deinit(hdev);
-
 	hid_hw_stop(hdev);
 	cancel_work_sync(&hidpp->work);
 	mutex_destroy(&hidpp->send_mutex);


