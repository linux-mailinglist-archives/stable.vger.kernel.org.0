Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C82CB11B07F
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732138AbfLKPX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:23:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:54372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732559AbfLKPXX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:23:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CEF022527;
        Wed, 11 Dec 2019 15:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077802;
        bh=Lg1GsrfLGX+N+0KkwfFNefi3f6pvzjRbCqdCVL6ExdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fHuED7j17UU0Sh4Oc2f8ReACmbxS756GNElkxk0QrnEdAhGOpo5JlkvryNniZURl5
         yPh3ufoeXZZIHeWYwBMq5r4Oo2MfKoCF9E4qVxMrq56roXRmsHR6RcwZP3vCnOTc8c
         xRD5YR8sQdDKkXULS3cmsoUhQrYqFfvYE3G7IHB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryan Case <ryandcase@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 176/243] tty: serial: qcom_geni_serial: Fix softlock
Date:   Wed, 11 Dec 2019 16:05:38 +0100
Message-Id: <20191211150351.054192812@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryan Case <ryandcase@chromium.org>

[ Upstream commit a1fee899e5bed457afc20a6a2ff3915a95cc5942 ]

Transfers were being divided into device FIFO sized (64 byte max)
operations which would poll for completion within a spin_lock_irqsave /
spin_unlock_irqrestore block. This both made things slow by waiting for
the FIFO to completely drain before adding further data and would also
result in softlocks on large transmissions.

This patch allows larger transfers with continuous FIFO additions as
space becomes available and removes polling from the interrupt handler.

Signed-off-by: Ryan Case <ryandcase@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 56 +++++++++++++++++++--------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 69b980bb8ac29..b3f7d1a1e97f8 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -113,6 +113,8 @@ struct qcom_geni_serial_port {
 	u32 *rx_fifo;
 	u32 loopback;
 	bool brk;
+
+	unsigned int tx_remaining;
 };
 
 static const struct uart_ops qcom_geni_console_pops;
@@ -435,6 +437,7 @@ static void qcom_geni_serial_console_write(struct console *co, const char *s,
 	struct qcom_geni_serial_port *port;
 	bool locked = true;
 	unsigned long flags;
+	u32 geni_status;
 
 	WARN_ON(co->index < 0 || co->index >= GENI_UART_CONS_PORTS);
 
@@ -448,6 +451,8 @@ static void qcom_geni_serial_console_write(struct console *co, const char *s,
 	else
 		spin_lock_irqsave(&uport->lock, flags);
 
+	geni_status = readl_relaxed(uport->membase + SE_GENI_STATUS);
+
 	/* Cancel the current write to log the fault */
 	if (!locked) {
 		geni_se_cancel_m_cmd(&port->se);
@@ -461,9 +466,19 @@ static void qcom_geni_serial_console_write(struct console *co, const char *s,
 		}
 		writel_relaxed(M_CMD_CANCEL_EN, uport->membase +
 							SE_GENI_M_IRQ_CLEAR);
+	} else if ((geni_status & M_GENI_CMD_ACTIVE) && !port->tx_remaining) {
+		/*
+		 * It seems we can't interrupt existing transfers if all data
+		 * has been sent, in which case we need to look for done first.
+		 */
+		qcom_geni_serial_poll_tx_done(uport);
 	}
 
 	__qcom_geni_serial_console_write(uport, s, count);
+
+	if (port->tx_remaining)
+		qcom_geni_serial_setup_tx(uport, port->tx_remaining);
+
 	if (locked)
 		spin_unlock_irqrestore(&uport->lock, flags);
 }
@@ -694,40 +709,45 @@ static void qcom_geni_serial_handle_rx(struct uart_port *uport, bool drop)
 	port->handle_rx(uport, total_bytes, drop);
 }
 
