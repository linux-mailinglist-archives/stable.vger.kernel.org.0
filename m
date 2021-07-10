Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A583C2ED9
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbhGJC2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:28:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233773AbhGJC16 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:27:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BFA761414;
        Sat, 10 Jul 2021 02:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883888;
        bh=KRbNFtgLa7uy+upaXNk0ep7zr+WJWjk7VFl4kzY/Jk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtIOtV+LpGG+ib+Ms0bvXQkAO/d6yu59Dh/yQD2IuHzbDn1in72GH6TRpnBIW8OJT
         zB3z3lSy8EcKGV6Nbh0x9Fo3h7441jO0Milq5+rxiqZA7OVTH9iRwbcbgcrIOMpp6W
         AxYDgJWGKSbDEW757DkOu7KWe+/h/2ZrRSgEq7C6xNJPeQc6yHIsEqS6WAr0bw2IGt
         jJE4QG8RDpRH3PG1ROrHS3drJVWou1D+yAawJOj8IZ4K4Bm0EohEfg9ZrK3ShM7d3n
         DJ6+5Mxk7RJvJck9WDbekOpW/O3fEFdIERzOvpqk6IQXbvE8vkH4pPuKXkupn/UwNB
         El2TgK1BWtNVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 15/93] iio: gyro: fxa21002c: Balance runtime pm + use pm_runtime_resume_and_get().
Date:   Fri,  9 Jul 2021 22:23:09 -0400
Message-Id: <20210710022428.3169839-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
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
index b7523357d8eb..ec6bd15bd2d4 100644
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
@@ -1005,7 +998,6 @@ int fxas21002c_core_probe(struct device *dev, struct regmap *regmap, int irq,
 pm_disable:
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
-	pm_runtime_put_noidle(dev);
 
 	return ret;
 }
@@ -1019,7 +1011,6 @@ void fxas21002c_core_remove(struct device *dev)
 
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
-	pm_runtime_put_noidle(dev);
 }
 EXPORT_SYMBOL_GPL(fxas21002c_core_remove);
 
-- 
2.30.2

