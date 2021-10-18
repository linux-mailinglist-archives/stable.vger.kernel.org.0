Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B76431C0A
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbhJRNhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233205AbhJRNfr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:35:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62DE5613B1;
        Mon, 18 Oct 2021 13:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563854;
        bh=lZ6e+SSnM1TUAUTuKQCwy6hZ3pcXZx5MHel341hCe4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqDRo3rGKnwVzU4BuyGXkTNZkwgXJBDQbTm6ho26Dt67zZjgQybVwyUYKprQJE5qo
         vMQmw/BJdFUrIpSE54oBzVdK2osGubov/xcOB9L9TP9N56WE3WrpwlOPoHngiY7TRT
         CpgjgOrOZJ793g0TLMKPg3SwVcY/VjpCnfVjjZwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Liu <hui.liu@mediatek.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 40/69] iio: mtk-auxadc: fix case IIO_CHAN_INFO_PROCESSED
Date:   Mon, 18 Oct 2021 15:24:38 +0200
Message-Id: <20211018132330.801284592@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Liu <hui.liu@mediatek.com>

commit c2980c64c7fd4585d684574c92d1624d44961edd upstream.

The previous driver does't apply the necessary scaling to take the
voltage range into account.
We change readback value from raw data to input voltage to fix case
IIO_CHAN_INFO_PROCESSED.

Fixes: ace4cdfe67be ("iio: adc: mt2701: Add Mediatek auxadc driver for mt2701.")
Signed-off-by: Hui Liu <hui.liu@mediatek.com>
Link: https://lore.kernel.org/r/20210926073028.11045-2-hui.liu@mediatek.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/mt6577_auxadc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/iio/adc/mt6577_auxadc.c
+++ b/drivers/iio/adc/mt6577_auxadc.c
@@ -82,6 +82,10 @@ static const struct iio_chan_spec mt6577
 	MT6577_AUXADC_CHANNEL(15),
 };
 
+/* For Voltage calculation */
+#define VOLTAGE_FULL_RANGE  1500	/* VA voltage */
+#define AUXADC_PRECISE      4096	/* 12 bits */
+
 static int mt_auxadc_get_cali_data(int rawdata, bool enable_cali)
 {
 	return rawdata;
@@ -191,6 +195,10 @@ static int mt6577_auxadc_read_raw(struct
 		}
 		if (adc_dev->dev_comp->sample_data_cali)
 			*val = mt_auxadc_get_cali_data(*val, true);
+
+		/* Convert adc raw data to voltage: 0 - 1500 mV */
+		*val = *val * VOLTAGE_FULL_RANGE / AUXADC_PRECISE;
+
 		return IIO_VAL_INT;
 
 	default:


