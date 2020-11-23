Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E12E2C0960
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388604AbgKWNGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:06:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732992AbgKWMtZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:49:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1886F21D46;
        Mon, 23 Nov 2020 12:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135764;
        bh=8hz9cDbkUsjAwmf7nLs7kxhcTcr0bLcaakhwX3Eyqk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ac1h6aMbh3rH0HKFpjGtfv3Ax0VOsTUMs1377BcCpW4awj4xVzXppB4MzJOAlbW03
         kG2qAnoVPc0A4vvDKINPKDbuTxK6SE5vHizr+1XfLyd9JMy7tRRSUZXOW+gW9xHGp8
         Y/VGW8sjHBHwsY4D0qae9ZCl0Asv15ZzJiMYvpnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 188/252] HID: logitech-dj: Fix Dinovo Mini when paired with a MX5x00 receiver
Date:   Mon, 23 Nov 2020 13:22:18 +0100
Message-Id: <20201123121844.663587695@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit b4c00e7976636f33a4f67eab436a11666c8afd60 ]

Some users are pairing the Dinovo keyboards with the MX5000 or MX5500
receivers, instead of with the Dinovo receivers. The receivers are
mostly the same (and the air protocol obviously is compatible) but
currently the Dinovo receivers are handled by hid-lg.c while the
MX5x00 receivers are handled by logitech-dj.c.

When using a Dinovo keyboard, with its builtin touchpad, through
logitech-dj.c then the touchpad stops working because when asking the
receiver for paired devices, we get only 1 paired device with
a device_type of REPORT_TYPE_KEYBOARD. And since we don't see a paired
mouse, we have nowhere to send mouse-events to, so we drop them.

Extend the existing fix for the Dinovo Edge for this to also cover the
Dinovo Mini keyboard and also add a mapping to logitech-hidpp for the
Media key on the Dinovo Mini, so that that keeps working too.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1811424
Fixes: f2113c3020ef ("HID: logitech-dj: add support for Logitech Bluetooth Mini-Receiver")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-dj.c    |  1 +
 drivers/hid/hid-logitech-hidpp.c | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 1cafb65428b04..389f953c1f12c 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -875,6 +875,7 @@ static void logi_dj_recv_queue_notification(struct dj_receiver_dev *djrcv_dev,
  */
 static const u16 kbd_builtin_touchpad_ids[] = {
 	0xb309, /* Dinovo Edge */
+	0xb30c, /* Dinovo Mini */
 };
 
 static void logi_hidpp_dev_conn_notif_equad(struct hid_device *hdev,
diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 730036650f7df..a2991622702ae 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -93,6 +93,8 @@ MODULE_PARM_DESC(disable_tap_to_click,
 #define HIDPP_CAPABILITY_BATTERY_LEVEL_STATUS	BIT(3)
 #define HIDPP_CAPABILITY_BATTERY_VOLTAGE	BIT(4)
 
+#define lg_map_key_clear(c)  hid_map_usage_clear(hi, usage, bit, max, EV_KEY, (c))
+
 /*
  * There are two hidpp protocols in use, the first version hidpp10 is known
  * as register access protocol or RAP, the second version hidpp20 is known as
@@ -2950,6 +2952,26 @@ static int g920_get_config(struct hidpp_device *hidpp,
 	return g920_ff_set_autocenter(hidpp, data);
 }
 
+/* -------------------------------------------------------------------------- */
+/* Logitech Dinovo Mini keyboard with builtin touchpad                        */
+/* -------------------------------------------------------------------------- */
+#define DINOVO_MINI_PRODUCT_ID		0xb30c
+
+static int lg_dinovo_input_mapping(struct hid_device *hdev, struct hid_input *hi,
+		struct hid_field *field, struct hid_usage *usage,
+		unsigned long **bit, int *max)
+{
+	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_LOGIVENDOR)
+		return 0;
+
+	switch (usage->hid & HID_USAGE) {
+	case 0x00d: lg_map_key_clear(KEY_MEDIA);	break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
 /* -------------------------------------------------------------------------- */
 /* HID++1.0 devices which use HID++ reports for their wheels                  */
 /* -------------------------------------------------------------------------- */
@@ -3185,6 +3207,9 @@ static int hidpp_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			field->application != HID_GD_MOUSE)
 		return m560_input_mapping(hdev, hi, field, usage, bit, max);
 
+	if (hdev->product == DINOVO_MINI_PRODUCT_ID)
+		return lg_dinovo_input_mapping(hdev, hi, field, usage, bit, max);
+
 	return 0;
 }
 
-- 
2.27.0



