Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9623C4ADB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240392AbhGLGyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:54:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239386AbhGLGwu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:52:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA069608FE;
        Mon, 12 Jul 2021 06:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072602;
        bh=37jubKHrX9AAPncdNUwS8cXQD9ZifQv4/JTpfQpsaow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1eWAwYeitR+GAZW1uOG8A2mimh9H1qqgmJwJYY0giOrBktFgUofra8/ZRt/XtVbd
         ehrNQUlvBRHf/dWklLOVGiIm0nFYJFIWaSm2Q9tPswnLu/YFkir+3uDQ6bHEHG88Lf
         +5Pjt2Bs1EVjJHMYWC1VqaunkZTjEscPXkBsju8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 551/593] serial: 8250: 8250_omap: Disable RX interrupt after DMA enable
Date:   Mon, 12 Jul 2021 08:11:51 +0200
Message-Id: <20210712060954.967514563@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit 439c7183e5b97952bba1747f5ffc4dea45a6a18b ]

UARTs on TI SoCs prior to J7200 don't provide independent control over
RX FIFO not empty interrupt (RHR_IT) and RX timeout interrupt.
Starting with J7200 SoC, its possible to disable RHR_IT independent of
RX timeout interrupt using bit 2 of IER2 register. So disable RHR_IT
once RX DMA is started so as to avoid spurious interrupt being raised
when data is in the RX FIFO but is yet to be drained by DMA (a known
errata in older SoCs).

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20201029051930.7097-1-vigneshr@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 42 ++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index f284c6f77a6c..a9cfe1c57642 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -27,6 +27,7 @@
 #include <linux/pm_qos.h>
 #include <linux/pm_wakeirq.h>
 #include <linux/dma-mapping.h>
+#include <linux/sys_soc.h>
 
 #include "8250.h"
 
@@ -41,6 +42,7 @@
  */
 #define UART_ERRATA_CLOCK_DISABLE	(1 << 3)
 #define	UART_HAS_EFR2			BIT(4)
+#define UART_HAS_RHR_IT_DIS		BIT(5)
 
 #define OMAP_UART_FCR_RX_TRIG		6
 #define OMAP_UART_FCR_TX_TRIG		4
@@ -94,6 +96,10 @@
 #define OMAP_UART_REV_52 0x0502
 #define OMAP_UART_REV_63 0x0603
 
+/* Interrupt Enable Register 2 */
+#define UART_OMAP_IER2			0x1B
+#define UART_OMAP_IER2_RHR_IT_DIS	BIT(2)
+
 /* Enhanced features register 2 */
 #define UART_OMAP_EFR2			0x23
 #define UART_OMAP_EFR2_TIMEOUT_BEHAVE	BIT(6)
@@ -756,17 +762,27 @@ static void __dma_rx_do_complete(struct uart_8250_port *p)
 {
 	struct uart_8250_dma    *dma = p->dma;
 	struct tty_port         *tty_port = &p->port.state->port;
+	struct omap8250_priv	*priv = p->port.private_data;
 	struct dma_chan		*rxchan = dma->rxchan;
 	dma_cookie_t		cookie;
 	struct dma_tx_state     state;
 	int                     count;
 	int			ret;
+	u32			reg;
 
 	if (!dma->rx_running)
 		goto out;
 
 	cookie = dma->rx_cookie;
 	dma->rx_running = 0;
+
+	/* Re-enable RX FIFO interrupt now that transfer is complete */
+	if (priv->habit & UART_HAS_RHR_IT_DIS) {
+		reg = serial_in(p, UART_OMAP_IER2);
+		reg &= ~UART_OMAP_IER2_RHR_IT_DIS;
+		serial_out(p, UART_OMAP_IER2, UART_OMAP_IER2_RHR_IT_DIS);
+	}
+
 	dmaengine_tx_status(rxchan, cookie, &state);
 
 	count = dma->rx_size - state.residue + state.in_flight_bytes;
@@ -862,6 +878,7 @@ static int omap_8250_rx_dma(struct uart_8250_port *p)
 	int				err = 0;
 	struct dma_async_tx_descriptor  *desc;
 	unsigned long			flags;
+	u32				reg;
 
 	if (priv->rx_dma_broken)
 		return -EINVAL;
@@ -897,6 +914,17 @@ static int omap_8250_rx_dma(struct uart_8250_port *p)
 
 	dma->rx_cookie = dmaengine_submit(desc);
 
+	/*
+	 * Disable RX FIFO interrupt while RX DMA is enabled, else
+	 * spurious interrupt may be raised when data is in the RX FIFO
+	 * but is yet to be drained by DMA.
+	 */
+	if (priv->habit & UART_HAS_RHR_IT_DIS) {
+		reg = serial_in(p, UART_OMAP_IER2);
+		reg |= UART_OMAP_IER2_RHR_IT_DIS;
+		serial_out(p, UART_OMAP_IER2, UART_OMAP_IER2_RHR_IT_DIS);
+	}
+
 	dma_async_issue_pending(dma->rxchan);
 out:
 	spin_unlock_irqrestore(&priv->rx_dma_lock, flags);
@@ -1163,6 +1191,11 @@ static int omap8250_no_handle_irq(struct uart_port *port)
 	return 0;
 }
 
+static const struct soc_device_attribute k3_soc_devices[] = {
+	{ .family = "AM65X",  },
+	{ .family = "J721E", .revision = "SR1.0" },
+};
+
 static struct omap8250_dma_params am654_dma = {
 	.rx_size = SZ_2K,
 	.rx_trigger = 1,
@@ -1177,7 +1210,7 @@ static struct omap8250_dma_params am33xx_dma = {
 
 static struct omap8250_platdata am654_platdata = {
 	.dma_params	= &am654_dma,
-	.habit		= UART_HAS_EFR2,
+	.habit		= UART_HAS_EFR2 | UART_HAS_RHR_IT_DIS,
 };
 
 static struct omap8250_platdata am33xx_platdata = {
@@ -1367,6 +1400,13 @@ static int omap8250_probe(struct platform_device *pdev)
 			up.dma->rxconf.src_maxburst = RX_TRIGGER;
 			up.dma->txconf.dst_maxburst = TX_TRIGGER;
 		}
+
+		/*
+		 * AM65x SR1.0, AM65x SR2.0 and J721e SR1.0 don't
+		 * don't have RHR_IT_DIS bit in IER2 register
+		 */
+		if (soc_device_match(k3_soc_devices))
+			priv->habit &= ~UART_HAS_RHR_IT_DIS;
 	}
 #endif
 	ret = serial8250_register_8250_port(&up);
-- 
2.30.2



