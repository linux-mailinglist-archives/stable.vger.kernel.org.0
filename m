Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D91499386
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346454AbiAXUed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51996 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382985AbiAXU0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:26:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 091656150F;
        Mon, 24 Jan 2022 20:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5F2C340E5;
        Mon, 24 Jan 2022 20:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055993;
        bh=uPoj56l//6ep58k5qjt+4b1ScvoN02nYEnT+UKSM9AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1YrIt57k9G2DyAWfW1yxW/P/bGc0YpSSPJC6Qg7hhBMJTyA/PpyQXo27JkL85317
         kMqAt2+nZ5VX8qxtxPLTltSxLvLPdUSLAj+wplJYuSsMHryrCIjmI+aONdMxCYE0oV
         S5v1h/eBt/xCMeGmt/aNSn7tQYimQguIt42fWwNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Valentin Caron <valentin.caron@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 335/846] serial: stm32: move tx dma terminate DMA to shutdown
Date:   Mon, 24 Jan 2022 19:37:32 +0100
Message-Id: <20220124184112.478807405@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Caron <valentin.caron@foss.st.com>

[ Upstream commit 56a23f9319e86e1d62a109896e2c7e52c414e67d ]

Terminate DMA transaction and clear CR3_DMAT when shutdown is requested,
instead of when remove is requested. If DMA transfer is not stopped in
shutdown ops, driver will fail to start a new DMA transfer after next
startup ops.

Fixes: 3489187204eb ("serial: stm32: adding dma support")
Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Signed-off-by: Valentin Caron <valentin.caron@foss.st.com>
Link: https://lore.kernel.org/r/20220104182445.4195-2-valentin.caron@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 8f032e77b954a..3366914dad7a8 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -691,6 +691,11 @@ static void stm32_usart_shutdown(struct uart_port *port)
 	u32 val, isr;
 	int ret;
 
+	if (stm32_port->tx_dma_busy) {
+		dmaengine_terminate_async(stm32_port->tx_ch);
+		stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
+	}
+
 	/* Disable modem control interrupts */
 	stm32_usart_disable_ms(port);
 
@@ -1385,7 +1390,6 @@ static int stm32_usart_serial_remove(struct platform_device *pdev)
 	stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAR);
 
 	if (stm32_port->tx_ch) {
-		dmaengine_terminate_async(stm32_port->tx_ch);
 		stm32_usart_of_dma_tx_remove(stm32_port, pdev);
 		dma_release_channel(stm32_port->tx_ch);
 	}
-- 
2.34.1



