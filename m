Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429AA517F6E
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 10:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbiECILr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 04:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbiECILm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 04:11:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE86020F5A;
        Tue,  3 May 2022 01:08:10 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id AA8B71F38D;
        Tue,  3 May 2022 08:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1651565289; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oST/6quGVTIG/7AvfcWNH38FZA1053Lg8E80M28hIlc=;
        b=H4xE8wA5fckN+Z4Je/Ts5TWK5x0Uz8u2ZtsbUjkdnIsdPTEoS2rb3XyqaaQ3NNMm0seFjs
        gFvLO+ko5yV89qhlCKe67iXUq0vHg/YEwpBbT1K4XfHawI0K4i3evBT0pAxNz79rwkQbh3
        rooj+gisWI4p5shVnL5+zdtT4QEQeog=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1651565289;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oST/6quGVTIG/7AvfcWNH38FZA1053Lg8E80M28hIlc=;
        b=OUh3Dw3uztirtLxjjR2TiRQy1JFxB/x5riKuW6coGs3afgkOccgukgFNpjPpuafpPW95gC
        2g9TmBdAHY777MAQ==
Received: from localhost.localdomain (unknown [10.100.208.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 79BF72C142;
        Tue,  3 May 2022 08:08:09 +0000 (UTC)
From:   Jiri Slaby <jslaby@suse.cz>
To:     gregkh@linuxfoundation.org
Cc:     linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 2/7] serial: pch: don't overwrite xmit->buf[0] by x_char
Date:   Tue,  3 May 2022 10:08:03 +0200
Message-Id: <20220503080808.28332-1-jslaby@suse.cz>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220503080613.27601-1-jslaby@suse.cz>
References: <20220503080613.27601-1-jslaby@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
2.36.0

