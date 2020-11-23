Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9689E2C073D
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbgKWMiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:38:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732117AbgKWMit (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:38:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0B3A21534;
        Mon, 23 Nov 2020 12:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135129;
        bh=VQmjakW0fTCTGpZZ3CFA7wc7YJckrCHIEsD8badNB04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQCRpaPp3UuiCyy0x5mJD/pxeOtp42xuz4Qol1Kgff6/pJ2hIDHiAGC+JFaa+/cLj
         wwP7hrFXVxm34d7WJF27du/WHwsLL+6Inc21xm0zk5hhSu80gh1n+Qmnu0r1wTLhr1
         VoD1x0BfRhcQwRZCSyZTpciBEwEYaB4L9O0CrDAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/158] HID: logitech-dj: Handle quad/bluetooth keyboards with a builtin trackpad
Date:   Mon, 23 Nov 2020 13:22:22 +0100
Message-Id: <20201123121825.435543539@linuxfoundation.org>
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

[ Upstream commit ee5e58418a854755201eb4952b1230d873a457d5 ]

Some quad/bluetooth keyboards, such as the Dinovo Edge (Y-RAY81) have a
builtin touchpad. In this case when asking the receiver for paired devices,
we get only 1 paired device with a device_type of REPORT_TYPE_KEYBOARD.

This means that we do not instantiate a second dj_hiddev for the mouse
(as we normally would) and thus there is no place for us to forward the
mouse input reports to, causing the touchpad part of the keyboard to not
work.

There is no way for us to detect these keyboards, so this commit adds
an array with device-ids for such keyboards and when a keyboard is on
this list it adds STD_MOUSE to the reports_supported bitmap for the
dj_hiddev created for the keyboard fixing the touchpad not working.

Using a list of device-ids for this is not ideal, but there are only
very few such keyboards so this should be fine. Besides the Dinovo Edge,
other known wireless Logitech keyboards with a builtin touchpad are:

* Dinovo Mini (TODO add its device-id to the list)
* K400 (uses a unifying receiver so is not affected)
* K600 (uses a unifying receiver so is not affected)

Cc: stable@vger.kernel.org
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1811424
Fixes: f2113c3020ef ("HID: logitech-dj: add support for Logitech Bluetooth Mini-Receiver")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-dj.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index bb50d6e7745bc..32e5391d98c35 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -866,11 +866,23 @@ static void logi_dj_recv_queue_notification(struct dj_receiver_dev *djrcv_dev,
 	schedule_work(&djrcv_dev->work);
 }
 
+/*
+ * Some quad/bluetooth keyboards have a builtin touchpad in this case we see
+ * only 1 paired device with a device_type of REPORT_TYPE_KEYBOARD. For the
+ * touchpad to work we must also forward mouse input reports to the dj_hiddev
+ * created for the keyboard (instead of forwarding them to a second paired
+ * device with a device_type of REPORT_TYPE_MOUSE as we normally would).
+ */
+static const u16 kbd_builtin_touchpad_ids[] = {
+	0xb309, /* Dinovo Edge */
+};
+
 static void logi_hidpp_dev_conn_notif_equad(struct hid_device *hdev,
 					    struct hidpp_event *hidpp_report,
 					    struct dj_workitem *workitem)
 {
 	struct dj_receiver_dev *djrcv_dev = hid_get_drvdata(hdev);
+	int i, id;
 
 	workitem->type = WORKITEM_TYPE_PAIRED;
 	workitem->device_type = hidpp_report->params[HIDPP_PARAM_DEVICE_INFO] &
@@ -882,6 +894,13 @@ static void logi_hidpp_dev_conn_notif_equad(struct hid_device *hdev,
 		workitem->reports_supported |= STD_KEYBOARD | MULTIMEDIA |
 					       POWER_KEYS | MEDIA_CENTER |
 					       HIDPP;
+		id = (workitem->quad_id_msb << 8) | workitem->quad_id_lsb;
+		for (i = 0; i < ARRAY_SIZE(kbd_builtin_touchpad_ids); i++) {
+			if (id == kbd_builtin_touchpad_ids[i]) {
+				workitem->reports_supported |= STD_MOUSE;
+				break;
+			}
+		}
 		break;
 	case REPORT_TYPE_MOUSE:
 		workitem->reports_supported |= STD_MOUSE | HIDPP;
-- 
2.27.0



