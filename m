Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34FF34423D
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhCVMjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231616AbhCVMiU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:38:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D37B8619A4;
        Mon, 22 Mar 2021 12:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416649;
        bh=GZICHe75+Nos1+a3Rz1pOMsaG9meol6RBYOP7c0EhNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjLmC9hJyuLtic9Dzv92NWGwrLkzhwWAyD53jovG4jySCPH7hTzOHm5x4PNz3KE5W
         KeWtTunbldXcVYqqoFQWr+JDw19FI307Kqx32LfWmrcxomwi7R/2sv1XB8lJFqVEcY
         o/S57xKc9p/Q/IfqCy/8Q2KxuqiD870+HYd+KwrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/157] serial: stm32: fix DMA initialization error handling
Date:   Mon, 22 Mar 2021 13:27:03 +0100
Message-Id: <20210322121935.860218813@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erwan Le Ray <erwan.leray@foss.st.com>

[ Upstream commit e7997f7ff7f8154d477f6f976698d868a2ac3934 ]

DMA initialization error handling is not properly implemented in the
driver.
Fix DMA initialization error handling by:
- moving TX DMA descriptor request error handling in a new dedicated
fallback_err label
- adding error handling to TX DMA descriptor submission
- adding error handling to RX DMA descriptor submission

This patch depends on '24832ca3ee85 ("tty: serial: stm32-usart: Remove set
but unused 'cookie' variables")' which unfortunately doesn't include a
"Fixes" tag.

Fixes: 3489187204eb ("serial: stm32: adding dma support")
Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Link: https://lore.kernel.org/r/20210106162203.28854-2-erwan.leray@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index f4de32d3f2af..6248304a001f 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -383,17 +383,18 @@ static void stm32_transmit_chars_dma(struct uart_port *port)
 					   DMA_MEM_TO_DEV,
 					   DMA_PREP_INTERRUPT);
 
-	if (!desc) {
-		for (i = count; i > 0; i--)
-			stm32_transmit_chars_pio(port);
-		return;
-	}
+	if (!desc)
+		goto fallback_err;
 
 	desc->callback = stm32_tx_dma_complete;
 	desc->callback_param = port;
 
 	/* Push current DMA TX transaction in the pending queue */
-	dmaengine_submit(desc);
+	if (dma_submit_error(dmaengine_submit(desc))) {
+		/* dma no yet started, safe to free resources */
+		dmaengine_terminate_async(stm32port->tx_ch);
+		goto fallback_err;
+	}
 
 	/* Issue pending DMA TX requests */
 	dma_async_issue_pending(stm32port->tx_ch);
@@ -402,6 +403,11 @@ static void stm32_transmit_chars_dma(struct uart_port *port)
 
 	xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
 	port->icount.tx += count;
+	return;
+
+fallback_err:
+	for (i = count; i > 0; i--)
+		stm32_transmit_chars_pio(port);
 }
 
 static void stm32_transmit_chars(struct uart_port *port)
@@ -1130,7 +1136,11 @@ static int stm32_of_dma_rx_probe(struct stm32_port *stm32port,
 	desc->callback_param = NULL;
 
 	/* Push current DMA transaction in the pending queue */
-	dmaengine_submit(desc);
+	ret = dma_submit_error(dmaengine_submit(desc));
+	if (ret) {
+		dmaengine_terminate_sync(stm32port->rx_ch);
+		goto config_err;
+	}
 
 	/* Issue pending DMA requests */
 	dma_async_issue_pending(stm32port->rx_ch);
-- 
2.30.1



