Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830952C073F
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732141AbgKWMix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:38:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:51522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732137AbgKWMiw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:38:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59CA82065E;
        Mon, 23 Nov 2020 12:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135131;
        bh=XIhCtibTz5EAmi93u71+j1Y10D/sRsNnUjTBMRyTU+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nsQ1Fifwgieqspq7HEOw2eAmLoLFRqwsQCPpWp6SMAIJA5n1IE4KU3ortlQ0ZXh2C
         s/VM1QiPEJSMVH4wtu5Wjky2Mq95z/W5WZiJFTBlDwujNNCIiqrIuGn92R0gzDbypO
         glOxO/6NfjfuSMKQ70FKE+AFnj34OWvKLdp8ZPj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/158] HID: logitech-dj: Fix Dinovo Mini when paired with a MX5x00 receiver
Date:   Mon, 23 Nov 2020 13:22:23 +0100
Message-Id: <20201123121825.488168996@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
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
index 32e5391d98c35..309e5df463d5c 100644
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
index c85070d631da5..e49d36de07968 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -88,6 +88,8 @@ MODULE_PARM_DESC(disable_tap_to_click,
 #define HIDPP_CAPABILITY_BATTERY_MILEAGE	BIT(2)
 #define HIDPP_CAPABILITY_BATTERY_LEVEL_STATUS	BIT(3)
 
+#define lg_map_key_clear(c)  hid_map_usage_clear(hi, usage, bit, max, EV_KEY, (c))
+
 /*
  * There are two hidpp protocols in use, the first version hidpp10 is known
  * as register access protocol or RAP, the second version hidpp20 is known as
@@ -2768,6 +2770,26 @@ static int g920_get_config(struct hidpp_device *hidpp,
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
@@ -3003,6 +3025,9 @@ static int hidpp_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			field->application != HID_GD_MOUSE)
 		return m560_input_mapping(hdev, hi, field, usage, bit, max);
 
+	if (hdev->product == DINOVO_MINI_PRODUCT_ID)
+		return lg_dinovo_input_mapping(hdev, hi, field, usage, bit, max);
+
 	return 0;
 }
 
-- 
2.27.0



