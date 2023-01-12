Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A771B667643
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237378AbjALOaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237393AbjALO2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:28:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437535D42C
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:19:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F024DB81E6A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DA2C433D2;
        Thu, 12 Jan 2023 14:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533154;
        bh=m22/9FuUJg1regPUCYE/ppXSR0JJAWxRNvmMrB/SHss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWrjrE65eWzkDmiZ0PMCJzHJ45kEPe+BoR6+BaxjzL4Ae8Go0ajJwIzIO701aGica
         QRz3DrBB7fA8qxTB4nV3eKWhuWkmipuNwXNhQWfR9KxPRLwb3mhiITblO0dqZVfoUR
         E+A3wO/1dGk9HtmMsQaQcSg6cwoO2WcVihwv81BU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 370/783] iio: adis: handle devices that cannot unmask the drdy pin
Date:   Thu, 12 Jan 2023 14:51:26 +0100
Message-Id: <20230112135541.489080306@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 715eef81bc24..5fcf269e98a6 100644
--- a/drivers/iio/imu/adis.c
+++ b/drivers/iio/imu/adis.c
@@ -290,6 +290,13 @@ int adis_enable_irq(struct adis *adis, bool enable)
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
@@ -434,7 +441,13 @@ int __adis_initial_startup(struct adis *adis)
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
index 17058ac7aa9f..76b0488ef41b 100644
--- a/drivers/iio/imu/adis_trigger.c
+++ b/drivers/iio/imu/adis_trigger.c
@@ -37,6 +37,10 @@ static void adis_trigger_setup(struct adis *adis)
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
index 04e96d688ba9..2ced0c88f481 100644
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
@@ -77,6 +78,7 @@ struct adis_data {
 	unsigned int status_error_mask;
 
 	int (*enable_irq)(struct adis *adis, bool enable);
+	bool unmasked_drdy;
 
 	bool has_paging;
 
-- 
2.35.1



