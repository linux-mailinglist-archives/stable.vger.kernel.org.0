Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20CCF65133F
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbiLST3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbiLST21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:28:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06D9CF4
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:28:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23F7761133
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B9CC433EF;
        Mon, 19 Dec 2022 19:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671478105;
        bh=iJ7rxC4CUAQQBLlxZgaDUUjCB7SyCLIq7baOx8xB0IM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gb5WtSjdEpW8azbwxPCl0/Yu7CI85UX38IAm1F5afXgrY89RdnIYeCxi0aUqSA8u7
         UJeMXFBSkoms2pp3rgiXCyP10VVJWs+1w7SSKCt0nDg6Lrg+bBQ62oluAbqeDfOn/Z
         vw05j0nOdk1yMGy7WvmYu/tZZVZ3siYu/xnC2/Zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/18] HID: ite: Add support for Acer S1002 keyboard-dock
Date:   Mon, 19 Dec 2022 20:25:06 +0100
Message-Id: <20221219182941.100788902@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182940.701087296@linuxfoundation.org>
References: <20221219182940.701087296@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 70a693f8f034..7fc6b204c399 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1150,6 +1150,7 @@
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



