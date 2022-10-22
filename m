Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D8D6087AC
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbiJVIFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbiJVIEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:04:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570BA2A4E1A;
        Sat, 22 Oct 2022 00:51:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A11A1B82E38;
        Sat, 22 Oct 2022 07:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF419C433D6;
        Sat, 22 Oct 2022 07:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425066;
        bh=iBB9h9YvKlo2kBA38TF8vV6C0UBNbRscfhurjMCwveY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSnK4u9TKNzZbpOdoNGwSHi4Z8qjXJOcLs+J8czEfLzgbNTrvZszU4mSfpBd6fhPO
         JhRgRl0gRosytHhTDZdcgwo2kvi08zkE2/iH76nsMwTo5EKmzS/nuhEU7466AdWvWo
         XLJrD7c0SuGSWLI0t5CaWaYQD5ZmVKxk0NLTYQqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakob Hauser <jahau@rocketmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 378/717] iio: magnetometer: yas530: Change data type of hard_offsets to signed
Date:   Sat, 22 Oct 2022 09:24:17 +0200
Message-Id: <20221022072513.929591657@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index b2bc637150bf..40192aa46b04 100644
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



