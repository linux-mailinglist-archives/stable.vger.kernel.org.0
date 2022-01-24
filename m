Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C85498EA9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345973AbiAXTob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:44:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34448 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346320AbiAXTm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:42:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33301B81142;
        Mon, 24 Jan 2022 19:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51722C340E5;
        Mon, 24 Jan 2022 19:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053345;
        bh=6d29mTJvh2GOvub6qrgiH29qIyJhZWECLVUAyxaXSJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnwInM1ZH9q16KkQPUMf1Ray8GQRZ3s9feio/k6go7PAmHbmJNU1LifCVa/NIEzxE
         DdshhDMMDZum1qIitS0JNsJ7ChkE00aX2gtSJD5I9pH61wJ9N+Oxxbkt63E4DgLzmW
         S+U+wBlTpGiZRcbJ6HptXiqFhfFDvS11HneuQ1ks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Ping Cheng <ping.cheng@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.10 004/563] HID: wacom: Ignore the confidence flag when a touch is removed
Date:   Mon, 24 Jan 2022 19:36:09 +0100
Message-Id: <20220124184024.558854900@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <killertofu@gmail.com>

commit df03e9bd6d4806619b4cdc91a3d7695818a8e2b7 upstream.

AES hardware may internally re-classify a contact that it thought was
intentional as a palm. Intentional contacts are reported as "down" with
the confidence bit set. When this re-classification occurs, however, the
state transitions to "up" with the confidence bit cleared. This kind of
transition appears to be legal according to Microsoft docs, but we do
not handle it correctly. Because the confidence bit is clear, we don't
call `wacom_wac_finger_slot` and update userspace. This causes hung
touches that confuse userspace and interfere with pen arbitration.

This commit adds a special case to ignore the confidence flag if a contact
is reported as removed. This ensures we do not leave a hung touch if one
of these re-classification events occured. Ideally we'd have some way to
also let userspace know that the touch has been re-classified as a palm
and needs to be canceled, but that's not possible right now :)

Link: https://github.com/linuxwacom/input-wacom/issues/288
Fixes: 7fb0413baa7f (HID: wacom: Use "Confidence" flag to prevent reporting invalid contacts)
CC: stable@vger.kernel.org
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2566,6 +2566,24 @@ static void wacom_wac_finger_slot(struct
 	}
 }
 
+static bool wacom_wac_slot_is_active(struct input_dev *dev, int key)
+{
+	struct input_mt *mt = dev->mt;
+	struct input_mt_slot *s;
+
+	if (!mt)
+		return false;
+
+	for (s = mt->slots; s != mt->slots + mt->num_slots; s++) {
+		if (s->key == key &&
+			input_mt_get_value(s, ABS_MT_TRACKING_ID) >= 0) {
+			return true;
+		}
+	}
+
+	return false;
+}
+
 static void wacom_wac_finger_event(struct hid_device *hdev,
 		struct hid_field *field, struct hid_usage *usage, __s32 value)
 {
@@ -2613,9 +2631,14 @@ static void wacom_wac_finger_event(struc
 	}
 
 	if (usage->usage_index + 1 == field->report_count) {
-		if (equivalent_usage == wacom_wac->hid_data.last_slot_field &&
-		    wacom_wac->hid_data.confidence)
-			wacom_wac_finger_slot(wacom_wac, wacom_wac->touch_input);
+		if (equivalent_usage == wacom_wac->hid_data.last_slot_field) {
+			bool touch_removed = wacom_wac_slot_is_active(wacom_wac->touch_input,
+				wacom_wac->hid_data.id) && !wacom_wac->hid_data.tipswitch;
+
+			if (wacom_wac->hid_data.confidence || touch_removed) {
+				wacom_wac_finger_slot(wacom_wac, wacom_wac->touch_input);
+			}
+		}
 	}
 }
 


