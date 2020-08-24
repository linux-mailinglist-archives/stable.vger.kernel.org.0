Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0491F24F8D3
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgHXJhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:37:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729467AbgHXIr3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:47:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42177204FD;
        Mon, 24 Aug 2020 08:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258848;
        bh=6w/oszwsnHTIdJ9mfROu3YvYwqGKZVMyT9uEp+7dW+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JC/cdr7pS5nj/0XezxbTMq5JFH3Kk8kPDFh2HYYv8jJ4S/KYqMdq5lAk9ich/xDQh
         HY/mlKAIYjjFTjhCI9kpeTt4HO3+UXXV/xaPry5jvpTpQMoAvArFa8kTOIauOKlaye
         VW+2RHEd1XdRCtE1ojF63trVXQIyRkeiDHHpPS9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amelie Delaunay <amelie.delaunay@st.com>,
        Alain Volmat <alain.volmat@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/107] spi: stm32: fixes suspend/resume management
Date:   Mon, 24 Aug 2020 10:30:32 +0200
Message-Id: <20200824082408.390520053@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
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
index b222ce8d083ef..7e92ab0cc9920 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -14,6 +14,7 @@
 #include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/of_platform.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
 #include <linux/spi/spi.h>
@@ -1986,6 +1987,8 @@ static int stm32_spi_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 
+	pinctrl_pm_select_sleep_state(&pdev->dev);
+
 	return 0;
 }
 
@@ -1997,13 +2000,18 @@ static int stm32_spi_runtime_suspend(struct device *dev)
 
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
@@ -2033,10 +2041,23 @@ static int stm32_spi_resume(struct device *dev)
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



