Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD54A66C7E5
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbjAPQf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbjAPQeg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:34:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DFE23DAA
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:22:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACAD4B80DC7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174C1C433EF;
        Mon, 16 Jan 2023 16:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886143;
        bh=JgKe15jaV9shHN3aN5fip3zQtjObwCyaBdkTTFakv3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a80LUHa7LWxtcge1J+Vb6dba39fSjtJS/ieKGOY+uqHzc13LoRL91GWjO08nIGtjE
         zSiju4FxcJMpFnshG3rC5aMF2f6rsbNYYEoELll7ZkEW/68Ac0qk8IWlT6TIZtmF1y
         P7crwBHL686FMiwyaTRwA46RZBRyQynHdHz4SYAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tobias Klauser <tklauser@distanz.ch>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 289/658] tty: serial: altera_uart_{r,t}x_chars() need only uart_port
Date:   Mon, 16 Jan 2023 16:46:17 +0100
Message-Id: <20230116154922.817477253@linuxfoundation.org>
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

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit 3af44d9bb0539d5fa27d6159d696fda5f3747bff ]

Both altera_uart_{r,t}x_chars() need only uart_port, not altera_uart. So
pass the former from altera_uart_interrupt() directly.

Apart it maybe saves a dereference, this makes the transition of
altera_uart_tx_chars() easier to follow in the next patch.

Cc: Tobias Klauser <tklauser@distanz.ch>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Acked-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20220920052049.20507-4-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1307c5d33cce ("serial: altera_uart: fix locking in polling mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/altera_uart.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/altera_uart.c b/drivers/tty/serial/altera_uart.c
index 508a3c2b7781..20c610440133 100644
--- a/drivers/tty/serial/altera_uart.c
+++ b/drivers/tty/serial/altera_uart.c
@@ -199,9 +199,8 @@ static void altera_uart_set_termios(struct uart_port *port,
 	 */
 }
 
-static void altera_uart_rx_chars(struct altera_uart *pp)
+static void altera_uart_rx_chars(struct uart_port *port)
 {
-	struct uart_port *port = &pp->port;
 	unsigned char ch, flag;
 	unsigned short status;
 
@@ -248,9 +247,8 @@ static void altera_uart_rx_chars(struct altera_uart *pp)
 	spin_lock(&port->lock);
 }
 
-static void altera_uart_tx_chars(struct altera_uart *pp)
+static void altera_uart_tx_chars(struct uart_port *port)
 {
-	struct uart_port *port = &pp->port;
 	struct circ_buf *xmit = &port->state->xmit;
 
 	if (port->x_char) {
@@ -288,9 +286,9 @@ static irqreturn_t altera_uart_interrupt(int irq, void *data)
 
 	spin_lock(&port->lock);
 	if (isr & ALTERA_UART_STATUS_RRDY_MSK)
-		altera_uart_rx_chars(pp);
+		altera_uart_rx_chars(port);
 	if (isr & ALTERA_UART_STATUS_TRDY_MSK)
-		altera_uart_tx_chars(pp);
+		altera_uart_tx_chars(port);
 	spin_unlock(&port->lock);
 
 	return IRQ_RETVAL(isr);
-- 
2.35.1



