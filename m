Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E71A4BEFE4
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 04:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239498AbiBVC6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 21:58:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239494AbiBVC6K (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 21 Feb 2022 21:58:10 -0500
X-Greylist: delayed 408 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Feb 2022 18:57:46 PST
Received: from inva020.nxp.com (inva020.nxp.com [92.121.34.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC2DE75;
        Mon, 21 Feb 2022 18:57:45 -0800 (PST)
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id F05211A0647;
        Tue, 22 Feb 2022 03:50:55 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B90701A157F;
        Tue, 22 Feb 2022 03:50:55 +0100 (CET)
Received: from localhost.localdomain (shlinux2.ap.freescale.net [10.192.224.44])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 7596B183AC94;
        Tue, 22 Feb 2022 10:50:54 +0800 (+08)
From:   haibo.chen@nxp.com
To:     jic23@kernel.org, lars@metafoo.de, linux-iio@vger.kernel.org,
        pmeerw@pmeerw.net, martink@posteo.de
Cc:     Stable@vger.kernel.org, haibo.chen@nxp.com, linux-imx@nxp.com
Subject: [PATCH] iio: mma8452: use the correct logic to get mma8452_data
Date:   Tue, 22 Feb 2022 10:42:21 +0800
Message-Id: <1645497741-5402-1-git-send-email-haibo.chen@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

The original logic to get mma8452_data is wrong, the *dev point to
the device belong to iio_dev. we can't use this dev to find the
correct i2c_client. The original logic happen to work because it
finally use dev->driver_data to get iio_dev. Here use the API
to_i2c_client() is wrong and make reader confuse. To correct the
logic, it should be like this

  struct mma8452_data *data = iio_priv(dev_get_drvdata(dev));

But after commit 8b7651f25962 ("iio: iio_device_alloc(): Remove
unnecessary self drvdata"), the upper logic also can't work.
When try to show the avialable scale in userspace, will meet kernel
dump, kernel handle NULL pointer dereference.

So use dev_to_iio_dev() to correct the logic.

Fixes: c3cdd6e48e35 ("iio: mma8452: refactor for seperating chip specific data")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
---
 drivers/iio/accel/mma8452.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index 64b82b4503ad..0016bb947c10 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -379,8 +379,8 @@ static ssize_t mma8452_show_scale_avail(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	struct mma8452_data *data = iio_priv(i2c_get_clientdata(
-					     to_i2c_client(dev)));
+	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
+	struct mma8452_data *data = iio_priv(indio_dev);
 
 	return mma8452_show_int_plus_micros(buf, data->chip_info->mma_scales,
 		ARRAY_SIZE(data->chip_info->mma_scales));
-- 
2.25.1

