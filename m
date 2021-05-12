Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9489137C7DE
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236392AbhELQDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:03:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238207AbhELP5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B573861942;
        Wed, 12 May 2021 15:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833454;
        bh=LcztlVqMIhmWJjoDruzZwUsYIlHKjCofS74neo4ix3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIKo9chQlGY6+duwz+EXB+eR4YMVn0Dnxq2NUpXhLr4YTxwSgLsD6eQWQ79ZVHZRa
         zAfQi+E/OHJIhoIK36XePDOa7RVvGoSUtFYVSRrMEnVezEzEj2Z0yW6eYOLZu5/y9k
         OvbRRAnGZx+/Vs4Irb2Sk7N3ferO6soRWOESilDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 157/601] serial: stm32: add FIFO flush when port is closed
Date:   Wed, 12 May 2021 16:43:54 +0200
Message-Id: <20210512144832.999552754@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index 6788fb3af6cb..cb8c2bece6d6 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -689,6 +689,11 @@ static void stm32_usart_shutdown(struct uart_port *port)
 	if (ret)
 		dev_err(port->dev, "transmission complete not set\n");
 
+	/* flush RX & TX FIFO */
+	if (ofs->rqr != UNDEF_REG)
+		writel_relaxed(USART_RQR_TXFRQ | USART_RQR_RXFRQ,
+			       port->membase + ofs->rqr);
+
 	stm32_usart_clr_bits(port, ofs->cr1, val);
 
 	free_irq(port->irq, port);
-- 
2.30.2



