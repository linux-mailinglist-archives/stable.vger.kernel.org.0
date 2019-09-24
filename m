Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9B53BD272
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 21:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392221AbfIXTN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 15:13:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39966 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390196AbfIXTNZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 15:13:25 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 67D00301A638;
        Tue, 24 Sep 2019 19:13:25 +0000 (UTC)
Received: from builder (ovpn-121-117.rdu2.redhat.com [10.10.121.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E758F60E1C;
        Tue, 24 Sep 2019 19:13:22 +0000 (UTC)
Received: from builder.jcline.org.com (localhost [IPv6:::1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by builder (Postfix) with ESMTPS id D60F06E78C0;
        Tue, 24 Sep 2019 19:13:21 +0000 (UTC)
From:   Jeremy Cline <jcline@redhat.com>
To:     stable@vger.kernel.org
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        =?UTF-8?q?Filipe=20La=C3=ADns?= <lains@archlinux.org>,
        Jeremy Cline <jcline@redhat.com>
Subject: [PATCH] Partially revert "HID: logitech-hidpp: add USB PID for a few more supported mice"
Date:   Tue, 24 Sep 2019 19:13:11 +0000
Message-Id: <20190924191311.22413-1-jcline@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 24 Sep 2019 19:13:25 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit addf3382c47c033e579c9c88f18e36c4e75d806a upstream.

This partially reverts commit 27fc32fd9417968a459d43d9a7c50fd423d53eb9.

It turns out that the G502 has some issues with hid-logitech-hidpp:
when plugging it in, the driver tries to contact it but it fails.
So the driver bails out leaving only the mouse event node available.

This timeout is problematic as it introduce a delay in the boot,
and having only the mouse event node means that the hardware
macros keys can not be relayed to the userspace.

Filipe and I just gave a shot at the following devices:

G403 Wireless (0xC082)
G703 (0xC087)
G703 Hero (0xC090)
G903 (0xC086)
G903 Hero (0xC091)
G Pro (0xC088)

Reverting the devices we are not sure that works flawlessly.

Reviewed-by: Filipe Laíns <lains@archlinux.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jeremy Cline <jcline@redhat.com>
---

For the v5.2 stable kernels. v5.2.11 picked up upstream commit
27fc32fd9417 ("HID: logitech-hidpp: add USB PID for a few more supported
mice") and v5.2.12 picked up commit a3384b8d9f63cc0 ("HID:
logitech-hidpp: remove support for the G700 over USB") with some
conflicts because this patch wasn't picked up. This backport resolves
the conflicts against v5.2.17.

 drivers/hid/hid-logitech-hidpp.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 4effce12607b..424d0f775ffa 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -3749,28 +3749,8 @@ static const struct hid_device_id hidpp_devices[] = {
 
 	{ L27MHZ_DEVICE(HID_ANY_ID) },
 
-	{ /* Logitech G203/Prodigy Gaming Mouse */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC084) },
-	{ /* Logitech G302 Gaming Mouse */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC07F) },
-	{ /* Logitech G303 Gaming Mouse */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC080) },
-	{ /* Logitech G400 Gaming Mouse */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC07E) },
 	{ /* Logitech G403 Wireless Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC082) },
-	{ /* Logitech G403 Gaming Mouse */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC083) },
-	{ /* Logitech G403 Hero Gaming Mouse over USB */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC08F) },
-	{ /* Logitech G502 Proteus Core Gaming Mouse */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC07D) },
-	{ /* Logitech G502 Proteus Spectrum Gaming Mouse over USB */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC332) },
-	{ /* Logitech G502 Hero Gaming Mouse over USB */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC08B) },
-	{ /* Logitech G700s Gaming Mouse over USB */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC07C) },
 	{ /* Logitech G703 Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC087) },
 	{ /* Logitech G703 Hero Gaming Mouse over USB */
-- 
2.21.0

