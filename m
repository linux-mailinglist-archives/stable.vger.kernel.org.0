Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE2F3C2ED7
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbhGJC2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:28:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233921AbhGJC16 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:27:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9D7961420;
        Sat, 10 Jul 2021 02:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883889;
        bh=v9qZnqwfvpH785xr3MAhs/rKtTiDDCcVynMBvt84IfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKR/fbDffdfxZOe+LWM8sUOZj6FjH5+58ZqRsSS3Dwt+Jy98gZhLxqlyWua2HH2/b
         jTWWmsHYksdN6XPouG3XqnQpcWBNRBxxLjgKnnKH7EWw8OtHzxo+BJplx4joEOxHqC
         ELg/qx/iwnTgcv0qByhUNAZQ/Bi76rH8X/5KMiXuBwxoyaHgKBbhfTUteTuVDgTsnX
         bodYECLCsopC7PyIPYJ6GF3Yt2muwZu02UUY/P7yk7RM/t3wdpFzvNg30fZKVmNA8j
         bpbJZaUu4Axb8u13b3geOa6Lnd3dBRxW/t5uXR2hLMEtGQhFrzXOuS+dbFmqna7lwn
         w+oc9qROOW6Qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 16/93] iio: magn: bmc150: Balance runtime pm + use pm_runtime_resume_and_get()
Date:   Fri,  9 Jul 2021 22:23:10 -0400
Message-Id: <20210710022428.3169839-16-sashal@kernel.org>
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

[ Upstream commit 264da512431495e542fcaf56ffe75e7df0e7db74 ]

probe() error paths after runtime pm is enabled, should disable it.
remove() should not call pm_runtime_put_noidle() as there is no
matching get() to have raised the reference count.  This case
has no affect a the runtime pm core protects against going negative.

Whilst here use pm_runtime_resume_and_get() to tidy things up a little.
coccicheck script didn't get this one due to complex code structure so
found by inspection.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Link: https://lore.kernel.org/r/20210509113354.660190-12-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/magnetometer/bmc150_magn.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/magnetometer/bmc150_magn.c b/drivers/iio/magnetometer/bmc150_magn.c
index fc6840f9c1fa..69112c35c022 100644
--- a/drivers/iio/magnetometer/bmc150_magn.c
+++ b/drivers/iio/magnetometer/bmc150_magn.c
@@ -260,7 +260,7 @@ static int bmc150_magn_set_power_state(struct bmc150_magn_data *data, bool on)
 	int ret;
 
 	if (on) {
-		ret = pm_runtime_get_sync(data->dev);
+		ret = pm_runtime_resume_and_get(data->dev);
 	} else {
 		pm_runtime_mark_last_busy(data->dev);
 		ret = pm_runtime_put_autosuspend(data->dev);
@@ -269,9 +269,6 @@ static int bmc150_magn_set_power_state(struct bmc150_magn_data *data, bool on)
 	if (ret < 0) {
 		dev_err(data->dev,
 			"failed to change power state to %d\n", on);
-		if (on)
-			pm_runtime_put_noidle(data->dev);
-
 		return ret;
 	}
 #endif
@@ -941,12 +938,14 @@ int bmc150_magn_probe(struct device *dev, struct regmap *regmap,
 	ret = iio_device_register(indio_dev);
 	if (ret < 0) {
 		dev_err(dev, "unable to register iio device\n");
-		goto err_buffer_cleanup;
+		goto err_disable_runtime_pm;
 	}
 
 	dev_dbg(dev, "Registered device %s\n", name);
 	return 0;
 
+err_disable_runtime_pm:
+	pm_runtime_disable(dev);
 err_buffer_cleanup:
 	iio_triggered_buffer_cleanup(indio_dev);
 err_free_irq:
@@ -970,7 +969,6 @@ int bmc150_magn_remove(struct device *dev)
 
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
-	pm_runtime_put_noidle(dev);
 
 	iio_triggered_buffer_cleanup(indio_dev);
 
-- 
2.30.2

