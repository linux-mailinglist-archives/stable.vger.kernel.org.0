Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B966E657C69
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbiL1Pcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbiL1PcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:32:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E01416489
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:32:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44FEBB8170E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B226AC433F0;
        Wed, 28 Dec 2022 15:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241525;
        bh=RbrP1irQ8j/Lcj9YrEfwriYCsl+nOfxlvSAUHujHDsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdPHV5ArtsREqVRoAzksmdaarZCjqNxOLUYKcWXtgGQRWR5sS6HIz5cuog+rqM+p/
         GsdRqdDsTXaUdezoirWZ+z9RGFe38gAjgULCNkkIkQ0TcyLPFPJxkhgQvZ+QtbrALj
         VObemFyQGjUXnmQ6l3MDmmgmxjXePC715ZIS3cuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 474/731] iio: adis: handle devices that cannot unmask the drdy pin
Date:   Wed, 28 Dec 2022 15:39:41 +0100
Message-Id: <20221228144310.289809844@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 31fa357ac809affd9f9a7d0b5d1991951e16beec ]

Some devices can't mask/unmask the data ready pin and in those cases
each driver was just calling '{dis}enable_irq()' to control the trigger
state. This change, moves that handling into the library by introducing
a new boolean in the data structure that tells the library that the
device cannot unmask the pin.

On top of controlling the trigger state, we can also use this flag to
automatically request the IRQ with 'IRQF_NO_AUTOEN' in case it is set.
So far, all users of the library want to start operation with IRQs/DRDY
pin disabled so it should be fairly safe to do this inside the library.

Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210903141423.517028-3-nuno.sa@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 99c05e4283a1 ("iio: adis: add '__adis_enable_irq()' implementation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis.c         | 15 ++++++++++++++-
 drivers/iio/imu/adis_trigger.c |  4 ++++
 include/linux/iio/imu/adis.h   |  2 ++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/adis.c b/drivers/iio/imu/adis.c
index d4e692b187cd..cb0d66bf6561 100644
--- a/drivers/iio/imu/adis.c
+++ b/drivers/iio/imu/adis.c
@@ -286,6 +286,13 @@ int adis_enable_irq(struct adis *adis, bool enable)
 	if (adis->data->enable_irq) {
 		ret = adis->data->enable_irq(adis, enable);
 		goto out_unlock;
+	} else if (adis->data->unmasked_drdy) {
+		if (enable)
+			enable_irq(adis->spi->irq);
+		else
+			disable_irq(adis->spi->irq);
+
+		goto out_unlock;
 	}
 
 	ret = __adis_read_reg_16(adis, adis->data->msc_ctrl_reg, &msc);
@@ -430,7 +437,13 @@ int __adis_initial_startup(struct adis *adis)
 	if (ret)
 		return ret;
 
-	adis_enable_irq(adis, false);
+	/*
+	 * don't bother calling this if we can't unmask the IRQ as in this case
+	 * the IRQ is most likely not yet requested and we will request it
+	 * with 'IRQF_NO_AUTOEN' anyways.
+	 */
+	if (!adis->data->unmasked_drdy)
+		adis_enable_irq(adis, false);
 
 	if (!adis->data->prod_id_reg)
 		return 0;
diff --git a/drivers/iio/imu/adis_trigger.c b/drivers/iio/imu/adis_trigger.c
index 48eedc29b28a..c461bd1e8e69 100644
--- a/drivers/iio/imu/adis_trigger.c
+++ b/drivers/iio/imu/adis_trigger.c
@@ -30,6 +30,10 @@ static const struct iio_trigger_ops adis_trigger_ops = {
 static int adis_validate_irq_flag(struct adis *adis)
 {
 	unsigned long direction = adis->irq_flag & IRQF_TRIGGER_MASK;
+
+	/* We cannot mask the interrupt so ensure it's not enabled at request */
+	if (adis->data->unmasked_drdy)
+		adis->irq_flag |= IRQF_NO_AUTOEN;
 	/*
 	 * Typically this devices have data ready either on the rising edge or
 	 * on the falling edge of the data ready pin. This checks enforces that
diff --git a/include/linux/iio/imu/adis.h b/include/linux/iio/imu/adis.h
index cf49997d5903..7c02f5292eea 100644
--- a/include/linux/iio/imu/adis.h
+++ b/include/linux/iio/imu/adis.h
@@ -49,6 +49,7 @@ struct adis_timeout {
  * @status_error_mask: Bitmask of errors supported by the device
  * @timeouts: Chip specific delays
  * @enable_irq: Hook for ADIS devices that have a special IRQ enable/disable
+ * @unmasked_drdy: True for devices that cannot mask/unmask the data ready pin
  * @has_paging: True if ADIS device has paged registers
  * @burst_reg_cmd:	Register command that triggers burst
  * @burst_len:		Burst size in the SPI RX buffer. If @burst_max_len is defined,
@@ -78,6 +79,7 @@ struct adis_data {
 	unsigned int status_error_mask;
 
 	int (*enable_irq)(struct adis *adis, bool enable);
+	bool unmasked_drdy;
 
 	bool has_paging;
 
-- 
2.35.1



