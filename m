Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0F52121449
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730548AbfLPSKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:10:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730543AbfLPSKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:10:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99CF2206E0;
        Mon, 16 Dec 2019 18:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519801;
        bh=J9rVZcIibE8KKmf4ktt4ACclYyInwY8C4/rXZDkABj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rk7jJFxR/Cw7CnGBgyi4GtqmI7YiyhjCcB6Keh3aDCzCfzVZ55fcmzpQBBBGIhE+E
         vYqBLt5jfPPuXGCV1320fTEaEK0KKP5mUhm8pqm/Wq1ZCsSbWl/I2LWI+k1ZvI45Zo
         9ZPAtzQFVJk4ndgI/EZpbQZWL2vJQNHJNVJpIWTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mircea Caprioru <mircea.caprioru@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.3 033/180] iio: adc: ad7124: Enable internal reference
Date:   Mon, 16 Dec 2019 18:47:53 +0100
Message-Id: <20191216174814.591886363@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mircea Caprioru <mircea.caprioru@analog.com>

commit 11d7c8d3b1259c303fb52789febed58f0bc35ad1 upstream.

When the internal reference was selected by a channel it was not enabled.
This patch fixes that and enables it.

Fixes: b3af341bbd96 ("iio: adc: Add ad7124 support")
Signed-off-by: Mircea Caprioru <mircea.caprioru@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ad7124.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -39,6 +39,8 @@
 #define AD7124_STATUS_POR_FLAG_MSK	BIT(4)
 
 /* AD7124_ADC_CONTROL */
+#define AD7124_ADC_CTRL_REF_EN_MSK	BIT(8)
+#define AD7124_ADC_CTRL_REF_EN(x)	FIELD_PREP(AD7124_ADC_CTRL_REF_EN_MSK, x)
 #define AD7124_ADC_CTRL_PWR_MSK	GENMASK(7, 6)
 #define AD7124_ADC_CTRL_PWR(x)		FIELD_PREP(AD7124_ADC_CTRL_PWR_MSK, x)
 #define AD7124_ADC_CTRL_MODE_MSK	GENMASK(5, 2)
@@ -424,7 +426,10 @@ static int ad7124_init_channel_vref(stru
 		break;
 	case AD7124_INT_REF:
 		st->channel_config[channel_number].vref_mv = 2500;
-		break;
+		st->adc_control &= ~AD7124_ADC_CTRL_REF_EN_MSK;
+		st->adc_control |= AD7124_ADC_CTRL_REF_EN(1);
+		return ad_sd_write_reg(&st->sd, AD7124_ADC_CONTROL,
+				      2, st->adc_control);
 	default:
 		dev_err(&st->sd.spi->dev, "Invalid reference %d\n", refsel);
 		return -EINVAL;


