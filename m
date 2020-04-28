Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633BF1BC9C6
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730995AbgD1Sll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730103AbgD1Sli (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:41:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3E0720730;
        Tue, 28 Apr 2020 18:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099298;
        bh=HVlooMNtiKSy3RQDjckeLqwmZgxF92lbXT5tCZ8rwnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozbgkO/9+7F38E12L3FqkblYO/Z77XCEyPmcg0wnnylyo7I/QaoDmhtdVTJyyNE6I
         900H+akJV2Hx4XjBID03gTyepe0z8rye2Vwjj7orDgvf7Aw1JXZgHP88TLG0AjOlO2
         BfmiFrPaf9Nw5mgqP85wFeXig5SG8ENvq25LMJgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 090/168] iio: adc: ti-ads8344: properly byte swap value
Date:   Tue, 28 Apr 2020 20:24:24 +0200
Message-Id: <20200428182243.717966856@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

commit dd7de4c0023e7564cabe39d64b2822a522890792 upstream.

The first received byte is the MSB, followed by the LSB so the value needs
to be byte swapped.

Also, the ADC actually has a delay of one clock on the SPI bus. Read three
bytes to get the last bit.

Fixes: 8dd2d7c0fed7 ("iio: adc: Add driver for the TI ADS8344 A/DC chips")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ti-ads8344.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/ti-ads8344.c
+++ b/drivers/iio/adc/ti-ads8344.c
@@ -29,7 +29,7 @@ struct ads8344 {
 	struct mutex lock;
 
 	u8 tx_buf ____cacheline_aligned;
-	u16 rx_buf;
+	u8 rx_buf[3];
 };
 
 #define ADS8344_VOLTAGE_CHANNEL(chan, si)				\
@@ -89,11 +89,11 @@ static int ads8344_adc_conversion(struct
 
 	udelay(9);
 
-	ret = spi_read(spi, &adc->rx_buf, 2);
+	ret = spi_read(spi, adc->rx_buf, sizeof(adc->rx_buf));
 	if (ret)
 		return ret;
 
-	return adc->rx_buf;
+	return adc->rx_buf[0] << 9 | adc->rx_buf[1] << 1 | adc->rx_buf[2] >> 7;
 }
 
 static int ads8344_read_raw(struct iio_dev *iio,


