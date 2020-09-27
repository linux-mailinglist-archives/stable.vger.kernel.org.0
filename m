Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567BC27A19A
	for <lists+stable@lfdr.de>; Sun, 27 Sep 2020 17:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgI0PKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Sep 2020 11:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgI0PKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Sep 2020 11:10:09 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3590C0613CE;
        Sun, 27 Sep 2020 08:10:08 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id d4so3863484wmd.5;
        Sun, 27 Sep 2020 08:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SzBl7wm7ho9tfo3JwIhFeWjVTbWY4f6C5L5RqhX83yE=;
        b=V7XdetLFjHr1QJVK/NImxfK8Pnczz47E1Un3RQL6OXGDBntzC72TsWb93lB9cIdsfQ
         9g48SjY7RKHsLXeE6p6YfyePPldvUFnIbxyEabhyNN1u6yhX4XpNz4blpLHDhJtt45C/
         DLmgWr9em+BvNUXsynNvjL54p+urXn2I6CkTGxW2eXHOogn3nySw4Y80vsKyZiTqMa3f
         NvbODaxlktP1RhFC8Vfgck3YAPSYF/DeO3mTrILSpka+p3TP4m5gPXv9p2ffU/lvW8lS
         ifR/GM4kRMG8HkSA/h8NM1rZzGmKMf9wKVWwG4hr+JXvImgYdqZgZzWR8NLxXLv5PAGR
         8MlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SzBl7wm7ho9tfo3JwIhFeWjVTbWY4f6C5L5RqhX83yE=;
        b=GacD1oBz1geWwUYvIkj0dm6bvFQWV4kyqOJrDtCl5XpJDfxDI2kJjcoTvPCztsuQv7
         WPm+gO+R96krHKGnAks9fgZUjjefcv0SNJCEsbBTSvpkgxCsshyVC6Vin+380/7d1njg
         wQowj7yPaROHZ5WckffhdhJauuaCiDyslRMIWwNC2AGkyMbq9gLm1xMYwjEBhjuC4pdg
         TsnHtuatCQBmNh260ynyHuKj3WVpgtpLtHOaE1g8w8xXnMNGgUaqU00TMeV8l8XCp/GA
         VxNCTBhoBcxobzN2pjFm7plJD5eVwZtDIa7P2a2+JrNDl5cmvLBfYPjJ566xgYMPsDMS
         0PzA==
X-Gm-Message-State: AOAM532C0u1nwjNIRZBuONvRN+X11Hp9D53ItqpXBen0o+8pjTxoVr1m
        LudOiGm8Znoq4Rm1rSF6XTs=
X-Google-Smtp-Source: ABdhPJzPADGTLSo9o6D4RuPD0rYbuOY+XKHH2BryYiM+CGy/wpxWPav6OBAoDphnUyNZPcD3t2hv1w==
X-Received: by 2002:a1c:2dc6:: with SMTP id t189mr7567161wmt.92.1601219407518;
        Sun, 27 Sep 2020 08:10:07 -0700 (PDT)
Received: from arrakis.kwizart.net (lfbn-nic-1-212-171.w2-15.abo.wanadoo.fr. [2.15.59.171])
        by smtp.gmail.com with ESMTPSA id s11sm9565114wrt.43.2020.09.27.08.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2020 08:10:06 -0700 (PDT)
From:   Nicolas Chauvet <kwizart@gmail.com>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     linux-tegra@vger.kernel.org, linux-pm@vger.kernel.org,
        Nicolas Chauvet <kwizart@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2 6/6] thermal: tegra: Avoid setting edp_irq when not relevant
Date:   Sun, 27 Sep 2020 17:09:56 +0200
Message-Id: <20200927150956.34609-7-kwizart@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200927150956.34609-1-kwizart@gmail.com>
References: <20200927150956.34609-1-kwizart@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to the binding, the edp_irq is not available on tegra124/132

This commit moves the initialization of tegra->edp_irq after the
introduced has_edp_irq condition. This will have the following effects:
 - soctherm_interrupts_init will not return prematurely with unfinished
thermal_irq initialization on tegra124 and tegra132
 - edp_irq initialization will be done only when relevant

As a result, this will clear the following error on jetson-tk1 :
  kernel: tegra_soctherm 700e2000.thermal-sensor: IRQ index 1 not found

v2:
    * Use .has_edp_irq boolean instead of of_compatible
    * Switch subject prefix to use thermal instead of ARM

Fixes: 4a04beb1bf2e (thermal: tegra: add support for EDP IRQ)
Cc: stable@vger.kernel.org
Signed-off-by: Nicolas Chauvet <kwizart@gmail.com>
---
 drivers/thermal/tegra/soctherm.c          | 38 +++++++++++++----------
 drivers/thermal/tegra/soctherm.h          |  1 +
 drivers/thermal/tegra/tegra124-soctherm.c |  1 +
 drivers/thermal/tegra/tegra132-soctherm.c |  1 +
 drivers/thermal/tegra/tegra210-soctherm.c |  1 +
 5 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/thermal/tegra/soctherm.c b/drivers/thermal/tegra/soctherm.c
