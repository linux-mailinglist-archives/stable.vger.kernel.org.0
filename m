Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00303651340
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiLST3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbiLST2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:28:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BDD13CE5
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:28:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE2DEB80EF6
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:28:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302F1C433F0;
        Mon, 19 Dec 2022 19:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671478108;
        bh=FNDevMvDQYjJvIM61DJo57BWb/uarRZE4PxJGOZCs6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i24E1AJiyHBIGunGPn2aS8MDlsYsBZgAqrrqZhEjpuaHctdLxcA/YDXOFJ3tqJb0k
         ffCBhX/P+Tu17d4w0W9OhOaC/TK3YytZvimcnt4B6sOVHhzi5OaGpps35xYDez2HjI
         tWBx8BfkWu2il92tKd+WNm62uNK+qnTxtGa+nTf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/18] HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch 10E
Date:   Mon, 19 Dec 2022 20:25:07 +0100
Message-Id: <20221219182941.130887915@linuxfoundation.org>
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

[ Upstream commit b7c20f3815985570ac71c39b1a3e68c201109578 ]

The Acer Aspire Switch 10E (SW3-016)'s keyboard-dock uses the same USB-ids
as the Acer One S1003 keyboard-dock. Yet they are not entirely the same:

1. The S1003 keyboard-dock has the same report descriptors as the
S1002 keyboard-dock (which has different USB-ids)

2. The Acer Aspire Switch 10E's keyboard-dock has different
report descriptors from the S1002/S1003 keyboard docks and it
sends 0x00880078 / 0x00880079 usage events when the touchpad is
toggled on/off (which is handled internally).

This means that all Acer kbd-docks handled by the hid-ite.c drivers
report their touchpad being toggled on/off through these custom
usage-codes with the exception of the S1003 dock, which likely is
a bug of that dock.

Add a QUIRK_TOUCHPAD_ON_OFF_REPORT quirk for the Aspire Switch 10E / S1003
usb-id so that the touchpad toggling will get reported to userspace on
the Aspire Switch 10E.

Since the Aspire Switch 10E's kbd-dock has different report-descriptors,
this also requires adding support for fixing those to ite_report_fixup().

Setting the quirk will also cause ite_report_fixup() to hit the
S1002/S1003 descriptors path on the S1003. Since the S1003 kbd-dock
never generates any input-reports for the fixed up part of the
descriptors this does not matter; and if there are versions out there
which do actually send input-reports for the touchpad-toggle then the
fixup should actually help to make things work.

This was tested on both an Acer Aspire Switch 10E and on an Acer One S1003.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: 9ad6645a9dce ("HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch V 10")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ite.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
index 22bfbebceaf4..14fc068affad 100644
--- a/drivers/hid/hid-ite.c
+++ b/drivers/hid/hid-ite.c
@@ -23,11 +23,16 @@ static __u8 *ite_report_fixup(struct hid_device *hdev, __u8 *rdesc, unsigned int
 			hid_info(hdev, "Fixing up Acer Sw5-012 ITE keyboard report descriptor\n");
 			rdesc[163] = HID_MAIN_ITEM_RELATIVE;
 		}
-		/* For Acer One S1002 keyboard-dock */
+		/* For Acer One S1002/S1003 keyboard-dock */
 		if (*rsize == 188 && rdesc[185] == 0x81 && rdesc[186] == 0x02) {
-			hid_info(hdev, "Fixing up Acer S1002 ITE keyboard report descriptor\n");
+			hid_info(hdev, "Fixing up Acer S1002/S1003 ITE keyboard report descriptor\n");
 			rdesc[186] = HID_MAIN_ITEM_RELATIVE;
 		}
+		/* For Acer Aspire Switch 10E (SW3-016) keyboard-dock */
+		if (*rsize == 210 && rdesc[184] == 0x81 && rdesc[185] == 0x02) {
+			hid_info(hdev, "Fixing up Acer Aspire Switch 10E (SW3-016) ITE keyboard report descriptor\n");
+			rdesc[185] = HID_MAIN_ITEM_RELATIVE;
+		}
 	}
 
 	return rdesc;
@@ -114,7 +119,8 @@ static const struct hid_device_id ite_devices[] = {
 	/* ITE8910 USB kbd ctlr, with Synaptics touchpad connected to it. */
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_SYNAPTICS,
-		     USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003) },
+		     USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003),
+	  .driver_data = QUIRK_TOUCHPAD_ON_OFF_REPORT },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ite_devices);
-- 
2.35.1



