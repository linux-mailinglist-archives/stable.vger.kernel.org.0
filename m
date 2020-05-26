Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA2F1E2D63
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391320AbgEZTJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391883AbgEZTJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:09:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFC8420776;
        Tue, 26 May 2020 19:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520172;
        bh=p9OcJyFAMvLDmi1flaOtACr8M52ClYUm0OlUxAf6mzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aApTGsV1YphuczxV4JxSp3lm0VWQIlFBLPD3EAwCOVqC1fiXueMEb+nA6uZotZpBV
         ulhv/D69fb6TIPZhIqrdURYbV1JhN143vAFdCe8n2cP6joOyet0woZBnyuZRrA7F0V
         qqzeDuDzh4OVqYPErUDucXVzNhNtGPgxcunJJXGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 087/111] iio: adc: ti-ads8344: Fix channel selection
Date:   Tue, 26 May 2020 20:53:45 +0200
Message-Id: <20200526183941.168613269@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gregory CLEMENT <gregory.clement@bootlin.com>

commit bcfa1e253d2e329e1ebab5c89f3c73f6dd17606c upstream.

During initial submission the selection of the channel was done using
the scan_index member of the iio_chan_spec structure. It was an abuse
because this member is supposed to be used with a buffer so it was
removed.

However there was still the need to be able to known how to select a
channel, the correct member to store this information is address.

Thanks to this it is possible to select any other channel than the
channel 0.

Fixes: 8dd2d7c0fed7 ("iio: adc: Add driver for the TI ADS8344 A/DC chips")
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ti-ads8344.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/ti-ads8344.c
+++ b/drivers/iio/adc/ti-ads8344.c
@@ -32,16 +32,17 @@ struct ads8344 {
 	u8 rx_buf[3];
 };
 
-#define ADS8344_VOLTAGE_CHANNEL(chan, si)				\
+#define ADS8344_VOLTAGE_CHANNEL(chan, addr)				\
 	{								\
 		.type = IIO_VOLTAGE,					\
 		.indexed = 1,						\
 		.channel = chan,					\
 		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
 		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),	\
+		.address = addr,					\
 	}
 
-#define ADS8344_VOLTAGE_CHANNEL_DIFF(chan1, chan2, si)			\
+#define ADS8344_VOLTAGE_CHANNEL_DIFF(chan1, chan2, addr)		\
 	{								\
 		.type = IIO_VOLTAGE,					\
 		.indexed = 1,						\
@@ -50,6 +51,7 @@ struct ads8344 {
 		.differential = 1,					\
 		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
 		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),	\
+		.address = addr,					\
 	}
 
 static const struct iio_chan_spec ads8344_channels[] = {
@@ -105,7 +107,7 @@ static int ads8344_read_raw(struct iio_d
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
 		mutex_lock(&adc->lock);
-		*value = ads8344_adc_conversion(adc, channel->scan_index,
+		*value = ads8344_adc_conversion(adc, channel->address,
 						channel->differential);
 		mutex_unlock(&adc->lock);
 		if (*value < 0)


