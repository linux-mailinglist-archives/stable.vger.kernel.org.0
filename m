Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA452180FE
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 09:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729938AbgGHHVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 03:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729340AbgGHHVk (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 8 Jul 2020 03:21:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF2A02078A;
        Wed,  8 Jul 2020 07:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594192900;
        bh=Db4nm7RPLgyGmG6IDruRbckPfNypP5RcCC2G2PaoCpM=;
        h=Subject:To:From:Date:From;
        b=TRrvxomjaWsREbAhCFyd4x5s7XM2x+GKJ7BTdEvgNps7Bhj2NHE3SB+C5BT5+iH7P
         qPl89ooE99ek4jyO02tgghKMisd89YhK9MoZm4qHeaNCc7gr4JAFixU/I5gy4bVmHD
         1c9uuwx2H9mJPQm97a1hGyUeHGPhoEq8VxkFrVzs=
Subject: patch "iio: magnetometer: ak8974: Fix runtime PM imbalance on error" added to staging-linus
To:     dinghao.liu@zju.edu.cn, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, linus.walleij@linaro.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Jul 2020 09:21:28 +0200
Message-ID: <159419288818153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: magnetometer: ak8974: Fix runtime PM imbalance on error

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0187294d227dfc42889e1da8f8ce1e44fc25f147 Mon Sep 17 00:00:00 2001
From: Dinghao Liu <dinghao.liu@zju.edu.cn>
Date: Tue, 26 May 2020 18:47:17 +0800
Subject: iio: magnetometer: ak8974: Fix runtime PM imbalance on error

When devm_regmap_init_i2c() returns an error code, a pairing
runtime PM usage counter decrement is needed to keep the
counter balanced. For error paths after ak8974_set_power(),
ak8974_detect() and ak8974_reset(), things are the same.

However, When iio_triggered_buffer_setup() returns an error
code, there will be two PM usgae counter decrements.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Fixes: 7c94a8b2ee8c ("iio: magn: add a driver for AK8974")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/magnetometer/ak8974.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/iio/magnetometer/ak8974.c b/drivers/iio/magnetometer/ak8974.c
index 810fdfd37c88..041c9007bfbe 100644
--- a/drivers/iio/magnetometer/ak8974.c
+++ b/drivers/iio/magnetometer/ak8974.c
@@ -862,19 +862,21 @@ static int ak8974_probe(struct i2c_client *i2c,
 	ak8974->map = devm_regmap_init_i2c(i2c, &ak8974_regmap_config);
 	if (IS_ERR(ak8974->map)) {
 		dev_err(&i2c->dev, "failed to allocate register map\n");
+		pm_runtime_put_noidle(&i2c->dev);
+		pm_runtime_disable(&i2c->dev);
 		return PTR_ERR(ak8974->map);
 	}
 
 	ret = ak8974_set_power(ak8974, AK8974_PWR_ON);
 	if (ret) {
 		dev_err(&i2c->dev, "could not power on\n");
-		goto power_off;
+		goto disable_pm;
 	}
 
 	ret = ak8974_detect(ak8974);
 	if (ret) {
 		dev_err(&i2c->dev, "neither AK8974 nor AMI30x found\n");
-		goto power_off;
+		goto disable_pm;
 	}
 
 	ret = ak8974_selftest(ak8974);
@@ -884,14 +886,9 @@ static int ak8974_probe(struct i2c_client *i2c,
 	ret = ak8974_reset(ak8974);
 	if (ret) {
 		dev_err(&i2c->dev, "AK8974 reset failed\n");
-		goto power_off;
+		goto disable_pm;
 	}
 
-	pm_runtime_set_autosuspend_delay(&i2c->dev,
-					 AK8974_AUTOSUSPEND_DELAY);
-	pm_runtime_use_autosuspend(&i2c->dev);
-	pm_runtime_put(&i2c->dev);
-
 	indio_dev->dev.parent = &i2c->dev;
 	switch (ak8974->variant) {
 	case AK8974_WHOAMI_VALUE_AMI306:
@@ -957,6 +954,11 @@ static int ak8974_probe(struct i2c_client *i2c,
 		goto cleanup_buffer;
 	}
 
+	pm_runtime_set_autosuspend_delay(&i2c->dev,
+					 AK8974_AUTOSUSPEND_DELAY);
+	pm_runtime_use_autosuspend(&i2c->dev);
+	pm_runtime_put(&i2c->dev);
+
 	return 0;
 
 cleanup_buffer:
@@ -965,7 +967,6 @@ static int ak8974_probe(struct i2c_client *i2c,
 	pm_runtime_put_noidle(&i2c->dev);
 	pm_runtime_disable(&i2c->dev);
 	ak8974_set_power(ak8974, AK8974_PWR_OFF);
-power_off:
 	regulator_bulk_disable(ARRAY_SIZE(ak8974->regs), ak8974->regs);
 
 	return ret;
-- 
2.27.0


