Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE65432AF21
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbhCCAPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:15:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:40282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244692AbhCBMDm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:03:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE17F64F26;
        Tue,  2 Mar 2021 11:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686165;
        bh=9yFRSrn0ZtCh8KKSuDANwymqtWmlkM7Vgl4mWGkhQb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMJrfAjZWEex/fo6zqREMwPhy96pbvM9l0eIdBIfZyA3iS6B0YlImf3uP0JhK6SrL
         Ru+083ZtGFQ5IKGpl9+KYs2+jrFyiyA7sy3Y8OBHKhzyeuoIVISDef3TvffghFk4Ys
         KQJHb3/Vau7Oj/LejlaOUz7bzFHbjYo77bsQibHtfK1/9uFFJvfuD5VtRb/5+F3VaI
         tnIW3SAbUFC77BDY3WKjBzmmy+GWogESGdHwF+5ZT2wVbfQnzCT1jABVoE0pidoOg2
         zYfbFR48WQnjCiIe4UYNa0PdoBlXrkvrZzaGkXTaidrDCL9FplfE6vQIwPfg45zmEv
         GybYZ0hkyIOww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 23/52] HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch 10E
Date:   Tue,  2 Mar 2021 06:55:04 -0500
Message-Id: <20210302115534.61800-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
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
2.30.1

