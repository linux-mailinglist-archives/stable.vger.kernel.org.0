Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2544F29FA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350506AbiDEJ6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344024AbiDEJQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:16:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666CB1BEB8;
        Tue,  5 Apr 2022 02:03:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11A4EB81BBF;
        Tue,  5 Apr 2022 09:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709E8C385A0;
        Tue,  5 Apr 2022 09:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149417;
        bh=q9sK/WaOZNRPr2VqWX/aW0cqtIBUU+WYW2Pf4EKTIJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+pApIU63HPT1wdaomPt6vhPtUMq0WW89J6NaedsVfRCckBQvscmCJt89/Tt9v1VZ
         qikqkEs75graT9CsjzlXMlpeefkIbJ5nSq5YapVt2LR8FqHkRYCFpxiAKO4EP0JQ/o
         3fR9pOso+WDFR2pEkXeiXtRaHd6uu5KVlq/wP6RU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilles Buloz <gilles.buloz@kontron.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0706/1017] serial: 8250: fix XOFF/XON sending when DMA is used
Date:   Tue,  5 Apr 2022 09:26:59 +0200
Message-Id: <20220405070415.227462552@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit f58c252e30cf74f68b0054293adc03b5923b9f0e ]

When 8250 UART is using DMA, x_char (XON/XOFF) is never sent
to the wire. After this change, x_char is injected correctly.

Create uart_xchar_out() helper for sending the x_char out and
accounting related to it. It seems that almost every driver
does these same steps with x_char. Except for 8250, however,
almost all currently lack .serial_out so they cannot immediately
take advantage of this new helper.

The downside of this patch is that it might reintroduce
the problems some devices faced with mixed DMA/non-DMA transfer
which caused revert f967fc8f165f (Revert "serial: 8250_dma:
don't bother DMA with small transfers"). However, the impact
should be limited to cases with XON/XOFF (that didn't work
with DMA capable devices to begin with so this problem is not
very likely to cause a major issue, if any at all).

Fixes: 9ee4b83e51f74 ("serial: 8250: Add support for dmaengine")
Reported-by: Gilles Buloz <gilles.buloz@kontron.com>
Tested-by: Gilles Buloz <gilles.buloz@kontron.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220314091432.4288-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_dma.c  | 11 ++++++++++-
 drivers/tty/serial/8250/8250_port.c |  4 +---
 drivers/tty/serial/serial_core.c    | 14 ++++++++++++++
 include/linux/serial_core.h         |  2 ++
 4 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 890fa7ddaa7f..b3c3f7e5851a 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -64,10 +64,19 @@ int serial8250_tx_dma(struct uart_8250_port *p)
 	struct uart_8250_dma		*dma = p->dma;
 	struct circ_buf			*xmit = &p->port.state->xmit;
 	struct dma_async_tx_descriptor	*desc;
+	struct uart_port		*up = &p->port;
 	int ret;
 
-	if (dma->tx_running)
+	if (dma->tx_running) {
+		if (up->x_char) {
+			dmaengine_pause(dma->txchan);
+			uart_xchar_out(up, UART_TX);
+			dmaengine_resume(dma->txchan);
+		}
 		return 0;
+	} else if (up->x_char) {
+		uart_xchar_out(up, UART_TX);
+	}
 
 	if (uart_tx_stopped(&p->port) || uart_circ_empty(xmit)) {
 		/* We have been called from __dma_tx_complete() */
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 344fbe7426f6..1e1750a9614e 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1819,9 +1819,7 @@ void serial8250_tx_chars(struct uart_8250_port *up)
 	int count;
 
 	if (port->x_char) {
-		serial_out(up, UART_TX, port->x_char);
-		port->icount.tx++;
-		port->x_char = 0;
+		uart_xchar_out(port, UART_TX);
 		return;
 	}
 	if (uart_tx_stopped(port)) {
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index dc6129ddef85..eb15423f935a 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -652,6 +652,20 @@ static void uart_flush_buffer(struct tty_struct *tty)
 	tty_port_tty_wakeup(&state->port);
 }
 
+/*
+ * This function performs low-level write of high-priority XON/XOFF
+ * character and accounting for it.
+ *
+ * Requires uart_port to implement .serial_out().
+ */
+void uart_xchar_out(struct uart_port *uport, int offset)
+{
+	serial_port_out(uport, offset, uport->x_char);
+	uport->icount.tx++;
+	uport->x_char = 0;
+}
+EXPORT_SYMBOL_GPL(uart_xchar_out);
+
 /*
  * This function is used to send a high-priority XON/XOFF character to
  * the device
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index c58cc142d23f..8c32935e1059 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -458,6 +458,8 @@ extern void uart_handle_cts_change(struct uart_port *uport,
 extern void uart_insert_char(struct uart_port *port, unsigned int status,
 		 unsigned int overrun, unsigned int ch, unsigned int flag);
 
+void uart_xchar_out(struct uart_port *uport, int offset);
+
 #ifdef CONFIG_MAGIC_SYSRQ_SERIAL
 #define SYSRQ_TIMEOUT	(HZ * 5)
 
-- 
2.34.1



