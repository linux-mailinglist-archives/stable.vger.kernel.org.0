Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643012A2BA8
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 14:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbgKBNhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 08:37:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36865 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbgKBNhL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 08:37:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604324229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PMHFRiKQsW+vrX36Mzt1zyc5DtfQ4KVKlW3w88xZRWA=;
        b=RBibPDDPrlklnPE8H97Cwnr0GdemXrXweeRK8E9g1n28zbv2JLgPj/FFRqcUdfGucD4K5p
        InRwtcq050lJug9UgGjE6anzZWpDB7FNVU12amEeGRb45SCHoHVJFCBkmZGiHT9lEeR29/
        AsaEcUX2E3eF7K1KAg0kgpv9u03uhhg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-qz3eOCVTN52vapKsrL-Cqg-1; Mon, 02 Nov 2020 08:37:05 -0500
X-MC-Unique: qz3eOCVTN52vapKsrL-Cqg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1AA2A4204A;
        Mon,  2 Nov 2020 13:37:03 +0000 (UTC)
Received: from x1.localdomain (ovpn-113-9.ams2.redhat.com [10.36.113.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 743DA5DA6B;
        Mon,  2 Nov 2020 13:36:59 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-input@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/3] HID: logitech-dj: Handle quad/bluetooth keyboards with a builtin trackpad
Date:   Mon,  2 Nov 2020 14:36:56 +0100
Message-Id: <20201102133658.4410-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/hid/hid-logitech-dj.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index ea1e40530f85..9ed7260b9593 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -867,11 +867,23 @@ static void logi_dj_recv_queue_notification(struct dj_receiver_dev *djrcv_dev,
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
@@ -883,6 +895,13 @@ static void logi_hidpp_dev_conn_notif_equad(struct hid_device *hdev,
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
2.28.0

