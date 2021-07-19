Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360523CDFCE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345583AbhGSPMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345477AbhGSPJY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:09:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C93D61166;
        Mon, 19 Jul 2021 15:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709743;
        bh=3UyRC9YMHv61tWXMtibjr5Yon1kzlZ7gv818W/5RkWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x9GECwlxHOckK9Wx5v/0Hl7MMEwgYTji35uibUaCCuXW7QQuDa/0E8kKD8By5jQhd
         MZUXxO/SQ9qFIWDC7tIbIAXQgeFr8/7SPN0vlL19QxFLQYjRCFjost+V65o7TsGNte
         u4vmHNNO7vy/w+yalbL+6g8P1iF1h2aZ+s3DQCgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Eichenberger <eichest@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/149] watchdog: imx_sc_wdt: fix pretimeout
Date:   Mon, 19 Jul 2021 16:53:08 +0200
Message-Id: <20210719144920.293190741@linuxfoundation.org>
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



