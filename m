Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8EF226899
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732076AbgGTQIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:08:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733250AbgGTQIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:08:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0B6120672;
        Mon, 20 Jul 2020 16:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261289;
        bh=PYHRM3/vuupAlPy3KFuJj1++LvMrnbsTNPrhIdDVqkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8XYOefOOv9BFRXWQvPPg1S7urWWQpGA9N8KlSqJSgi2MKvuAs8sGZmJVMgTRkPdv
         PMR9yPGgNDmAOhcOxpcvxe2MHRGvtcKqxQYPbGJRJRFCvppFyn+dGgUVgu72xNbj/X
         9iY5NPZDP/ZYRy6h9+viwErTMUhN5En32W4z/0ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.7 062/244] iio: magnetometer: ak8974: Fix runtime PM imbalance on error
Date:   Mon, 20 Jul 2020 17:35:33 +0200
Message-Id: <20200720152828.804562991@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

commit 0187294d227dfc42889e1da8f8ce1e44fc25f147 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/magnetometer/ak8974.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/iio/magnetometer/ak8974.c
+++ b/drivers/iio/magnetometer/ak8974.c
@@ -768,19 +768,21 @@ static int ak8974_probe(struct i2c_clien
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
@@ -790,14 +792,9 @@ static int ak8974_probe(struct i2c_clien
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
 	indio_dev->channels = ak8974_channels;
 	indio_dev->num_channels = ARRAY_SIZE(ak8974_channels);
@@ -850,6 +847,11 @@ no_irq:
 		goto cleanup_buffer;
 	}
 
+	pm_runtime_set_autosuspend_delay(&i2c->dev,
+					 AK8974_AUTOSUSPEND_DELAY);
+	pm_runtime_use_autosuspend(&i2c->dev);
+	pm_runtime_put(&i2c->dev);
+
 	return 0;
 
 cleanup_buffer:
@@ -858,7 +860,6 @@ disable_pm:
 	pm_runtime_put_noidle(&i2c->dev);
 	pm_runtime_disable(&i2c->dev);
 	ak8974_set_power(ak8974, AK8974_PWR_OFF);
-power_off:
 	regulator_bulk_disable(ARRAY_SIZE(ak8974->regs), ak8974->regs);
 
 	return ret;


