Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F933231941
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 07:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgG2F5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 01:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbgG2F5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jul 2020 01:57:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 210CB20786;
        Wed, 29 Jul 2020 05:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596002241;
        bh=D5a/2ySxZEAGosEtNMpbk6TfJU5CqjREMi/g6t6wkmw=;
        h=Subject:To:From:Date:From;
        b=KHxgw9nYfc9U3xWqcwFNguZm39rXo9hWic5kyfBNAD//apkFy2LW+jRJqueGLFoTe
         4EisORdmwL7ZJ8ykVfLr/WO7TPtxEmi7ttTNs9aXDhDfMeY+trjgl2bJROmyjlxcCN
         2uqqNReku/Jh8gX7emGjgZM/XRQ1TsFVeqCrAZPc=
Subject: patch "USB: serial: cp210x: re-enable auto-RTS on open" added to usb-next
To:     brant.merryman@silabs.com, johan@kernel.org, phu.luu@silabs.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 29 Jul 2020 07:56:51 +0200
Message-ID: <1596002211204214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: cp210x: re-enable auto-RTS on open

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From c7614ff9b73a1e6fb2b1b51396da132ed22fecdb Mon Sep 17 00:00:00 2001
From: Brant Merryman <brant.merryman@silabs.com>
Date: Fri, 26 Jun 2020 04:24:20 +0000
Subject: USB: serial: cp210x: re-enable auto-RTS on open

CP210x hardware disables auto-RTS but leaves auto-CTS when in hardware
flow control mode and UART on cp210x hardware is disabled. When
re-opening the port, if auto-CTS is enabled on the cp210x, then auto-RTS
must be re-enabled in the driver.

Signed-off-by: Brant Merryman <brant.merryman@silabs.com>
Co-developed-by: Phu Luu <phu.luu@silabs.com>
Signed-off-by: Phu Luu <phu.luu@silabs.com>
Link: https://lore.kernel.org/r/ECCF8E73-91F3-4080-BE17-1714BC8818FB@silabs.com
[ johan: fix up tags and problem description ]
Fixes: 39a66b8d22a3 ("[PATCH] USB: CP2101 Add support for flow control")
Cc: stable <stable@vger.kernel.org>     # 2.6.12
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/cp210x.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index bcceb4ad8be0..a90801ef0055 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -917,6 +917,7 @@ static void cp210x_get_termios_port(struct usb_serial_port *port,
 	u32 baud;
 	u16 bits;
 	u32 ctl_hs;
+	u32 flow_repl;
 
 	cp210x_read_u32_reg(port, CP210X_GET_BAUDRATE, &baud);
 
@@ -1017,6 +1018,22 @@ static void cp210x_get_termios_port(struct usb_serial_port *port,
 	ctl_hs = le32_to_cpu(flow_ctl.ulControlHandshake);
 	if (ctl_hs & CP210X_SERIAL_CTS_HANDSHAKE) {
 		dev_dbg(dev, "%s - flow control = CRTSCTS\n", __func__);
+		/*
+		 * When the port is closed, the CP210x hardware disables
+		 * auto-RTS and RTS is deasserted but it leaves auto-CTS when
+		 * in hardware flow control mode. When re-opening the port, if
+		 * auto-CTS is enabled on the cp210x, then auto-RTS must be
+		 * re-enabled in the driver.
+		 */
+		flow_repl = le32_to_cpu(flow_ctl.ulFlowReplace);
+		flow_repl &= ~CP210X_SERIAL_RTS_MASK;
+		flow_repl |= CP210X_SERIAL_RTS_SHIFT(CP210X_SERIAL_RTS_FLOW_CTL);
+		flow_ctl.ulFlowReplace = cpu_to_le32(flow_repl);
+		cp210x_write_reg_block(port,
+				CP210X_SET_FLOW,
+				&flow_ctl,
+				sizeof(flow_ctl));
+
 		cflag |= CRTSCTS;
 	} else {
 		dev_dbg(dev, "%s - flow control = NONE\n", __func__);
-- 
2.27.0


