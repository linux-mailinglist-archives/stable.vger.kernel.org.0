Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620563CE488
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348522AbhGSPoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:44:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233689AbhGSPkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:40:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F03161363;
        Mon, 19 Jul 2021 16:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711652;
        bh=cyHD2oQuOJvUpiuoQ4Y/gRXIIVB8xWrQuC8BwU950Ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhk6DndT0uRfe1vWTJmxdmcrFF2qJsY5131IUakDt34T8uOImU863s74dM1GSM/n9
         +9nGThQJaeR84Li541rSbY1QIBJYMu0oINWH5wugQ5eOK8h/fkNxMVFa4+tBKOYaze
         WnCnAfPJ1DpN1Dx2qfvqATi4fle137M6X22rt2MA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 048/292] iio: gyro: fxa21002c: Balance runtime pm + use pm_runtime_resume_and_get().
Date:   Mon, 19 Jul 2021 16:51:50 +0200
Message-Id: <20210719144944.090229374@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -366,14 +366,7 @@ out_unlock:
 
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



