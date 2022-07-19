Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C0B5799CD
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238132AbiGSMGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238138AbiGSMF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:05:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3660545991;
        Tue, 19 Jul 2022 05:00:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 393196163C;
        Tue, 19 Jul 2022 12:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035E5C341CA;
        Tue, 19 Jul 2022 12:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232058;
        bh=idIgHxzFR0bsPwk/cCgE2kIAYig5esRDLPEC9iqLQik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zOVxSDBzvoLP7o88Ei9rBn8J9/q/4yX5yahp0gbIMS4BFN4E/mdfgeI90F4ClS5mE
         DCctqcsayD79QTjclB9z4Xg04qPnMkTOnK1oS9jo0WuUP2JkcnlWd9atJ4FfIHYayX
         KaZAo1B+63uTZj2wzg1LwSouf+oZpol2t2XO67L8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Lukas Wunner <lukas@wunner.de>,
        =?UTF-8?q?Nuno=20Gon=C3=A7alves?= <nunojpg@gmail.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 4.19 47/48] serial: pl011: UPSTAT_AUTORTS requires .throttle/unthrottle
Date:   Tue, 19 Jul 2022 13:54:24 +0200
Message-Id: <20220719114523.982727104@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114518.915546280@linuxfoundation.org>
References: <20220719114518.915546280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 211565b100993c90b53bf40851eacaefc830cfe0 upstream.

The driver must provide throttle and unthrottle in uart_ops when it
sets UPSTAT_AUTORTS. Add them using existing stop_rx &
enable_interrupts functions.

Fixes: 2a76fa283098 (serial: pl011: Adopt generic flag to store auto RTS status)
Cc: stable <stable@kernel.org>
Cc: Lukas Wunner <lukas@wunner.de>
Reported-by: Nuno Gonçalves <nunojpg@gmail.com>
Tested-by: Nuno Gonçalves <nunojpg@gmail.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220614075637.8558-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/amba-pl011.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1335,6 +1335,15 @@ static void pl011_stop_rx(struct uart_po
 	pl011_dma_rx_stop(uap);
 }
 
+static void pl011_throttle_rx(struct uart_port *port)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+	pl011_stop_rx(port);
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
 static void pl011_enable_ms(struct uart_port *port)
 {
 	struct uart_amba_port *uap =
@@ -1728,9 +1737,10 @@ static int pl011_allocate_irq(struct uar
  */
 static void pl011_enable_interrupts(struct uart_amba_port *uap)
 {
+	unsigned long flags;
 	unsigned int i;
 
-	spin_lock_irq(&uap->port.lock);
+	spin_lock_irqsave(&uap->port.lock, flags);
 
 	/* Clear out any spuriously appearing RX interrupts */
 	pl011_write(UART011_RTIS | UART011_RXIS, uap, REG_ICR);
@@ -1752,7 +1762,14 @@ static void pl011_enable_interrupts(stru
 	if (!pl011_dma_rx_running(uap))
 		uap->im |= UART011_RXIM;
 	pl011_write(uap->im, uap, REG_IMSC);
-	spin_unlock_irq(&uap->port.lock);
+	spin_unlock_irqrestore(&uap->port.lock, flags);
+}
+
+static void pl011_unthrottle_rx(struct uart_port *port)
+{
+	struct uart_amba_port *uap = container_of(port, struct uart_amba_port, port);
+
+	pl011_enable_interrupts(uap);
 }
 
 static int pl011_startup(struct uart_port *port)
@@ -2127,6 +2144,8 @@ static const struct uart_ops amba_pl011_
 	.stop_tx	= pl011_stop_tx,
 	.start_tx	= pl011_start_tx,
 	.stop_rx	= pl011_stop_rx,
+	.throttle	= pl011_throttle_rx,
+	.unthrottle	= pl011_unthrottle_rx,
 	.enable_ms	= pl011_enable_ms,
 	.break_ctl	= pl011_break_ctl,
 	.startup	= pl011_startup,


