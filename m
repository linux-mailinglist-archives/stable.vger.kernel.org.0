Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5CFF13F173
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389393AbgAPS2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:28:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:34408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392233AbgAPR0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:26:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C08C4246C4;
        Thu, 16 Jan 2020 17:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195564;
        bh=6Exa74BCNq8gdEwIASZAeepESvLnl5ToSJO+t6bDfUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofgN3bRKfo6Po2EG2njj2DVUdIw2h89VZq2VT8YDjsJw7OqwTBP4OM1eN5UygCt9W
         VT5A/OduUJsJ8zdNBOfF2KWWbxdyvyyODl+w+rxO589Igm4j/eaA4/th2XyyrEe55e
         QeL5WkL/sUUFl7bh66DaOWTFjdvkn8P61iKYsE6s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sowjanya Komatineni <skomatineni@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 150/371] spi: tegra114: fix for unpacked mode transfers
Date:   Thu, 16 Jan 2020 12:20:22 -0500
Message-Id: <20200116172403.18149-93-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sowjanya Komatineni <skomatineni@nvidia.com>

[ Upstream commit 1a89ac5b91895127f7c586ec5075c3753ca25501 ]

Fixes: computation of actual bytes to fill/receive in/from FIFO in unpacked
mode when transfer length is not a multiple of requested bits per word.

unpacked mode transfers fails when the transfer includes partial bytes in
the last word.

Total words to be written/read to/from FIFO is computed based on transfer
length and bits per word. Unpacked mode includes 0 padding bytes for partial
words to align with bits per word and these extra bytes are also accounted
for calculating bytes left to transfer in the current driver.

This causes extra bytes access of tx/rx buffers along with buffer index
position crossing actual length where remain_len becomes negative and due to
unsigned type, negative value is a 32 bit representation of signed value
and transferred bytes never meets the actual transfer length resulting in
transfer timeout and a hang.

This patch fixes this with proper computation of the actual bytes to fill in
FIFO during transmit and the actual bytes to read from FIFO during receive
ignoring 0 padded bytes.

Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra114.c | 43 +++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 3a6b202dfffe..c6674b01e0fd 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -307,10 +307,16 @@ static unsigned tegra_spi_fill_tx_fifo_from_client_txbuf(
 				x |= (u32)(*tx_buf++) << (i * 8);
 			tegra_spi_writel(tspi, x, SPI_TX_FIFO);
 		}
+
+		tspi->cur_tx_pos += written_words * tspi->bytes_per_word;
 	} else {
+		unsigned int write_bytes;
 		max_n_32bit = min(tspi->curr_dma_words,  tx_empty_count);
 		written_words = max_n_32bit;
 		nbytes = written_words * tspi->bytes_per_word;
+		if (nbytes > t->len - tspi->cur_pos)
+			nbytes = t->len - tspi->cur_pos;
+		write_bytes = nbytes;
 		for (count = 0; count < max_n_32bit; count++) {
 			u32 x = 0;
 
@@ -319,8 +325,10 @@ static unsigned tegra_spi_fill_tx_fifo_from_client_txbuf(
 				x |= (u32)(*tx_buf++) << (i * 8);
 			tegra_spi_writel(tspi, x, SPI_TX_FIFO);
 		}
+
+		tspi->cur_tx_pos += write_bytes;
 	}
-	tspi->cur_tx_pos += written_words * tspi->bytes_per_word;
+
 	return written_words;
 }
 
@@ -344,20 +352,27 @@ static unsigned int tegra_spi_read_rx_fifo_to_client_rxbuf(
 			for (i = 0; len && (i < 4); i++, len--)
 				*rx_buf++ = (x >> i*8) & 0xFF;
 		}
-		tspi->cur_rx_pos += tspi->curr_dma_words * tspi->bytes_per_word;
 		read_words += tspi->curr_dma_words;
