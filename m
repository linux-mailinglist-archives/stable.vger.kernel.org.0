Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27D3292C3F
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 19:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbgJSRDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 13:03:39 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:32870 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730911AbgJSRCp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 13:02:45 -0400
Date:   Mon, 19 Oct 2020 17:02:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603126964;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=NLYA7x8rNUp2NIhnLBpUVlWTRkGxI0xw9WxzR9oWLlw=;
        b=iVxCTAmFCfWpvgCGMf6UxqZ25Ygm4h3A8h4V5gCBWdAXu86D0X/ImJm6n12XOFCjm4T7EC
        m+RH7LgJak2t6g5sFAfp7k+4qgKS+tpTGQMYB1wRRcTjM91+NMXIoNAMPyBOpVMQcrAnT2
        uBaY8OTAfeGcZiLwmCW56wJzjIL8Dfjcl9do6u1NoAups+3IHZVlcovaHxN1sg7R/OV1oQ
        0SPncUo8123Xzo/Ojhsqxrawr2RLizTDnf+8zqHbpYowDdeak9RcOipbOzrHK62TmQSiCg
        GeI91HwcuD7DNesQj1s7jgcspvHVpsjRjoNVmUv54xYdXretz9bNYJtL4M5ZKQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603126964;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=NLYA7x8rNUp2NIhnLBpUVlWTRkGxI0xw9WxzR9oWLlw=;
        b=rQNcYPjImkF0t+ATEwSst3iR2OEktWu7LzRyhPglVPkrFwTFSFX9M9G4dAQfE8opf1bHks
        anwsIz0I+ezY9HCA==
From:   "tip-bot2 for Mychaela N. Falconia" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] USB: serial: ftdi_sio: add support for FreeCalypso
 JTAG+UART adapters
Cc:     "Mychaela N. Falconia" <falcon@freecalypso.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <160312696333.7002.7451593653017604833.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     a71ec88ae6a61ac69854b4ef60c0c7920b225e31
Gitweb:        https://git.kernel.org/tip/a71ec88ae6a61ac69854b4ef60c0c7920b225e31
Author:        Mychaela N. Falconia <falcon@freecalypso.org>
AuthorDate:    Wed, 16 Sep 2020 01:56:29 
Committer:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CommitterDate: Sat, 17 Oct 2020 08:31:22 +02:00

USB: serial: ftdi_sio: add support for FreeCalypso JTAG+UART adapters

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
 drivers/usb/serial/ftdi_sio.c     | 5 +++++
 drivers/usb/serial/ftdi_sio_ids.h | 7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 9823bb4..8d89a16 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1037,6 +1037,11 @@ static const struct usb_device_id id_table_combined[] = {
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
 
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index b5ca17a..3d47c6d 100644
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
 
