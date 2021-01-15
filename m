Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4282F798F
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388129AbhAOMiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:38:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731934AbhAOMiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:38:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A92EE23888;
        Fri, 15 Jan 2021 12:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714275;
        bh=NbB2AQ4CypMmuJMs414rcSphJQYtCRaC+9wKdZRkkoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BDotkSz5f0aTpJkZUNLFwSWh5ahn7JHzbUpPeV5wvzk0F5ctqMdfeRF6EN5ZsXmr9
         foXYpQOOpLLTKQeytMegN08/VxXFRjU9yAjn4ovwb+HUmqyWyRC1H73hDN8/mLODh4
         U0sOsGStVny3+T3G04csBMhGASg2k3y+yNNgyDBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 061/103] spi: spi-geni-qcom: Fix geni_spi_isr() NULL dereference in timeout case
Date:   Fri, 15 Jan 2021 13:27:54 +0100
Message-Id: <20210115122008.999891067@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit 4aa1464acbe3697710279a4bd65cb4801ed30425 upstream.

In commit 7ba9bdcb91f6 ("spi: spi-geni-qcom: Don't keep a local state
variable") we changed handle_fifo_timeout() so that we set
"mas->cur_xfer" to NULL to make absolutely sure that we don't mess
with the buffers from the previous transfer in the timeout case.

Unfortunately, this caused the IRQ handler to dereference NULL in some
cases.  One case:

  CPU0                           CPU1
  ----                           ----
                                 setup_fifo_xfer()
                                  geni_se_setup_m_cmd()
                                 <hardware starts transfer>
                                 <transfer completes in hardware>
                                 <hardware sets M_RX_FIFO_WATERMARK_EN in m_irq>
                                 ...
                                 handle_fifo_timeout()
                                  spin_lock_irq(mas->lock)
                                  mas->cur_xfer = NULL
                                  geni_se_cancel_m_cmd()
                                  spin_unlock_irq(mas->lock)

  geni_spi_isr()
   spin_lock(mas->lock)
   if (m_irq & M_RX_FIFO_WATERMARK_EN)
    geni_spi_handle_rx()
     mas->cur_xfer NULL dereference!

tl;dr: Seriously delayed interrupts for RX/TX can lead to timeout
handling setting mas->cur_xfer to NULL.

Let's check for the NULL transfer in the TX and RX cases and reset the
watermark or clear out the fifo respectively to put the hardware back
into a sane state.

NOTE: things still could get confused if we get timeouts all the way
through handle_fifo_timeout() and then start a new transfer because
interrupts from the old transfer / cancel / abort could still be
pending.  A future patch will help this corner case.

Fixes: 561de45f72bd ("spi: spi-geni-qcom: Add SPI driver support for GENI based QUP")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20201217142842.v3.1.I99ee04f0cb823415df59bd4f550d6ff5756e43d6@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-geni-qcom.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -406,6 +406,12 @@ static bool geni_spi_handle_tx(struct sp
 	unsigned int bytes_per_fifo_word = geni_byte_per_fifo_word(mas);
 	unsigned int i = 0;
 
+	/* Stop the watermark IRQ if nothing to send */
+	if (!mas->cur_xfer) {
+		writel(0, se->base + SE_GENI_TX_WATERMARK_REG);
+		return false;
+	}
+
 	max_bytes = (mas->tx_fifo_depth - mas->tx_wm) * bytes_per_fifo_word;
 	if (mas->tx_rem_bytes < max_bytes)
 		max_bytes = mas->tx_rem_bytes;
@@ -448,6 +454,14 @@ static void geni_spi_handle_rx(struct sp
 		if (rx_last_byte_valid && rx_last_byte_valid < 4)
 			rx_bytes -= bytes_per_fifo_word - rx_last_byte_valid;
 	}
+
+	/* Clear out the FIFO and bail if nowhere to put it */
+	if (!mas->cur_xfer) {
+		for (i = 0; i < DIV_ROUND_UP(rx_bytes, bytes_per_fifo_word); i++)
+			readl(se->base + SE_GENI_RX_FIFOn);
+		return;
+	}
+
 	if (mas->rx_rem_bytes < rx_bytes)
 		rx_bytes = mas->rx_rem_bytes;
 


