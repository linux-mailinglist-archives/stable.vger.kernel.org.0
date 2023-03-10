Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02D66B4563
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbjCJOd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbjCJOdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:33:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA55311EE9E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:32:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49958618A6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392C3C433D2;
        Fri, 10 Mar 2023 14:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458763;
        bh=LqUZuZVtVodn/4TJ1Mr70TicUMVdx4jW2gnbihWzC6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=waoJRJI4c+s8zvC0a+GYfc/mAiGiEkHq89eNBWqwtK/g9rde/ZQm0cxjioxL+mz/u
         we7FtiYMpiJDUzy/6X+97M54xC4x4VNDN8t0ggjiKVUhoVJ9ZUYiyAFHh7vepB5WhV
         r3uZfesvY/EWlzJs/ZvP3Xd7hQC6TNrjDN/Hsdwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 136/357] HID: asus: Add support for multi-touch touchpad on Medion Akoya E1239T
Date:   Fri, 10 Mar 2023 14:37:05 +0100
Message-Id: <20230310133740.686857485@linuxfoundation.org>
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

[ Upstream commit e271f6c2df78d60dd4873c790a51dba40e6dfb72 ]

The multi-touch touchpad found on the Medion Akoya E1239T's keyboard-dock,
uses the same custom multi-touch protocol as the Asus keyboard-docks
(same chipset vendor, Integrated Technology Express / ITE).

Add support for this using the existing multi-touch touchpad support in
the hid-asus driver.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: 4ab3a086d10e ("HID: asus: use spinlock to safely schedule workers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 26 +++++++++++++++++++++++++-
 drivers/hid/hid-ids.h  |  1 +
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 4d877b4581b40..bfe754419253e 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -40,6 +40,7 @@ MODULE_AUTHOR("Frederik Wenigwieser <frederik.wenigwieser@gmail.com>");
 MODULE_DESCRIPTION("Asus HID Keyboard and TouchPad");
 
 #define T100_TPAD_INTF 2
+#define MEDION_E1239T_TPAD_INTF 1
 
 #define T100CHI_MOUSE_REPORT_ID 0x06
 #define FEATURE_REPORT_ID 0x0d
@@ -77,6 +78,7 @@ MODULE_DESCRIPTION("Asus HID Keyboard and TouchPad");
 #define QUIRK_G752_KEYBOARD		BIT(8)
 #define QUIRK_T101HA_DOCK		BIT(9)
 #define QUIRK_T90CHI			BIT(10)
+#define QUIRK_MEDION_E1239T		BIT(11)
 
 #define I2C_KEYBOARD_QUIRKS			(QUIRK_FIX_NOTEBOOK_REPORT | \
 						 QUIRK_NO_INIT_REPORTS | \
@@ -171,6 +173,16 @@ static const struct asus_touchpad_info asus_t100chi_tp = {
 	.report_size = 15 /* 2 byte header + 3 * 4 + 1 byte footer */,
 };
 
+static const struct asus_touchpad_info medion_e1239t_tp = {
+	.max_x = 2640,
+	.max_y = 1380,
+	.res_x = 29, /* units/mm */
+	.res_y = 28, /* units/mm */
+	.contact_size = 5,
+	.max_contacts = 5,
+	.report_size = 32 /* 2 byte header + 5 * 5 + 5 byte footer */,
+};
+
 static void asus_report_contact_down(struct asus_drvdata *drvdat,
 		int toolType, u8 *data)
 {
@@ -903,6 +915,17 @@ static int asus_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		drvdata->tp = &asus_t100chi_tp;
 	}
 
+	if ((drvdata->quirks & QUIRK_MEDION_E1239T) &&
+	    hid_is_using_ll_driver(hdev, &usb_hid_driver)) {
+		struct usb_host_interface *alt =
+			to_usb_interface(hdev->dev.parent)->altsetting;
+
+		if (alt->desc.bInterfaceNumber == MEDION_E1239T_TPAD_INTF) {
+			drvdata->quirks |= QUIRK_SKIP_INPUT_MAPPING;
+			drvdata->tp = &medion_e1239t_tp;
+		}
+	}
+
 	if (drvdata->quirks & QUIRK_NO_INIT_REPORTS)
 		hdev->quirks |= HID_QUIRK_NO_INIT_REPORTS;
 
@@ -1086,7 +1109,8 @@ static const struct hid_device_id asus_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_JESS, USB_DEVICE_ID_ASUS_MD_5112) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ASUSTEK,
 		USB_DEVICE_ID_ASUSTEK_T100CHI_KEYBOARD), QUIRK_T100CHI },
-
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ITE, USB_DEVICE_ID_ITE_MEDION_E1239T),
+		QUIRK_MEDION_E1239T },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, asus_devices);
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 1c034c397e3e7..b883423a89c5d 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -650,6 +650,7 @@
 #define I2C_DEVICE_ID_ITE_LENOVO_LEGION_Y720	0x837a
 #define USB_DEVICE_ID_ITE_LENOVO_YOGA900	0x8396
 #define USB_DEVICE_ID_ITE8595		0x8595
+#define USB_DEVICE_ID_ITE_MEDION_E1239T	0xce50
 
 #define USB_VENDOR_ID_JABRA		0x0b0e
 #define USB_DEVICE_ID_JABRA_SPEAK_410	0x0412
-- 
2.39.2



