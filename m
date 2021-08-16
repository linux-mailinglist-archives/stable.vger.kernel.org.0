Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324283ED506
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237126AbhHPNHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:07:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237145AbhHPNGQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:06:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BF1F63292;
        Mon, 16 Aug 2021 13:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119144;
        bh=0GJHKCgtQFCa5wy20nwIEnS5gRWm1ntnOwSJe8/LrRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YdppYaHSD/VzrGiI5qslZ1I/5j7wI0T60sWNAFg3/rg08uvnZ4UXYgrRqmaVFvbyE
         CJgxMmvwX0BJAn+dQpl+ks5AdDplXfFPkMa6NmwHjEM+Mo3jOduCYhJFnjKiTgdYQq
         7IrMbxErAAGaSs5Rf2CKS3TNxD3H4hEsewFMR7mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        David Lechner <david@lechnology.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 01/96] iio: adc: ti-ads7950: Ensure CS is deasserted after reading channels
Date:   Mon, 16 Aug 2021 15:01:11 +0200
Message-Id: <20210816125434.995485081@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 9898cb24e454602beb6e17bacf9f97b26c85c955 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads7950.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/iio/adc/ti-ads7950.c
+++ b/drivers/iio/adc/ti-ads7950.c
@@ -568,7 +568,6 @@ static int ti_ads7950_probe(struct spi_d
 	st->ring_xfer.tx_buf = &st->tx_buf[0];
 	st->ring_xfer.rx_buf = &st->rx_buf[0];
 	/* len will be set later */
-	st->ring_xfer.cs_change = true;
 
 	spi_message_add_tail(&st->ring_xfer, &st->ring_msg);
 


