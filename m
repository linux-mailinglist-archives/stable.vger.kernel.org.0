Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AB727C404
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgI2LKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728681AbgI2LJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:09:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA55121D7F;
        Tue, 29 Sep 2020 11:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377797;
        bh=HxKxLArqv0zTXU/qx0NU1qQYE/H9Vb0E6/1RbvoyXo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHQL/P33+4CpusKumvsfrmzwGwQ1KFreK90RWdDqWMMrxsiBo3WcmvkqxO9yoFlhC
         yX3jgvSjpleSqzL7NnvY9A+IeubO+s9NmaLm2V9OSDlbNd185DzRoQIT1pI6VsJG6i
         VVH/7kgbrilUoihAbIOrEOEPQHmm4l+qaUa66TtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Francois Dagenais <jeff.dagenais@gmail.com>,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Subject: [PATCH 4.9 075/121] serial: uartps: Add a timeout to the tx empty wait
Date:   Tue, 29 Sep 2020 13:00:19 +0200
Message-Id: <20200929105933.897487544@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>

commit 277375b864e8147975b064b513f491e2a910e66a upstream.

In case the cable is not connected then the target gets into
an infinite wait for tx empty.
Add a timeout to the tx empty wait.

Reported-by: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/xilinx_uartps.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -30,6 +30,7 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/module.h>
+#include <linux/iopoll.h>
 
 #define CDNS_UART_TTY_NAME	"ttyPS"
 #define CDNS_UART_NAME		"xuartps"
@@ -38,6 +39,7 @@
 #define CDNS_UART_NR_PORTS	2
 #define CDNS_UART_FIFO_SIZE	64	/* FIFO size */
 #define CDNS_UART_REGISTER_SPACE	0x1000
+#define TX_TIMEOUT		500000
 
 /* Rx Trigger level */
 static int rx_trigger_level = 56;
@@ -681,16 +683,20 @@ static void cdns_uart_set_termios(struct
 	unsigned int cval = 0;
 	unsigned int baud, minbaud, maxbaud;
 	unsigned long flags;
-	unsigned int ctrl_reg, mode_reg;
+	unsigned int ctrl_reg, mode_reg, val;
+	int err;
 
 	spin_lock_irqsave(&port->lock, flags);
 
 	/* Wait for the transmit FIFO to empty before making changes */
 	if (!(readl(port->membase + CDNS_UART_CR) &
 				CDNS_UART_CR_TX_DIS)) {
-		while (!(readl(port->membase + CDNS_UART_SR) &
-				CDNS_UART_SR_TXEMPTY)) {
-			cpu_relax();
+		err = readl_poll_timeout(port->membase + CDNS_UART_SR,
+					 val, (val & CDNS_UART_SR_TXEMPTY),
+					 1000, TX_TIMEOUT);
+		if (err) {
+			dev_err(port->dev, "timed out waiting for tx empty");
+			return;
 		}
 	}
 


