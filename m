Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621CE395E2C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhEaNzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:55:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232813AbhEaNws (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:52:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0259B61864;
        Mon, 31 May 2021 13:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467978;
        bh=po92fyaU31d9OfaH20goi4hugIcHBnKfk/b12o0pnSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKmmBUdTHA8iYSuwTc4kWRAJ4Dx8ZwmVFzLhE56jvR7ZbE7tKFcM+AKkBZDihpiwN
         9sJAlOq8FRiPFvppdPr5DNIobCwQZukP+EZ44zssG+kh3qXT2A9GrEJuy3r/M7i6mT
         VSylbn6jX7m28J2JURb4JEegWNlSRpnsWOu7iX50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ChiaWei Wang <chiawei_wang@aspeedtech.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: [PATCH 5.10 070/252] serial: 8250: Add UART_BUG_TXRACE workaround for Aspeed VUART
Date:   Mon, 31 May 2021 15:12:15 +0200
Message-Id: <20210531130700.364773895@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jeffery <andrew@aj.id.au>

commit df8f2be2fd0b44b2cb6077068f52e05f0ac40897 upstream.

Aspeed Virtual UARTs directly bridge e.g. the system console UART on the
LPC bus to the UART interface on the BMC's internal APB. As such there's
no RS-232 signalling involved - the UART interfaces on each bus are
directly connected as the producers and consumers of the one set of
FIFOs.

The APB in the AST2600 generally runs at 100MHz while the LPC bus peaks
at 33MHz. The difference in clock speeds exposes a race in the VUART
design where a Tx data burst on the APB interface can result in a byte
lost on the LPC interface. The symptom is LSR[DR] remains clear on the
LPC interface despite data being present in its Rx FIFO, while LSR[THRE]
remains clear on the APB interface as the host has not consumed the data
the BMC has transmitted. In this state, the UART has stalled and no
further data can be transmitted without manual intervention (e.g.
resetting the FIFOs, resulting in loss of data).

The recommended work-around is to insert a read cycle on the APB
interface between writes to THR.

Cc: ChiaWei Wang <chiawei_wang@aspeedtech.com>
Tested-by: ChiaWei Wang <chiawei_wang@aspeedtech.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210520021334.497341-2-andrew@aj.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250.h              |    1 +
 drivers/tty/serial/8250/8250_aspeed_vuart.c |    1 +
 drivers/tty/serial/8250/8250_port.c         |   12 ++++++++++++
 3 files changed, 14 insertions(+)

--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -88,6 +88,7 @@ struct serial8250_config {
 #define UART_BUG_NOMSR	(1 << 2)	/* UART has buggy MSR status bits (Au1x00) */
 #define UART_BUG_THRE	(1 << 3)	/* UART has buggy THRE reassertion */
 #define UART_BUG_PARITY	(1 << 4)	/* UART mishandles parity if FIFO enabled */
+#define UART_BUG_TXRACE	(1 << 5)	/* UART Tx fails to set remote DR */
 
 
 #ifdef CONFIG_SERIAL_8250_SHARE_IRQ
--- a/drivers/tty/serial/8250/8250_aspeed_vuart.c
+++ b/drivers/tty/serial/8250/8250_aspeed_vuart.c
@@ -403,6 +403,7 @@ static int aspeed_vuart_probe(struct pla
 	port.port.status = UPSTAT_SYNC_FIFO;
 	port.port.dev = &pdev->dev;
 	port.port.has_sysrq = IS_ENABLED(CONFIG_SERIAL_8250_CONSOLE);
+	port.bugs |= UART_BUG_TXRACE;
 
 	rc = sysfs_create_group(&vuart->dev->kobj, &aspeed_vuart_attr_group);
 	if (rc < 0)
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1815,6 +1815,18 @@ void serial8250_tx_chars(struct uart_825
 	count = up->tx_loadsz;
 	do {
 		serial_out(up, UART_TX, xmit->buf[xmit->tail]);
+		if (up->bugs & UART_BUG_TXRACE) {
+			/*
+			 * The Aspeed BMC virtual UARTs have a bug where data
+			 * may get stuck in the BMC's Tx FIFO from bursts of
+			 * writes on the APB interface.
+			 *
+			 * Delay back-to-back writes by a read cycle to avoid
+			 * stalling the VUART. Read a register that won't have
+			 * side-effects and discard the result.
+			 */
+			serial_in(up, UART_SCR);
+		}
 		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		port->icount.tx++;
 		if (uart_circ_empty(xmit))


