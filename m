Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9F75B0735
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 16:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbiIGOle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 10:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiIGOlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 10:41:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C4D5A151
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 07:41:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74FE9B81D1C
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 14:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C535CC433D6;
        Wed,  7 Sep 2022 14:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662561661;
        bh=9gClJztoqkOzFXETn/AUsn+XhQfDVapaCHdB6AsY82E=;
        h=Subject:To:From:Date:From;
        b=rKRro2jvidOvJDdoKijUH67WgNFZK1094bXOctWKiI+gi/fczVLylgS9nojA9Jx/X
         vg1TILe5gVRyJ8cdtl3uEKhE3HuxaeeadLbRF0aTyXx2+OwLYQ4xOABhDf8h7EOrBH
         2QF3FppEAose6uuy9MIOAZIvUiEKFFVkTp3H7PiM=
Subject: patch "serial: tegra: Use uart_xmit_advance(), fixes icount.tx accounting" added to tty-linus
To:     ilpo.jarvinen@linux.intel.com, andy.shevchenko@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 07 Sep 2022 16:40:50 +0200
Message-ID: <1662561650142187@kroah.com>
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


This is a note to let you know that I've just added the patch titled

    serial: tegra: Use uart_xmit_advance(), fixes icount.tx accounting

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 754f68044c7dd6c52534ba3e0f664830285c4b15 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Thu, 1 Sep 2022 17:39:33 +0300
Subject: serial: tegra: Use uart_xmit_advance(), fixes icount.tx accounting
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

DMA complete & stop paths did not correctly account Tx'ed characters
into icount.tx. Using uart_xmit_advance() fixes the problem.

Fixes: e9ea096dd225 ("serial: tegra: add serial driver")
Cc: <stable@vger.kernel.org> # serial: Create uart_xmit_advance()
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220901143934.8850-3-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial-tegra.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index ad4f3567ff90..a5748e41483b 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -525,7 +525,7 @@ static void tegra_uart_tx_dma_complete(void *args)
 	count = tup->tx_bytes_requested - state.residue;
 	async_tx_ack(tup->tx_dma_desc);
 	spin_lock_irqsave(&tup->uport.lock, flags);
-	xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
+	uart_xmit_advance(&tup->uport, count);
 	tup->tx_in_progress = 0;
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(&tup->uport);
@@ -613,7 +613,6 @@ static unsigned int tegra_uart_tx_empty(struct uart_port *u)
 static void tegra_uart_stop_tx(struct uart_port *u)
 {
 	struct tegra_uart_port *tup = to_tegra_uport(u);
-	struct circ_buf *xmit = &tup->uport.state->xmit;
 	struct dma_tx_state state;
 	unsigned int count;
 
@@ -624,7 +623,7 @@ static void tegra_uart_stop_tx(struct uart_port *u)
 	dmaengine_tx_status(tup->tx_dma_chan, tup->tx_cookie, &state);
 	count = tup->tx_bytes_requested - state.residue;
 	async_tx_ack(tup->tx_dma_desc);
-	xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
+	uart_xmit_advance(&tup->uport, count);
 	tup->tx_in_progress = 0;
 }
 
-- 
2.37.3