-static void qcom_geni_serial_handle_tx(struct uart_port *uport)
+static void qcom_geni_serial_handle_tx(struct uart_port *uport, bool done,
+		bool active)
 {
 	struct qcom_geni_serial_port *port = to_dev_port(uport, uport);
 	struct circ_buf *xmit = &uport->state->xmit;
 	size_t avail;
 	size_t remaining;
+	size_t pending;
 	int i;
 	u32 status;
 	unsigned int chunk;
 	int tail;
-	u32 irq_en;
 
-	chunk = uart_circ_chars_pending(xmit);
 	status = readl_relaxed(uport->membase + SE_GENI_TX_FIFO_STATUS);
-	/* Both FIFO and framework buffer are drained */
-	if (!chunk && !status) {
+
+	/* Complete the current tx command before taking newly added data */
+	if (active)
+		pending = port->tx_remaining;
+	else
+		pending = uart_circ_chars_pending(xmit);
+
+	/* All data has been transmitted and acknowledged as received */
+	if (!pending && !status && done) {
 		qcom_geni_serial_stop_tx(uport);
 		goto out_write_wakeup;
 	}
 
-	if (!uart_console(uport)) {
-		irq_en = readl_relaxed(uport->membase + SE_GENI_M_IRQ_EN);
-		irq_en &= ~(M_TX_FIFO_WATERMARK_EN);
-		writel_relaxed(0, uport->membase + SE_GENI_TX_WATERMARK_REG);
-		writel_relaxed(irq_en, uport->membase + SE_GENI_M_IRQ_EN);
-	}
+	avail = port->tx_fifo_depth - (status & TX_FIFO_WC);
+	avail *= port->tx_bytes_pw;
 
-	avail = (port->tx_fifo_depth - port->tx_wm) * port->tx_bytes_pw;
 	tail = xmit->tail;
-	chunk = min3((size_t)chunk, (size_t)(UART_XMIT_SIZE - tail), avail);
+	chunk = min3(avail, pending, (size_t)(UART_XMIT_SIZE - tail));
 	if (!chunk)
 		goto out_write_wakeup;
 
-	qcom_geni_serial_setup_tx(uport, chunk);
+	if (!port->tx_remaining) {
+		qcom_geni_serial_setup_tx(uport, pending);
+		port->tx_remaining = pending;
+	}
 
 	remaining = chunk;
 	for (i = 0; i < chunk; ) {
@@ -746,11 +766,10 @@ static void qcom_geni_serial_handle_tx(struct uart_port *uport)
 		tail += tx_bytes;
 		uport->icount.tx += tx_bytes;
 		remaining -= tx_bytes;
+		port->tx_remaining -= tx_bytes;
 	}
 
 	xmit->tail = tail & (UART_XMIT_SIZE - 1);
-	if (uart_console(uport))
-		qcom_geni_serial_poll_tx_done(uport);
 out_write_wakeup:
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(uport);
@@ -760,6 +779,7 @@ static irqreturn_t qcom_geni_serial_isr(int isr, void *dev)
 {
 	unsigned int m_irq_status;
 	unsigned int s_irq_status;
+	unsigned int geni_status;
 	struct uart_port *uport = dev;
 	unsigned long flags;
 	unsigned int m_irq_en;
@@ -773,6 +793,7 @@ static irqreturn_t qcom_geni_serial_isr(int isr, void *dev)
 	spin_lock_irqsave(&uport->lock, flags);
 	m_irq_status = readl_relaxed(uport->membase + SE_GENI_M_IRQ_STATUS);
 	s_irq_status = readl_relaxed(uport->membase + SE_GENI_S_IRQ_STATUS);
+	geni_status = readl_relaxed(uport->membase + SE_GENI_STATUS);
 	m_irq_en = readl_relaxed(uport->membase + SE_GENI_M_IRQ_EN);
 	writel_relaxed(m_irq_status, uport->membase + SE_GENI_M_IRQ_CLEAR);
 	writel_relaxed(s_irq_status, uport->membase + SE_GENI_S_IRQ_CLEAR);
@@ -787,7 +808,8 @@ static irqreturn_t qcom_geni_serial_isr(int isr, void *dev)
 
 	if (m_irq_status & (M_TX_FIFO_WATERMARK_EN | M_CMD_DONE_EN) &&
 	    m_irq_en & (M_TX_FIFO_WATERMARK_EN | M_CMD_DONE_EN))
-		qcom_geni_serial_handle_tx(uport);
+		qcom_geni_serial_handle_tx(uport, m_irq_status & M_CMD_DONE_EN,
+					geni_status & M_GENI_CMD_ACTIVE);
 
 	if (s_irq_status & S_GP_IRQ_0_EN || s_irq_status & S_GP_IRQ_1_EN) {
 		if (s_irq_status & S_GP_IRQ_0_EN)
-- 
2.20.1



