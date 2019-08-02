Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F337F278
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405341AbfHBJsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405920AbfHBJss (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:48:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7A9F206A2;
        Fri,  2 Aug 2019 09:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739328;
        bh=uaG/nocy+VuJbNmkPLj0hukthBq5FUvJyceyfyA9W0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJeiyNCzW1XhKUdvExY6ipGTM+i2qfl7q9VzlMVTO+ZPtzShyQ7xu2tCGwubsGx9a
         9LgXdS62sr5D++FyMm1oc+ExbXhCvOFPFa99KNLawxHl+mDU3NMEWFUyGGgOYfEtgc
         1q1FdCRqOtSyo9zCIAc1i0q1pZRdM1/n4raXPerQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kimmo Rautkoski <ext-kimmo.rautkoski@vaisala.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 169/223] serial: 8250: Fix TX interrupt handling condition
Date:   Fri,  2 Aug 2019 11:36:34 +0200
Message-Id: <20190802092248.929363205@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit db1b5bc047b3cadaedab3826bba82c3d9e023c4b ]

Interrupt handler checked THRE bit (transmitter holding register
empty) in LSR to detect if TX fifo is empty.
In case when there is only receive interrupts the TX handling
got called because THRE bit in LSR is set when there is no
transmission (FIFO empty). TX handling caused TX stop, which in
RS-485 half-duplex mode actually resets receiver FIFO. This is not
desired during reception because of possible data loss.

The fix is to check if THRI is set in IER in addition of the TX
fifo status. THRI in IER is set when TX is started and cleared
when TX is stopped.
This ensures that TX handling is only called when there is really
transmission on going and an interrupt for THRE and not when there
are only RX interrupts.

Signed-off-by: Kimmo Rautkoski <ext-kimmo.rautkoski@vaisala.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 84474f06dbcf..8f1233324586 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1819,7 +1819,8 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 			status = serial8250_rx_chars(up, status);
 	}
 	serial8250_modem_status(up);
-	if ((!up->dma || up->dma->tx_err) && (status & UART_LSR_THRE))
+	if ((!up->dma || up->dma->tx_err) && (status & UART_LSR_THRE) &&
+		(up->ier & UART_IER_THRI))
 		serial8250_tx_chars(up);
 
 	spin_unlock_irqrestore(&port->lock, flags);
-- 
2.20.1



