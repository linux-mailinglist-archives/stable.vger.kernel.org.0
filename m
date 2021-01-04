Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74452E97A7
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 15:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbhADOvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 09:51:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbhADOvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 09:51:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B2E207BC;
        Mon,  4 Jan 2021 14:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609771820;
        bh=ea0BSOIo3CcIaAqXFaqVnRfchTxse6NY+3N3MboDOXA=;
        h=From:To:Cc:Subject:Date:From;
        b=IVc8H97gqE5VQ70EaVOLGVq3dJFBIcom/Vp9NUcb6NHUQn4dTMbqX2BiuoybE9+eI
         DuYsXtTu0KNVah9Xd1piJawAZRJmiTyc7H3abz/4GTx6tb370EVZxWhkDhzc0Tphv2
         u7X4h4zkqS6/P3gXVMu4/FMPG0e6N2iM1jCz8wLcv8saz2cOvtzOI+hYflkKL/AZS7
         30u1XZOaXUrAOamLJ8MMfB0g97LgguXqxtFyTRGX1L3QZc7EqMcef2JgEHRyHxNRVM
         Vrf9286ALZYKoYlZt5p2Ab08y9iH0ER4XhfLa8aBAkHo1LHMNX38/0nK3wGu+F5xBe
         WFE3FsR8VVRbQ==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kwRBa-0007Js-8t; Mon, 04 Jan 2021 15:50:18 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] USB: serial: iuu_phoenix: fix DMA from stack
Date:   Mon,  4 Jan 2021 15:50:07 +0100
Message-Id: <20210104145007.28093-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stack-allocated buffers cannot be used for DMA (on all architectures) so
allocate the flush command buffer using kmalloc().

Fixes: 60a8fc017103 ("USB: add iuu_phoenix driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.25
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
2.26.2

