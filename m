Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1321024F457
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgHXIfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:35:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726753AbgHXIfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:35:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA939206F0;
        Mon, 24 Aug 2020 08:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258108;
        bh=7E+dN2Dwfn9XnzV0ZiH7houZl7O40rFViWmGZxzzRPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIcZCORKA3JYdyxEFkvVSsIyAm4BCfzNWg/1zhPBLqHbZFK2UK+Ms11k5ZUCRIQH3
         v8k4H7QgUJz7lHbVFZyr3cJxMENlGGEZ/qo4Vn+9MGQIGjN8IVeGv8VmeR4k1H7Xu7
         pwtdEQRjj3j9WfIrCJs9yOSBrcgQKJ23Rq09XMOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amelie Delaunay <amelie.delaunay@st.com>,
        Alain Volmat <alain.volmat@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 077/148] spi: stm32: fixes suspend/resume management
Date:   Mon, 24 Aug 2020 10:29:35 +0200
Message-Id: <20200824082417.764517299@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@st.com>

[ Upstream commit db96bf976a4fc65439be0b4524c0d41427d98814 ]

This patch adds pinctrl power management, and reconfigure spi controller
in case of resume.

Fixes: 038ac869c9d2 ("spi: stm32: add runtime PM support")

Signed-off-by: Amelie Delaunay <amelie.delaunay@st.com>
Signed-off-by: Alain Volmat <alain.volmat@st.com>
Link: https://lore.kernel.org/r/1597043558-29668-5-git-send-email-alain.volmat@st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 4c643dfc7fbbc..9672cda2f8031 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -13,6 +13,7 @@
 #include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/of_platform.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
 #include <linux/spi/spi.h>
@@ -1996,6 +1997,8 @@ static int stm32_spi_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 
+	pinctrl_pm_select_sleep_state(&pdev->dev);
+
 	return 0;
 }
 
@@ -2007,13 +2010,18 @@ static int stm32_spi_runtime_suspend(struct device *dev)
 
 	clk_disable_unprepare(spi->clk);
 
-	return 0;
+	return pinctrl_pm_select_sleep_state(dev);
 }
 
 static int stm32_spi_runtime_resume(struct device *dev)
 {
 	struct spi_master *master = dev_get_drvdata(dev);
 	struct stm32_spi *spi = spi_master_get_devdata(master);
+	int ret;
+
+	ret = pinctrl_pm_select_default_state(dev);
+	if (ret)
+		return ret;
 
 	return clk_prepare_enable(spi->clk);
 }
@@ -2043,10 +2051,23 @@ static int stm32_spi_resume(struct device *dev)
 		return ret;
 
 	ret = spi_master_resume(master);
-	if (ret)
+	if (ret) {
 		clk_disable_unprepare(spi->clk);
+		return ret;
+	}
 
-	return ret;
+	ret = pm_runtime_get_sync(dev);
+	if (ret) {
+		dev_err(dev, "Unable to power device:%d\n", ret);
+		return ret;
+	}
+
+	spi->cfg->config(spi);
+
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
+
+	return 0;
 }
 #endif
 
-- 
2.25.1



