Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E013C5089
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243282AbhGLHdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343701AbhGLH2r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:28:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA252613B2;
        Mon, 12 Jul 2021 07:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074660;
        bh=5giSapIWNfVJNm5RH03Eqhjq3fxDKyBMJtCGcCWePoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LxtPdoYUdLcf10uw8bxznH6DlGf2DAfiFX8MbusaY5jm5hHIfn17TH/YeswfquW/m
         W+RY+cm5xXi09NS09GsGRDwFzb2GJL3uwLnR8RS6qIqj5TogUN8prODHzslKKFy62e
         mBlJYSAxAODvd18wOhaZOyfZDfXiV63pS8JMqcR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 653/700] serial: 8250: 8250_omap: Fix possible interrupt storm on K3 SoCs
Date:   Mon, 12 Jul 2021 08:12:16 +0200
Message-Id: <20210712061045.322229220@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit b67e830d38fa9335d927fe67e812e3ed81b4689c ]

On K3 family of SoCs (which includes AM654 SoC), it is observed that RX
TIMEOUT is signalled after RX FIFO has been drained, in which case a
dummy read of RX FIFO is required to clear RX TIMEOUT condition.
Otherwise, this would lead to an interrupt storm.

Fix this by introducing UART_RX_TIMEOUT_QUIRK flag and doing a dummy
read in IRQ handler when RX TIMEOUT is reported with no data in RX FIFO.

Fixes: be70874498f3 ("serial: 8250_omap: Add support for AM654 UART controller")
Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Tested-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20210622145704.11168-1-vigneshr@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 3161d3655670..c37468887fd2 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -43,6 +43,7 @@
 #define UART_ERRATA_CLOCK_DISABLE	(1 << 3)
 #define	UART_HAS_EFR2			BIT(4)
 #define UART_HAS_RHR_IT_DIS		BIT(5)
+#define UART_RX_TIMEOUT_QUIRK		BIT(6)
 
 #define OMAP_UART_FCR_RX_TRIG		6
 #define OMAP_UART_FCR_TX_TRIG		4
@@ -104,6 +105,9 @@
 #define UART_OMAP_EFR2			0x23
 #define UART_OMAP_EFR2_TIMEOUT_BEHAVE	BIT(6)
 
+/* RX FIFO occupancy indicator */
+#define UART_OMAP_RX_LVL		0x64
+
 struct omap8250_priv {
 	int line;
 	u8 habit;
@@ -611,6 +615,7 @@ static int omap_8250_dma_handle_irq(struct uart_port *port);
 static irqreturn_t omap8250_irq(int irq, void *dev_id)
 {
 	struct uart_port *port = dev_id;
+	struct omap8250_priv *priv = port->private_data;
 	struct uart_8250_port *up = up_to_u8250p(port);
 	unsigned int iir;
 	int ret;
@@ -625,6 +630,18 @@ static irqreturn_t omap8250_irq(int irq, void *dev_id)
 	serial8250_rpm_get(up);
 	iir = serial_port_in(port, UART_IIR);
 	ret = serial8250_handle_irq(port, iir);
+
+	/*
+	 * On K3 SoCs, it is observed that RX TIMEOUT is signalled after
+	 * FIFO has been drained, in which case a dummy read of RX FIFO
+	 * is required to clear RX TIMEOUT condition.
+	 */
+	if (priv->habit & UART_RX_TIMEOUT_QUIRK &&
+	    (iir & UART_IIR_RX_TIMEOUT) == UART_IIR_RX_TIMEOUT &&
+	    serial_port_in(port, UART_OMAP_RX_LVL) == 0) {
+		serial_port_in(port, UART_RX);
+	}
+
 	serial8250_rpm_put(up);
 
 	return IRQ_RETVAL(ret);
@@ -1218,7 +1235,8 @@ static struct omap8250_dma_params am33xx_dma = {
 
 static struct omap8250_platdata am654_platdata = {
 	.dma_params	= &am654_dma,
-	.habit		= UART_HAS_EFR2 | UART_HAS_RHR_IT_DIS,
+	.habit		= UART_HAS_EFR2 | UART_HAS_RHR_IT_DIS |
+			  UART_RX_TIMEOUT_QUIRK,
 };
 
 static struct omap8250_platdata am33xx_platdata = {
-- 
2.30.2



