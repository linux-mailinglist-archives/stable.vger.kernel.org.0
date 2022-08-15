Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479DC593FDA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348866AbiHOVhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349042AbiHOVgb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:36:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA83C6DAE5;
        Mon, 15 Aug 2022 12:26:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C26860EF0;
        Mon, 15 Aug 2022 19:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4B9C433C1;
        Mon, 15 Aug 2022 19:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591563;
        bh=dz7vQ4RXKIwyT5wUIh04z6+gRNzyrIgUgYrhIoQKgSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dgmBKoVA7MOOpzNlh++pa5SgvinpPFTZ7FPZVamdVPk0/SkoX7H6olpiuW7nh4wHI
         40mGQ2ULrGbjQl1S0dRJoWwDeiU3eySYAcPABgkXI9VmVNof/9gwKlsw/ExNN9lZ5Z
         WWi1pcFJxHFM1RCrHDGQqnqeaap6ZbRkUpSFtCvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jagath Jog J <jagathjog1996@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0581/1095] iio: accel: bma400: Fix the scale min and max macro values
Date:   Mon, 15 Aug 2022 19:59:40 +0200
Message-Id: <20220815180453.613172440@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jagath Jog J <jagathjog1996@gmail.com>

[ Upstream commit 747c7cf1592e226d40543231b26502b332d0ea2f ]

Changing the scale macro values to match the bma400 sensitivity
for 1 LSB of all the available ranges.

Fixes: 465c811f1f20 ("iio: accel: Add driver for the BMA400")
Signed-off-by: Jagath Jog J <jagathjog1996@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220505133021.22362-2-jagathjog1996@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/bma400.h | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/accel/bma400.h b/drivers/iio/accel/bma400.h
index c4c8d74155c2..80330c7ce17f 100644
--- a/drivers/iio/accel/bma400.h
+++ b/drivers/iio/accel/bma400.h
@@ -83,8 +83,27 @@
 #define BMA400_ACC_ODR_MIN_WHOLE_HZ 25
 #define BMA400_ACC_ODR_MIN_HZ       12
 
-#define BMA400_SCALE_MIN            38357
-#define BMA400_SCALE_MAX            306864
+/*
+ * BMA400_SCALE_MIN macro value represents m/s^2 for 1 LSB before
+ * converting to micro values for +-2g range.
+ *
+ * For +-2g - 1 LSB = 0.976562 milli g = 0.009576 m/s^2
+ * For +-4g - 1 LSB = 1.953125 milli g = 0.019153 m/s^2
+ * For +-16g - 1 LSB = 7.8125 milli g = 0.076614 m/s^2
+ *
+ * The raw value which is used to select the different ranges is determined
+ * by the first bit set position from the scale value, so BMA400_SCALE_MIN
+ * should be odd.
+ *
+ * Scale values for +-2g, +-4g, +-8g and +-16g are populated into bma400_scales
+ * array by left shifting BMA400_SCALE_MIN.
+ * e.g.:
+ * To select +-2g = 9577 << 0 = raw value to write is 0.
+ * To select +-8g = 9577 << 2 = raw value to write is 2.
+ * To select +-16g = 9577 << 3 = raw value to write is 3.
+ */
+#define BMA400_SCALE_MIN            9577
+#define BMA400_SCALE_MAX            76617
 
 #define BMA400_NUM_REGULATORS       2
 #define BMA400_VDD_REGULATOR        0
-- 
2.35.1



