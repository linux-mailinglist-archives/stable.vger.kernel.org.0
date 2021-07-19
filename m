Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A09E3CE067
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346426AbhGSPRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:17:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345690AbhGSPNr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:13:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7A2861351;
        Mon, 19 Jul 2021 15:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710021;
        bh=cyHD2oQuOJvUpiuoQ4Y/gRXIIVB8xWrQuC8BwU950Ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SAlYJlQ4ziqHcFftwrmDDcvL/Q9JzGMuM9zwgR1hK/e4khSB0nc1lO8/LtKiijjKI
         a4rjAnaoTS1P8WkLkMDEGa75+PtkLntrkUoFBHXy7/novrttgcugvYSgCHDcO6oN4C
         Bl1+ZMnxcAeKH31e3FDeDP9akD9OKWf8wNeKxyio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/243] iio: gyro: fxa21002c: Balance runtime pm + use pm_runtime_resume_and_get().
Date:   Mon, 19 Jul 2021 16:51:04 +0200
Message-Id: <20210719144942.065467933@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
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



