Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6EA41A5B96
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbgDKXuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:50:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbgDKXD5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:03:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8719020CC7;
        Sat, 11 Apr 2020 23:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646237;
        bh=FSf27dSxLFynBy3f4z0uQuP395gcFdgbx8vHr+5lx7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXAYbUW9ogOkbvbGwtk0AkZHnLnD8Thx3+SL4CaEcGvCzadeqzRN4zYVxxKC21trN
         /fNg/j5qPto/3Yh3ocqYJFuJGkz1P8P6x6h6TI3PetCIWgZfUk+BedSEIYX+S3Nee3
         LAWM219gAw2kGjI1yqRJfRYQTaRI5PDtsW3JyAdc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haibo Chen <haibo.chen@nxp.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 007/149] mmc: sdhci-esdhc-imx: restore pin state when resume back
Date:   Sat, 11 Apr 2020 19:01:24 -0400
Message-Id: <20200411230347.22371-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit af8fade4bd7bc7bf49851832a20166213e032978 ]

In some low power mode, SoC will lose the pin state, so need to restore
the pin state when resume back.

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://lore.kernel.org/r/1582100757-20683-8-git-send-email-haibo.chen@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 382f25b2fa458..8d5e7d5e669af 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1617,7 +1617,11 @@ static int sdhci_esdhc_suspend(struct device *dev)
 	if (host->tuning_mode != SDHCI_TUNING_MODE_3)
 		mmc_retune_needed(host->mmc);
 
-	return sdhci_suspend_host(host);
+	ret = sdhci_suspend_host(host);
+	if (!ret)
+		return pinctrl_pm_select_sleep_state(dev);
+
+	return ret;
 }
 
 static int sdhci_esdhc_resume(struct device *dev)
@@ -1625,6 +1629,10 @@ static int sdhci_esdhc_resume(struct device *dev)
 	struct sdhci_host *host = dev_get_drvdata(dev);
 	int ret;
 
+	ret = pinctrl_pm_select_default_state(dev);
+	if (ret)
+		return ret;
+
 	/* re-initialize hw state in case it's lost in low power mode */
 	sdhci_esdhc_imx_hwinit(host);
 
-- 
2.20.1

