Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322A93C2CED
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbhGJCVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231948AbhGJCVA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:21:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 049B6613D1;
        Sat, 10 Jul 2021 02:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883495;
        bh=o8aaZx/XYxtSU9+pu+I4Ex0S+DBTO+g8Ltz2DKKNK0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kbAT+6qhuLIRCdsXY7rSGLeAf8JYxfHceIAmLCmAOlx7P4HrCRbl8ZO5r5yVn7/RW
         geQjCQKMFxw9ku/fL/hFQG6BIp3xI5xy7kwkROZV90bIGdo6vbTp6geLkKXMiCTNXX
         YMWvRyEV5QNHB2sTUlPXqAfpE+YOn/c1mKd/q15c2OHVG6JSU4Qf9h7Rn5D+gPRMU3
         T6R6VZhZFvi+Ycmr6Nlr+1KXfTdTFLeE5QSlcv2huWe1kT1o0Bj/ZvsCnJu7nOe2ua
         ScjkQW32xzMbmFRR0o0m3d68XwV9UQgkfS9qAuwG/Wk+/ypxez1VqrpHy4j0KLquEk
         lB7vH5yCkZhRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 019/114] iio: gyro: fxa21002c: Balance runtime pm + use pm_runtime_resume_and_get().
Date:   Fri,  9 Jul 2021 22:16:13 -0400
Message-Id: <20210710021748.3167666-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 41120ebbb1eb5e9dec93320e259d5b2c93226073 ]

In both the probe() error path and remove() pm_runtime_put_noidle()
is called which will decrement the runtime pm reference count.
However, there is no matching function to have raised the reference count.
Not this isn't a fix as the runtime pm core will stop the reference count
going negative anyway.

An alternative would have been to raise the count in these paths, but
it is not clear why that would be necessary.

Whilst we are here replace some boilerplate with pm_runtime_resume_and_get()
Found using coccicheck script under review at:
https://lore.kernel.org/lkml/20210427141946.2478411-1-Julia.Lawall@inria.fr/

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Rui Miguel Silva <rui.silva@linaro.org>
Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Link: https://lore.kernel.org/r/20210509113354.660190-2-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/gyro/fxas21002c_core.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/iio/gyro/fxas21002c_core.c b/drivers/iio/gyro/fxas21002c_core.c
index 645461c70454..6a85f231fd57 100644
--- a/drivers/iio/gyro/fxas21002c_core.c
+++ b/drivers/iio/gyro/fxas21002c_core.c
@@ -366,14 +366,7 @@ static int fxas21002c_write(struct fxas21002c_data *data,
 
 static int  fxas21002c_pm_get(struct fxas21002c_data *data)
 {
-	struct device *dev = regmap_get_device(data->regmap);
-	int ret;
-
-	ret = pm_runtime_get_sync(dev);
-	if (ret < 0)
-		pm_runtime_put_noidle(dev);
-
-	return ret;
+	return pm_runtime_resume_and_get(regmap_get_device(data->regmap));
 }
 
 static int  fxas21002c_pm_put(struct fxas21002c_data *data)
@@ -1004,7 +997,6 @@ int fxas21002c_core_probe(struct device *dev, struct regmap *regmap, int irq,
 pm_disable:
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
-	pm_runtime_put_noidle(dev);
 
 	return ret;
 }
@@ -1018,7 +1010,6 @@ void fxas21002c_core_remove(struct device *dev)
 
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
-	pm_runtime_put_noidle(dev);
 }
 EXPORT_SYMBOL_GPL(fxas21002c_core_remove);
 
-- 
2.30.2

