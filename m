Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDD72E420F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731973AbgL1PRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:17:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392557AbgL1PRK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 10:17:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 021CD223E8;
        Mon, 28 Dec 2020 15:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609168589;
        bh=RNBiK0q5L0B6y+ZBNc0VzEwVQ5u9W7D2nAPJra2HCzQ=;
        h=Subject:To:From:Date:From;
        b=OGRg0Pk0HCIKAbGnAKql+oi4YduxQ26IBUGp6r/oW9+39k007yG2a5p2s5No5dKgk
         W2j5hhxLD4pNT+XRzQBP0pImmPpJyV5uRtaOkXkcPuZFwIzz1t8T/4rvH4GOXWct4c
         7fdfOhDFUlcXr1QaE22JLQ1DBRLdQQ9enkwjk0Ko=
Subject: patch "serial: mvebu-uart: fix tx lost characters at power off" added to tty-linus
To:     pali@kernel.org, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 16:17:51 +0100
Message-ID: <16091686718519@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: mvebu-uart: fix tx lost characters at power off

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 54ca955b5a4024e2ce0f206b03adb7109bc4da26 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Wed, 23 Dec 2020 20:19:31 +0100
Subject: serial: mvebu-uart: fix tx lost characters at power off
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit c685af1108d7 ("serial: mvebu-uart: fix tx lost characters") fixed tx
lost characters at low baud rates but started causing tx lost characters
when kernel is going to power off or reboot.

TX_EMP tells us when transmit queue is empty therefore all characters were
transmitted. TX_RDY tells us when CPU can send a new character.

Therefore we need to use different check prior transmitting new character
and different check after all characters were sent.

This patch splits polling code into two functions: wait_for_xmitr() which
waits for TX_RDY and wait_for_xmite() which waits for TX_EMP.

When rebooting A3720 platform without this patch on UART is print only:
[   42.699�

And with this patch on UART is full output:
[   39.530216] reboot: Restarting system

Fixes: c685af1108d7 ("serial: mvebu-uart: fix tx lost characters")
Signed-off-by: Pali Rohár <pali@kernel.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201223191931.18343-1-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/mvebu-uart.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/mvebu-uart.c
index 118b29912289..e0c00a1b0763 100644
--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -648,6 +648,14 @@ static void wait_for_xmitr(struct uart_port *port)
 				  (val & STAT_TX_RDY(port)), 1, 10000);
 }
 
+static void wait_for_xmite(struct uart_port *port)
+{
+	u32 val;
+
+	readl_poll_timeout_atomic(port->membase + UART_STAT, val,
+				  (val & STAT_TX_EMP), 1, 10000);
+}
+
 static void mvebu_uart_console_putchar(struct uart_port *port, int ch)
 {
 	wait_for_xmitr(port);
@@ -675,7 +683,7 @@ static void mvebu_uart_console_write(struct console *co, const char *s,
 
 	uart_console_write(port, s, count, mvebu_uart_console_putchar);
 
-	wait_for_xmitr(port);
+	wait_for_xmite(port);
 
 	if (ier)
 		writel(ier, port->membase + UART_CTRL(port));
-- 
2.29.2


