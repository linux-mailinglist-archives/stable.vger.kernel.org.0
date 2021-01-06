Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C702EC2C6
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 18:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbhAFRxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 12:53:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727431AbhAFRxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 12:53:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C86CE2311B;
        Wed,  6 Jan 2021 17:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609955553;
        bh=CVWXk8jkRNyKZIZRoKouPV2MSA1U3+VGZrEQ8x6hIx4=;
        h=Subject:To:From:Date:From;
        b=ZDpsUZbU724FPLRa5fovvcDmvwwZq2OCQU+4utKMtw8dxS/lWNEHrZUYHUBU8OSxz
         w8HHIqYPlgZeaAdkoTAtiUOt6rolEpAVsp4A+tPLm7ynxN9dxN79P2qKdHVvpAyVhd
         xOtXU+F/onkzVkSBqqJbwQBhHXw5U54IfbP7qDyw=
Subject: patch "USB: serial: iuu_phoenix: fix DMA from stack" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 06 Jan 2021 18:53:45 +0100
Message-ID: <160995562511951@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: iuu_phoenix: fix DMA from stack

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 54d0a3ab80f49f19ee916def62fe067596833403 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 4 Jan 2021 15:50:07 +0100
Subject: USB: serial: iuu_phoenix: fix DMA from stack

Stack-allocated buffers cannot be used for DMA (on all architectures) so
allocate the flush command buffer using kmalloc().

Fixes: 60a8fc017103 ("USB: add iuu_phoenix driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.25
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/iuu_phoenix.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index f1201d4de297..e8f06b41a503 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -532,23 +532,29 @@ static int iuu_uart_flush(struct usb_serial_port *port)
 	struct device *dev = &port->dev;
 	int i;
 	int status;
-	u8 rxcmd = IUU_UART_RX;
+	u8 *rxcmd;
 	struct iuu_private *priv = usb_get_serial_port_data(port);
 
 	if (iuu_led(port, 0xF000, 0, 0, 0xFF) < 0)
 		return -EIO;
 
+	rxcmd = kmalloc(1, GFP_KERNEL);
+	if (!rxcmd)
+		return -ENOMEM;
+
+	rxcmd[0] = IUU_UART_RX;
+
 	for (i = 0; i < 2; i++) {
-		status = bulk_immediate(port, &rxcmd, 1);
+		status = bulk_immediate(port, rxcmd, 1);
 		if (status != IUU_OPERATION_OK) {
 			dev_dbg(dev, "%s - uart_flush_write error\n", __func__);
-			return status;
+			goto out_free;
 		}
 
 		status = read_immediate(port, &priv->len, 1);
 		if (status != IUU_OPERATION_OK) {
 			dev_dbg(dev, "%s - uart_flush_read error\n", __func__);
-			return status;
+			goto out_free;
 		}
 
 		if (priv->len > 0) {
@@ -556,12 +562,16 @@ static int iuu_uart_flush(struct usb_serial_port *port)
 			status = read_immediate(port, priv->buf, priv->len);
 			if (status != IUU_OPERATION_OK) {
 				dev_dbg(dev, "%s - uart_flush_read error\n", __func__);
-				return status;
+				goto out_free;
 			}
 		}
 	}
 	dev_dbg(dev, "%s - uart_flush_read OK!\n", __func__);
 	iuu_led(port, 0, 0xF000, 0, 0xFF);
+
+out_free:
+	kfree(rxcmd);
+
 	return status;
 }
 
-- 
2.30.0


