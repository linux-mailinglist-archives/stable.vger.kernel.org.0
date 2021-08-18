Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEF73F0E8A
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 01:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbhHRXKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 19:10:37 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54590 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231976AbhHRXKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 19:10:36 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Aug 2021 19:10:36 EDT
From:   Mike <mpagano@gentoo.org>
To:     stable@vger.kernel.org
Cc:     pav@iki.fi
Subject: Bluetooth: btusb: check conditions before enabling USB ALT 3 for WBS
Message-ID: <a680e819-74da-0c40-9812-9f4e748dc20b@gentoo.org>
Date:   Wed, 18 Aug 2021 19:04:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pauli Virtanen <pav@iki.fi>
Kernel Version 5.13

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
---
drivers/bluetooth/btusb.c | 22 ++++++++++++++--------
1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 488f110e17e27..2336f731dbc7e 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -528,6 +528,7 @@ static const struct dmi_system_id btusb_needs_reset_resume_table[] = {
#define BTUSB_HW_RESET_ACTIVE 12
#define BTUSB_TX_WAIT_VND_EVT 13
#define BTUSB_WAKEUP_DISABLE 14
+#define BTUSB_USE_ALT3_FOR_WBS 15

struct btusb_data {
struct hci_dev *hdev;
@@ -1761,16 +1762,20 @@ static void btusb_work(struct work_struct *work)
/* Bluetooth USB spec recommends alt 6 (63 bytes), but
* many adapters do not support it. Alt 1 appears to
* work for all adapters that do not have alt 6, and
- * which work with WBS at all.
+ * which work with WBS at all. Some devices prefer
+ * alt 3 (HCI payload >= 60 Bytes let air packet
+ * data satisfy 60 bytes), requiring
+ * MTU >= 3 (packets) * 25 (size) - 3 (headers) = 72
+ * see also Core spec 5, vol 4, B 2.1.1 & Table 2.1.
*/
- new_alts = btusb_find_altsetting(data, 6) ? 6 : 1;
- /* Because mSBC frames do not need to be aligned to the
- * SCO packet boundary. If support the Alt 3, use the
- * Alt 3 for HCI payload >= 60 Bytes let air packet
- * data satisfy 60 bytes.
- */
- if (new_alts == 1 && btusb_find_altsetting(data, 3))
+ if (btusb_find_altsetting(data, 6))
+ new_alts = 6;
+ else if (btusb_find_altsetting(data, 3) &&
+ hdev->sco_mtu >= 72 &&
+ test_bit(BTUSB_USE_ALT3_FOR_WBS, &data->flags))
new_alts = 3;
+ else
+ new_alts = 1;
}

if (btusb_switch_alt_setting(hdev, new_alts) < 0)
@@ -3882,6 +3887,7 @@ static int btusb_probe(struct usb_interface *intf,
* (DEVICE_REMOTE_WAKEUP)
*/
set_bit(BTUSB_WAKEUP_DISABLE, &data->flags);
+ set_bit(BTUSB_USE_ALT3_FOR_WBS, &data->flags);
}

if (!reset)
-- 
cgit 1.2.3-1.el7



