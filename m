Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7B715B182
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 21:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgBLUCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 15:02:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727923AbgBLUCm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Feb 2020 15:02:42 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47A0C217F4;
        Wed, 12 Feb 2020 20:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581537761;
        bh=h/9n1guqwk1bSlfNzVZ32bMihpPxz5jlfqQ1bgGdiOo=;
        h=Subject:To:From:Date:From;
        b=Ql8fCexte1Wynd8Ihy2js6jr6JT2MpgfJXOeLmm+0g+EVng8t/Prmqk/6rthoW8A6
         Plc2Dq16jPSLPvC9ynHCtBv/3xafHw8Em3A3kcCy0HI/tDssEJI+UhkDn4HUqKYc5b
         8cW2jigs1VyB4acK0AbdZC4gf8XjF5Z3hubsfS1Y=
Subject: patch "tty: serial: qcom_geni_serial: Fix RX cancel command failure" added to tty-linus
To:     skakit@codeaurora.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 Feb 2020 12:02:32 -0800
Message-ID: <1581537752120200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: serial: qcom_geni_serial: Fix RX cancel command failure

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 679aac5ead2f18d223554a52b543e1195e181811 Mon Sep 17 00:00:00 2001
From: satya priya <skakit@codeaurora.org>
Date: Tue, 11 Feb 2020 15:43:02 +0530
Subject: tty: serial: qcom_geni_serial: Fix RX cancel command failure

RX cancel command fails when BT is switched on and off multiple times.

To handle this, poll for the cancel bit in SE_GENI_S_IRQ_STATUS register
instead of SE_GENI_S_CMD_CTRL_REG.

As per the HPG update, handle the RX last bit after cancel command
and flush out the RX FIFO buffer.

Signed-off-by: satya priya <skakit@codeaurora.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1581415982-8793-1-git-send-email-skakit@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 191abb18fc2a..0bd1684cabb3 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -129,6 +129,7 @@ static int handle_rx_console(struct uart_port *uport, u32 bytes, bool drop);
 static int handle_rx_uart(struct uart_port *uport, u32 bytes, bool drop);
 static unsigned int qcom_geni_serial_tx_empty(struct uart_port *port);
 static void qcom_geni_serial_stop_rx(struct uart_port *uport);
+static void qcom_geni_serial_handle_rx(struct uart_port *uport, bool drop);
 
 static const unsigned long root_freq[] = {7372800, 14745600, 19200000, 29491200,
 					32000000, 48000000, 64000000, 80000000,
@@ -599,7 +600,7 @@ static void qcom_geni_serial_stop_rx(struct uart_port *uport)
 	u32 irq_en;
 	u32 status;
 	struct qcom_geni_serial_port *port = to_dev_port(uport, uport);
-	u32 irq_clear = S_CMD_DONE_EN;
+	u32 s_irq_status;
 
 	irq_en = readl(uport->membase + SE_GENI_S_IRQ_EN);
 	irq_en &= ~(S_RX_FIFO_WATERMARK_EN | S_RX_FIFO_LAST_EN);
@@ -615,10 +616,19 @@ static void qcom_geni_serial_stop_rx(struct uart_port *uport)
 		return;
 
 	geni_se_cancel_s_cmd(&port->se);
-	qcom_geni_serial_poll_bit(uport, SE_GENI_S_CMD_CTRL_REG,
-					S_GENI_CMD_CANCEL, false);
+	qcom_geni_serial_poll_bit(uport, SE_GENI_S_IRQ_STATUS,
+					S_CMD_CANCEL_EN, true);
+	/*
+	 * If timeout occurs secondary engine remains active
+	 * and Abort sequence is executed.
+	 */
+	s_irq_status = readl(uport->membase + SE_GENI_S_IRQ_STATUS);
+	/* Flush the Rx buffer */
+	if (s_irq_status & S_RX_FIFO_LAST_EN)
+		qcom_geni_serial_handle_rx(uport, true);
+	writel(s_irq_status, uport->membase + SE_GENI_S_IRQ_CLEAR);
+
 	status = readl(uport->membase + SE_GENI_STATUS);
-	writel(irq_clear, uport->membase + SE_GENI_S_IRQ_CLEAR);
 	if (status & S_GENI_CMD_ACTIVE)
 		qcom_geni_serial_abort_rx(uport);
 }
-- 
2.25.0


