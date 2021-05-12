Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4068B37CBD7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237591AbhELQiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:38:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236450AbhELQ3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:29:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C42361353;
        Wed, 12 May 2021 15:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835005;
        bh=pUW+uy/EbG8u/g2VfSdmXn8uvH4oH94jims3k28uwVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VAOOojWOBOudO9EE/iujyXgFTuKHf5lw1qj4nbDP1PajHJFhfrYBKIdxnHG+QSLdE
         I2jVMCqTOo7NZS8u+MeGODBcpz8aTFS1+znoz6TwDh+0pfLODFMYQV8m/UTQH9RLYe
         WjbBnLd2oN+UHlzVb5Nfv22IJMzW1m0o9qhpjCTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 170/677] serial: stm32: add FIFO flush when port is closed
Date:   Wed, 12 May 2021 16:43:36 +0200
Message-Id: <20210512144842.887154298@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erwan Le Ray <erwan.leray@foss.st.com>

[ Upstream commit 9f77d19207a0e8ba814c8ceb22e90ce7cb2aef64 ]

Transmission complete error is sent when ISR_TC is not set. If port closure
is requested despite data in TDR / TX FIFO has not been sent (because of
flow control), ISR_TC is not set and error message is sent on port closure
but also when a new port is opened.

Flush the data when port is closed, so the error isn't printed twice upon
next port opening.

Fixes: 64c32eab6603 ("serial: stm32: Add support of TC bit status check")
Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Link: https://lore.kernel.org/r/20210304162308.8984-12-erwan.leray@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 183c76ddb165..d205fce1950a 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -691,6 +691,11 @@ static void stm32_usart_shutdown(struct uart_port *port)
 	if (ret)
 		dev_err(port->dev, "Transmission is not complete\n");
 
+	/* flush RX & TX FIFO */
+	if (ofs->rqr != UNDEF_REG)
+		writel_relaxed(USART_RQR_TXFRQ | USART_RQR_RXFRQ,
+			       port->membase + ofs->rqr);
+
 	stm32_usart_clr_bits(port, ofs->cr1, val);
 
 	free_irq(port->irq, port);
-- 
2.30.2



