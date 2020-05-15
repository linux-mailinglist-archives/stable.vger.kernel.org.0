Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786061D4FF7
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 16:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgEOOGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 10:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgEOOGO (ORCPT <rfc822;Stable@vger.kernel.org>);
        Fri, 15 May 2020 10:06:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C521A206B6;
        Fri, 15 May 2020 14:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589551574;
        bh=+i3/ZFjHjz4Uqt351+PIV6upz86BE4NmrHdqXBcDdsg=;
        h=Subject:To:From:Date:From;
        b=sc01btdcULsJeQfSg2G+PXtWI4mt5SA/5jjqzv4WTdl0ep52gMIqvND9hPnDIyLbv
         vEWidRgPJFE/JGFKeuAnBNOfLw23ymtLSTgrOylX+tNq9myMGYPbVolq+4lJiPXSNA
         253VSnacQ5WwG3k9sJAlrbLNU4R46GMb8g3VbFXc=
Subject: patch "staging: iio: ad2s1210: Fix SPI reading" added to staging-linus
To:     dragos.bogdan@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, alexandru.ardelean@analog.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 May 2020 16:06:07 +0200
Message-ID: <158955156758208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: iio: ad2s1210: Fix SPI reading

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5e4f99a6b788047b0b8a7496c2e0c8f372f6edf2 Mon Sep 17 00:00:00 2001
From: Dragos Bogdan <dragos.bogdan@analog.com>
Date: Wed, 29 Apr 2020 10:21:29 +0300
Subject: staging: iio: ad2s1210: Fix SPI reading

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
---
 drivers/staging/iio/resolver/ad2s1210.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/iio/resolver/ad2s1210.c b/drivers/staging/iio/resolver/ad2s1210.c
index 4b25a3a314ed..ed404355ea4c 100644
--- a/drivers/staging/iio/resolver/ad2s1210.c
+++ b/drivers/staging/iio/resolver/ad2s1210.c
@@ -130,17 +130,24 @@ static int ad2s1210_config_write(struct ad2s1210_state *st, u8 data)
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
 
-- 
2.26.2


