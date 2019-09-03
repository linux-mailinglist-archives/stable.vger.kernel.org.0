Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E213A70AD
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbfICQka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730253AbfICQZF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A98F023431;
        Tue,  3 Sep 2019 16:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527904;
        bh=NBMbHfyt/tFX6thX00LXdA6w09xVqvszfiMH1DCrQA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TIgIgAoLkKvp5t1AlHFKwMvhU0g8dT0/GziAE4imsggnm49oYkTOnlqEscXn5oSYS
         nYx0CRcK2dRwMU1F9C6SDtABkr1rZd1Ebsc+3//a8uqu6L2tx8y2Tcm5b1tPaE5rAa
         /2NZVC1G7Pno5FIyl4VtW2OvdeRKO3wjFJZJ5hus=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baolin Wang <baolin.wang@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 15/23] mmc: sdhci-sprd: Fix the incorrect soft reset operation when runtime resuming
Date:   Tue,  3 Sep 2019 12:24:16 -0400
Message-Id: <20190903162424.6877-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162424.6877-1-sashal@kernel.org>
References: <20190903162424.6877-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baolin Wang <baolin.wang@linaro.org>

[ Upstream commit c6303c5d52d5ec3e5bce2e6a5480fa2a1baa45e6 ]

The SD host controller specification defines 3 types software reset:
software reset for data line, software reset for command line and software
reset for all. Software reset for all means this reset affects the entire
Host controller except for the card detection circuit.

In sdhci_runtime_resume_host() we always do a software "reset for all",
which causes the Spreadtrum variant controller to work abnormally after
resuming. To fix the problem, let's do a software reset for the data and
the command part, rather than "for all".

However, as sdhci_runtime_resume() is a common sdhci function and we don't
want to change the behaviour for other variants, let's introduce a new
in-parameter for it. This enables the caller to decide if a "reset for all"
shall be done or not.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
Fixes: fb8bd90f83c4 ("mmc: sdhci-sprd: Add Spreadtrum's initial host controller")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-acpi.c      | 2 +-
 drivers/mmc/host/sdhci-esdhc-imx.c | 2 +-
 drivers/mmc/host/sdhci-of-at91.c   | 2 +-
 drivers/mmc/host/sdhci-pci-core.c  | 4 ++--
 drivers/mmc/host/sdhci-pxav3.c     | 2 +-
 drivers/mmc/host/sdhci-s3c.c       | 2 +-
 drivers/mmc/host/sdhci-sprd.c      | 2 +-
 drivers/mmc/host/sdhci-xenon.c     | 2 +-
 drivers/mmc/host/sdhci.c           | 4 ++--
 drivers/mmc/host/sdhci.h           | 2 +-
 10 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/host/sdhci-acpi.c b/drivers/mmc/host/sdhci-acpi.c
index b3a130a9ee233..1604f512c7bd1 100644
--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -883,7 +883,7 @@ static int sdhci_acpi_runtime_resume(struct device *dev)
 
 	sdhci_acpi_byt_setting(&c->pdev->dev);
 
-	return sdhci_runtime_resume_host(c->host);
+	return sdhci_runtime_resume_host(c->host, 0);
 }
 
 #endif
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index c391510e9ef40..776a942162488 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1705,7 +1705,7 @@ static int sdhci_esdhc_runtime_resume(struct device *dev)
 		esdhc_pltfm_set_clock(host, imx_data->actual_clock);
 	}
 
-	err = sdhci_runtime_resume_host(host);
+	err = sdhci_runtime_resume_host(host, 0);
 	if (err)
 		goto disable_ipg_clk;
 
diff --git a/drivers/mmc/host/sdhci-of-at91.c b/drivers/mmc/host/sdhci-of-at91.c
index e377b9bc55a46..d4e7e8b7be772 100644
--- a/drivers/mmc/host/sdhci-of-at91.c
+++ b/drivers/mmc/host/sdhci-of-at91.c
@@ -289,7 +289,7 @@ static int sdhci_at91_runtime_resume(struct device *dev)
 	}
 
 out:
-	return sdhci_runtime_resume_host(host);
+	return sdhci_runtime_resume_host(host, 0);
 }
 #endif /* CONFIG_PM */
 
