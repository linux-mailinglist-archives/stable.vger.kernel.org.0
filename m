Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A306694A05
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjBMPEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbjBMPEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:04:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361B11DBB3
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:03:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA46FB81256
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54ED9C4339B;
        Mon, 13 Feb 2023 15:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300619;
        bh=11jIUUdQHAkqGBAXcC4CZPDe+5WWgdf9H4cMejdW8FI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJ2IIBUkOEkya0+fd+dwXnDMXlQxzVJwkVu2XNrReGsE/50ZgXQhgPaHV8NyenfG2
         9HZxhfdexng1qv6w1JUbOAohZ4tLHfgiBTx6k9a7Vvq95zLHSLIldLfbA27rl0dt2+
         PgsTEZbL9AGe62BLwv3Cs5pZnXWNb7OLSGWabyVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gilles BULOZ <gilles.buloz@kontron.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.10 084/139] serial: 8250_dma: Fix DMA Rx completion race
Date:   Mon, 13 Feb 2023 15:50:29 +0100
Message-Id: <20230213144750.296694493@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
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

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 31352811e13dc2313f101b890fd4b1ce760b5fe7 upstream.

__dma_rx_complete() is called from two places:
  - Through the DMA completion callback dma_rx_complete()
  - From serial8250_rx_dma_flush() after IIR_RLSI or IIR_RX_TIMEOUT
The former does not hold port's lock during __dma_rx_complete() which
allows these two to race and potentially insert the same data twice.

Extend port's lock coverage in dma_rx_complete() to prevent the race
and check if the DMA Rx is still pending completion before calling
into __dma_rx_complete().

Reported-by: Gilles BULOZ <gilles.buloz@kontron.com>
Tested-by: Gilles BULOZ <gilles.buloz@kontron.com>
Fixes: 9ee4b83e51f7 ("serial: 8250: Add support for dmaengine")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20230130114841.25749-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dma.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -59,6 +59,18 @@ static void __dma_rx_complete(void *para
 	tty_flip_buffer_push(tty_port);
 }
 
+static void dma_rx_complete(void *param)
+{
+	struct uart_8250_port *p = param;
+	struct uart_8250_dma *dma = p->dma;
+	unsigned long flags;
+
+	spin_lock_irqsave(&p->port.lock, flags);
+	if (dma->rx_running)
+		__dma_rx_complete(p);
+	spin_unlock_irqrestore(&p->port.lock, flags);
+}
+
 int serial8250_tx_dma(struct uart_8250_port *p)
 {
 	struct uart_8250_dma		*dma = p->dma;
@@ -130,7 +142,7 @@ int serial8250_rx_dma(struct uart_8250_p
 		return -EBUSY;
 
 	dma->rx_running = 1;
-	desc->callback = __dma_rx_complete;
+	desc->callback = dma_rx_complete;
 	desc->callback_param = p;
 
 	dma->rx_cookie = dmaengine_submit(desc);


