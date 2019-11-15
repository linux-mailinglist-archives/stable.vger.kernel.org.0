Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C252FDB11
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 11:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfKOKSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 05:18:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727134AbfKOKSM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 05:18:12 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DC7F20815;
        Fri, 15 Nov 2019 10:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573813092;
        bh=X4C9DDMTSpJ1jrBF0QBPaIW3I8VkL22KdLelqJ7XT28=;
        h=Subject:To:From:Date:From;
        b=ttzT0T+ozJVLJ0ir0KjnW4pjAX+HI0qdhRYAlni/B6RXQPdSqeQ9QU2MQ70+vwh56
         XThIZml8SuLLzHsL2nFLsN+j5oRMPDsIfGkgUd0tONPWHhrtUXnEUMKveUxQ2twY+u
         bEEevHJ9ybT2nQ4ldmjAaumXtblcRX3Dga/dEoVM=
Subject: patch "USB: serial: ftdi_sio: add device IDs for U-Blox C099-F9P" added to usb-testing
To:     fabiodurso@hotmail.it, johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Nov 2019 18:17:37 +0800
Message-ID: <157381305717241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: ftdi_sio: add device IDs for U-Blox C099-F9P

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From c1a1f273d0825774c80896b8deb1c9ea1d0b91e3 Mon Sep 17 00:00:00 2001
From: Fabio D'Urso <fabiodurso@hotmail.it>
Date: Thu, 14 Nov 2019 01:30:53 +0000
Subject: USB: serial: ftdi_sio: add device IDs for U-Blox C099-F9P

This device presents itself as a USB hub with three attached devices:
 - An ACM serial port connected to the GPS module (not affected by this
   commit)
 - An FTDI serial port connected to the GPS module (1546:0502)
 - Another FTDI serial port connected to the ODIN-W2 radio module
   (1546:0503)

This commit registers U-Blox's VID and the PIDs of the second and third
devices.

Datasheet: https://www.u-blox.com/sites/default/files/C099-F9P-AppBoard-Mbed-OS3-FW_UserGuide_%28UBX-18063024%29.pdf

Signed-off-by: Fabio D'Urso <fabiodurso@hotmail.it>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ftdi_sio.c     | 3 +++
 drivers/usb/serial/ftdi_sio_ids.h | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 25e81faf4c24..9ad44a96dfe3 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1033,6 +1033,9 @@ static const struct usb_device_id id_table_combined[] = {
 	/* Sienna devices */
 	{ USB_DEVICE(FTDI_VID, FTDI_SIENNA_PID) },
 	{ USB_DEVICE(ECHELON_VID, ECHELON_U20_PID) },
+	/* U-Blox devices */
+	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ZED_PID) },
+	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ODIN_PID) },
 	{ }					/* Terminating entry */
 };
 
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 22d66217cb41..e8373528264c 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1558,3 +1558,10 @@
  */
 #define UNJO_VID			0x22B7
 #define UNJO_ISODEBUG_V1_PID		0x150D
+
+/*
+ * U-Blox products (http://www.u-blox.com).
+ */
+#define UBLOX_VID			0x1546
+#define UBLOX_C099F9P_ZED_PID		0x0502
+#define UBLOX_C099F9P_ODIN_PID		0x0503
-- 
2.24.0


