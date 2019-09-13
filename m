Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF01B1AF7
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 11:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388000AbfIMJlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 05:41:25 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33108 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388004AbfIMJlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 05:41:25 -0400
Received: by mail-lf1-f67.google.com with SMTP id d10so21631177lfi.0
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 02:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=QS5aLvWZAGl2qy1uqqrDaZesBLdCRvn2tS/IES0IrhM=;
        b=yZ5hsC3wpKS6si95BrlMuHu1YR8h/0bTMI9DXnxjZWspdHqN1NRmsaGxp+nAxstv92
         1fzPPu9jEAL6CNzjvzEjLp3g5hmREbhMnxAnZKOVckJvwdCAu+bJxIyKdlR0Qi6YVo4b
         5OLcr7zH3kOTDBXAfUWTiPfaKSQrrO/oIeQuBf8qX8wUaMyVk37vlWX27hoxlGuF/+UY
         ZAyTx1v2oq1OSd8OlcaHIAtDfN5ElolhZyhFTyFLrygAk9maOIMXSQWY49hELJZBT2Tn
         Jp6rEBMG+D8e4yy7qTe/q2oOWmRdxz+x5Puswfi2iho4OcCIWM+ZDvDq2hc0/0gOrJiz
         qung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QS5aLvWZAGl2qy1uqqrDaZesBLdCRvn2tS/IES0IrhM=;
        b=nq20k5B0GrcC//SJYKNlUnJlYXxrop0dqo2l881D26Dz1HMOcUZs4j+g3WSIFrRP+9
         IivABj/INOS80FBL7KciWKS3mndjVMCMlz76HR9Ct48cIYwufPvSYjkwvaJ2jBfZhY75
         Mz/souFNGDNOqdSep7lnM6CgdPKsDCq17LodEmwMJlcVD0M2fISMMY8Uk5vmb4PRnfk/
         O8Keth5r1x5tLQa4jQ/iOqRnZlj0fBgSayt+OvY2XApuD4QMuefKr/hbcVEFbvHiJ/ko
         eAlibUo0wDpJzNAsReXuzgZcYcLCzotAFO5YiDeoqKxKf9FtEkyXCBpIkCRbU2+VpDmi
         rXtQ==
X-Gm-Message-State: APjAAAW2gyQV5ZWlUNDO+mLxquomcRWPHyw7eXaA34U2RvxND9gnWD/3
        3bsroiyDQZTnaq16N0Fo8meHIQ==
X-Google-Smtp-Source: APXvYqyUxASV7kYcJEmZaWXICNtRekMjOPkhAQ78JgYbxBn5y94tN6W9C5mpRNzDqz1V5ckldlf5eg==
X-Received: by 2002:ac2:51cd:: with SMTP id u13mr8658216lfm.135.1568367682684;
        Fri, 13 Sep 2019 02:41:22 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id h21sm6198268ljg.34.2019.09.13.02.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 02:41:22 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     Ulrich Hecht <uli+renesas@fpond.eu>,
        Simon Horman <horms+renesas@verge.net.au>,
        Niklas Soderlund <niklas.soderlund@ragnatech.se>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        stable@vger.kernel.org
Subject: [PATCH 3/3] mmc: tmio: Fixup runtime PM management during remove
Date:   Fri, 13 Sep 2019 11:41:18 +0200
Message-Id: <20190913094118.21243-1-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Accessing the device when it may be runtime suspended is a bug, which is
the case in tmio_mmc_host_remove(). Let's fix the behaviour.

Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/tmio_mmc_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc_core.c b/drivers/mmc/host/tmio_mmc_core.c
index 32f9679ec42e..9b6e1001e77c 100644
--- a/drivers/mmc/host/tmio_mmc_core.c
+++ b/drivers/mmc/host/tmio_mmc_core.c
@@ -1274,12 +1274,11 @@ void tmio_mmc_host_remove(struct tmio_mmc_host *host)
 	struct platform_device *pdev = host->pdev;
 	struct mmc_host *mmc = host->mmc;
 
+	pm_runtime_get_sync(&pdev->dev);
+
 	if (host->pdata->flags & TMIO_MMC_SDIO_IRQ)
 		sd_ctrl_write16(host, CTL_TRANSACTION_CTL, 0x0000);
 
-	if (!host->native_hotplug)
-		pm_runtime_get_sync(&pdev->dev);
-
 	dev_pm_qos_hide_latency_limit(&pdev->dev);
 
 	mmc_remove_host(mmc);
@@ -1288,6 +1287,8 @@ void tmio_mmc_host_remove(struct tmio_mmc_host *host)
 	tmio_mmc_release_dma(host);
 
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
+	if (host->native_hotplug)
+		pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 }
-- 
2.17.1