diff --git a/drivers/mmc/host/sdhci-pci-core.c b/drivers/mmc/host/sdhci-pci-core.c
index 4154ee11b47dc..267b90374fa48 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -167,7 +167,7 @@ static int sdhci_pci_runtime_suspend_host(struct sdhci_pci_chip *chip)
 
 err_pci_runtime_suspend:
 	while (--i >= 0)
-		sdhci_runtime_resume_host(chip->slots[i]->host);
+		sdhci_runtime_resume_host(chip->slots[i]->host, 0);
 	return ret;
 }
 
@@ -181,7 +181,7 @@ static int sdhci_pci_runtime_resume_host(struct sdhci_pci_chip *chip)
 		if (!slot)
 			continue;
 
-		ret = sdhci_runtime_resume_host(slot->host);
+		ret = sdhci_runtime_resume_host(slot->host, 0);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index 3ddecf4792958..e55037ceda734 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -554,7 +554,7 @@ static int sdhci_pxav3_runtime_resume(struct device *dev)
 	if (!IS_ERR(pxa->clk_core))
 		clk_prepare_enable(pxa->clk_core);
 
-	return sdhci_runtime_resume_host(host);
+	return sdhci_runtime_resume_host(host, 0);
 }
 #endif
 
diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
index 8e4a8ba33f050..f5753aef71511 100644
--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -745,7 +745,7 @@ static int sdhci_s3c_runtime_resume(struct device *dev)
 	clk_prepare_enable(busclk);
 	if (ourhost->cur_clk >= 0)
 		clk_prepare_enable(ourhost->clk_bus[ourhost->cur_clk]);
-	ret = sdhci_runtime_resume_host(host);
+	ret = sdhci_runtime_resume_host(host, 0);
 	return ret;
 }
 #endif
diff --git a/drivers/mmc/host/sdhci-sprd.c b/drivers/mmc/host/sdhci-sprd.c
index 06f84a4d79e00..f3261068adfbc 100644
--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -470,7 +470,7 @@ static int sdhci_sprd_runtime_resume(struct device *dev)
 		return ret;
 	}
 
-	sdhci_runtime_resume_host(host);
+	sdhci_runtime_resume_host(host, 1);
 
 	return 0;
 }
diff --git a/drivers/mmc/host/sdhci-xenon.c b/drivers/mmc/host/sdhci-xenon.c
index 8a18f14cf842d..1dea1ba66f7b4 100644
--- a/drivers/mmc/host/sdhci-xenon.c
+++ b/drivers/mmc/host/sdhci-xenon.c
@@ -638,7 +638,7 @@ static int xenon_runtime_resume(struct device *dev)
 		priv->restore_needed = false;
 	}
 
-	ret = sdhci_runtime_resume_host(host);
+	ret = sdhci_runtime_resume_host(host, 0);
 	if (ret)
 		goto out;
 	return 0;
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 59acf8e3331ee..a5dc5aae973e6 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -3320,7 +3320,7 @@ int sdhci_runtime_suspend_host(struct sdhci_host *host)
 }
 EXPORT_SYMBOL_GPL(sdhci_runtime_suspend_host);
 
-int sdhci_runtime_resume_host(struct sdhci_host *host)
+int sdhci_runtime_resume_host(struct sdhci_host *host, int soft_reset)
 {
 	struct mmc_host *mmc = host->mmc;
 	unsigned long flags;
@@ -3331,7 +3331,7 @@ int sdhci_runtime_resume_host(struct sdhci_host *host)
 			host->ops->enable_dma(host);
 	}
 
-	sdhci_init(host, 0);
+	sdhci_init(host, soft_reset);
 
 	if (mmc->ios.power_mode != MMC_POWER_UNDEFINED &&
 	    mmc->ios.power_mode != MMC_POWER_OFF) {
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 199712e7adbb3..d2c7c9c436c97 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -781,7 +781,7 @@ void sdhci_adma_write_desc(struct sdhci_host *host, void **desc,
 int sdhci_suspend_host(struct sdhci_host *host);
 int sdhci_resume_host(struct sdhci_host *host);
 int sdhci_runtime_suspend_host(struct sdhci_host *host);
-int sdhci_runtime_resume_host(struct sdhci_host *host);
+int sdhci_runtime_resume_host(struct sdhci_host *host, int soft_reset);
 #endif
 
 void sdhci_cqe_enable(struct mmc_host *mmc);
-- 
2.20.1

