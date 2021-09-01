Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A383FDB77
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343698AbhIAMlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344880AbhIAMkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5972D610C7;
        Wed,  1 Sep 2021 12:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499763;
        bh=YK+KW2Idzy+P/U+2hCDCl1WtB/7YnE2uT8Nb41k7wk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1/Sk3EbTLC2ZZZrYWDUmCPhLyajsVWkie3YM4Lu5ZNVAEs2Q6s+yKQLqoKWWacgz
         nhnxcN6zGTKpKeGHKEiQ1SyOLfhzV8NNHV4Yq/KoH1LPTiUjDzQuuNdaOqxBDImaaH
         LFWUSQJsEbuaV0x2I4IkqryO8mphUaG3GohdZHD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pauli Virtanen <pav@iki.fi>,
        =?UTF-8?q?Micha=C5=82=20K=C4=99pie=C5=84?= <kernel@kempniu.pl>,
        =?UTF-8?q?Jonathan=20Lamp=C3=A9rth?= <jon@h4n.dev>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 077/103] Bluetooth: btusb: check conditions before enabling USB ALT 3 for WBS
Date:   Wed,  1 Sep 2021 14:28:27 +0200
Message-Id: <20210901122303.149455672@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pauli Virtanen <pav@iki.fi>

commit 55981d3541812234e687062926ff199c83f79a39 upstream.

Some USB BT adapters don't satisfy the MTU requirement mentioned in
commit e848dbd364ac ("Bluetooth: btusb: Add support USB ALT 3 for WBS")
and have ALT 3 setting that produces no/garbled audio. Some adapters
with larger MTU were also reported to have problems with ALT 3.

Add a flag and check it and MTU before selecting ALT 3, falling back to
ALT 1. Enable the flag for Realtek, restoring the previous behavior for
non-Realtek devices.

Tested with USB adapters (mtu<72, no/garbled sound with ALT3, ALT1
works) BCM20702A1 0b05:17cb, CSR8510A10 0a12:0001, and (mtu>=72, ALT3
works) RTL8761BU 0bda:8771, Intel AX200 8087:0029 (after disabling
ALT6). Also got reports for (mtu>=72, ALT 3 reported to produce bad
audio) Intel 8087:0a2b.

Signed-off-by: Pauli Virtanen <pav@iki.fi>
Fixes: e848dbd364ac ("Bluetooth: btusb: Add support USB ALT 3 for WBS")
Tested-by: Michał Kępień <kernel@kempniu.pl>
Tested-by: Jonathan Lampérth <jon@h4n.dev>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -486,6 +486,7 @@ static const struct dmi_system_id btusb_
 #define BTUSB_HW_RESET_ACTIVE	12
 #define BTUSB_TX_WAIT_VND_EVT	13
 #define BTUSB_WAKEUP_DISABLE	14
+#define BTUSB_USE_ALT3_FOR_WBS	15
 
 struct btusb_data {
 	struct hci_dev       *hdev;
@@ -1718,16 +1719,20 @@ static void btusb_work(struct work_struc
 			/* Bluetooth USB spec recommends alt 6 (63 bytes), but
 			 * many adapters do not support it.  Alt 1 appears to
 			 * work for all adapters that do not have alt 6, and
-			 * which work with WBS at all.
+			 * which work with WBS at all.  Some devices prefer
+			 * alt 3 (HCI payload >= 60 Bytes let air packet
+			 * data satisfy 60 bytes), requiring
+			 * MTU >= 3 (packets) * 25 (size) - 3 (headers) = 72
+			 * see also Core spec 5, vol 4, B 2.1.1 & Table 2.1.
 			 */
-			new_alts = btusb_find_altsetting(data, 6) ? 6 : 1;
-			/* Because mSBC frames do not need to be aligned to the
-			 * SCO packet boundary. If support the Alt 3, use the
-			 * Alt 3 for HCI payload >= 60 Bytes let air packet
-			 * data satisfy 60 bytes.
-			 */
-			if (new_alts == 1 && btusb_find_altsetting(data, 3))
+			if (btusb_find_altsetting(data, 6))
+				new_alts = 6;
+			else if (btusb_find_altsetting(data, 3) &&
+				 hdev->sco_mtu >= 72 &&
+				 test_bit(BTUSB_USE_ALT3_FOR_WBS, &data->flags))
 				new_alts = 3;
+			else
+				new_alts = 1;
 		}
 
 		if (btusb_switch_alt_setting(hdev, new_alts) < 0)
@@ -4170,6 +4175,7 @@ static int btusb_probe(struct usb_interf
 		 * (DEVICE_REMOTE_WAKEUP)
 		 */
 		set_bit(BTUSB_WAKEUP_DISABLE, &data->flags);
+		set_bit(BTUSB_USE_ALT3_FOR_WBS, &data->flags);
 	}
 
 	if (!reset)


