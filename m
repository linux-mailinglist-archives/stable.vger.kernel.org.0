Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAAF9603E38
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbiJSJLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbiJSJH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:07:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E771ADBD;
        Wed, 19 Oct 2022 02:00:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59AD5617FB;
        Wed, 19 Oct 2022 08:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAC5C433C1;
        Wed, 19 Oct 2022 08:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169932;
        bh=9PXW0jD/9VCb+BHX7rIhISiFRilpbAWDGc1l+7xT2L4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5Rsczci9CaitFDER9yY5r1Ma62xlL2GGOzWn5gd0yIAuR9t5zcUMLONduQ1XtN2Z
         6k43CbhY9KypdBLg/ax1voZ/A5aDlaYnaDzM/OJyJs0V76Hyai4bWOqTrelVMfef+9
         2QsiuL/eIQoVOudjDcKOMEGRIaYr2/fvLkyAAF1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakob Hauser <jahau@rocketmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 464/862] iio: magnetometer: yas530: Change data type of hard_offsets to signed
Date:   Wed, 19 Oct 2022 10:29:11 +0200
Message-Id: <20221019083310.493893259@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakob Hauser <jahau@rocketmail.com>

[ Upstream commit e137fafc8985cf152a4bb6f18ae83ebb06816df1 ]

The "hard_offsets" are currently unsigned u8 but they should be signed as they
can get negative. They are signed in function yas5xx_meaure_offsets() and in the
Yamaha drivers [1][2].

[1] https://github.com/NovaFusion/android_kernel_samsung_golden/blob/cm-12.1/drivers/sensor/compass/yas.h#L156
[2] https://github.com/msm8916-mainline/android_kernel_qcom_msm8916/blob/GT-I9195I/drivers/iio/magnetometer/yas_mag_drv-yas532.c#L91

Fixes: de8860b1ed47 ("iio: magnetometer: Add driver for Yamaha YAS530")
Signed-off-by: Jakob Hauser <jahau@rocketmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/40f052bf6491457d0c5c0ed4c3534dc6fa251c3c.1660337264.git.jahau@rocketmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/magnetometer/yamaha-yas530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/magnetometer/yamaha-yas530.c b/drivers/iio/magnetometer/yamaha-yas530.c
index aeaa4da6923b..d1f16729c60e 100644
--- a/drivers/iio/magnetometer/yamaha-yas530.c
+++ b/drivers/iio/magnetometer/yamaha-yas530.c
@@ -132,7 +132,7 @@ struct yas5xx {
 	unsigned int version;
 	char name[16];
 	struct yas5xx_calibration calibration;
-	u8 hard_offsets[3];
+	s8 hard_offsets[3];
 	struct iio_mount_matrix orientation;
 	struct regmap *map;
 	struct regulator_bulk_data regs[2];
-- 
2.35.1



