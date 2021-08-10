Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3EEC3E53F4
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 08:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbhHJG4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 02:56:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231482AbhHJG4D (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 10 Aug 2021 02:56:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CC7660FC4;
        Tue, 10 Aug 2021 06:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628578541;
        bh=SeHYDimNQH4mQD9jBWtANp0yyLGtmvplf8V0qnfkm7c=;
        h=Subject:To:From:Date:From;
        b=gpZKRx1t7tQqOGqwVMzJGF+Jej34LVKqjeye2P9wER19MOO082Lq8qOTD+oBD7sKJ
         liaeFRG1Tjr2F3hrvVl6mczePGYlef25Ho+psKRaeuemGM4BoKBisVBxjKs9+e/1jc
         L84QIZe7RgKkhJeutZKW4c+U+jjTJUT4jrlmZ6so=
Subject: patch "iio: adc: ti-ads7950: Ensure CS is deasserted after reading channels" added to staging-linus
To:     u.kleine-koenig@pengutronix.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, david@lechnology.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Aug 2021 08:55:31 +0200
Message-ID: <162857853155166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ti-ads7950: Ensure CS is deasserted after reading channels

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9898cb24e454602beb6e17bacf9f97b26c85c955 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Date: Fri, 9 Jul 2021 12:11:10 +0200
Subject: iio: adc: ti-ads7950: Ensure CS is deasserted after reading channels
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The ADS7950 requires that CS is deasserted after each SPI word. Before
commit e2540da86ef8 ("iio: adc: ti-ads7950: use SPI_CS_WORD to reduce
CPU usage") the driver used a message with one spi transfer per channel
where each but the last one had .cs_change set to enforce a CS toggle.
This was wrongly translated into a message with a single transfer and
.cs_change set which results in a CS toggle after each word but the
last which corrupts the first adc conversion of all readouts after the
first readout.

Fixes: e2540da86ef8 ("iio: adc: ti-ads7950: use SPI_CS_WORD to reduce CPU usage")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: David Lechner <david@lechnology.com>
Tested-by: David Lechner <david@lechnology.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210709101110.1814294-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ti-ads7950.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iio/adc/ti-ads7950.c b/drivers/iio/adc/ti-ads7950.c
index 2383eacada87..a2b83f0bd526 100644
--- a/drivers/iio/adc/ti-ads7950.c
+++ b/drivers/iio/adc/ti-ads7950.c
@@ -568,7 +568,6 @@ static int ti_ads7950_probe(struct spi_device *spi)
 	st->ring_xfer.tx_buf = &st->tx_buf[0];
 	st->ring_xfer.rx_buf = &st->rx_buf[0];
 	/* len will be set later */
-	st->ring_xfer.cs_change = true;
 
 	spi_message_add_tail(&st->ring_xfer, &st->ring_msg);
 
-- 
2.32.0


