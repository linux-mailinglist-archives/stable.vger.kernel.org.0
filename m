Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955A66B4564
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbjCJOd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbjCJOdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:33:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0FD11E6F4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:32:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A444B822BB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:32:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF944C433EF;
        Fri, 10 Mar 2023 14:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458766;
        bh=Dir9XLVPOhx7BWAxHbcQWkoUQYaPQ3fIV/s6qVIhpLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bq9awBQ+3IiTJNOITYxbRfBaP5iiLc1X/zftzO1OUCKJjEW1QIkirqY6sHJvcN0+t
         9VHvLmpTWk/jUtTBjlgX72vXa/MZfYFlSNAWxFLfciL0R55EbdNyMXc+LiKzQ/+M34
         xly7FP7KhhK5s/M9ubpfN65/k+iptuPf69LIlS1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 137/357] HID: asus: Fix mute and touchpad-toggle keys on Medion Akoya E1239T
Date:   Fri, 10 Mar 2023 14:37:06 +0100
Message-Id: <20230310133740.726750385@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 350bd245fc180032b442633d40ab37ff8e60e8eb ]

The mute key, is broken. All the consumer keys on the keyboard USB
interface work normally, except for mute which only sends press events
and never sends release events.

The touchpad key sends the otherwise unused input report with a report-id
of 5 on the touchpad interface. It too only sends press events. This also
requires extra special handling since the multi-touch touchpad events and
the KEY_F21 events for the touchpad toggle must not be send from the same
input_dev (userspace cannot handle this).

This commit adds special handlig for both, fixing these keys not working.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: 4ab3a086d10e ("HID: asus: use spinlock to safely schedule workers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 60 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index bfe754419253e..e15ba7f5fe0a0 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -42,6 +42,7 @@ MODULE_DESCRIPTION("Asus HID Keyboard and TouchPad");
 #define T100_TPAD_INTF 2
 #define MEDION_E1239T_TPAD_INTF 1
 
+#define E1239T_TP_TOGGLE_REPORT_ID 0x05
 #define T100CHI_MOUSE_REPORT_ID 0x06
 #define FEATURE_REPORT_ID 0x0d
 #define INPUT_REPORT_ID 0x5d
@@ -112,6 +113,7 @@ struct asus_drvdata {
 	unsigned long quirks;
 	struct hid_device *hdev;
 	struct input_dev *input;
+	struct input_dev *tp_kbd_input;
 	struct asus_kbd_leds *kbd_backlight;
 	const struct asus_touchpad_info *tp;
 	bool enable_backlight;
@@ -276,6 +278,34 @@ static int asus_report_input(struct asus_drvdata *drvdat, u8 *data, int size)
 	return 1;
 }
 
+static int asus_e1239t_event(struct asus_drvdata *drvdat, u8 *data, int size)
+{
+	if (size != 3)
+		return 0;
+
+	/* Handle broken mute key which only sends press events */
+	if (!drvdat->tp &&
+	    data[0] == 0x02 && data[1] == 0xe2 && data[2] == 0x00) {
+		input_report_key(drvdat->input, KEY_MUTE, 1);
+		input_sync(drvdat->input);
+		input_report_key(drvdat->input, KEY_MUTE, 0);
+		input_sync(drvdat->input);
+		return 1;
+	}
+
+	/* Handle custom touchpad toggle key which only sends press events */
+	if (drvdat->tp_kbd_input &&
+	    data[0] == 0x05 && data[1] == 0x02 && data[2] == 0x28) {
+		input_report_key(drvdat->tp_kbd_input, KEY_F21, 1);
+		input_sync(drvdat->tp_kbd_input);
+		input_report_key(drvdat->tp_kbd_input, KEY_F21, 0);
+		input_sync(drvdat->tp_kbd_input);
+		return 1;
+	}
+
+	return 0;
+}
+
 static int asus_event(struct hid_device *hdev, struct hid_field *field,
 		      struct hid_usage *usage, __s32 value)
 {
@@ -300,6 +330,9 @@ static int asus_raw_event(struct hid_device *hdev,
 	if (drvdata->tp && data[0] == INPUT_REPORT_ID)
 		return asus_report_input(drvdata, data, size);
 
+	if (drvdata->quirks & QUIRK_MEDION_E1239T)
+		return asus_e1239t_event(drvdata, data, size);
+
 	return 0;
 }
 
@@ -653,6 +686,21 @@ static int asus_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	    hi->report->id != T100CHI_MOUSE_REPORT_ID)
 		return 0;
 
+	/* Handle MULTI_INPUT on E1239T mouse/touchpad USB interface */
+	if (drvdata->tp && (drvdata->quirks & QUIRK_MEDION_E1239T)) {
+		switch (hi->report->id) {
+		case E1239T_TP_TOGGLE_REPORT_ID:
+			input_set_capability(input, EV_KEY, KEY_F21);
+			input->name = "Asus Touchpad Keys";
+			drvdata->tp_kbd_input = input;
+			return 0;
+		case INPUT_REPORT_ID:
+			break; /* Touchpad report, handled below */
+		default:
+			return 0; /* Ignore other reports */
+		}
+	}
+
 	if (drvdata->tp) {
 		int ret;
 
@@ -820,6 +868,16 @@ static int asus_input_mapping(struct hid_device *hdev,
 		}
 	}
 
+	/*
+	 * The mute button is broken and only sends press events, we
+	 * deal with this in our raw_event handler, so do not map it.
+	 */
+	if ((drvdata->quirks & QUIRK_MEDION_E1239T) &&
+	    usage->hid == (HID_UP_CONSUMER | 0xe2)) {
+		input_set_capability(hi->input, EV_KEY, KEY_MUTE);
+		return -1;
+	}
+
 	return 0;
 }
 
@@ -921,6 +979,8 @@ static int asus_probe(struct hid_device *hdev, const struct hid_device_id *id)
 			to_usb_interface(hdev->dev.parent)->altsetting;
 
 		if (alt->desc.bInterfaceNumber == MEDION_E1239T_TPAD_INTF) {
+			/* For separate input-devs for tp and tp toggle key */
+			hdev->quirks |= HID_QUIRK_MULTI_INPUT;
 			drvdata->quirks |= QUIRK_SKIP_INPUT_MAPPING;
 			drvdata->tp = &medion_e1239t_tp;
 		}
-- 
2.39.2



