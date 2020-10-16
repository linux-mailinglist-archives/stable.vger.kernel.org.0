Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BCA290181
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406131AbgJPJPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:15:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394747AbgJPJJQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:09:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 007E0218AC;
        Fri, 16 Oct 2020 09:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839338;
        bh=5UdppMz/DH5yVLE6cGd9AeTzfxWdz0PQeRYlkXJIol0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXeQJLYVCw3N210H3AkyjseZ8spH4GJaOYox3GhPeRzBGrOXFhniRsxyew+DLhiva
         A8qICqX41f9MK/5DRaMdn5ZLiEkB7XEGIeadNxiEOF9f3z2bYCp+6ijDpA76D/lO/B
         z9J1bmxn1eLJeUxwRprcK2W4qQb1GWG4u35ONnAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Mychaela N. Falconia" <falcon@freecalypso.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 13/18] USB: serial: ftdi_sio: add support for FreeCalypso JTAG+UART adapters
Date:   Fri, 16 Oct 2020 11:07:23 +0200
Message-Id: <20201016090437.939246342@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.265805669@linuxfoundation.org>
References: <20201016090437.265805669@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mychaela N. Falconia <falcon@freecalypso.org>

commit 6cf87e5edd9944e1d3b6efd966ea401effc304ee upstream.

There exist many FT2232-based JTAG+UART adapter designs in which
FT2232 Channel A is used for JTAG and Channel B is used for UART.
The best way to handle them in Linux is to have the ftdi_sio driver
create a ttyUSB device only for Channel B and not for Channel A:
a ttyUSB device for Channel A would be bogus and will disappear as
soon as the user runs OpenOCD or other applications that access
Channel A for JTAG from userspace, causing undesirable noise for
users.  The ftdi_sio driver already has a dedicated quirk for such
JTAG+UART FT2232 adapters, and it requires assigning custom USB IDs
to such adapters and adding these IDs to the driver with the
ftdi_jtag_quirk applied.

Boutique hardware manufacturer Falconia Partners LLC has created a
couple of JTAG+UART adapter designs (one buffered, one unbuffered)
as part of FreeCalypso project, and this hardware is specifically made
to be used with Linux hosts, with the intent that Channel A will be
accessed only from userspace via appropriate applications, and that
Channel B will be supported by the ftdi_sio kernel driver, presenting
a standard ttyUSB device to userspace.  Toward this end the hardware
manufacturer will be programming FT2232 EEPROMs with custom USB IDs,
specifically with the intent that these IDs will be recognized by
the ftdi_sio driver with the ftdi_jtag_quirk applied.

Signed-off-by: Mychaela N. Falconia <falcon@freecalypso.org>
[johan: insert in PID order and drop unused define]
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    5 +++++
 drivers/usb/serial/ftdi_sio_ids.h |    7 +++++++
 2 files changed, 12 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1032,6 +1032,11 @@ static const struct usb_device_id id_tab
 	/* U-Blox devices */
 	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ZED_PID) },
 	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ODIN_PID) },
+	/* FreeCalypso USB adapters */
+	{ USB_DEVICE(FTDI_VID, FTDI_FALCONIA_JTAG_BUF_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(FTDI_VID, FTDI_FALCONIA_JTAG_UNBUF_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -39,6 +39,13 @@
 
 #define FTDI_LUMEL_PD12_PID	0x6002
 
+/*
+ * Custom USB adapters made by Falconia Partners LLC
+ * for FreeCalypso project, ID codes allocated to Falconia by FTDI.
+ */
+#define FTDI_FALCONIA_JTAG_BUF_PID	0x7150
+#define FTDI_FALCONIA_JTAG_UNBUF_PID	0x7151
+
 /* Sienna Serial Interface by Secyourit GmbH */
 #define FTDI_SIENNA_PID		0x8348
 


