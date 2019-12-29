Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1D712C54A
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbfL2RfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:35:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:39386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729494AbfL2RfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:35:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 070B3207FF;
        Sun, 29 Dec 2019 17:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640912;
        bh=GeMjq1zg3nLt9JQ+I43kou047pBWN4o106rYxSC7SLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjbivanUfsRLZyzNkBqap4OIb/Gn78zcNET2JHvXYlPXEwk1ymIXGwx770wQKyDId
         oQdiCWHzWSyMTr6C6AqJuS6sAX3Q8gEOPLt6MefBm6eQ1uYxStqJUSVcPSXYV8CTE5
         MdMyRaEgtn7mwjHpEfsZ51BVIXqe0I75HinFUt2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 190/219] Revert "mmc: sdhci: Fix incorrect switch to HS mode"
Date:   Sun, 29 Dec 2019 18:19:52 +0100
Message-Id: <20191229162538.393934281@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

commit 07bcc411567cb96f9d1fc84fff8d387118a2920d upstream.

This reverts commit c894e33ddc1910e14d6f2a2016f60ab613fd8b37.

This commit aims to treat SD High speed and SDR25 as the same while
setting UHS Timings in HOST_CONTROL2 which leads to failures with some
SD cards in AM65x. Revert this commit.

The issue this commit was trying to fix can be implemented in a platform
specific callback instead of common sdhci code.

Cc: <stable@vger.kernel.org>
Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20191128110422.25917-1-faiz_abbas@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1713,9 +1713,7 @@ void sdhci_set_uhs_signaling(struct sdhc
 		ctrl_2 |= SDHCI_CTRL_UHS_SDR104;
 	else if (timing == MMC_TIMING_UHS_SDR12)
 		ctrl_2 |= SDHCI_CTRL_UHS_SDR12;
-	else if (timing == MMC_TIMING_SD_HS ||
-		 timing == MMC_TIMING_MMC_HS ||
-		 timing == MMC_TIMING_UHS_SDR25)
+	else if (timing == MMC_TIMING_UHS_SDR25)
 		ctrl_2 |= SDHCI_CTRL_UHS_SDR25;
 	else if (timing == MMC_TIMING_UHS_SDR50)
 		ctrl_2 |= SDHCI_CTRL_UHS_SDR50;