index 66e0639da4bf..0c79e033e7ea 100644
--- a/drivers/thermal/tegra/soctherm.c
+++ b/drivers/thermal/tegra/soctherm.c
@@ -2025,12 +2025,6 @@ static int soctherm_interrupts_init(struct platform_device *pdev,
 		return 0;
 	}
 
-	tegra->edp_irq = platform_get_irq(pdev, 1);
-	if (tegra->edp_irq < 0) {
-		dev_dbg(&pdev->dev, "get 'edp_irq' failed.\n");
-		return 0;
-	}
-
 	ret = devm_request_threaded_irq(&pdev->dev,
 					tegra->thermal_irq,
 					soctherm_thermal_isr,
@@ -2043,16 +2037,28 @@ static int soctherm_interrupts_init(struct platform_device *pdev,
 		return ret;
 	}
 
-	ret = devm_request_threaded_irq(&pdev->dev,
-					tegra->edp_irq,
-					soctherm_edp_isr,
-					soctherm_edp_isr_thread,
-					IRQF_ONESHOT,
-					"soctherm_edp",
-					tegra);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "request_irq 'edp_irq' failed.\n");
-		return ret;
+	/* Initialize edp_irq when available */
+	if (tegra->soc->has_edp_irq) {
+		/* get IRQ */
+
+		tegra->edp_irq = platform_get_irq(pdev, 1);
+		if (tegra->edp_irq < 0) {
+			dev_dbg(&pdev->dev, "get 'edp_irq' failed.\n");
+			return 0;
+		}
+
+		/* request IRQ */
+		ret = devm_request_threaded_irq(&pdev->dev,
+						tegra->edp_irq,
+						soctherm_edp_isr,
+						soctherm_edp_isr_thread,
+						IRQF_ONESHOT,
+						"soctherm_edp",
+						tegra);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "request_irq 'edp_irq' failed.\n");
+			return ret;
+		}
 	}
 
 	return 0;
diff --git a/drivers/thermal/tegra/soctherm.h b/drivers/thermal/tegra/soctherm.h
index 70501e73d586..b93cfdd06e5d 100644
--- a/drivers/thermal/tegra/soctherm.h
+++ b/drivers/thermal/tegra/soctherm.h
@@ -128,6 +128,7 @@ struct tegra_soctherm_soc {
 	const int thresh_grain;
 	const unsigned int bptt;
 	const bool use_ccroc;
+	const bool has_edp_irq;
 	struct tsensor_group_thermtrips *thermtrips;
 };
 
diff --git a/drivers/thermal/tegra/tegra124-soctherm.c b/drivers/thermal/tegra/tegra124-soctherm.c
index 20ad27f4d1a1..c8c8231f6cdd 100644
--- a/drivers/thermal/tegra/tegra124-soctherm.c
+++ b/drivers/thermal/tegra/tegra124-soctherm.c
@@ -216,4 +216,5 @@ const struct tegra_soctherm_soc tegra124_soctherm = {
 	.thresh_grain = TEGRA124_THRESH_GRAIN,
 	.bptt = TEGRA124_BPTT,
 	.use_ccroc = false,
+	.has_edp_irq = false,
 };
diff --git a/drivers/thermal/tegra/tegra132-soctherm.c b/drivers/thermal/tegra/tegra132-soctherm.c
index b76308fdad9e..1bc9481de5fc 100644
--- a/drivers/thermal/tegra/tegra132-soctherm.c
+++ b/drivers/thermal/tegra/tegra132-soctherm.c
@@ -216,4 +216,5 @@ const struct tegra_soctherm_soc tegra132_soctherm = {
 	.thresh_grain = TEGRA132_THRESH_GRAIN,
 	.bptt = TEGRA132_BPTT,
 	.use_ccroc = true,
+	.has_edp_irq = false,
 };
diff --git a/drivers/thermal/tegra/tegra210-soctherm.c b/drivers/thermal/tegra/tegra210-soctherm.c
index d0ff793f18c5..2b09c8a811d0 100644
--- a/drivers/thermal/tegra/tegra210-soctherm.c
+++ b/drivers/thermal/tegra/tegra210-soctherm.c
@@ -224,5 +224,6 @@ const struct tegra_soctherm_soc tegra210_soctherm = {
 	.thresh_grain = TEGRA210_THRESH_GRAIN,
 	.bptt = TEGRA210_BPTT,
 	.use_ccroc = false,
+	.has_edp_irq = true,
 	.thermtrips = tegra210_tsensor_thermtrips,
 };
-- 
2.25.4

