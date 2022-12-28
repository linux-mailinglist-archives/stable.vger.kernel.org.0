Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537CE65818C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbiL1Q3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbiL1Q26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:28:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EAE1A069
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:25:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9864F6157B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC35C433EF;
        Wed, 28 Dec 2022 16:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244714;
        bh=2t4VGP6/TwZJtk6iHWU/J1bzW291JIdvEI9vvwQXQBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCJuZzzuQEuWxSCmfIFA148mQ6BBqLoHcb3Uw+BO/SEtdysV8IBZHoh+WDEk+x5y6
         T28nUz6uoyaZk2ihYEE5JEFoCHG1pl2/bemBPg2voUP+Ug9V5AhMaLRmKlB2Qy1Q3l
         2PLsX2yZb/+2IJ9f112S9keSjrWCK5zwq0tWH2cA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ramona Bolboaca <ramona.bolboaca@analog.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0723/1146] iio: adis: add __adis_enable_irq() implementation
Date:   Wed, 28 Dec 2022 15:37:42 +0100
Message-Id: <20221228144349.783416694@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Ramona Bolboaca <ramona.bolboaca@analog.com>

[ Upstream commit 99c05e4283a19a02a256f14100ca4ec3b2da3f62 ]

Add '__adis_enable_irq()' implementation which is the unlocked
version of 'adis_enable_irq()'.
Call '__adis_enable_irq()' instead of 'adis_enable_irq()' from
'__adis_intial_startup()' to keep the expected unlocked functionality.

This fix is needed to remove a deadlock for all devices which are
using 'adis_initial_startup()'. The deadlock occurs because the
same mutex is acquired twice, without releasing it.
The mutex is acquired once inside 'adis_initial_startup()', before
calling '__adis_initial_startup()', and once inside
'adis_enable_irq()', which is called by '__adis_initial_startup()'.
The deadlock is removed by calling '__adis_enable_irq()', instead of
'adis_enable_irq()' from within '__adis_initial_startup()'.

Fixes: b600bd7eb3335 ("iio: adis: do not disabe IRQs in 'adis_init()'")
Signed-off-by: Ramona Bolboaca <ramona.bolboaca@analog.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20221122082757.449452-2-ramona.bolboaca@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis.c       | 28 ++++++++++------------------
 include/linux/iio/imu/adis.h | 13 ++++++++++++-
 2 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/iio/imu/adis.c b/drivers/iio/imu/adis.c
index f7fcfd04f659..bc40240b29e2 100644
--- a/drivers/iio/imu/adis.c
+++ b/drivers/iio/imu/adis.c
@@ -270,23 +270,19 @@ EXPORT_SYMBOL_NS(adis_debugfs_reg_access, IIO_ADISLIB);
 #endif
 
 /**
- * adis_enable_irq() - Enable or disable data ready IRQ
+ * __adis_enable_irq() - Enable or disable data ready IRQ (unlocked)
  * @adis: The adis device
  * @enable: Whether to enable the IRQ
  *
  * Returns 0 on success, negative error code otherwise
  */
-int adis_enable_irq(struct adis *adis, bool enable)
+int __adis_enable_irq(struct adis *adis, bool enable)
 {
-	int ret = 0;
+	int ret;
 	u16 msc;
 
-	mutex_lock(&adis->state_lock);
-
-	if (adis->data->enable_irq) {
-		ret = adis->data->enable_irq(adis, enable);
-		goto out_unlock;
-	}
+	if (adis->data->enable_irq)
+		return adis->data->enable_irq(adis, enable);
 
 	if (adis->data->unmasked_drdy) {
 		if (enable)
@@ -294,12 +290,12 @@ int adis_enable_irq(struct adis *adis, bool enable)
 		else
 			disable_irq(adis->spi->irq);
 
-		goto out_unlock;
+		return 0;
 	}
 
 	ret = __adis_read_reg_16(adis, adis->data->msc_ctrl_reg, &msc);
 	if (ret)
-		goto out_unlock;
+		return ret;
 
 	msc |= ADIS_MSC_CTRL_DATA_RDY_POL_HIGH;
 	msc &= ~ADIS_MSC_CTRL_DATA_RDY_DIO2;
@@ -308,13 +304,9 @@ int adis_enable_irq(struct adis *adis, bool enable)
 	else
 		msc &= ~ADIS_MSC_CTRL_DATA_RDY_EN;
 
-	ret = __adis_write_reg_16(adis, adis->data->msc_ctrl_reg, msc);
-
-out_unlock:
-	mutex_unlock(&adis->state_lock);
-	return ret;
+	return __adis_write_reg_16(adis, adis->data->msc_ctrl_reg, msc);
 }
-EXPORT_SYMBOL_NS(adis_enable_irq, IIO_ADISLIB);
+EXPORT_SYMBOL_NS(__adis_enable_irq, IIO_ADISLIB);
 
 /**
  * __adis_check_status() - Check the device for error conditions (unlocked)
@@ -445,7 +437,7 @@ int __adis_initial_startup(struct adis *adis)
 	 * with 'IRQF_NO_AUTOEN' anyways.
 	 */
 	if (!adis->data->unmasked_drdy)
-		adis_enable_irq(adis, false);
+		__adis_enable_irq(adis, false);
 
 	if (!adis->data->prod_id_reg)
 		return 0;
diff --git a/include/linux/iio/imu/adis.h b/include/linux/iio/imu/adis.h
index 515ca09764fe..bcbefb757475 100644
--- a/include/linux/iio/imu/adis.h
+++ b/include/linux/iio/imu/adis.h
@@ -402,9 +402,20 @@ static inline int adis_update_bits_base(struct adis *adis, unsigned int reg,
 	__adis_update_bits_base(adis, reg, mask, val, sizeof(val));	\
 })
 
-int adis_enable_irq(struct adis *adis, bool enable);
 int __adis_check_status(struct adis *adis);
 int __adis_initial_startup(struct adis *adis);
+int __adis_enable_irq(struct adis *adis, bool enable);
+
+static inline int adis_enable_irq(struct adis *adis, bool enable)
+{
+	int ret;
+
+	mutex_lock(&adis->state_lock);
+	ret = __adis_enable_irq(adis, enable);
+	mutex_unlock(&adis->state_lock);
+
+	return ret;
+}
 
 static inline int adis_check_status(struct adis *adis)
 {
-- 
2.35.1



