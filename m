Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82F4649C9A
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 11:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbiLLKnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 05:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbiLLKlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 05:41:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D038B7C8;
        Mon, 12 Dec 2022 02:36:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 168F160F91;
        Mon, 12 Dec 2022 10:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC194C433D2;
        Mon, 12 Dec 2022 10:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670841379;
        bh=i5B8jfM7mYqUw8LJhrV4rt/J/for8B42sTXA4HqjeoA=;
        h=From:To:Cc:Subject:Date:From;
        b=CGumjtmHkQQgO0LV5jUcOq9OmY2Jbyv/rvFIb/i4yM/tFKSu/WFHXVmIykznDG5KS
         hJCPUWR8CFhB9JKXbRLnYrlc3TJgZGYaIwhEDau8O294dQNROjepo3rIxHinGRZJhS
         CFMzIEK5i4V0pT1y1a5oyGS2w0rV/5CvPotoXw/hsSFzlFiboHyyl+n8/8qeuu9Jja
         ZLeJ8/dFrlG0udiG3QEGWsazrLuQptaGCLf1rxK+qv84AVJ/UokyNX7FH6tsDjgiaU
         vu5QkpR3MSxTjL6ict4abIT+NSOw8pkr9ypmumjRWiEdbRw/5HujZ/PPX+eBscZ/4Q
         FhW7nv2ra5Cqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, jikos@kernel.org,
        benjamin.tissoires@redhat.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 1/7] HID: ite: Add support for Acer S1002 keyboard-dock
Date:   Mon, 12 Dec 2022 05:36:09 -0500
Message-Id: <20221212103616.300049-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c961facb5b19634eee5bcdd91fc5bf3f1c545bc5 ]

Make the hid-ite driver handle the Acer S1002 keyboard-dock, this
leads to 2 improvements:

1. The non working wifi-toggle hotkey now works.
2. Toggling the touchpad on of with the hotkey will no show OSD
notifications in e.g. GNOME3. The actual toggling is handled inside
the keyboard, this adds support for notifying evdev listeners about this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: 9ad6645a9dce ("HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch V 10")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h |  1 +
 drivers/hid/hid-ite.c | 13 ++++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 3350a41d7dce..6ba318a49e44 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1148,6 +1148,7 @@
 #define USB_DEVICE_ID_SYNAPTICS_DELL_K12A	0x2819
 #define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012	0x2968
 #define USB_DEVICE_ID_SYNAPTICS_TP_V103	0x5710
+#define USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1002	0x73f4
 #define USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003	0x73f5
 #define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5	0x81a7
 
diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
index 742c052b0110..22bfbebceaf4 100644
--- a/drivers/hid/hid-ite.c
+++ b/drivers/hid/hid-ite.c
@@ -18,10 +18,16 @@ static __u8 *ite_report_fixup(struct hid_device *hdev, __u8 *rdesc, unsigned int
 	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
 
 	if (quirks & QUIRK_TOUCHPAD_ON_OFF_REPORT) {
+		/* For Acer Aspire Switch 10 SW5-012 keyboard-dock */
 		if (*rsize == 188 && rdesc[162] == 0x81 && rdesc[163] == 0x02) {
-			hid_info(hdev, "Fixing up ITE keyboard report descriptor\n");
+			hid_info(hdev, "Fixing up Acer Sw5-012 ITE keyboard report descriptor\n");
 			rdesc[163] = HID_MAIN_ITEM_RELATIVE;
 		}
+		/* For Acer One S1002 keyboard-dock */
+		if (*rsize == 188 && rdesc[185] == 0x81 && rdesc[186] == 0x02) {
+			hid_info(hdev, "Fixing up Acer S1002 ITE keyboard report descriptor\n");
+			rdesc[186] = HID_MAIN_ITEM_RELATIVE;
+		}
 	}
 
 	return rdesc;
@@ -101,6 +107,11 @@ static const struct hid_device_id ite_devices[] = {
 		     USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012),
 	  .driver_data = QUIRK_TOUCHPAD_ON_OFF_REPORT },
 	/* ITE8910 USB kbd ctlr, with Synaptics touchpad connected to it. */
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_SYNAPTICS,
+		     USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1002),
+	  .driver_data = QUIRK_TOUCHPAD_ON_OFF_REPORT },
+	/* ITE8910 USB kbd ctlr, with Synaptics touchpad connected to it. */
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_SYNAPTICS,
 		     USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003) },
-- 
2.35.1

