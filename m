Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5AB541EA9
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353740AbiFGWcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384755AbiFGWbM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:31:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E79527850D;
        Tue,  7 Jun 2022 12:24:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76ADBB823CA;
        Tue,  7 Jun 2022 19:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96A1C385A2;
        Tue,  7 Jun 2022 19:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629863;
        bh=/nt2azIDU63waHlYWHq5Z5MohAVPxSo0yJVmg3AdC48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wd5FZwfPbNWtO5tuZr+YbNztPwtFB41T8SVMCxqZfciK+hHWcuQ3ic0UP9SwOTBGM
         SKeCHVJKJ3H7wYQ666Srx6rc2JsQZrwnXk0OyXzA9Qbr6iQVPl0Sy45DK+VofpTWjz
         YPJKxotda+72OwcosKvxWOgmumAx4dqhjyA0tTEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 5.18 843/879] serial: pch: dont overwrite xmit->buf[0] by x_char
Date:   Tue,  7 Jun 2022 19:06:01 +0200
Message-Id: <20220607165027.320975559@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit d9f3af4fbb1d955bbaf872d9e76502f6e3e803cb upstream.

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
 drivers/tty/serial/pch_uart.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -624,22 +624,6 @@ static int push_rx(struct eg20t_port *pr
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
@@ -889,9 +873,10 @@ static unsigned int handle_tx(struct eg2
 
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
@@ -946,9 +931,11 @@ static unsigned int dma_handle_tx(struct
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
 


