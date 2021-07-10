Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D663C2CEA
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhGJCVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231956AbhGJCVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:21:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DDB7613B5;
        Sat, 10 Jul 2021 02:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883497;
        bh=qkyStRzVzgmsKgEzw3Yf2YV5ytw5pKCpkSfz7p/4k00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFd1hHs5JSaeuuLQoxjf9jdgwMae3cplR9DQOUM6+tnAmf7iJ+BfiDCxLq7k4lC5J
         QXKTyL2NAGhKYLbo+qFOSze6xPWuQiEnezQKzOAhjN+MpcF38O4Kh/odRhZdIo8v7i
         9rFcSwLZL/FuhmVPheR4VepwVwZ33AH4b+AezPwCYkmUvooENHZF9sDVpOqn0Rv7fx
         pwgaQbA8/AnvE7exJIjww/QfcEi7F2dmApb58qAeSkx0knKQRaBQ2KsN4Is/XLFADf
         GzC5bEM8Jy8GLaaTd//fcL0bn6JrlS1W7AB9AIMsTxi77eyGMSp/2tVrJjUwvD8TW/
         xxCPBW3fKUUcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 020/114] iio: magn: bmc150: Balance runtime pm + use pm_runtime_resume_and_get()
Date:   Fri,  9 Jul 2021 22:16:14 -0400
Message-Id: <20210710021748.3167666-20-sashal@kernel.org>
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
index 00f9766bad5c..8ed548ef6924 100644
--- a/drivers/iio/magnetometer/bmc150_magn.c
+++ b/drivers/iio/magnetometer/bmc150_magn.c
@@ -262,7 +262,7 @@ static int bmc150_magn_set_power_state(struct bmc150_magn_data *data, bool on)
 	int ret;
 
 	if (on) {
-		ret = pm_runtime_get_sync(data->dev);
+		ret = pm_runtime_resume_and_get(data->dev);
 	} else {
 		pm_runtime_mark_last_busy(data->dev);
 		ret = pm_runtime_put_autosuspend(data->dev);
@@ -271,9 +271,6 @@ static int bmc150_magn_set_power_state(struct bmc150_magn_data *data, bool on)
 	if (ret < 0) {
 		dev_err(data->dev,
 			"failed to change power state to %d\n", on);
-		if (on)
-			pm_runtime_put_noidle(data->dev);
-
 		return ret;
 	}
 #endif
@@ -963,12 +960,14 @@ int bmc150_magn_probe(struct device *dev, struct regmap *regmap,
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
@@ -992,7 +991,6 @@ int bmc150_magn_remove(struct device *dev)
 
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
-	pm_runtime_put_noidle(dev);
 
 	iio_triggered_buffer_cleanup(indio_dev);
 
-- 
2.30.2

