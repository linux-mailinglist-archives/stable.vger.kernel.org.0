Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84BB451A88D
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356205AbiEDRL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356934AbiEDRJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8522047394;
        Wed,  4 May 2022 09:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEEB5617D5;
        Wed,  4 May 2022 16:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6BEC385AF;
        Wed,  4 May 2022 16:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683391;
        bh=5kiyZl3wv3CTm+GFIfjJaXI1i53KPSbQgo/RAbnYu2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PddjGtZjvYH9uwo5QxX0CNCU5Psw1v2SnX/b0D8cMBnkrIPpiFuLak+Xe//4u4sNE
         oDv8gk0uzCHuFaezwUK6eMkL09Vr71yYWGVDxNDtKNs6k1UtkrZSCmKDTghbnGef0T
         Vbmjn8UM/7nzaeswhhslG2XJTkAX2db0HztE0aN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tong Zhang <ztong0001@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 063/225] iio:imu:bmi160: disable regulator in error path
Date:   Wed,  4 May 2022 18:45:01 +0200
Message-Id: <20220504153115.803995263@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit d926054d5565d3cfa2c7c3f7a48e79bcc10453ed ]

Regulator should be disabled in error path as mentioned in _regulator_put().
Also disable accel if gyro cannot be enabled.

[   16.233604] WARNING: CPU: 0 PID: 2177 at drivers/regulator/core.c:2257 _regulator_put
[   16.240453] Call Trace:
[   16.240572]  <TASK>
[   16.240676]  regulator_put+0x26/0x40
[   16.240853]  regulator_bulk_free+0x26/0x50
[   16.241050]  release_nodes+0x3f/0x70
[   16.241225]  devres_release_group+0x147/0x1c0
[   16.241441]  ? bmi160_core_probe+0x175/0x3a0 [bmi160_core]

Fixes: 5dea3fb066f0 ("iio: imu: bmi160: added regulator support")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Link: https://lore.kernel.org/r/20220327154005.806049-1-ztong0001@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/bmi160/bmi160_core.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/imu/bmi160/bmi160_core.c b/drivers/iio/imu/bmi160/bmi160_core.c
index 824b5124a5f5..01336105792e 100644
--- a/drivers/iio/imu/bmi160/bmi160_core.c
+++ b/drivers/iio/imu/bmi160/bmi160_core.c
@@ -730,7 +730,7 @@ static int bmi160_chip_init(struct bmi160_data *data, bool use_spi)
 
 	ret = regmap_write(data->regmap, BMI160_REG_CMD, BMI160_CMD_SOFTRESET);
 	if (ret)
-		return ret;
+		goto disable_regulator;
 
 	usleep_range(BMI160_SOFTRESET_USLEEP, BMI160_SOFTRESET_USLEEP + 1);
 
@@ -741,29 +741,37 @@ static int bmi160_chip_init(struct bmi160_data *data, bool use_spi)
 	if (use_spi) {
 		ret = regmap_read(data->regmap, BMI160_REG_DUMMY, &val);
 		if (ret)
-			return ret;
+			goto disable_regulator;
 	}
 
 	ret = regmap_read(data->regmap, BMI160_REG_CHIP_ID, &val);
 	if (ret) {
 		dev_err(dev, "Error reading chip id\n");
-		return ret;
+		goto disable_regulator;
 	}
 	if (val != BMI160_CHIP_ID_VAL) {
 		dev_err(dev, "Wrong chip id, got %x expected %x\n",
 			val, BMI160_CHIP_ID_VAL);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto disable_regulator;
 	}
 
 	ret = bmi160_set_mode(data, BMI160_ACCEL, true);
 	if (ret)
-		return ret;
+		goto disable_regulator;
 
 	ret = bmi160_set_mode(data, BMI160_GYRO, true);
 	if (ret)
-		return ret;
+		goto disable_accel;
 
 	return 0;
+
+disable_accel:
+	bmi160_set_mode(data, BMI160_ACCEL, false);
+
+disable_regulator:
+	regulator_bulk_disable(ARRAY_SIZE(data->supplies), data->supplies);
+	return ret;
 }
 
 static int bmi160_data_rdy_trigger_set_state(struct iio_trigger *trig,
-- 
2.35.1



