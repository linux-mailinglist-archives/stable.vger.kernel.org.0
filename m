Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A22171ED4
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387638AbgB0OEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:04:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387629AbgB0OEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:04:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F14D20578;
        Thu, 27 Feb 2020 14:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812288;
        bh=i3h9xgWqiMLVtmnfToFicDosJ3zbFw17mjewyc8NrfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=geYqgTXvymHCe/XpJkbKNFmB/Q5BId/78vjNoZt1J8q6bnaMJMaxe0gvh97EMmC9F
         S/D+L9PuzlDNMU5+joYn4deRPAd+2X5VB/mayGwwDVvNY/BHXRHm7e+eysJ6qzZTMM
         8H1eeJm5L7lmL4e61W9/32un4KXGy0cFSMK0L2V8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryan Case <ryandcase@chromium.org>,
        Evan Green <evgreen@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 56/97] tty: serial: qcom_geni_serial: Remove use of *_relaxed() and mb()
Date:   Thu, 27 Feb 2020 14:37:04 +0100
Message-Id: <20200227132223.720151315@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryan Case <ryandcase@chromium.org>

[ Upstream commit 9e06d55f7b856bfaf82036b50072600b21e52d20 ]

A frequent side comment has been to remove the use of writel_relaxed,
readl_relaxed, and mb. This reduces driver complexity and the _relaxed
variants were not known to provide any noticeable performance benefit.

Signed-off-by: Ryan Case <ryandcase@chromium.org>
Reviewed-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 191 +++++++++++---------------
 1 file changed, 80 insertions(+), 111 deletions(-)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 743d877e7ff94..4824869a4080d 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -226,7 +226,7 @@ static unsigned int qcom_geni_serial_get_mctrl(struct uart_port *uport)
 	if (uart_console(uport)) {
 		mctrl |= TIOCM_CTS;
 	} else {
-		geni_ios = readl_relaxed(uport->membase + SE_GENI_IOS);
+		geni_ios = readl(uport->membase + SE_GENI_IOS);
 		if (!(geni_ios & IO2_DATA_IN))
 			mctrl |= TIOCM_CTS;
 	}
@@ -244,7 +244,7 @@ static void qcom_geni_serial_set_mctrl(struct uart_port *uport,
 
 	if (!(mctrl & TIOCM_RTS))
 		uart_manual_rfr = UART_MANUAL_RFR_EN | UART_RFR_NOT_READY;
-	writel_relaxed(uart_manual_rfr, uport->membase + SE_UART_MANUAL_RFR);
+	writel(uart_manual_rfr, uport->membase + SE_UART_MANUAL_RFR);
 }
 
 static const char *qcom_geni_serial_get_type(struct uart_port *uport)
