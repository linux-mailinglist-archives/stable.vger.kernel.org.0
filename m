Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB1C419A0E
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbhI0RGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235929AbhI0RGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:06:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BF806113A;
        Mon, 27 Sep 2021 17:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762262;
        bh=ddjRpM4FxVyZt5Ae/yxSo/QEoLsCMBmjqDKiTYP+zK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFBQYdKcW/6ovb75s6ppjbnd1ybWLu5APYYJ68PM8TBtig0VDaqUA8oWYDcM0W6lR
         8mBkLZuWPfGdvGJ59ogrhZVFDrRRIGDVOqvoOAqcDP7jXV+E+/Pa8M5cQOuIkribKr
         1cPvrY/ttLjku3RmAh9+NbflFtwy0uq3Yk7Kkvps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 5.4 23/68] serial: mvebu-uart: fix drivers tx_empty callback
Date:   Mon, 27 Sep 2021 19:02:19 +0200
Message-Id: <20210927170220.753300096@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 74e1eb3b4a1ef2e564b4bdeb6e92afe844e900de upstream.

Driver's tx_empty callback should signal when the transmit shift register
is empty. So when the last character has been sent.

STAT_TX_FIFO_EMP bit signals only that HW transmit FIFO is empty, which
happens when the last byte is loaded into transmit shift register.

STAT_TX_EMP bit signals when the both HW transmit FIFO and transmit shift
register are empty.

So replace STAT_TX_FIFO_EMP check by STAT_TX_EMP in mvebu_uart_tx_empty()
callback function.

Fixes: 30530791a7a0 ("serial: mvebu-uart: initial support for Armada-3700 serial port")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20210911132017.25505-1-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/mvebu-uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -164,7 +164,7 @@ static unsigned int mvebu_uart_tx_empty(
 	st = readl(port->membase + UART_STAT);
 	spin_unlock_irqrestore(&port->lock, flags);
 
-	return (st & STAT_TX_FIFO_EMP) ? TIOCSER_TEMT : 0;
+	return (st & STAT_TX_EMP) ? TIOCSER_TEMT : 0;
 }
 
 static unsigned int mvebu_uart_get_mctrl(struct uart_port *port)


