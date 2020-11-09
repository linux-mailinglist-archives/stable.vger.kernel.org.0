Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5855D2ABA01
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733228AbgKINOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:14:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730936AbgKINOq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:14:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12AEF20663;
        Mon,  9 Nov 2020 13:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927685;
        bh=+ygSuQHw3/v88x5CVHerg+ymLJphdgbHYhg9SSG8rZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJYvAx5cHrXZKujnuaf22WNHnnX4B7vkV/VRpIuesuWZdKw/uGd1+V3+8Pw3s4nhn
         QWWLKYf+rsz3H3OvI81okrSN2061yC7Cj9FcGNc+LvvDL2tb1GHuL6uvgjrklNzzNq
         fSe2su2Y+ZxlgB1z6uddiVMYyL0p8phqHdip7gOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH 5.4 73/85] tty: serial: fsl_lpuart: add LS1028A support
Date:   Mon,  9 Nov 2020 13:56:10 +0100
Message-Id: <20201109125026.083533458@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

commit c2f448cff22a7ed09281f02bde084b0ce3bc61ed upstream.

The LS1028A uses little endian register access and has a different FIFO
size encoding.

Signed-off-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20200306214433.23215-4-michael@walle.cc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/fsl_lpuart.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -238,6 +238,7 @@ static DEFINE_IDA(fsl_lpuart_ida);
 enum lpuart_type {
 	VF610_LPUART,
 	LS1021A_LPUART,
+	LS1028A_LPUART,
 	IMX7ULP_LPUART,
 	IMX8QXP_LPUART,
 };
@@ -282,11 +283,16 @@ static const struct lpuart_soc_data vf_d
 	.iotype = UPIO_MEM,
 };
 
-static const struct lpuart_soc_data ls_data = {
+static const struct lpuart_soc_data ls1021a_data = {
 	.devtype = LS1021A_LPUART,
 	.iotype = UPIO_MEM32BE,
 };
 
+static const struct lpuart_soc_data ls1028a_data = {
+	.devtype = LS1028A_LPUART,
+	.iotype = UPIO_MEM32,
+};
+
 static struct lpuart_soc_data imx7ulp_data = {
 	.devtype = IMX7ULP_LPUART,
 	.iotype = UPIO_MEM32,
@@ -301,7 +307,8 @@ static struct lpuart_soc_data imx8qxp_da
 
 static const struct of_device_id lpuart_dt_ids[] = {
 	{ .compatible = "fsl,vf610-lpuart",	.data = &vf_data, },
-	{ .compatible = "fsl,ls1021a-lpuart",	.data = &ls_data, },
+	{ .compatible = "fsl,ls1021a-lpuart",	.data = &ls1021a_data, },
+	{ .compatible = "fsl,ls1028a-lpuart",	.data = &ls1028a_data, },
 	{ .compatible = "fsl,imx7ulp-lpuart",	.data = &imx7ulp_data, },
 	{ .compatible = "fsl,imx8qxp-lpuart",	.data = &imx8qxp_data, },
 	{ /* sentinel */ }
@@ -311,6 +318,11 @@ MODULE_DEVICE_TABLE(of, lpuart_dt_ids);
 /* Forward declare this for the dma callbacks*/
 static void lpuart_dma_tx_complete(void *arg);
 
+static inline bool is_ls1028a_lpuart(struct lpuart_port *sport)
+{
+	return sport->devtype == LS1028A_LPUART;
+}
+
 static inline bool is_imx8qxp_lpuart(struct lpuart_port *sport)
 {
 	return sport->devtype == IMX8QXP_LPUART;
@@ -1553,6 +1565,17 @@ static int lpuart32_startup(struct uart_
 	sport->rxfifo_size = UARTFIFO_DEPTH((temp >> UARTFIFO_RXSIZE_OFF) &
 					    UARTFIFO_FIFOSIZE_MASK);
 
+	/*
+	 * The LS1028A has a fixed length of 16 words. Although it supports the
+	 * RX/TXSIZE fields their encoding is different. Eg the reference manual
+	 * states 0b101 is 16 words.
+	 */
+	if (is_ls1028a_lpuart(sport)) {
+		sport->rxfifo_size = 16;
+		sport->txfifo_size = 16;
+		sport->port.fifosize = sport->txfifo_size;
+	}
+
 	spin_lock_irqsave(&sport->port.lock, flags);
 
 	lpuart32_setup_watermark_enable(sport);


