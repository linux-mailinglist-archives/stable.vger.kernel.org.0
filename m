Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D782F498D73
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351684AbiAXTcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351890AbiAXT27 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:28:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812A9C06135D;
        Mon, 24 Jan 2022 11:13:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E61E612FE;
        Mon, 24 Jan 2022 19:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF521C340E5;
        Mon, 24 Jan 2022 19:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051592;
        bh=INA086hqSWtwfZHOLhkrFU+jwIwMPMlerwTlFpXtk6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmwWFpd+kmDXHOCvXIMIr5kG6DsVr0pQ916pnxuTed46HY1KhuIXc4GY5q/UyH5yZ
         tT3tWwTAIqySAyrZopS5inct2xjFgxB2HHVWaAslH9wXtaltGweLVMw8AqckkjJPxn
         P+pkPsKC3q3+QPfrxsDeQJeh2rqN7M/FPfVfT8W0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Ping Cheng <ping.cheng@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 024/239] HID: wacom: Ignore the confidence flag when a touch is removed
Date:   Mon, 24 Jan 2022 19:41:02 +0100
Message-Id: <20220124183943.888440598@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
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
@@ -2529,6 +2529,24 @@ static void wacom_wac_finger_slot(struct
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
@@ -2571,9 +2589,14 @@ static void wacom_wac_finger_event(struc
 
 
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
 


