Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790981E2E7E
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391029AbgEZTCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:02:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403815AbgEZTCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:02:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40C5A2084C;
        Tue, 26 May 2020 19:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519721;
        bh=vD5WoP4lTdpRbN/IxdmcqV8p9UNc8KxGm1x8FKbUuus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAKF/OvSQ+ii/nDKEjCiYH2nrdsKqNxYG40mz5RgOX8Cq/aoGNcH2Ac6i0SmdXU1F
         GGYqnQUlzXal5EcYtfFEO/cjO5EMubCpcqtOQa+kezpvQvFq2s5rdB72jkXSUfzQS7
         4wTmst5TBc2uxr90HjMKuzGy7Zc/Iza427CPIveg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dragos Bogdan <dragos.bogdan@analog.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 50/59] staging: iio: ad2s1210: Fix SPI reading
Date:   Tue, 26 May 2020 20:53:35 +0200
Message-Id: <20200526183922.637497629@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183907.123822792@linuxfoundation.org>
References: <20200526183907.123822792@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dragos Bogdan <dragos.bogdan@analog.com>

commit 5e4f99a6b788047b0b8a7496c2e0c8f372f6edf2 upstream.

If the serial interface is used, the 8-bit address should be latched using
the rising edge of the WR/FSYNC signal.

This basically means that a CS change is required between the first byte
sent, and the second one.
This change splits the single-transfer transfer of 2 bytes into 2 transfers
with a single byte, and CS change in-between.

Note fixes tag is not accurate, but reflects a point beyond which there
are too many refactors to make backporting straight forward.

Fixes: b19e9ad5e2cb ("staging:iio:resolver:ad2s1210 general driver cleanup.")
Signed-off-by: Dragos Bogdan <dragos.bogdan@analog.com>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/iio/resolver/ad2s1210.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/staging/iio/resolver/ad2s1210.c
+++ b/drivers/staging/iio/resolver/ad2s1210.c
@@ -126,17 +126,24 @@ static int ad2s1210_config_write(struct
 static int ad2s1210_config_read(struct ad2s1210_state *st,
 				unsigned char address)
 {
-	struct spi_transfer xfer = {
-		.len = 2,
-		.rx_buf = st->rx,
-		.tx_buf = st->tx,
+	struct spi_transfer xfers[] = {
+		{
+			.len = 1,
+			.rx_buf = &st->rx[0],
+			.tx_buf = &st->tx[0],
+			.cs_change = 1,
+		}, {
+			.len = 1,
+			.rx_buf = &st->rx[1],
+			.tx_buf = &st->tx[1],
+		},
 	};
 	int ret = 0;
 
 	ad2s1210_set_mode(MOD_CONFIG, st);
 	st->tx[0] = address | AD2S1210_MSB_IS_HIGH;
 	st->tx[1] = AD2S1210_REG_FAULT;
-	ret = spi_sync_transfer(st->sdev, &xfer, 1);
+	ret = spi_sync_transfer(st->sdev, xfers, 2);
 	if (ret < 0)
 		return ret;
 	st->old_data = true;


