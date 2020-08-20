Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDB224B815
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgHTLIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:08:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730648AbgHTKKE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:10:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 243BC2067C;
        Thu, 20 Aug 2020 10:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918203;
        bh=XJ5DmlNOlYa9O5RhsrLNP3SNVFa/vv5QstJP+KMrTms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b36zhDYbvBr+965GA0WamGSxJ9k8ma6qRuWsZ2CcVcRNUot2Db6iC5zjrua0l/OXb
         bqnV6Rq+FQWQcewZhugZ3r4ZKM/UrcMs+JJOyPJGO/5dj7U0JvsKYv1q2YZsaFc/9A
         khzvkpUyrL2bQ4bOuO/bejkaCoMGf4x9mBcgVwPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dilip Kota <eswara.kota@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 058/228] spi: lantiq: fix: Rx overflow error in full duplex mode
Date:   Thu, 20 Aug 2020 11:20:33 +0200
Message-Id: <20200820091610.506196666@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dilip Kota <eswara.kota@linux.intel.com>

[ Upstream commit 661ccf2b3f1360be50242726f7c26ced6a9e7d52 ]

In full duplex mode, rx overflow error is observed. To overcome the error,
wait until the complete data got received and proceed further.

Fixes: 17f84b793c01 ("spi: lantiq-ssc: add support for Lantiq SSC SPI controller")
Signed-off-by: Dilip Kota <eswara.kota@linux.intel.com>
Link: https://lore.kernel.org/r/efb650b0faa49a00788c4e0ca8ef7196bdba851d.1594957019.git.eswara.kota@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-lantiq-ssc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/spi/spi-lantiq-ssc.c b/drivers/spi/spi-lantiq-ssc.c
index d5976615d924b..dc740b5f720ba 100644
--- a/drivers/spi/spi-lantiq-ssc.c
+++ b/drivers/spi/spi-lantiq-ssc.c
@@ -187,6 +187,7 @@ struct lantiq_ssc_spi {
 	unsigned int			tx_fifo_size;
 	unsigned int			rx_fifo_size;
 	unsigned int			base_cs;
+	unsigned int			fdx_tx_level;
 };
 
 static u32 lantiq_ssc_readl(const struct lantiq_ssc_spi *spi, u32 reg)
@@ -484,6 +485,7 @@ static void tx_fifo_write(struct lantiq_ssc_spi *spi)
 	u32 data;
 	unsigned int tx_free = tx_fifo_free(spi);
 
+	spi->fdx_tx_level = 0;
 	while (spi->tx_todo && tx_free) {
 		switch (spi->bits_per_word) {
 		case 2 ... 8:
@@ -512,6 +514,7 @@ static void tx_fifo_write(struct lantiq_ssc_spi *spi)
 
 		lantiq_ssc_writel(spi, data, LTQ_SPI_TB);
 		tx_free--;
+		spi->fdx_tx_level++;
 	}
 }
 
@@ -523,6 +526,13 @@ static void rx_fifo_read_full_duplex(struct lantiq_ssc_spi *spi)
 	u32 data;
 	unsigned int rx_fill = rx_fifo_level(spi);
 
+	/*
+	 * Wait until all expected data to be shifted in.
+	 * Otherwise, rx overrun may occur.
+	 */
+	while (rx_fill != spi->fdx_tx_level)
+		rx_fill = rx_fifo_level(spi);
+
 	while (rx_fill) {
 		data = lantiq_ssc_readl(spi, LTQ_SPI_RB);
 
-- 
2.25.1



