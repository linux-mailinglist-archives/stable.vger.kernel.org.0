Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01258450C53
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236330AbhKORhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:37:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238186AbhKORdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:33:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2518961265;
        Mon, 15 Nov 2021 17:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996918;
        bh=Zpk4huBovzAl/s2iLuKTBFCPMJTMumQY/LLWNizifqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9nv0DjYaMmpexlOCD1gOwtLKF8kuQbCJi/8KfvK1AknBXu8wUMYlxSKhqCnajCsk
         gB+TyO1HjIZo7lCVmdUWQbnA1QiVOQ2sTkbMHZaouOK7AlIAyQh1e81Q8mj8WqvO1i
         Oculfo+tgL21f39UnYG20F7FV3ZozeeVz6UCwaPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anssi Hannula <anssi.hannula@bitwise.fi>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 283/355] serial: xilinx_uartps: Fix race condition causing stuck TX
Date:   Mon, 15 Nov 2021 18:03:27 +0100
Message-Id: <20211115165322.884034187@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anssi Hannula <anssi.hannula@bitwise.fi>

[ Upstream commit 88b20f84f0fe47409342669caf3e58a3fc64c316 ]

xilinx_uartps .start_tx() clears TXEMPTY when enabling TXEMPTY to avoid
any previous TXEVENT event asserting the UART interrupt. This clear
operation is done immediately after filling the TX FIFO.

However, if the bytes inserted by cdns_uart_handle_tx() are consumed by
the UART before the TXEMPTY is cleared, the clear operation eats the new
TXEMPTY event as well, causing cdns_uart_isr() to never receive the
TXEMPTY event. If there are bytes still queued in circbuf, TX will get
stuck as they will never get transferred to FIFO (unless new bytes are
queued to circbuf in which case .start_tx() is called again).

While the racy missed TXEMPTY occurs fairly often with short data
sequences (e.g. write 1 byte), in those cases circbuf is usually empty
so no action on TXEMPTY would have been needed anyway. On the other
hand, longer data sequences make the race much more unlikely as UART
takes longer to consume the TX FIFO. Therefore it is rare for this race
to cause visible issues in general.

Fix the race by clearing the TXEMPTY bit in ISR *before* filling the
FIFO.

The TXEMPTY bit in ISR will only get asserted at the exact moment the
TX FIFO *becomes* empty, so clearing the bit before filling FIFO does
not cause an extra immediate assertion even if the FIFO is initially
empty.

This is hard to reproduce directly on a normal system, but inserting
e.g. udelay(200) after cdns_uart_handle_tx(port), setting 4000000 baud,
and then running "dd if=/dev/zero bs=128 of=/dev/ttyPS0 count=50"
reliably reproduces the issue on my ZynqMP test system unless this fix
is applied.

Fixes: 85baf542d54e ("tty: xuartps: support 64 byte FIFO size")
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Link: https://lore.kernel.org/r/20211026102741.2910441-1-anssi.hannula@bitwise.fi
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/xilinx_uartps.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 9359c80fbb9f5..a1409251fbcc3 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -595,9 +595,10 @@ static void cdns_uart_start_tx(struct uart_port *port)
 	if (uart_circ_empty(&port->state->xmit))
 		return;
 
+	writel(CDNS_UART_IXR_TXEMPTY, port->membase + CDNS_UART_ISR);
+
 	cdns_uart_handle_tx(port);
 
-	writel(CDNS_UART_IXR_TXEMPTY, port->membase + CDNS_UART_ISR);
 	/* Enable the TX Empty interrupt */
 	writel(CDNS_UART_IXR_TXEMPTY, port->membase + CDNS_UART_IER);
 }
-- 
2.33.0



