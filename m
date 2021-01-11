Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465962F166D
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730830AbhAKNwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:52:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:56364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730699AbhAKNJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:09:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0F1122ADF;
        Mon, 11 Jan 2021 13:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370505;
        bh=TOJcZvjnJZQGS+cQbsthieBdACSYNWvv/ibbBiaOXuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQ9Q0fhj5GIy6Gk7xbgk0Zj8stxmzHes+r3QQWwysOdyMZ8IsiuwxEpNmVbuCWqEC
         mX/SWsRJXrt2EarxuhtQjHWbuZwc0hogIh9E6KhFwaDCF7Ghr0z/hxs7802Ne8RAdN
         KIeZ7hvTh39tyofPLzx+NkYraIH4sjIix56himo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 51/77] USB: serial: iuu_phoenix: fix DMA from stack
Date:   Mon, 11 Jan 2021 14:02:00 +0100
Message-Id: <20210111130038.874137327@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 54d0a3ab80f49f19ee916def62fe067596833403 upstream.

Stack-allocated buffers cannot be used for DMA (on all architectures) so
allocate the flush command buffer using kmalloc().

Fixes: 60a8fc017103 ("USB: add iuu_phoenix driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.25
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/iuu_phoenix.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -536,23 +536,29 @@ static int iuu_uart_flush(struct usb_ser
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
@@ -560,12 +566,16 @@ static int iuu_uart_flush(struct usb_ser
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
 


