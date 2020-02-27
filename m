Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 522F8171BB2
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387635AbgB0OEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:04:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:41220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733179AbgB0OEq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:04:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABAAE20578;
        Thu, 27 Feb 2020 14:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812286;
        bh=WeAnVRuT+eJ3/I9Ri+fo4SZBU5CHsbAcXpVA/xFFqgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0huLFyY3fyGwoKjOF4N5yGUpKVp1FfCTQczdWoUiJZl5O9j++fn4uC450A54wurEE
         UbbHho6RcZAsmP3negYi5wb6A1MYNDoIlpZeqI3IP7cYc58Z0BXlukLUwLnoknvFyq
         FOw6VzUkhXXuRz2inNH68DqxKVYZA9cBTovYK4+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryan Case <ryandcase@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 55/97] tty: serial: qcom_geni_serial: Remove interrupt storm
Date:   Thu, 27 Feb 2020 14:37:03 +0100
Message-Id: <20200227132223.560905310@linuxfoundation.org>
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

[ Upstream commit 64a428077758383518c258641e81d57fcd454792 ]

Disable M_TX_FIFO_WATERMARK_EN after we've sent all data for a given
transaction so we don't continue to receive a flurry of free space
interrupts while waiting for the M_CMD_DONE notification. Re-enable the
watermark when establishing the next transaction.

Also clear the watermark interrupt after filling the FIFO so we do not
receive notification again prior to actually having free space.

Signed-off-by: Ryan Case <ryandcase@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 2003dfcace5d8..743d877e7ff94 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -727,6 +727,7 @@ static void qcom_geni_serial_handle_tx(struct uart_port *uport, bool done,
 	size_t pending;
 	int i;
 	u32 status;
+	u32 irq_en;
 	unsigned int chunk;
 	int tail;
 
@@ -755,6 +756,11 @@ static void qcom_geni_serial_handle_tx(struct uart_port *uport, bool done,
 	if (!port->tx_remaining) {
 		qcom_geni_serial_setup_tx(uport, pending);
 		port->tx_remaining = pending;
+
+		irq_en = readl_relaxed(uport->membase + SE_GENI_M_IRQ_EN);
+		if (!(irq_en & M_TX_FIFO_WATERMARK_EN))
+			writel_relaxed(irq_en | M_TX_FIFO_WATERMARK_EN,
+					uport->membase + SE_GENI_M_IRQ_EN);
 	}
 
 	remaining = chunk;
@@ -778,7 +784,23 @@ static void qcom_geni_serial_handle_tx(struct uart_port *uport, bool done,
 	}
 
 	xmit->tail = tail & (UART_XMIT_SIZE - 1);
+
+	/*
+	 * The tx fifo watermark is level triggered and latched. Though we had
+	 * cleared it in qcom_geni_serial_isr it will have already reasserted
+	 * so we must clear it again here after our writes.
+	 */
+	writel_relaxed(M_TX_FIFO_WATERMARK_EN,
+			uport->membase + SE_GENI_M_IRQ_CLEAR);
+
 out_write_wakeup:
+	if (!port->tx_remaining) {
+		irq_en = readl_relaxed(uport->membase + SE_GENI_M_IRQ_EN);
+		if (irq_en & M_TX_FIFO_WATERMARK_EN)
+			writel_relaxed(irq_en & ~M_TX_FIFO_WATERMARK_EN,
+					uport->membase + SE_GENI_M_IRQ_EN);
+	}
+
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(uport);
 }
@@ -814,8 +836,7 @@ static irqreturn_t qcom_geni_serial_isr(int isr, void *dev)
 		tty_insert_flip_char(tport, 0, TTY_OVERRUN);
 	}
 
-	if (m_irq_status & (M_TX_FIFO_WATERMARK_EN | M_CMD_DONE_EN) &&
-	    m_irq_en & (M_TX_FIFO_WATERMARK_EN | M_CMD_DONE_EN))
+	if (m_irq_status & m_irq_en & (M_TX_FIFO_WATERMARK_EN | M_CMD_DONE_EN))
 		qcom_geni_serial_handle_tx(uport, m_irq_status & M_CMD_DONE_EN,
 					geni_status & M_GENI_CMD_ACTIVE);
 
-- 
2.20.1



