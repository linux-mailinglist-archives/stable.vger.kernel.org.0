Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4684545C013
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345515AbhKXNEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:04:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347787AbhKXNDS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:03:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1774A611EE;
        Wed, 24 Nov 2021 12:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757373;
        bh=hjf3xry4z7OF52jAyoBoSTE4cJQO9+JN5+oo556tKqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wGy4LTwelpBrpz6aIKg6Mk66/BJ+d9qNHV8uc4dUYK0Eoxw+V8RyBqXi8OaPm181F
         iIJO6ZcG384h+mKfpbVQYMe6BsWqapAaHX6Qx00Sl8gld0aQrmSxSzdNEHjpIz7iTR
         l7ZspZA1Psuz7itnM6y4Psa5zQCnupokh802emEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 145/323] mmc: sdhci-omap: Fix NULL pointer exception if regulator is not configured
Date:   Wed, 24 Nov 2021 12:55:35 +0100
Message-Id: <20211124115723.817043671@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 8e0e7bd38b1ec7f9e5d18725ad41828be4e09859 ]

If sdhci-omap is configured for an unused device instance and the device
is not set as disabled, we can get a NULL pointer dereference:

Unable to handle kernel NULL pointer dereference at virtual address
00000045
...
(regulator_set_voltage) from [<c07d7008>] (mmc_regulator_set_ocr+0x44/0xd0)
(mmc_regulator_set_ocr) from [<c07e2d80>] (sdhci_set_ios+0xa4/0x490)
(sdhci_set_ios) from [<c07ea690>] (sdhci_omap_set_ios+0x124/0x160)
(sdhci_omap_set_ios) from [<c07c8e94>] (mmc_power_up.part.0+0x3c/0x154)
(mmc_power_up.part.0) from [<c07c9d20>] (mmc_start_host+0x88/0x9c)
(mmc_start_host) from [<c07cad34>] (mmc_add_host+0x58/0x7c)
(mmc_add_host) from [<c07e2574>] (__sdhci_add_host+0xf0/0x22c)
(__sdhci_add_host) from [<c07eaf68>] (sdhci_omap_probe+0x318/0x72c)
(sdhci_omap_probe) from [<c06a39d8>] (platform_probe+0x58/0xb8)

AFAIK we are not seeing this with the devices configured in the mainline
kernel but this can cause issues for folks bringing up their boards.

Fixes: 7d326930d352 ("mmc: sdhci-omap: Add OMAP SDHCI driver")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20210921110029.21944-2-tony@atomide.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-omap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-omap.c b/drivers/mmc/host/sdhci-omap.c
index 05ade7a2dd243..f5bff9e710fb2 100644
--- a/drivers/mmc/host/sdhci-omap.c
+++ b/drivers/mmc/host/sdhci-omap.c
@@ -690,7 +690,8 @@ static void sdhci_omap_set_power(struct sdhci_host *host, unsigned char mode,
 {
 	struct mmc_host *mmc = host->mmc;
 
-	mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, vdd);
+	if (!IS_ERR(mmc->supply.vmmc))
+		mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, vdd);
 }
 
 static int sdhci_omap_enable_dma(struct sdhci_host *host)
-- 
2.33.0



