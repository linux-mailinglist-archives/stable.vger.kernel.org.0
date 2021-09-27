Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF46F419AF1
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236347AbhI0ROk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:14:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236565AbhI0RMu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:12:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75E9161279;
        Mon, 27 Sep 2021 17:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762536;
        bh=ddjRpM4FxVyZt5Ae/yxSo/QEoLsCMBmjqDKiTYP+zK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1fLZ4A0WVSIaYNm793PvufGqChji3k5KZ/JHwWB7ZtVIK0NBRTUKw3vv275Dy143
         GC/v5kwMt5xNGnzxYOb3AGAX0XIROPTtUbV/W7GIstjqG134YEaoYOQOutB9I7/gcu
         uLDMla+pjL8scXi74T2FApkdMHb3hXtnJyZqPybk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 5.10 028/103] serial: mvebu-uart: fix drivers tx_empty callback
Date:   Mon, 27 Sep 2021 19:02:00 +0200
Message-Id: <20210927170226.715243770@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
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


