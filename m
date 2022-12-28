Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9916657C0E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbiL1P2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233482AbiL1P2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:28:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE6C140CF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:28:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B805B81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85763C433D2;
        Wed, 28 Dec 2022 15:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241298;
        bh=TLzqQU6EPU+aJtQ1mQwvfFGxYgMU3QufR4hXfdO7F04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBe/KJuZ5Jyfii3NhMGLO00PwGANgiqloebfDJn0vS7GyNH2zMNCswRQ3y03Oqff+
         jqAf5URM9rja83k6+cUeAav4efM5XerXKzPIz9hwMXxlB+2VHNmGSrH7Ey5J5Ve4ao
         Ork3+EVVVE52ZxedsWhe/PPjcubaaZQ3lCxSKusE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gabriel Somlo <gsomlo@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 463/731] serial: altera_uart: fix locking in polling mode
Date:   Wed, 28 Dec 2022 15:39:30 +0100
Message-Id: <20221228144309.970565586@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Somlo <gsomlo@gmail.com>

[ Upstream commit 1307c5d33cce8a41dd77c2571e4df65a5b627feb ]

Since altera_uart_interrupt() may also be called from
a poll timer in "serving_softirq" context, use
spin_[lock_irqsave|unlock_irqrestore] variants, which
are appropriate for both softirq and hardware interrupt
contexts.

Fixes: 2f8b9c15cd88 ("altera_uart: Add support for polling mode (IRQ-less)")
Signed-off-by: Gabriel Somlo <gsomlo@gmail.com>
Link: https://lore.kernel.org/r/20221122200426.888349-1-gsomlo@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/altera_uart.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/altera_uart.c b/drivers/tty/serial/altera_uart.c
index 6e08fa11ceea..91799c420e25 100644
--- a/drivers/tty/serial/altera_uart.c
+++ b/drivers/tty/serial/altera_uart.c
@@ -278,16 +278,17 @@ static irqreturn_t altera_uart_interrupt(int irq, void *data)
 {
 	struct uart_port *port = data;
 	struct altera_uart *pp = container_of(port, struct altera_uart, port);
+	unsigned long flags;
 	unsigned int isr;
 
 	isr = altera_uart_readl(port, ALTERA_UART_STATUS_REG) & pp->imr;
 
-	spin_lock(&port->lock);
+	spin_lock_irqsave(&port->lock, flags);
 	if (isr & ALTERA_UART_STATUS_RRDY_MSK)
 		altera_uart_rx_chars(port);
 	if (isr & ALTERA_UART_STATUS_TRDY_MSK)
 		altera_uart_tx_chars(port);
-	spin_unlock(&port->lock);
+	spin_unlock_irqrestore(&port->lock, flags);
 
 	return IRQ_RETVAL(isr);
 }
-- 
2.35.1



