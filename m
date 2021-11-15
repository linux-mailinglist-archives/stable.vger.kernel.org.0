Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89661450DE1
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237858AbhKOSIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:08:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239716AbhKOSEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:04:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3543963255;
        Mon, 15 Nov 2021 17:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997902;
        bh=nkcqMojx5IMqD6h167wQSxZdB+rdS8IbCRKz0/CQniE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILnkIL1pGyf+86aNqFbNpDTLkA2X9kSiKgaVin0z9EoZIkKJXivZ6mULeIgYvEFpd
         tItQBy0Z6r0TJehDnOCt27yK59UyZXhzrsIRM4I5S0nM909DoA7y+v8oGJuX4gGn6m
         hTYifrOq6IEvDkIHOED9GfdKqccAkdgRLktPYIhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 315/575] mmc: sdhci-omap: Fix NULL pointer exception if regulator is not configured
Date:   Mon, 15 Nov 2021 18:00:40 +0100
Message-Id: <20211115165354.686675375@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 7893fd3599b61..8a669f57f14b3 100644
--- a/drivers/mmc/host/sdhci-omap.c
+++ b/drivers/mmc/host/sdhci-omap.c
@@ -682,7 +682,8 @@ static void sdhci_omap_set_power(struct sdhci_host *host, unsigned char mode,
 {
 	struct mmc_host *mmc = host->mmc;
 
-	mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, vdd);
+	if (!IS_ERR(mmc->supply.vmmc))
+		mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, vdd);
 }
 
 static int sdhci_omap_enable_dma(struct sdhci_host *host)
-- 
2.33.0