@@ -273,9 +273,6 @@ static bool qcom_geni_serial_poll_bit(struct uart_port *uport,
 	unsigned int fifo_bits;
 	unsigned long timeout_us = 20000;
 
-	/* Ensure polling is not re-ordered before the prior writes/reads */
-	mb();
-
 	if (uport->private_data) {
 		port = to_dev_port(uport, uport);
 		baud = port->baud;
@@ -295,7 +292,7 @@ static bool qcom_geni_serial_poll_bit(struct uart_port *uport,
 	 */
 	timeout_us = DIV_ROUND_UP(timeout_us, 10) * 10;
 	while (timeout_us) {
-		reg = readl_relaxed(uport->membase + offset);
+		reg = readl(uport->membase + offset);
 		if ((bool)(reg & field) == set)
 			return true;
 		udelay(10);
@@ -308,7 +305,7 @@ static void qcom_geni_serial_setup_tx(struct uart_port *uport, u32 xmit_size)
 {
 	u32 m_cmd;
 
-	writel_relaxed(xmit_size, uport->membase + SE_UART_TX_TRANS_LEN);
+	writel(xmit_size, uport->membase + SE_UART_TX_TRANS_LEN);
 	m_cmd = UART_START_TX << M_OPCODE_SHFT;
 	writel(m_cmd, uport->membase + SE_GENI_M_CMD0);
 }
@@ -321,13 +318,13 @@ static void qcom_geni_serial_poll_tx_done(struct uart_port *uport)
 	done = qcom_geni_serial_poll_bit(uport, SE_GENI_M_IRQ_STATUS,
 						M_CMD_DONE_EN, true);
 	if (!done) {
-		writel_relaxed(M_GENI_CMD_ABORT, uport->membase +
+		writel(M_GENI_CMD_ABORT, uport->membase +
 						SE_GENI_M_CMD_CTRL_REG);
 		irq_clear |= M_CMD_ABORT_EN;
 		qcom_geni_serial_poll_bit(uport, SE_GENI_M_IRQ_STATUS,
 							M_CMD_ABORT_EN, true);
 	}
-	writel_relaxed(irq_clear, uport->membase + SE_GENI_M_IRQ_CLEAR);
+	writel(irq_clear, uport->membase + SE_GENI_M_IRQ_CLEAR);
 }
 
 static void qcom_geni_serial_abort_rx(struct uart_port *uport)
@@ -337,8 +334,8 @@ static void qcom_geni_serial_abort_rx(struct uart_port *uport)
 	writel(S_GENI_CMD_ABORT, uport->membase + SE_GENI_S_CMD_CTRL_REG);
 	qcom_geni_serial_poll_bit(uport, SE_GENI_S_CMD_CTRL_REG,
 					S_GENI_CMD_ABORT, false);
-	writel_relaxed(irq_clear, uport->membase + SE_GENI_S_IRQ_CLEAR);
-	writel_relaxed(FORCE_DEFAULT, uport->membase + GENI_FORCE_DEFAULT_REG);
+	writel(irq_clear, uport->membase + SE_GENI_S_IRQ_CLEAR);
+	writel(FORCE_DEFAULT, uport->membase + GENI_FORCE_DEFAULT_REG);
 }
 
 #ifdef CONFIG_CONSOLE_POLL
@@ -347,19 +344,13 @@ static int qcom_geni_serial_get_char(struct uart_port *uport)
 	u32 rx_fifo;
 	u32 status;
 
-	status = readl_relaxed(uport->membase + SE_GENI_M_IRQ_STATUS);
-	writel_relaxed(status, uport->membase + SE_GENI_M_IRQ_CLEAR);
-
-	status = readl_relaxed(uport->membase + SE_GENI_S_IRQ_STATUS);
-	writel_relaxed(status, uport->membase + SE_GENI_S_IRQ_CLEAR);
+	status = readl(uport->membase + SE_GENI_M_IRQ_STATUS);
+	writel(status, uport->membase + SE_GENI_M_IRQ_CLEAR);
 
-	/*
-	 * Ensure the writes to clear interrupts is not re-ordered after
-	 * reading the data.
-	 */
-	mb();
+	status = readl(uport->membase + SE_GENI_S_IRQ_STATUS);
+	writel(status, uport->membase + SE_GENI_S_IRQ_CLEAR);
 
-	status = readl_relaxed(uport->membase + SE_GENI_RX_FIFO_STATUS);
+	status = readl(uport->membase + SE_GENI_RX_FIFO_STATUS);
 	if (!(status & RX_FIFO_WC_MSK))
 		return NO_POLL_CHAR;
 
@@ -372,13 +363,12 @@ static void qcom_geni_serial_poll_put_char(struct uart_port *uport,
 {
 	struct qcom_geni_serial_port *port = to_dev_port(uport, uport);
 
-	writel_relaxed(port->tx_wm, uport->membase + SE_GENI_TX_WATERMARK_REG);
+	writel(port->tx_wm, uport->membase + SE_GENI_TX_WATERMARK_REG);
 	qcom_geni_serial_setup_tx(uport, 1);
 	WARN_ON(!qcom_geni_serial_poll_bit(uport, SE_GENI_M_IRQ_STATUS,
 						M_TX_FIFO_WATERMARK_EN, true));
-	writel_relaxed(c, uport->membase + SE_GENI_TX_FIFOn);
-	writel_relaxed(M_TX_FIFO_WATERMARK_EN, uport->membase +
-							SE_GENI_M_IRQ_CLEAR);
+	writel(c, uport->membase + SE_GENI_TX_FIFOn);
+	writel(M_TX_FIFO_WATERMARK_EN, uport->membase + SE_GENI_M_IRQ_CLEAR);
 	qcom_geni_serial_poll_tx_done(uport);
 }
 #endif
@@ -386,7 +376,7 @@ static void qcom_geni_serial_poll_put_char(struct uart_port *uport,
 #ifdef CONFIG_SERIAL_QCOM_GENI_CONSOLE
 static void qcom_geni_serial_wr_char(struct uart_port *uport, int ch)
 {
-	writel_relaxed(ch, uport->membase + SE_GENI_TX_FIFOn);
+	writel(ch, uport->membase + SE_GENI_TX_FIFOn);
 }
 
 static void
@@ -405,7 +395,7 @@ __qcom_geni_serial_console_write(struct uart_port *uport, const char *s,
 			bytes_to_send++;
 	}
 
-	writel_relaxed(DEF_TX_WM, uport->membase + SE_GENI_TX_WATERMARK_REG);
+	writel(DEF_TX_WM, uport->membase + SE_GENI_TX_WATERMARK_REG);
 	qcom_geni_serial_setup_tx(uport, bytes_to_send);
 	for (i = 0; i < count; ) {
 		size_t chars_to_write = 0;
@@ -423,7 +413,7 @@ __qcom_geni_serial_console_write(struct uart_port *uport, const char *s,
 		chars_to_write = min_t(size_t, count - i, avail / 2);
 		uart_console_write(uport, s + i, chars_to_write,
 						qcom_geni_serial_wr_char);
-		writel_relaxed(M_TX_FIFO_WATERMARK_EN, uport->membase +
+		writel(M_TX_FIFO_WATERMARK_EN, uport->membase +
 							SE_GENI_M_IRQ_CLEAR);
 		i += chars_to_write;
 	}
@@ -452,7 +442,7 @@ static void qcom_geni_serial_console_write(struct console *co, const char *s,
 	else
 		spin_lock_irqsave(&uport->lock, flags);
 
-	geni_status = readl_relaxed(uport->membase + SE_GENI_STATUS);
+	geni_status = readl(uport->membase + SE_GENI_STATUS);
 
 	/* Cancel the current write to log the fault */
 	if (!locked) {
@@ -462,11 +452,10 @@ static void qcom_geni_serial_console_write(struct console *co, const char *s,
 			geni_se_abort_m_cmd(&port->se);
 			qcom_geni_serial_poll_bit(uport, SE_GENI_M_IRQ_STATUS,
 							M_CMD_ABORT_EN, true);
-			writel_relaxed(M_CMD_ABORT_EN, uport->membase +
+			writel(M_CMD_ABORT_EN, uport->membase +
 							SE_GENI_M_IRQ_CLEAR);
 		}
-		writel_relaxed(M_CMD_CANCEL_EN, uport->membase +
-							SE_GENI_M_IRQ_CLEAR);
+		writel(M_CMD_CANCEL_EN, uport->membase + SE_GENI_M_IRQ_CLEAR);
 	} else if ((geni_status & M_GENI_CMD_ACTIVE) && !port->tx_remaining) {
 		/*
 		 * It seems we can't interrupt existing transfers if all data
@@ -475,9 +464,8 @@ static void qcom_geni_serial_console_write(struct console *co, const char *s,
 		qcom_geni_serial_poll_tx_done(uport);
 
 		if (uart_circ_chars_pending(&uport->state->xmit)) {
-			irq_en = readl_relaxed(uport->membase +
-					SE_GENI_M_IRQ_EN);
-			writel_relaxed(irq_en | M_TX_FIFO_WATERMARK_EN,
+			irq_en = readl(uport->membase + SE_GENI_M_IRQ_EN);
+			writel(irq_en | M_TX_FIFO_WATERMARK_EN,
 					uport->membase + SE_GENI_M_IRQ_EN);
 		}
 	}
@@ -580,12 +568,12 @@ static void qcom_geni_serial_start_tx(struct uart_port *uport)
 		if (!qcom_geni_serial_tx_empty(uport))
 			return;
 
-		irq_en = readl_relaxed(uport->membase +	SE_GENI_M_IRQ_EN);
+		irq_en = readl(uport->membase +	SE_GENI_M_IRQ_EN);
 		irq_en |= M_TX_FIFO_WATERMARK_EN | M_CMD_DONE_EN;
 
-		writel_relaxed(port->tx_wm, uport->membase +
+		writel(port->tx_wm, uport->membase +
 						SE_GENI_TX_WATERMARK_REG);
-		writel_relaxed(irq_en, uport->membase +	SE_GENI_M_IRQ_EN);
+		writel(irq_en, uport->membase +	SE_GENI_M_IRQ_EN);
 	}
 }
 
@@ -595,35 +583,28 @@ static void qcom_geni_serial_stop_tx(struct uart_port *uport)
 	u32 status;
 	struct qcom_geni_serial_port *port = to_dev_port(uport, uport);
 
-	irq_en = readl_relaxed(uport->membase + SE_GENI_M_IRQ_EN);
+	irq_en = readl(uport->membase + SE_GENI_M_IRQ_EN);
 	irq_en &= ~M_CMD_DONE_EN;
 	if (port->xfer_mode == GENI_SE_FIFO) {
 		irq_en &= ~M_TX_FIFO_WATERMARK_EN;
-		writel_relaxed(0, uport->membase +
+		writel(0, uport->membase +
 				     SE_GENI_TX_WATERMARK_REG);
 	}
-	writel_relaxed(irq_en, uport->membase + SE_GENI_M_IRQ_EN);
-	status = readl_relaxed(uport->membase + SE_GENI_STATUS);
+	writel(irq_en, uport->membase + SE_GENI_M_IRQ_EN);
+	status = readl(uport->membase + SE_GENI_STATUS);
 	/* Possible stop tx is called multiple times. */
 	if (!(status & M_GENI_CMD_ACTIVE))
 		return;
 
-	/*
-	 * Ensure cancel command write is not re-ordered before checking
-	 * the status of the Primary Sequencer.
-	 */
-	mb();
-
 	geni_se_cancel_m_cmd(&port->se);
 	if (!qcom_geni_serial_poll_bit(uport, SE_GENI_M_IRQ_STATUS,
 						M_CMD_CANCEL_EN, true)) {
 		geni_se_abort_m_cmd(&port->se);
 		qcom_geni_serial_poll_bit(uport, SE_GENI_M_IRQ_STATUS,
 						M_CMD_ABORT_EN, true);
-		writel_relaxed(M_CMD_ABORT_EN, uport->membase +
-							SE_GENI_M_IRQ_CLEAR);
+		writel(M_CMD_ABORT_EN, uport->membase + SE_GENI_M_IRQ_CLEAR);
 	}
-	writel_relaxed(M_CMD_CANCEL_EN, uport->membase + SE_GENI_M_IRQ_CLEAR);
+	writel(M_CMD_CANCEL_EN, uport->membase + SE_GENI_M_IRQ_CLEAR);
 }
 
 static void qcom_geni_serial_start_rx(struct uart_port *uport)
@@ -632,26 +613,20 @@ static void qcom_geni_serial_start_rx(struct uart_port *uport)
 	u32 status;
 	struct qcom_geni_serial_port *port = to_dev_port(uport, uport);
 
-	status = readl_relaxed(uport->membase + SE_GENI_STATUS);
+	status = readl(uport->membase + SE_GENI_STATUS);
 	if (status & S_GENI_CMD_ACTIVE)
 		qcom_geni_serial_stop_rx(uport);
 
-	/*
-	 * Ensure setup command write is not re-ordered before checking
-	 * the status of the Secondary Sequencer.
-	 */
-	mb();
-
 	geni_se_setup_s_cmd(&port->se, UART_START_READ, 0);
 
 	if (port->xfer_mode == GENI_SE_FIFO) {
-		irq_en = readl_relaxed(uport->membase + SE_GENI_S_IRQ_EN);
+		irq_en = readl(uport->membase + SE_GENI_S_IRQ_EN);
 		irq_en |= S_RX_FIFO_WATERMARK_EN | S_RX_FIFO_LAST_EN;
-		writel_relaxed(irq_en, uport->membase + SE_GENI_S_IRQ_EN);
+		writel(irq_en, uport->membase + SE_GENI_S_IRQ_EN);
 
-		irq_en = readl_relaxed(uport->membase + SE_GENI_M_IRQ_EN);
+		irq_en = readl(uport->membase + SE_GENI_M_IRQ_EN);
 		irq_en |= M_RX_FIFO_WATERMARK_EN | M_RX_FIFO_LAST_EN;
-		writel_relaxed(irq_en, uport->membase + SE_GENI_M_IRQ_EN);
+		writel(irq_en, uport->membase + SE_GENI_M_IRQ_EN);
 	}
 }
 
@@ -663,31 +638,25 @@ static void qcom_geni_serial_stop_rx(struct uart_port *uport)
 	u32 irq_clear = S_CMD_DONE_EN;
 
 	if (port->xfer_mode == GENI_SE_FIFO) {
-		irq_en = readl_relaxed(uport->membase + SE_GENI_S_IRQ_EN);
+		irq_en = readl(uport->membase + SE_GENI_S_IRQ_EN);
 		irq_en &= ~(S_RX_FIFO_WATERMARK_EN | S_RX_FIFO_LAST_EN);
-		writel_relaxed(irq_en, uport->membase + SE_GENI_S_IRQ_EN);
+		writel(irq_en, uport->membase + SE_GENI_S_IRQ_EN);
 
-		irq_en = readl_relaxed(uport->membase + SE_GENI_M_IRQ_EN);
+		irq_en = readl(uport->membase + SE_GENI_M_IRQ_EN);
 		irq_en &= ~(M_RX_FIFO_WATERMARK_EN | M_RX_FIFO_LAST_EN);
-		writel_relaxed(irq_en, uport->membase + SE_GENI_M_IRQ_EN);
+		writel(irq_en, uport->membase + SE_GENI_M_IRQ_EN);
 	}
 
-	status = readl_relaxed(uport->membase + SE_GENI_STATUS);
+	status = readl(uport->membase + SE_GENI_STATUS);
 	/* Possible stop rx is called multiple times. */
 	if (!(status & S_GENI_CMD_ACTIVE))
 		return;
 
-	/*
-	 * Ensure cancel command write is not re-ordered before checking
-	 * the status of the Secondary Sequencer.
-	 */
-	mb();
-
 	geni_se_cancel_s_cmd(&port->se);
 	qcom_geni_serial_poll_bit(uport, SE_GENI_S_CMD_CTRL_REG,
 					S_GENI_CMD_CANCEL, false);
-	status = readl_relaxed(uport->membase + SE_GENI_STATUS);
-	writel_relaxed(irq_clear, uport->membase + SE_GENI_S_IRQ_CLEAR);
+	status = readl(uport->membase + SE_GENI_STATUS);
+	writel(irq_clear, uport->membase + SE_GENI_S_IRQ_CLEAR);
 	if (status & S_GENI_CMD_ACTIVE)
 		qcom_geni_serial_abort_rx(uport);
 }
@@ -701,7 +670,7 @@ static void qcom_geni_serial_handle_rx(struct uart_port *uport, bool drop)
 	u32 total_bytes;
 	struct qcom_geni_serial_port *port = to_dev_port(uport, uport);
 
-	status = readl_relaxed(uport->membase +	SE_GENI_RX_FIFO_STATUS);
+	status = readl(uport->membase +	SE_GENI_RX_FIFO_STATUS);
 	word_cnt = status & RX_FIFO_WC_MSK;
 	last_word_partial = status & RX_LAST;
 	last_word_byte_cnt = (status & RX_LAST_BYTE_VALID_MSK) >>
@@ -731,7 +700,7 @@ static void qcom_geni_serial_handle_tx(struct uart_port *uport, bool done,
 	unsigned int chunk;
 	int tail;
 
-	status = readl_relaxed(uport->membase + SE_GENI_TX_FIFO_STATUS);
+	status = readl(uport->membase + SE_GENI_TX_FIFO_STATUS);
 
 	/* Complete the current tx command before taking newly added data */
 	if (active)
@@ -757,9 +726,9 @@ static void qcom_geni_serial_handle_tx(struct uart_port *uport, bool done,
 		qcom_geni_serial_setup_tx(uport, pending);
 		port->tx_remaining = pending;
 
-		irq_en = readl_relaxed(uport->membase + SE_GENI_M_IRQ_EN);
+		irq_en = readl(uport->membase + SE_GENI_M_IRQ_EN);
 		if (!(irq_en & M_TX_FIFO_WATERMARK_EN))
-			writel_relaxed(irq_en | M_TX_FIFO_WATERMARK_EN,
+			writel(irq_en | M_TX_FIFO_WATERMARK_EN,
 					uport->membase + SE_GENI_M_IRQ_EN);
 	}
 
@@ -790,14 +759,14 @@ static void qcom_geni_serial_handle_tx(struct uart_port *uport, bool done,
 	 * cleared it in qcom_geni_serial_isr it will have already reasserted
 	 * so we must clear it again here after our writes.
 	 */
-	writel_relaxed(M_TX_FIFO_WATERMARK_EN,
+	writel(M_TX_FIFO_WATERMARK_EN,
 			uport->membase + SE_GENI_M_IRQ_CLEAR);
 
 out_write_wakeup:
 	if (!port->tx_remaining) {
-		irq_en = readl_relaxed(uport->membase + SE_GENI_M_IRQ_EN);
+		irq_en = readl(uport->membase + SE_GENI_M_IRQ_EN);
 		if (irq_en & M_TX_FIFO_WATERMARK_EN)
-			writel_relaxed(irq_en & ~M_TX_FIFO_WATERMARK_EN,
+			writel(irq_en & ~M_TX_FIFO_WATERMARK_EN,
 					uport->membase + SE_GENI_M_IRQ_EN);
 	}
 
@@ -821,12 +790,12 @@ static irqreturn_t qcom_geni_serial_isr(int isr, void *dev)
 		return IRQ_NONE;
 
 	spin_lock_irqsave(&uport->lock, flags);
-	m_irq_status = readl_relaxed(uport->membase + SE_GENI_M_IRQ_STATUS);
-	s_irq_status = readl_relaxed(uport->membase + SE_GENI_S_IRQ_STATUS);
-	geni_status = readl_relaxed(uport->membase + SE_GENI_STATUS);
-	m_irq_en = readl_relaxed(uport->membase + SE_GENI_M_IRQ_EN);
-	writel_relaxed(m_irq_status, uport->membase + SE_GENI_M_IRQ_CLEAR);
-	writel_relaxed(s_irq_status, uport->membase + SE_GENI_S_IRQ_CLEAR);
+	m_irq_status = readl(uport->membase + SE_GENI_M_IRQ_STATUS);
+	s_irq_status = readl(uport->membase + SE_GENI_S_IRQ_STATUS);
+	geni_status = readl(uport->membase + SE_GENI_STATUS);
+	m_irq_en = readl(uport->membase + SE_GENI_M_IRQ_EN);
+	writel(m_irq_status, uport->membase + SE_GENI_M_IRQ_CLEAR);
+	writel(s_irq_status, uport->membase + SE_GENI_S_IRQ_CLEAR);
 
 	if (WARN_ON(m_irq_status & M_ILLEGAL_CMD_EN))
 		goto out_unlock;
@@ -921,7 +890,7 @@ static int qcom_geni_serial_port_setup(struct uart_port *uport)
 	get_tx_fifo_size(port);
 
 	set_rfr_wm(port);
-	writel_relaxed(rxstale, uport->membase + SE_UART_RX_STALE_CNT);
+	writel(rxstale, uport->membase + SE_UART_RX_STALE_CNT);
 	/*
 	 * Make an unconditional cancel on the main sequencer to reset
 	 * it else we could end up in data loss scenarios.
@@ -1025,10 +994,10 @@ static void qcom_geni_serial_set_termios(struct uart_port *uport,
 	ser_clk_cfg |= clk_div << CLK_DIV_SHFT;
 
 	/* parity */
-	tx_trans_cfg = readl_relaxed(uport->membase + SE_UART_TX_TRANS_CFG);
-	tx_parity_cfg = readl_relaxed(uport->membase + SE_UART_TX_PARITY_CFG);
-	rx_trans_cfg = readl_relaxed(uport->membase + SE_UART_RX_TRANS_CFG);
-	rx_parity_cfg = readl_relaxed(uport->membase + SE_UART_RX_PARITY_CFG);
+	tx_trans_cfg = readl(uport->membase + SE_UART_TX_TRANS_CFG);
+	tx_parity_cfg = readl(uport->membase + SE_UART_TX_PARITY_CFG);
+	rx_trans_cfg = readl(uport->membase + SE_UART_RX_TRANS_CFG);
+	rx_parity_cfg = readl(uport->membase + SE_UART_RX_PARITY_CFG);
 	if (termios->c_cflag & PARENB) {
 		tx_trans_cfg |= UART_TX_PAR_EN;
 		rx_trans_cfg |= UART_RX_PAR_EN;
@@ -1084,17 +1053,17 @@ static void qcom_geni_serial_set_termios(struct uart_port *uport,
 		uart_update_timeout(uport, termios->c_cflag, baud);
 
 	if (!uart_console(uport))
-		writel_relaxed(port->loopback,
+		writel(port->loopback,
 				uport->membase + SE_UART_LOOPBACK_CFG);
-	writel_relaxed(tx_trans_cfg, uport->membase + SE_UART_TX_TRANS_CFG);
-	writel_relaxed(tx_parity_cfg, uport->membase + SE_UART_TX_PARITY_CFG);
-	writel_relaxed(rx_trans_cfg, uport->membase + SE_UART_RX_TRANS_CFG);
-	writel_relaxed(rx_parity_cfg, uport->membase + SE_UART_RX_PARITY_CFG);
-	writel_relaxed(bits_per_char, uport->membase + SE_UART_TX_WORD_LEN);
-	writel_relaxed(bits_per_char, uport->membase + SE_UART_RX_WORD_LEN);
-	writel_relaxed(stop_bit_len, uport->membase + SE_UART_TX_STOP_BIT_LEN);
-	writel_relaxed(ser_clk_cfg, uport->membase + GENI_SER_M_CLK_CFG);
-	writel_relaxed(ser_clk_cfg, uport->membase + GENI_SER_S_CLK_CFG);
+	writel(tx_trans_cfg, uport->membase + SE_UART_TX_TRANS_CFG);
+	writel(tx_parity_cfg, uport->membase + SE_UART_TX_PARITY_CFG);
+	writel(rx_trans_cfg, uport->membase + SE_UART_RX_TRANS_CFG);
+	writel(rx_parity_cfg, uport->membase + SE_UART_RX_PARITY_CFG);
+	writel(bits_per_char, uport->membase + SE_UART_TX_WORD_LEN);
+	writel(bits_per_char, uport->membase + SE_UART_RX_WORD_LEN);
+	writel(stop_bit_len, uport->membase + SE_UART_TX_STOP_BIT_LEN);
+	writel(ser_clk_cfg, uport->membase + GENI_SER_M_CLK_CFG);
+	writel(ser_clk_cfg, uport->membase + GENI_SER_S_CLK_CFG);
 out_restart_rx:
 	qcom_geni_serial_start_rx(uport);
 }
@@ -1185,13 +1154,13 @@ static int __init qcom_geni_serial_earlycon_setup(struct earlycon_device *dev,
 	geni_se_init(&se, DEF_FIFO_DEPTH_WORDS / 2, DEF_FIFO_DEPTH_WORDS - 2);
 	geni_se_select_mode(&se, GENI_SE_FIFO);
 
-	writel_relaxed(tx_trans_cfg, uport->membase + SE_UART_TX_TRANS_CFG);
-	writel_relaxed(tx_parity_cfg, uport->membase + SE_UART_TX_PARITY_CFG);
-	writel_relaxed(rx_trans_cfg, uport->membase + SE_UART_RX_TRANS_CFG);
-	writel_relaxed(rx_parity_cfg, uport->membase + SE_UART_RX_PARITY_CFG);
-	writel_relaxed(bits_per_char, uport->membase + SE_UART_TX_WORD_LEN);
-	writel_relaxed(bits_per_char, uport->membase + SE_UART_RX_WORD_LEN);
-	writel_relaxed(stop_bit_len, uport->membase + SE_UART_TX_STOP_BIT_LEN);
+	writel(tx_trans_cfg, uport->membase + SE_UART_TX_TRANS_CFG);
+	writel(tx_parity_cfg, uport->membase + SE_UART_TX_PARITY_CFG);
+	writel(rx_trans_cfg, uport->membase + SE_UART_RX_TRANS_CFG);
+	writel(rx_parity_cfg, uport->membase + SE_UART_RX_PARITY_CFG);
+	writel(bits_per_char, uport->membase + SE_UART_TX_WORD_LEN);
+	writel(bits_per_char, uport->membase + SE_UART_RX_WORD_LEN);
+	writel(stop_bit_len, uport->membase + SE_UART_TX_STOP_BIT_LEN);
 
 	dev->con->write = qcom_geni_serial_earlycon_write;
 	dev->con->setup = NULL;
-- 
2.20.1



