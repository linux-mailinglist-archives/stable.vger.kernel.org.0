Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C10D25417F8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378695AbiFGVHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378784AbiFGVBt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:01:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B9120ED4A;
        Tue,  7 Jun 2022 11:45:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72C32B81FE1;
        Tue,  7 Jun 2022 18:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC305C385A2;
        Tue,  7 Jun 2022 18:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627535;
        bh=/nt2azIDU63waHlYWHq5Z5MohAVPxSo0yJVmg3AdC48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ot1tANJ1Wsn5zbTEfXM5NttQ9KsdlgnnXLpA3bTpc0AhgylxbJ09AqD50jYawKoAv
         6mbn/y//zQPMjV7/nf2cwzaUjEirGLPOtCziwXN2XeBQ17IEQmAe8M6O986Sov1Lwr
         dR6U7+VTMbZ62l1oXtIrVWVyhpohMy6JCqAOJYcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 5.17 737/772] serial: pch: dont overwrite xmit->buf[0] by x_char
Date:   Tue,  7 Jun 2022 19:05:29 +0200
Message-Id: <20220607165010.754152605@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
 


