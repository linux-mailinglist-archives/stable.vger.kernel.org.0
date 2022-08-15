Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8887C5939B9
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244547AbiHOT2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344441AbiHOT0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:26:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958F13FA05;
        Mon, 15 Aug 2022 11:42:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DE2F60FEE;
        Mon, 15 Aug 2022 18:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D611C433C1;
        Mon, 15 Aug 2022 18:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588958;
        bh=zZb3w4ZEQn3rVjMUEfbqtgtrFhNi4p7gFpwg8dCPZdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nb28TJvNIv8XJqe/Fyd/sLrk1cFbcRd/x6RdrEE8IygS1LGDD31EUuNbRmN+29NjM
         IBr//jFmXfmKUvoltVoB0t9+Hzwefecd60Q+9QA0boFma2ZBErOGMEODz48kqE34d3
         dCDIVSyeBbF7UHPRkXzRIVRA5ye8EV5J3iLaHgXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 569/779] serial: 8250: dma: Allow driver operations before starting DMA transfers
Date:   Mon, 15 Aug 2022 20:03:33 +0200
Message-Id: <20220815180401.657567808@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit e4fb03fe10c5e7a5d9aef7cefe815253274fb9ee ]

One situation where this could be used is when configuring the UART
controller to be the DMA flow controller. This is a typical case where
the driver might need to program a few more registers before starting a
DMA transfer. Provide the necessary infrastructure to support this
case.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20220422180615.9098-6-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250.h     | 18 ++++++++++++++++++
 drivers/tty/serial/8250/8250_dma.c |  4 ++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 0efe4df24622..b3abc29aa927 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -17,6 +17,8 @@
 struct uart_8250_dma {
 	int (*tx_dma)(struct uart_8250_port *p);
 	int (*rx_dma)(struct uart_8250_port *p);
+	void (*prepare_tx_dma)(struct uart_8250_port *p);
+	void (*prepare_rx_dma)(struct uart_8250_port *p);
 
 	/* Filter function */
 	dma_filter_fn		fn;
@@ -331,6 +333,22 @@ extern int serial8250_rx_dma(struct uart_8250_port *);
 extern void serial8250_rx_dma_flush(struct uart_8250_port *);
 extern int serial8250_request_dma(struct uart_8250_port *);
 extern void serial8250_release_dma(struct uart_8250_port *);
+
+static inline void serial8250_do_prepare_tx_dma(struct uart_8250_port *p)
+{
+	struct uart_8250_dma *dma = p->dma;
+
+	if (dma->prepare_tx_dma)
+		dma->prepare_tx_dma(p);
+}
+
+static inline void serial8250_do_prepare_rx_dma(struct uart_8250_port *p)
+{
+	struct uart_8250_dma *dma = p->dma;
+
+	if (dma->prepare_rx_dma)
+		dma->prepare_rx_dma(p);
+}
 #else
 static inline int serial8250_tx_dma(struct uart_8250_port *p)
 {
diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index b3c3f7e5851a..1bdc8d6432fe 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -86,6 +86,8 @@ int serial8250_tx_dma(struct uart_8250_port *p)
 
 	dma->tx_size = CIRC_CNT_TO_END(xmit->head, xmit->tail, UART_XMIT_SIZE);
 
+	serial8250_do_prepare_tx_dma(p);
+
 	desc = dmaengine_prep_slave_single(dma->txchan,
 					   dma->tx_addr + xmit->tail,
 					   dma->tx_size, DMA_MEM_TO_DEV,
@@ -123,6 +125,8 @@ int serial8250_rx_dma(struct uart_8250_port *p)
 	if (dma->rx_running)
 		return 0;
 
+	serial8250_do_prepare_rx_dma(p);
+
 	desc = dmaengine_prep_slave_single(dma->rxchan, dma->rx_addr,
 					   dma->rx_size, DMA_DEV_TO_MEM,
 					   DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
-- 
2.35.1