+		tspi->cur_rx_pos += tspi->curr_dma_words * tspi->bytes_per_word;
 	} else {
 		u32 rx_mask = ((u32)1 << t->bits_per_word) - 1;
+		u8 bytes_per_word = tspi->bytes_per_word;
+		unsigned int read_bytes;
 
+		len = rx_full_count * bytes_per_word;
+		if (len > t->len - tspi->cur_pos)
+			len = t->len - tspi->cur_pos;
+		read_bytes = len;
 		for (count = 0; count < rx_full_count; count++) {
 			u32 x = tegra_spi_readl(tspi, SPI_RX_FIFO) & rx_mask;
 
-			for (i = 0; (i < tspi->bytes_per_word); i++)
+			for (i = 0; len && (i < bytes_per_word); i++, len--)
 				*rx_buf++ = (x >> (i*8)) & 0xFF;
 		}
-		tspi->cur_rx_pos += rx_full_count * tspi->bytes_per_word;
 		read_words += rx_full_count;
+		tspi->cur_rx_pos += read_bytes;
 	}
+
 	return read_words;
 }
 
@@ -372,12 +387,17 @@ static void tegra_spi_copy_client_txbuf_to_spi_txbuf(
 		unsigned len = tspi->curr_dma_words * tspi->bytes_per_word;
 
 		memcpy(tspi->tx_dma_buf, t->tx_buf + tspi->cur_pos, len);
+		tspi->cur_tx_pos += tspi->curr_dma_words * tspi->bytes_per_word;
 	} else {
 		unsigned int i;
 		unsigned int count;
 		u8 *tx_buf = (u8 *)t->tx_buf + tspi->cur_tx_pos;
 		unsigned consume = tspi->curr_dma_words * tspi->bytes_per_word;
+		unsigned int write_bytes;
 
+		if (consume > t->len - tspi->cur_pos)
+			consume = t->len - tspi->cur_pos;
+		write_bytes = consume;
 		for (count = 0; count < tspi->curr_dma_words; count++) {
 			u32 x = 0;
 
@@ -386,8 +406,9 @@ static void tegra_spi_copy_client_txbuf_to_spi_txbuf(
 				x |= (u32)(*tx_buf++) << (i * 8);
 			tspi->tx_dma_buf[count] = x;
 		}
+
+		tspi->cur_tx_pos += write_bytes;
 	}
-	tspi->cur_tx_pos += tspi->curr_dma_words * tspi->bytes_per_word;
 
 	/* Make the dma buffer to read by dma */
 	dma_sync_single_for_device(tspi->dev, tspi->tx_dma_phys,
@@ -405,20 +426,28 @@ static void tegra_spi_copy_spi_rxbuf_to_client_rxbuf(
 		unsigned len = tspi->curr_dma_words * tspi->bytes_per_word;
 
 		memcpy(t->rx_buf + tspi->cur_rx_pos, tspi->rx_dma_buf, len);
+		tspi->cur_rx_pos += tspi->curr_dma_words * tspi->bytes_per_word;
 	} else {
 		unsigned int i;
 		unsigned int count;
 		unsigned char *rx_buf = t->rx_buf + tspi->cur_rx_pos;
 		u32 rx_mask = ((u32)1 << t->bits_per_word) - 1;
+		unsigned consume = tspi->curr_dma_words * tspi->bytes_per_word;
+		unsigned int read_bytes;
 
+		if (consume > t->len - tspi->cur_pos)
+			consume = t->len - tspi->cur_pos;
+		read_bytes = consume;
 		for (count = 0; count < tspi->curr_dma_words; count++) {
 			u32 x = tspi->rx_dma_buf[count] & rx_mask;
 
-			for (i = 0; (i < tspi->bytes_per_word); i++)
+			for (i = 0; consume && (i < tspi->bytes_per_word);
+							i++, consume--)
 				*rx_buf++ = (x >> (i*8)) & 0xFF;
 		}
+
+		tspi->cur_rx_pos += read_bytes;
 	}
-	tspi->cur_rx_pos += tspi->curr_dma_words * tspi->bytes_per_word;
 
 	/* Make the dma buffer to read by dma */
 	dma_sync_single_for_device(tspi->dev, tspi->rx_dma_phys,
-- 
2.20.1

