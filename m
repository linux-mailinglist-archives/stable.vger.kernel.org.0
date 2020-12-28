Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8642E41A5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438133AbgL1OHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:07:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:42208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438494AbgL1OHm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:07:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F37520791;
        Mon, 28 Dec 2020 14:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164421;
        bh=+oPL0Vde0wY/NnKJWOcdVe4OJumN86wh5CX/G/uXh3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3pE71dmXgxsKNcvOhT4e1l7hMDBjQxvnEEptB3IH5QQMMEwlwKHRHYsYAGKCXDXL
         BC9Xz59gaIsuL8B5SkYLOAIGcQU1Yeg+UvV5f6Yenm33mTeFkkqV+GsKnpZV226kCD
         Wjx2sV86rHX0vDuK4QwCciYlK567fvIpVmzDzL0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 173/717] spi: fix resource leak for drivers without .remove callback
Date:   Mon, 28 Dec 2020 13:42:51 +0100
Message-Id: <20201228125029.249159768@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 440408dbadfe47a615afd0a0a4a402e629be658a ]

Consider an spi driver with a .probe but without a .remove callback (e.g.
rtc-ds1347). The function spi_drv_probe() is called to bind a device and
so dev_pm_domain_attach() is called. As there is no remove callback
spi_drv_remove() isn't called at unbind time however and so calling
dev_pm_domain_detach() is missed and the pm domain keeps active.

To fix this always use both spi_drv_probe() and spi_drv_remove() and
make them handle the respective callback not being set. This has the
side effect that for a (hypothetical) driver that has neither .probe nor
remove the clk and pm domain setup is done.

Fixes: 33cf00e57082 ("spi: attach/detach SPI device to the ACPI power domain")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20201119161604.2633521-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index fc9a59788d2ea..2eaa7dbb70108 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -405,9 +405,11 @@ static int spi_drv_probe(struct device *dev)
 	if (ret)
 		return ret;
 
-	ret = sdrv->probe(spi);
-	if (ret)
-		dev_pm_domain_detach(dev, true);
+	if (sdrv->probe) {
+		ret = sdrv->probe(spi);
+		if (ret)
+			dev_pm_domain_detach(dev, true);
+	}
 
 	return ret;
 }
@@ -415,9 +417,10 @@ static int spi_drv_probe(struct device *dev)
 static int spi_drv_remove(struct device *dev)
 {
 	const struct spi_driver		*sdrv = to_spi_driver(dev->driver);
-	int ret;
+	int ret = 0;
 
-	ret = sdrv->remove(to_spi_device(dev));
+	if (sdrv->remove)
+		ret = sdrv->remove(to_spi_device(dev));
 	dev_pm_domain_detach(dev, true);
 
 	return ret;
@@ -442,10 +445,8 @@ int __spi_register_driver(struct module *owner, struct spi_driver *sdrv)
 {
 	sdrv->driver.owner = owner;
 	sdrv->driver.bus = &spi_bus_type;
-	if (sdrv->probe)
-		sdrv->driver.probe = spi_drv_probe;
-	if (sdrv->remove)
-		sdrv->driver.remove = spi_drv_remove;
+	sdrv->driver.probe = spi_drv_probe;
+	sdrv->driver.remove = spi_drv_remove;
 	if (sdrv->shutdown)
 		sdrv->driver.shutdown = spi_drv_shutdown;
 	return driver_register(&sdrv->driver);
-- 
2.27.0



