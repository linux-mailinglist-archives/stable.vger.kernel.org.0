Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323601F2D0A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbgFIAa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730089AbgFHXPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3B9220659;
        Mon,  8 Jun 2020 23:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658144;
        bh=NIvfnbAIw5QiLc2iBkfIAXHTrtRPZKfqnsnYAz9ZcoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zAxxxOiPCejfHMqXscA2CSRKCvkRBq0/TkIGlgCdQbm4O9rOx60/9FHTj+D9Hcm/H
         2MdfuaqIumRBfCjavvluZ2v6QX8VH+RV9sFfdZtlZfa8thuzxoObCsw+v85XT4zL0U
         KhN36uMRH3HNZf0Hc9S6c52bnAxw6006N2JDdHWs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 177/606] iio: adc: ti-ads8344: Fix channel selection
Date:   Mon,  8 Jun 2020 19:05:02 -0400
Message-Id: <20200608231211.3363633-177-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/iio/adc/ti-ads8344.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ti-ads8344.c b/drivers/iio/adc/ti-ads8344.c
index abe4b56c847c..8a8792010c20 100644
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
@@ -105,7 +107,7 @@ static int ads8344_read_raw(struct iio_dev *iio,
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
 		mutex_lock(&adc->lock);
-		*value = ads8344_adc_conversion(adc, channel->scan_index,
+		*value = ads8344_adc_conversion(adc, channel->address,
 						channel->differential);
 		mutex_unlock(&adc->lock);
 		if (*value < 0)
-- 
2.25.1

