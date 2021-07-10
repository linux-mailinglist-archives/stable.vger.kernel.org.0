Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B603C388F
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbhGJXz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233172AbhGJXya (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:54:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75B55613B5;
        Sat, 10 Jul 2021 23:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961083;
        bh=3UyRC9YMHv61tWXMtibjr5Yon1kzlZ7gv818W/5RkWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sSUfFioPWqW3tVnjQxBV2nj4NnmD17sgp7uuXFNT3bwUeTRcEOtSM23zGmxd5UQpd
         EsPSYiFq6yVZMx13FKE6hhBN+SznA2DbbK44IIuCWNMLQHqWTxqXj6kpUKHMVCerpS
         GzSRbgPnleAK8owcDzwnioIKUI5mgXBnlK+1HKU2vy/y2veGo+QGqnf4DwKsFG8Ymx
         UUhPSYJ+yQn8k6hvcjES9UGAZx1M/SfgryXrrS4JmM7Fq+4j46eF13TbsulzA46OzW
         6q9dKlJdG3shlkqdisF41XMea/PvBmav+cy51dIBfQhB+so3UUe0AB50XXHA3TStLa
         YM95htEgGKRuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Eichenberger <eichest@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 12/28] watchdog: imx_sc_wdt: fix pretimeout
Date:   Sat, 10 Jul 2021 19:50:51 -0400
Message-Id: <20210710235107.3221840-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235107.3221840-1-sashal@kernel.org>
References: <20210710235107.3221840-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Eichenberger <eichest@gmail.com>

[ Upstream commit 854478a381078ee86ae2a7908a934b1ded399130 ]

If the WDIOF_PRETIMEOUT flag is not set when registering the device the
driver will not show the sysfs entries or register the default governor.
By moving the registering after the decision whether pretimeout is
supported this gets fixed.

Signed-off-by: Stefan Eichenberger <eichest@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
Link: https://lore.kernel.org/r/20210519080311.142928-1-eichest@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/imx_sc_wdt.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/watchdog/imx_sc_wdt.c b/drivers/watchdog/imx_sc_wdt.c
index e0e62149a6f4..8c9936e78bee 100644
--- a/drivers/watchdog/imx_sc_wdt.c
+++ b/drivers/watchdog/imx_sc_wdt.c
@@ -185,16 +185,12 @@ static int imx_sc_wdt_probe(struct platform_device *pdev)
 	watchdog_stop_on_reboot(wdog);
 	watchdog_stop_on_unregister(wdog);
 
-	ret = devm_watchdog_register_device(dev, wdog);
-	if (ret)
-		return ret;
-
 	ret = imx_scu_irq_group_enable(SC_IRQ_GROUP_WDOG,
 				       SC_IRQ_WDOG,
 				       true);
 	if (ret) {
 		dev_warn(dev, "Enable irq failed, pretimeout NOT supported\n");
-		return 0;
+		goto register_device;
 	}
 
 	imx_sc_wdd->wdt_notifier.notifier_call = imx_sc_wdt_notify;
@@ -205,7 +201,7 @@ static int imx_sc_wdt_probe(struct platform_device *pdev)
 					 false);
 		dev_warn(dev,
 			 "Register irq notifier failed, pretimeout NOT supported\n");
-		return 0;
+		goto register_device;
 	}
 
 	ret = devm_add_action_or_reset(dev, imx_sc_wdt_action,
@@ -215,7 +211,8 @@ static int imx_sc_wdt_probe(struct platform_device *pdev)
 	else
 		dev_warn(dev, "Add action failed, pretimeout NOT supported\n");
 
-	return 0;
+register_device:
+	return devm_watchdog_register_device(dev, wdog);
 }
 
 static int __maybe_unused imx_sc_wdt_suspend(struct device *dev)
-- 
2.30.2

