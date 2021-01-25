Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7E7302ACA
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbhAYSxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:53:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731184AbhAYSwy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:52:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60FD822460;
        Mon, 25 Jan 2021 18:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600733;
        bh=n75Q2tY6ZfNexKfok1s9pQn9mz47sj6JLbYAKUy6jNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a4WaeozaAX5fVFSo3hwzWN2bMRpy/RpTGci/70E2jnuXVYyUgx5RfvirmevvSP+AV
         3KHHQzDw42ll34pR+2TxlWCjWJ3UfK7U8qWWO/Jnr/sSUN5QJ1byklMJuGlMRTFs/w
         ZZyCIqKbhsGmrD9/QkRdUeokYyPtuXtdQW8D4TNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 5.10 131/199] serial: mvebu-uart: fix tx lost characters at power off
Date:   Mon, 25 Jan 2021 19:39:13 +0100
Message-Id: <20210125183221.747799528@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 54ca955b5a4024e2ce0f206b03adb7109bc4da26 upstream.

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
 drivers/tty/serial/mvebu-uart.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -648,6 +648,14 @@ static void wait_for_xmitr(struct uart_p
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
@@ -675,7 +683,7 @@ static void mvebu_uart_console_write(str
 
 	uart_console_write(port, s, count, mvebu_uart_console_putchar);
 
-	wait_for_xmitr(port);
+	wait_for_xmite(port);
 
 	if (ier)
 		writel(ier, port->membase + UART_CTRL(port));


