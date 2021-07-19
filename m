Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8183CDF1E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345094AbhGSPHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244648AbhGSPFe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:05:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92E2260238;
        Mon, 19 Jul 2021 15:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709573;
        bh=9um7bU0QSz8fHCjawR9fxW6X0ZJGhUEH7wCqU6luNOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLR3kmegB+JjKZtPdonERDXe/wh6YzPFITF9a5MV7pyoJSro5l8/zu35vm9PcnkI5
         YRw4QM542t7t7HnJ4PfOqvyfDto/KsTVAMGPbMKcLcThb/fd7aI9nfi2hq55PmjMri
         l4jozDWlrFvkFnQDn+2rnvdgyzHv9xjZBi8JO/HE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 015/149] iio: magn: bmc150: Balance runtime pm + use pm_runtime_resume_and_get()
Date:   Mon, 19 Jul 2021 16:52:03 +0200
Message-Id: <20210719144905.056627130@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 48685d785c1b..087dc16c2185 100644
--- a/drivers/iio/magnetometer/bmc150_magn.c
+++ b/drivers/iio/magnetometer/bmc150_magn.c
@@ -263,7 +263,7 @@ static int bmc150_magn_set_power_state(struct bmc150_magn_data *data, bool on)
 	int ret;
 
 	if (on) {
-		ret = pm_runtime_get_sync(data->dev);
+		ret = pm_runtime_resume_and_get(data->dev);
 	} else {
 		pm_runtime_mark_last_busy(data->dev);
 		ret = pm_runtime_put_autosuspend(data->dev);
@@ -272,9 +272,6 @@ static int bmc150_magn_set_power_state(struct bmc150_magn_data *data, bool on)
 	if (ret < 0) {
 		dev_err(data->dev,
 			"failed to change power state to %d\n", on);
-		if (on)
-			pm_runtime_put_noidle(data->dev);
-
 		return ret;
 	}
 #endif
@@ -947,12 +944,14 @@ int bmc150_magn_probe(struct device *dev, struct regmap *regmap,
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
@@ -976,7 +975,6 @@ int bmc150_magn_remove(struct device *dev)
 
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
-	pm_runtime_put_noidle(dev);
 
 	iio_triggered_buffer_cleanup(indio_dev);
 
-- 
2.30.2



