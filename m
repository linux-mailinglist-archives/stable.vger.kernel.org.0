Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E5926B667
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgIPAEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:04:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgIOO3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:29:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AF18229C9;
        Tue, 15 Sep 2020 14:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179674;
        bh=TelFs5DRtu/ns8dH0C70STQs/zQzZTtdnUp8n6R4ye8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H0OsF7PsXH6tfCp2e1W+rY45MWbtMhpoiH9V6Td2XIRZCWIqXddLRX+MGRsHE609C
         3VnVpf4FVP70cf5ztx8V4Ot8HxcitfQsFrYVwlxKUmOikYotczp+36v1Y1JoCTUNdP
         hgbnaYV32qnEfCS9nEMnql7HWRBbzh2JhywyWU/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 074/132] iio: adc: mcp3422: fix locking scope
Date:   Tue, 15 Sep 2020 16:12:56 +0200
Message-Id: <20200915140647.812623816@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Angelo Compagnucci <angelo.compagnucci@gmail.com>

commit 3f1093d83d7164e4705e4232ccf76da54adfda85 upstream.

Locking should be held for the entire reading sequence involving setting
the channel, waiting for the channel switch and reading from the
channel.
If not, reading from a channel can result mixing with the reading from
another channel.

Fixes: 07914c84ba30 ("iio: adc: Add driver for Microchip MCP3422/3/4 high resolution ADC")
Signed-off-by: Angelo Compagnucci <angelo.compagnucci@gmail.com>
Link: https://lore.kernel.org/r/20200819075525.1395248-1-angelo.compagnucci@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/mcp3422.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/iio/adc/mcp3422.c
+++ b/drivers/iio/adc/mcp3422.c
@@ -95,16 +95,12 @@ static int mcp3422_update_config(struct
 {
 	int ret;
 
-	mutex_lock(&adc->lock);
-
 	ret = i2c_master_send(adc->i2c, &newconfig, 1);
 	if (ret > 0) {
 		adc->config = newconfig;
 		ret = 0;
 	}
 
-	mutex_unlock(&adc->lock);
-
 	return ret;
 }
 
@@ -137,6 +133,8 @@ static int mcp3422_read_channel(struct m
 	u8 config;
 	u8 req_channel = channel->channel;
 
+	mutex_lock(&adc->lock);
+
 	if (req_channel != MCP3422_CHANNEL(adc->config)) {
 		config = adc->config;
 		config &= ~MCP3422_CHANNEL_MASK;
@@ -151,7 +149,11 @@ static int mcp3422_read_channel(struct m
 		msleep(mcp3422_read_times[MCP3422_SAMPLE_RATE(adc->config)]);
 	}
 
-	return mcp3422_read(adc, value, &config);
+	ret = mcp3422_read(adc, value, &config);
+
+	mutex_unlock(&adc->lock);
+
+	return ret;
 }
 
 static int mcp3422_read_raw(struct iio_dev *iio,


