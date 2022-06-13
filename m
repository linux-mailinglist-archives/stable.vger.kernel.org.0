Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D75F548A7E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348849AbiFMK4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350199AbiFMKyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:54:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C55FC;
        Mon, 13 Jun 2022 03:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C866FB80E95;
        Mon, 13 Jun 2022 10:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B952C34114;
        Mon, 13 Jun 2022 10:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116209;
        bh=1bHKVpQyhEW1w0URJKjGqU3yZrzSpBsz2kNzQOdOcTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYOM0I/DU2P8Y3AbvR5QZVHxyRmb7t4V7ik9c4q38MT9qtEC1odK9wO1ctKPP0bsD
         lxoUkfQNrqNK/Dxk61y9Ol0V3RZyd2GpscBWif4IZvGyu1owemwNfVdZxTwhpJK5YN
         n77JWvoJMjSpaGjrDRcWiKSR3VjQarT9JNxRAsn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Petr Mladek <pmladek@suse.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        John Ogness <john.ogness@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 151/218] serial: meson: acquire port->lock in startup()
Date:   Mon, 13 Jun 2022 12:10:09 +0200
Message-Id: <20220613094925.171526660@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 589f892ac8ef244e47c5a00ffd8605daa1eaef8e ]

The uart_ops startup() callback is called without interrupts
disabled and without port->lock locked, relatively late during the
boot process (from the call path of console_on_rootfs()). If the
device is a console, it was already previously registered and could
be actively printing messages.

Since the startup() callback is reading/writing registers used by
the console write() callback (AML_UART_CONTROL), its access must
be synchronized using the port->lock. Currently it is not.

The startup() callback is the only function that explicitly enables
interrupts. Without the synchronization, it is possible that
interrupts become accidentally permanently disabled.

CPU0                           CPU1
meson_serial_console_write     meson_uart_startup
--------------------------     ------------------
spin_lock(port->lock)
val = readl(AML_UART_CONTROL)
uart_console_write()
                               writel(INT_EN, AML_UART_CONTROL)
writel(val, AML_UART_CONTROL)
spin_unlock(port->lock)

Add port->lock synchronization to meson_uart_startup() to avoid
racing with meson_serial_console_write().

Also add detailed comments to meson_uart_reset() explaining why it
is *not* using port->lock synchronization.

Link: https://lore.kernel.org/lkml/2a82eae7-a256-f70c-fd82-4e510750906e@samsung.com
Fixes: ff7693d079e5 ("ARM: meson: serial: add MesonX SoC on-chip uart driver")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Link: https://lore.kernel.org/r/20220508103547.626355-1-john.ogness@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/meson_uart.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/tty/serial/meson_uart.c b/drivers/tty/serial/meson_uart.c
index 07c0f98be3ac..2bb5ab508321 100644
--- a/drivers/tty/serial/meson_uart.c
+++ b/drivers/tty/serial/meson_uart.c
@@ -253,6 +253,14 @@ static const char *meson_uart_type(struct uart_port *port)
 	return (port->type == PORT_MESON) ? "meson_uart" : NULL;
 }
 
+/*
+ * This function is called only from probe() using a temporary io mapping
+ * in order to perform a reset before setting up the device. Since the
+ * temporarily mapped region was successfully requested, there can be no
+ * console on this port at this time. Hence it is not necessary for this
+ * function to acquire the port->lock. (Since there is no console on this
+ * port at this time, the port->lock is not initialized yet.)
+ */
 static void meson_uart_reset(struct uart_port *port)
 {
 	u32 val;
@@ -267,9 +275,12 @@ static void meson_uart_reset(struct uart_port *port)
 
 static int meson_uart_startup(struct uart_port *port)
 {
+	unsigned long flags;
 	u32 val;
 	int ret = 0;
 
+	spin_lock_irqsave(&port->lock, flags);
+
 	val = readl(port->membase + AML_UART_CONTROL);
 	val |= AML_UART_CLR_ERR;
 	writel(val, port->membase + AML_UART_CONTROL);
@@ -285,6 +296,8 @@ static int meson_uart_startup(struct uart_port *port)
 	val = (AML_UART_RECV_IRQ(1) | AML_UART_XMIT_IRQ(port->fifosize / 2));
 	writel(val, port->membase + AML_UART_MISC);
 
+	spin_unlock_irqrestore(&port->lock, flags);
+
 	ret = request_irq(port->irq, meson_uart_interrupt, 0,
 			  port->name, port);
 
-- 
2.35.1



