Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572D35EA01E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbiIZKd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235876AbiIZKc7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:32:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115AD1AF0F;
        Mon, 26 Sep 2022 03:20:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42DB660B7E;
        Mon, 26 Sep 2022 10:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6F1C433D6;
        Mon, 26 Sep 2022 10:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187599;
        bh=UrYpoJkOcC+Z/4HedVZyNA5cwMtyJQfPL+QJGcXp3k0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNbWDlr1TQJpJDk2DG2FdQ3fCkqT5gZJMxrcxE4sUnwEj8uMY1bm9DNah2jb5/Zu0
         agDBPfyIdPudnVKg0dMYdRtgbIIIl3rwHu9ZQtNHhsy5Fngl/4JeC5fzMsOMvj/ZUg
         5rKYLKwx5f96t+81l2d3bLhTcNVB9ED4EKZI2HJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 4.19 51/58] serial: tegra: Use uart_xmit_advance(), fixes icount.tx accounting
Date:   Mon, 26 Sep 2022 12:12:10 +0200
Message-Id: <20220926100743.320354793@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 754f68044c7dd6c52534ba3e0f664830285c4b15 upstream.

DMA complete & stop paths did not correctly account Tx'ed characters
into icount.tx. Using uart_xmit_advance() fixes the problem.

Fixes: e9ea096dd225 ("serial: tegra: add serial driver")
Cc: <stable@vger.kernel.org> # serial: Create uart_xmit_advance()
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220901143934.8850-3-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial-tegra.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -398,7 +398,7 @@ static void tegra_uart_tx_dma_complete(v
 	count = tup->tx_bytes_requested - state.residue;
 	async_tx_ack(tup->tx_dma_desc);
 	spin_lock_irqsave(&tup->uport.lock, flags);
-	xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
+	uart_xmit_advance(&tup->uport, count);
 	tup->tx_in_progress = 0;
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(&tup->uport);
@@ -482,7 +482,6 @@ static unsigned int tegra_uart_tx_empty(
 static void tegra_uart_stop_tx(struct uart_port *u)
 {
 	struct tegra_uart_port *tup = to_tegra_uport(u);
-	struct circ_buf *xmit = &tup->uport.state->xmit;
 	struct dma_tx_state state;
 	unsigned int count;
 
@@ -493,7 +492,7 @@ static void tegra_uart_stop_tx(struct ua
 	dmaengine_tx_status(tup->tx_dma_chan, tup->tx_cookie, &state);
 	count = tup->tx_bytes_requested - state.residue;
 	async_tx_ack(tup->tx_dma_desc);
-	xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
+	uart_xmit_advance(&tup->uport, count);
 	tup->tx_in_progress = 0;
 }
 


