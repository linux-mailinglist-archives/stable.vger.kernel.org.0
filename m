Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9266D32899A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbhCASAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:00:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236588AbhCARyI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:54:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 470546504C;
        Mon,  1 Mar 2021 17:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619111;
        bh=SLEXgjDorRN61SND0rkTIITpPrSjtZdiLSKi/kAWjro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hNOzXjwNmEa16XoxeJDBdzyawy1HSLs1ct43gaonEBuobWjfUifvcipAPH1QBOnP2
         B5MJ42vADa+eQqSBG9UlG+GglDbsCPGyYsbIelmvlvLoyGTGpit509jxTm3+ShtjcX
         UQuq9wtafVfi3ngaqmyYwtgATBBeIMbenHwej9A8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 336/663] amba: Fix resource leak for drivers without .remove
Date:   Mon,  1 Mar 2021 17:09:44 +0100
Message-Id: <20210301161158.472217735@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit de5d7adb89367bbc87b4e5ce7afe7ae9bd86dc12 ]

Consider an amba driver with a .probe but without a .remove callback (e.g.
pl061_gpio_driver). The function amba_probe() is called to bind a device
and so dev_pm_domain_attach() and others are called. As there is no remove
callback amba_remove() isn't called at unbind time however and so calling
dev_pm_domain_detach() is missed and the pm domain keeps active.

To fix this always use the core driver callbacks and handle missing amba
callbacks there. For probe refuse registration as a driver without probe
doesn't make sense.

Fixes: 7cfe249475fd ("ARM: AMBA: Add pclk support to AMBA bus infrastructure")
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20210126165835.687514-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/amba/bus.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index ecc304149067c..b5f5ca4e3f343 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -299,10 +299,11 @@ static int amba_remove(struct device *dev)
 {
 	struct amba_device *pcdev = to_amba_device(dev);
 	struct amba_driver *drv = to_amba_driver(dev->driver);
-	int ret;
+	int ret = 0;
 
 	pm_runtime_get_sync(dev);
-	ret = drv->remove(pcdev);
+	if (drv->remove)
+		ret = drv->remove(pcdev);
 	pm_runtime_put_noidle(dev);
 
 	/* Undo the runtime PM settings in amba_probe() */
@@ -319,7 +320,9 @@ static int amba_remove(struct device *dev)
 static void amba_shutdown(struct device *dev)
 {
 	struct amba_driver *drv = to_amba_driver(dev->driver);
-	drv->shutdown(to_amba_device(dev));
+
+	if (drv->shutdown)
+		drv->shutdown(to_amba_device(dev));
 }
 
 /**
@@ -332,12 +335,13 @@ static void amba_shutdown(struct device *dev)
  */
 int amba_driver_register(struct amba_driver *drv)
 {
-	drv->drv.bus = &amba_bustype;
+	if (!drv->probe)
+		return -EINVAL;
 
-#define SETFN(fn)	if (drv->fn) drv->drv.fn = amba_##fn
-	SETFN(probe);
-	SETFN(remove);
-	SETFN(shutdown);
+	drv->drv.bus = &amba_bustype;
+	drv->drv.probe = amba_probe;
+	drv->drv.remove = amba_remove;
+	drv->drv.shutdown = amba_shutdown;
 
 	return driver_register(&drv->drv);
 }
-- 
2.27.0



