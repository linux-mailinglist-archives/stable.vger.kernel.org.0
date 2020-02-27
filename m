Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 208DF171BEA
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387405AbgB0OGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:06:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387598AbgB0OGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:06:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FC5F20578;
        Thu, 27 Feb 2020 14:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812412;
        bh=8xjQQ0YhFjU5P9RymGIDkr/KwUaQQ8iwiQv/6zyt+FM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBI1t4CQZEjJeh+zi7GQMg27FIY1X4Ix4hXfuVD5FYRhsfPKYxssrRjqs/qXs7XjY
         T7+npKeiZsYHpuKbtc+FJ6qhH85HjIn3mCBQrC/bL7rJ/K6ExANyyPFgvw0myAlj+Z
         6nz/68gc5A1tQlPrjSwgjvPlHHF6rX9PDKek5GUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, satya priya <skakit@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 59/97] tty: serial: qcom_geni_serial: Fix RX cancel command failure
Date:   Thu, 27 Feb 2020 14:37:07 +0100
Message-Id: <20200227132224.186889698@linuxfoundation.org>
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

From: satya priya <skakit@codeaurora.org>

[ Upstream commit 679aac5ead2f18d223554a52b543e1195e181811 ]

RX cancel command fails when BT is switched on and off multiple times.

To handle this, poll for the cancel bit in SE_GENI_S_IRQ_STATUS register
instead of SE_GENI_S_CMD_CTRL_REG.

As per the HPG update, handle the RX last bit after cancel command
and flush out the RX FIFO buffer.

Signed-off-by: satya priya <skakit@codeaurora.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1581415982-8793-1-git-send-email-skakit@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 4182129925dec..4458419f053b6 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -121,6 +121,7 @@ static int handle_rx_console(struct uart_port *uport, u32 bytes, bool drop);
 static int handle_rx_uart(struct uart_port *uport, u32 bytes, bool drop);
 static unsigned int qcom_geni_serial_tx_empty(struct uart_port *port);
 static void qcom_geni_serial_stop_rx(struct uart_port *uport);
+static void qcom_geni_serial_handle_rx(struct uart_port *uport, bool drop);
 
 static const unsigned long root_freq[] = {7372800, 14745600, 19200000, 29491200,
 					32000000, 48000000, 64000000, 80000000,
@@ -614,7 +615,7 @@ static void qcom_geni_serial_stop_rx(struct uart_port *uport)
 	u32 irq_en;
 	u32 status;
 	struct qcom_geni_serial_port *port = to_dev_port(uport, uport);
-	u32 irq_clear = S_CMD_DONE_EN;
+	u32 s_irq_status;
 
 	irq_en = readl(uport->membase + SE_GENI_S_IRQ_EN);
 	irq_en &= ~(S_RX_FIFO_WATERMARK_EN | S_RX_FIFO_LAST_EN);
@@ -630,10 +631,19 @@ static void qcom_geni_serial_stop_rx(struct uart_port *uport)
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
2.20.1



