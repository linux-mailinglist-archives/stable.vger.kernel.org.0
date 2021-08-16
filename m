Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C68A3ED5FE
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239713AbhHPNQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237283AbhHPNND (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:13:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14429632AA;
        Mon, 16 Aug 2021 13:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119431;
        bh=PmLQkYivfrmVLCyY2Lp0dOcMm/pXXRkmz8Q/TzXpCeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDYd4uZAwJCPoP5EYMa2KoSHahWUh1cH7cP5MqnNMBwkfoqfWpN0FQU/rxK48LhvF
         Wu/9d8e/u5x2TMs4I4qAYTFbEhxojfRpzw6BydN/qbVn6EETwum9KSLX0c8FO7L0dO
         FwTdqW7fd05xf9ZFX2JvJDQh9s4nCa6q37fa2op8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Lesiak <chris.lesiak@licor.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.13 005/151] iio: humidity: hdc100x: Add margin to the conversion time
Date:   Mon, 16 Aug 2021 15:00:35 +0200
Message-Id: <20210816125444.259297225@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Lesiak <chris.lesiak@licor.com>

commit 84edec86f449adea9ee0b4912a79ab8d9d65abb7 upstream.

The datasheets have the following note for the conversion time
specification: "This parameter is specified by design and/or
characterization and it is not tested in production."

Parts have been seen that require more time to do 14-bit conversions for
the relative humidity channel.  The result is ENXIO due to the address
phase of a transfer not getting an ACK.

Delay an additional 1 ms per conversion to allow for additional margin.

Fixes: 4839367d99e3 ("iio: humidity: add HDC100x support")
Signed-off-by: Chris Lesiak <chris.lesiak@licor.com>
Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
Link: https://lore.kernel.org/r/20210614141820.2034827-1-chris.lesiak@licor.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/humidity/hdc100x.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iio/humidity/hdc100x.c
+++ b/drivers/iio/humidity/hdc100x.c
@@ -25,6 +25,8 @@
 #include <linux/iio/trigger_consumer.h>
 #include <linux/iio/triggered_buffer.h>
 
+#include <linux/time.h>
+
 #define HDC100X_REG_TEMP			0x00
 #define HDC100X_REG_HUMIDITY			0x01
 
@@ -166,7 +168,7 @@ static int hdc100x_get_measurement(struc
 				   struct iio_chan_spec const *chan)
 {
 	struct i2c_client *client = data->client;
-	int delay = data->adc_int_us[chan->address];
+	int delay = data->adc_int_us[chan->address] + 1*USEC_PER_MSEC;
 	int ret;
 	__be16 val;
 
@@ -316,7 +318,7 @@ static irqreturn_t hdc100x_trigger_handl
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct hdc100x_data *data = iio_priv(indio_dev);
 	struct i2c_client *client = data->client;
-	int delay = data->adc_int_us[0] + data->adc_int_us[1];
+	int delay = data->adc_int_us[0] + data->adc_int_us[1] + 2*USEC_PER_MSEC;
 	int ret;
 
 	/* dual read starts at temp register */


