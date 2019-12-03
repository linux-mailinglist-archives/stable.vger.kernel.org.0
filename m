Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40846111F15
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbfLCWnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:43:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728203AbfLCWnh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:43:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ED3620803;
        Tue,  3 Dec 2019 22:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413015;
        bh=LSTdpTaR8hFMPic0CKoXaJCg2EX49Lkv4RNvwW08Kyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DrNnqViprd+e6vYc5D+W56fc6fyYh3sW/0OwXdS24el9h726oMVpym8SGTXbh/8mM
         7GZz/qkaObcheKlkBECH/1FTFLNlhUflOzfJJv4/pM5Jnwt3u3WPs0GwyfdksXnFRI
         /AnllyHVlNiqeGlsKXPqpLcZX7jodkJcci1PflHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio DUrso <fabiodurso@hotmail.it>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.3 103/135] USB: serial: ftdi_sio: add device IDs for U-Blox C099-F9P
Date:   Tue,  3 Dec 2019 23:35:43 +0100
Message-Id: <20191203213039.967919092@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio D'Urso <fabiodurso@hotmail.it>

commit c1a1f273d0825774c80896b8deb1c9ea1d0b91e3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    3 +++
 drivers/usb/serial/ftdi_sio_ids.h |    7 +++++++
 2 files changed, 10 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1033,6 +1033,9 @@ static const struct usb_device_id id_tab
 	/* Sienna devices */
 	{ USB_DEVICE(FTDI_VID, FTDI_SIENNA_PID) },
 	{ USB_DEVICE(ECHELON_VID, ECHELON_U20_PID) },
+	/* U-Blox devices */
+	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ZED_PID) },
+	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ODIN_PID) },
 	{ }					/* Terminating entry */
 };
 
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


