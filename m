Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02600133199
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbgAGVCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:02:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:41326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727431AbgAGVCN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:02:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DDCC20678;
        Tue,  7 Jan 2020 21:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430933;
        bh=0FstCUXHfmt/wPEtDm64QswSEukEzEeXl3fqYx9rozE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohO1JH79BjYiFRr1jGjqcbT0pltTI0VaToedtnsQbA5mnjfOi8B2MuK4ijdrzvV7C
         gIEvWNMUb6l0bI5zxi1PSr9OFFr8FFiqa6kjCSi/QOPJtiAluq8jwZsUnZqV9ACmbz
         9+2vDZLQZK5H2jOgnF7TIjYwXS9oXK8PsLuKCqBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Keiji Hayashibara <hayashibara.keiji@socionext.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 155/191] spi: uniphier: Fix FIFO threshold
Date:   Tue,  7 Jan 2020 21:54:35 +0100
Message-Id: <20200107205341.260078760@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

commit 9cd34efbd3012171c102910ce17ee632a3cccb44 upstream.

Rx threshold means the value to inform the receiver when the number of words
in Rx FIFO is equal to or more than the value. Similarly, Tx threshold means
the value to inform the sender when the number of words in Tx FIFO is equal
to or less than the value. The controller triggers the driver to start
the transfer.

In case of Rx, the driver wants to detect that the specified number of words
N are in Rx FIFO, so the value of Rx threshold should be N. In case of Tx,
the driver wants to detect that the same number of spaces as Rx are in
Tx FIFO, so the value of Tx threshold should be (FIFO size - N).

For example, in order for the driver to receive at least 3 words from
Rx FIFO, set 3 to Rx threshold.
   +-+-+-+-+-+-+-+-+
   | | | | | |*|*|*|
   +-+-+-+-+-+-+-+-+

In order for the driver to send at least 3 words to Tx FIFO, because
it needs at least 3 spaces, set 8(FIFO size) - 3 = 5 to Tx threshold.
   +-+-+-+-+-+-+-+-+
   |*|*|*|*|*| | | |
   +-+-+-+-+-+-+-+-+

This adds new function uniphier_spi_set_fifo_threshold() to set
threshold value to the register.

And more, FIFO counts by 'words', so this renames 'fill_bytes' with
'fill_words', and fixes the calculation using bytes_per_words.

Fixes: 37ffab817098 ("spi: uniphier: introduce polling mode")
Cc: Keiji Hayashibara <hayashibara.keiji@socionext.com>
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/1577149107-30670-2-git-send-email-hayashi.kunihiko@socionext.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-uniphier.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

--- a/drivers/spi/spi-uniphier.c
+++ b/drivers/spi/spi-uniphier.c
@@ -290,25 +290,32 @@ static void uniphier_spi_recv(struct uni
 	}
 }
 
-static void uniphier_spi_fill_tx_fifo(struct uniphier_spi_priv *priv)
+static void uniphier_spi_set_fifo_threshold(struct uniphier_spi_priv *priv,
+					    unsigned int threshold)
 {
-	unsigned int fifo_threshold, fill_bytes;
 	u32 val;
 
-	fifo_threshold = DIV_ROUND_UP(priv->rx_bytes,
-				bytes_per_word(priv->bits_per_word));
-	fifo_threshold = min(fifo_threshold, SSI_FIFO_DEPTH);
-
-	fill_bytes = fifo_threshold - (priv->rx_bytes - priv->tx_bytes);
-
-	/* set fifo threshold */
 	val = readl(priv->base + SSI_FC);
 	val &= ~(SSI_FC_TXFTH_MASK | SSI_FC_RXFTH_MASK);
-	val |= FIELD_PREP(SSI_FC_TXFTH_MASK, fifo_threshold);
-	val |= FIELD_PREP(SSI_FC_RXFTH_MASK, fifo_threshold);
+	val |= FIELD_PREP(SSI_FC_TXFTH_MASK, SSI_FIFO_DEPTH - threshold);
+	val |= FIELD_PREP(SSI_FC_RXFTH_MASK, threshold);
 	writel(val, priv->base + SSI_FC);
+}
+
+static void uniphier_spi_fill_tx_fifo(struct uniphier_spi_priv *priv)
+{
+	unsigned int fifo_threshold, fill_words;
+	unsigned int bpw = bytes_per_word(priv->bits_per_word);
+
+	fifo_threshold = DIV_ROUND_UP(priv->rx_bytes, bpw);
+	fifo_threshold = min(fifo_threshold, SSI_FIFO_DEPTH);
+
+	uniphier_spi_set_fifo_threshold(priv, fifo_threshold);
+
+	fill_words = fifo_threshold -
+		DIV_ROUND_UP(priv->rx_bytes - priv->tx_bytes, bpw);
 
-	while (fill_bytes--)
+	while (fill_words--)
 		uniphier_spi_send(priv);
 }
 


