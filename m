Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F113E51FF36
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 16:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236737AbiEIOO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 10:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236692AbiEIOOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 10:14:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71532B1DDA
        for <stable@vger.kernel.org>; Mon,  9 May 2022 07:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7271F615C3
        for <stable@vger.kernel.org>; Mon,  9 May 2022 14:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610CDC385A8;
        Mon,  9 May 2022 14:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652105426;
        bh=3yw6rNLbNhYyqvha9+sEX4795fd/s6C4bX34DjyatNk=;
        h=Subject:To:From:Date:From;
        b=RVpaXvgniJkmFivdsLhWh1Ye71SwvrOzCGw8wCpdAMPqV9YV+irxmuqJ7MFkIEE+n
         43uekIdkWEXrq9WkqTPvXJjIl8sYuaaMfR7NDO07IG+2H/7tPYg5kqJxpZo7+1Umcu
         FwEL8RAUPTLYoKZUw757eZ4KDM6jIveoONAvL03w=
Subject: patch "serial: pch: don't overwrite xmit->buf[0] by x_char" added to tty-next
To:     jslaby@suse.cz, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 16:09:53 +0200
Message-ID: <16521053931359@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: pch: don't overwrite xmit->buf[0] by x_char

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From d9f3af4fbb1d955bbaf872d9e76502f6e3e803cb Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Tue, 3 May 2022 10:08:03 +0200
Subject: serial: pch: don't overwrite xmit->buf[0] by x_char

When x_char is to be sent, the TX path overwrites whatever is in the
circular buffer at offset 0 with x_char and sends it using
pch_uart_hal_write(). I don't understand how this was supposed to work
if xmit->buf[0] already contained some character. It must have been
lost.

Remove this whole pop_tx_x() concept and do the work directly in the
callers. (Without printing anything using dev_dbg().)

Cc: <stable@vger.kernel.org>
Fixes: 3c6a483275f4 (Serial: EG20T: add PCH_UART driver)
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20220503080808.28332-1-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/pch_uart.c | 27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index f872613a5e83..6cb631487383 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -624,22 +624,6 @@ static int push_rx(struct eg20t_port *priv, const unsigned char *buf,
 	return 0;
 }
 
-static int pop_tx_x(struct eg20t_port *priv, unsigned char *buf)
-{
-	int ret = 0;
-	struct uart_port *port = &priv->port;
-
-	if (port->x_char) {
-		dev_dbg(priv->port.dev, "%s:X character send %02x (%lu)\n",
-			__func__, port->x_char, jiffies);
-		buf[0] = port->x_char;
-		port->x_char = 0;
-		ret = 1;
-	}
-
-	return ret;
-}
-
 static int dma_push_rx(struct eg20t_port *priv, int size)
 {
 	int room;
@@ -889,9 +873,10 @@ static unsigned int handle_tx(struct eg20t_port *priv)
 
 	fifo_size = max(priv->fifo_size, 1);
 	tx_empty = 1;
-	if (pop_tx_x(priv, xmit->buf)) {
-		pch_uart_hal_write(priv, xmit->buf, 1);
+	if (port->x_char) {
+		pch_uart_hal_write(priv, &port->x_char, 1);
 		port->icount.tx++;
+		port->x_char = 0;
 		tx_empty = 0;
 		fifo_size--;
 	}
@@ -948,9 +933,11 @@ static unsigned int dma_handle_tx(struct eg20t_port *priv)
 	}
 
 	fifo_size = max(priv->fifo_size, 1);
-	if (pop_tx_x(priv, xmit->buf)) {
-		pch_uart_hal_write(priv, xmit->buf, 1);
+
+	if (port->x_char) {
+		pch_uart_hal_write(priv, &port->x_char, 1);
 		port->icount.tx++;
+		port->x_char = 0;
 		fifo_size--;
 	}
 
-- 
2.36.1


