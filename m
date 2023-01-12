Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B34E667611
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237192AbjALO2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:28:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237204AbjALO1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:27:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485C85790E
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:18:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1D1261FCB
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E70C433D2;
        Thu, 12 Jan 2023 14:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533121;
        bh=A+9ksah5KvmIWx3MrKo+M9nNXzXe9yZyLD3ExquifNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kqPeyXW10DwkLxONGA5iEJb4QwcGQqiQ/AhU+t1toz7b+zrKrPV7ilznsDVUHx+ar
         pKe5QS2SKsAD6NEdXRtkUH7MQZipqnlSLrwyv7wA35VWZKwAj/BBr4A9JaECNP7Zl0
         /6Rqsc5UOQb6u55Um0O9rwJgQlIbAnZKUQZrFVqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Nuno Sa <nuno.sa@analog.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 369/783] iio:imu:adis: Use IRQF_NO_AUTOEN instead of irq request then disable
Date:   Thu, 12 Jan 2023 14:51:25 +0100
Message-Id: <20230112135541.439174562@linuxfoundation.org>
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 30f6a542b7d39b1ba990a28a3891bc03691d8d41 ]

This is a bit involved as the adis library code already has some
sanity checking of the flags of the requested irq that we need
to ensure is happy to pass through the IRQF_NO_AUTOEN flag untouched.

Using this flag avoids us autoenabling the irq in the adis16460 and
adis16475 drivers which cover parts that don't have any means of
masking the interrupt on the device end.

Note, compile tested only!

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Alexandru Ardelean <ardeleanalex@gmail.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Reviewed-by: Barry Song <song.bao.hua@hisilicon.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20210402184544.488862-7-jic23@kernel.org
Stable-dep-of: 99c05e4283a1 ("iio: adis: add '__adis_enable_irq()' implementation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis16460.c    |  4 ++--
 drivers/iio/imu/adis16475.c    |  5 +++--
 drivers/iio/imu/adis_trigger.c | 11 ++++++-----
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/iio/imu/adis16460.c b/drivers/iio/imu/adis16460.c
index 74a161e39733..73bf45e859b8 100644
--- a/drivers/iio/imu/adis16460.c
+++ b/drivers/iio/imu/adis16460.c
@@ -403,12 +403,12 @@ static int adis16460_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
+	/* We cannot mask the interrupt, so ensure it isn't auto enabled */
+	st->adis.irq_flag |= IRQF_NO_AUTOEN;
 	ret = devm_adis_setup_buffer_and_trigger(&st->adis, indio_dev, NULL);
 	if (ret)
 		return ret;
 
-	adis16460_enable_irq(&st->adis, 0);
-
 	ret = __adis_initial_startup(&st->adis);
 	if (ret)
 		return ret;
diff --git a/drivers/iio/imu/adis16475.c b/drivers/iio/imu/adis16475.c
index 3c4e4deb8760..8ab88ba4892c 100644
--- a/drivers/iio/imu/adis16475.c
+++ b/drivers/iio/imu/adis16475.c
@@ -1196,6 +1196,9 @@ static int adis16475_config_irq_pin(struct adis16475 *st)
 		return -EINVAL;
 	}
 
+	/* We cannot mask the interrupt so ensure it's not enabled at request */
+	st->adis.irq_flag |= IRQF_NO_AUTOEN;
+
 	val = ADIS16475_MSG_CTRL_DR_POL(polarity);
 	ret = __adis_update_bits(&st->adis, ADIS16475_REG_MSG_CTRL,
 				 ADIS16475_MSG_CTRL_DR_POL_MASK, val);
@@ -1300,8 +1303,6 @@ static int adis16475_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
-	adis16475_enable_irq(&st->adis, false);
-
 	ret = devm_iio_device_register(&spi->dev, indio_dev);
 	if (ret)
 		return ret;
diff --git a/drivers/iio/imu/adis_trigger.c b/drivers/iio/imu/adis_trigger.c
index 64e0ba51cb18..17058ac7aa9f 100644
--- a/drivers/iio/imu/adis_trigger.c
+++ b/drivers/iio/imu/adis_trigger.c
@@ -36,18 +36,19 @@ static void adis_trigger_setup(struct adis *adis)
 
 static int adis_validate_irq_flag(struct adis *adis)
 {
+	unsigned long direction = adis->irq_flag & IRQF_TRIGGER_MASK;
 	/*
 	 * Typically this devices have data ready either on the rising edge or
 	 * on the falling edge of the data ready pin. This checks enforces that
 	 * one of those is set in the drivers... It defaults to
-	 * IRQF_TRIGGER_RISING for backward compatibility wiht devices that
+	 * IRQF_TRIGGER_RISING for backward compatibility with devices that
 	 * don't support changing the pin polarity.
 	 */
-	if (!adis->irq_flag) {
-		adis->irq_flag = IRQF_TRIGGER_RISING;
+	if (direction == IRQF_TRIGGER_NONE) {
+		adis->irq_flag |= IRQF_TRIGGER_RISING;
 		return 0;
-	} else if (adis->irq_flag != IRQF_TRIGGER_RISING &&
-		   adis->irq_flag != IRQF_TRIGGER_FALLING) {
+	} else if (direction != IRQF_TRIGGER_RISING &&
+		   direction != IRQF_TRIGGER_FALLING) {
 		dev_err(&adis->spi->dev, "Invalid IRQ mask: %08lx\n",
 			adis->irq_flag);
 		return -EINVAL;
-- 
2.35.1



