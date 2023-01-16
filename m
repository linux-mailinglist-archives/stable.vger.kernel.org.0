Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3386F66C997
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbjAPQwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbjAPQvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:51:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05E94B77B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:37:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEE43B8108F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E822C433F1;
        Mon, 16 Jan 2023 16:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887029;
        bh=dqaCuBh2RIQ1CzdKUSfdsctJEEfsKXJj5CweXNPbFX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIkpHxyIsRJu8hN6rqZtBSCXciPXusrMVPtQYrrnfi0H2X4Fut5kaCcdD2GcHqdDq
         hzgNvwGS3BDEwu1/DgnIEvS7FQ5d28kM2xHk9GFPqRTWMpYXca45MPGN76SPQE9r2Q
         vYE6wjcDcQ4XHgT3BzKqHQ13W8GWmD+hmPNewH0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dmitry Osipenko <digetx@gmail.com>
Subject: [PATCH 5.4 654/658] tty: serial: tegra: Handle RX transfer in PIO mode if DMA wasnt started
Date:   Mon, 16 Jan 2023 16:52:22 +0100
Message-Id: <20230116154939.382477043@linuxfoundation.org>
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

From: Dmitry Osipenko <digetx@gmail.com>

commit 1f69a1273b3f204a9c00dc3bbdcc4afcd0787428 upstream.

It is possible to get an instant RX timeout or end-of-transfer interrupt
before RX DMA was started, if transaction is less than 16 bytes. Transfer
should be handled in PIO mode in this case because DMA can't handle it.
This patch brings back the original behaviour of the driver that was
changed by accident by a previous commit, it fixes occasional Bluetooth HW
initialization failures which I started to notice recently.

Fixes: d5e3fadb7012 ("tty: serial: tegra: Activate RX DMA transfer by request")
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20200209164415.9632-1-digetx@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial-tegra.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -694,11 +694,22 @@ static void tegra_uart_copy_rx_to_tty(st
 				TEGRA_UART_RX_DMA_BUFFER_SIZE, DMA_TO_DEVICE);
 }
 
+static void do_handle_rx_pio(struct tegra_uart_port *tup)
+{
+	struct tty_struct *tty = tty_port_tty_get(&tup->uport.state->port);
+	struct tty_port *port = &tup->uport.state->port;
+
+	tegra_uart_handle_rx_pio(tup, port);
+	if (tty) {
+		tty_flip_buffer_push(port);
+		tty_kref_put(tty);
+	}
+}
+
 static void tegra_uart_rx_buffer_push(struct tegra_uart_port *tup,
 				      unsigned int residue)
 {
 	struct tty_port *port = &tup->uport.state->port;
-	struct tty_struct *tty = tty_port_tty_get(port);
 	unsigned int count;
 
 	async_tx_ack(tup->rx_dma_desc);
@@ -707,11 +718,7 @@ static void tegra_uart_rx_buffer_push(st
 	/* If we are here, DMA is stopped */
 	tegra_uart_copy_rx_to_tty(tup, port, count);
 
-	tegra_uart_handle_rx_pio(tup, port);
-	if (tty) {
-		tty_flip_buffer_push(port);
-		tty_kref_put(tty);
-	}
+	do_handle_rx_pio(tup);
 }
 
 static void tegra_uart_rx_dma_complete(void *args)
@@ -751,8 +758,10 @@ static void tegra_uart_terminate_rx_dma(
 {
 	struct dma_tx_state state;
 
-	if (!tup->rx_dma_active)
+	if (!tup->rx_dma_active) {
+		do_handle_rx_pio(tup);
 		return;
+	}
 
 	dmaengine_pause(tup->rx_dma_chan);
 	dmaengine_tx_status(tup->rx_dma_chan, tup->rx_cookie, &state);
@@ -821,18 +830,6 @@ static void tegra_uart_handle_modem_sign
 		uart_handle_cts_change(&tup->uport, msr & UART_MSR_CTS);
 }
 
-static void do_handle_rx_pio(struct tegra_uart_port *tup)
-{
-	struct tty_struct *tty = tty_port_tty_get(&tup->uport.state->port);
-	struct tty_port *port = &tup->uport.state->port;
-
-	tegra_uart_handle_rx_pio(tup, port);
-	if (tty) {
-		tty_flip_buffer_push(port);
-		tty_kref_put(tty);
-	}
-}
-
 static irqreturn_t tegra_uart_isr(int irq, void *data)
 {
 	struct tegra_uart_port *tup = data;


