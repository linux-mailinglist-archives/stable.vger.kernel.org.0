Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF1066C7DC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbjAPQfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbjAPQeg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:34:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F202658E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:22:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 934C160FE0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A632AC433EF;
        Mon, 16 Jan 2023 16:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886146;
        bh=ol7l/uQVlMVpFTVq/84NzuVy1FRN75bbCgRlrqurfSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wxDPU8D1Oh8w+3C8ah9nvTiR8DVSeevOlVlPp8/PVXMONJkdfHv3bSjc9RYWh6lJO
         fxLD1KG1Ptbc1RLAfKX6eaBCxAMQ1Oy9isDEcELHUmYmhhVNwD62xbs94Nt9PyO4ba
         yGpaUM7RiLNjBspKN+T7wtlvnHX5sI0KbAHJD7W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gabriel Somlo <gsomlo@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 290/658] serial: altera_uart: fix locking in polling mode
Date:   Mon, 16 Jan 2023 16:46:18 +0100
Message-Id: <20230116154922.857999692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 20c610440133..d91f76b1d353 100644
--- a/drivers/tty/serial/altera_uart.c
+++ b/drivers/tty/serial/altera_uart.c
@@ -280,16 +280,17 @@ static irqreturn_t altera_uart_interrupt(int irq, void *data)
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



