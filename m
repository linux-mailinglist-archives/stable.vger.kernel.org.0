Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C0540A8DE
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 10:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhINIKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 04:10:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230520AbhINIIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 04:08:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD948601FC;
        Tue, 14 Sep 2021 08:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631606850;
        bh=Nixj6LnHKh92L8XhvsfrVCy51EYusEPbPoZkZynfO6I=;
        h=Subject:To:From:Date:From;
        b=iPrumILFTTz9T/qJqYKAczSIkT154HPPXPGr28odm/y3XBQFqm2V8JJLJ3PKr8i07
         yCIdq9/jFPtwCd9F6etE61sjhqTs3hKrWC2FB9Zu9rnfXDEewyA99E1woP1j6Xe6ce
         GRjqkwxsdcLC3LVSnENYYcizI33b/U8D6KDRL7mg=
Subject: patch "serial: mvebu-uart: fix driver's tx_empty callback" added to tty-linus
To:     pali@kernel.org, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Sep 2021 10:07:28 +0200
Message-ID: <1631606848175126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: mvebu-uart: fix driver's tx_empty callback

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 74e1eb3b4a1ef2e564b4bdeb6e92afe844e900de Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Sat, 11 Sep 2021 15:20:17 +0200
Subject: serial: mvebu-uart: fix driver's tx_empty callback
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
 drivers/tty/serial/mvebu-uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/mvebu-uart.c
index 231de29a6452..ab226da75f7b 100644
--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -163,7 +163,7 @@ static unsigned int mvebu_uart_tx_empty(struct uart_port *port)
 	st = readl(port->membase + UART_STAT);
 	spin_unlock_irqrestore(&port->lock, flags);
 
-	return (st & STAT_TX_FIFO_EMP) ? TIOCSER_TEMT : 0;
+	return (st & STAT_TX_EMP) ? TIOCSER_TEMT : 0;
 }
 
 static unsigned int mvebu_uart_get_mctrl(struct uart_port *port)
-- 
2.33.0


