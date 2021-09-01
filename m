Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B68483FDC97
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345951AbhIAMv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:51:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346406AbhIAMuL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23AC560C3E;
        Wed,  1 Sep 2021 12:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500091;
        bh=euou5dDXYWLl5efyDSdIq244YaYvwvkg/kzzcPJzSD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjUg9NxTauYs6WEga1fYWCsqhb/ESr5WfKujW4MUu6U7jAvSgZrK+6WKqj8grrXaa
         2sUwZdISgEN4Uq8K8X71XOOBocI+DEWQGEvyh7m7/lN788HrIIMDp6xo+ggcG0DIdy
         QTN9/MLO2KDcAZf1iid4O3/GLKX3j8ze/0D8+I8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 066/113] Revert "mmc: sdhci-iproc: Set SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN on BCM2711"
Date:   Wed,  1 Sep 2021 14:28:21 +0200
Message-Id: <20210901122304.182401203@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 885814a97f5a1a2daf66bde5f2076f0bf632c174 ]

This reverts commit 419dd626e357e89fc9c4e3863592c8b38cfe1571.

It turned out that the change from the reverted commit breaks the ACPI
based rpi's because it causes the 100Mhz max clock to be overridden to the
return from sdhci_iproc_get_max_clock(), which is 0 because there isn't a
OF/DT based clock device.

Reported-by: Jeremy Linton <jeremy.linton@arm.com>
Fixes: 419dd626e357 ("mmc: sdhci-iproc: Set SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN on BCM2711")
Acked-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-iproc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-iproc.c b/drivers/mmc/host/sdhci-iproc.c
index 9f0eef97ebdd..b9eb2ec61a83 100644
--- a/drivers/mmc/host/sdhci-iproc.c
+++ b/drivers/mmc/host/sdhci-iproc.c
@@ -295,8 +295,7 @@ static const struct sdhci_ops sdhci_iproc_bcm2711_ops = {
 };
 
 static const struct sdhci_pltfm_data sdhci_bcm2711_pltfm_data = {
-	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 |
-		  SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
+	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
 	.ops = &sdhci_iproc_bcm2711_ops,
 };
 
-- 
2.30.2



