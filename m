Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 299001910ED
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgCXNSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgCXNSc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:18:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2A68208D6;
        Tue, 24 Mar 2020 13:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055912;
        bh=a9nhZwx9EI0wQiaVo+A5K9svhSVJKhXAV6X6EYX4Rws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IlpLqZW1QK+tD3I1jIfgn/x8YkOwc20C+swPo3qA3NpJsf4PgV4UIVnftGSXs1Fqd
         aiou/8iljdxRYClhvxVGjCvDTVxqc+803LhQB91LcbhqAb2BtcA3waa2m3o6EMGsAf
         gqQP2QsxIkv/KvRpkeriJgBLIVUBfvc8xXltJWs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 066/102] mmc: sdhci-of-at91: fix cd-gpios for SAMA5D2
Date:   Tue, 24 Mar 2020 14:10:58 +0100
Message-Id: <20200324130813.314010108@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit 53dd0a7cd65edc83b0c243d1c08377c8b876b2ee upstream.

SAMA5D2x doesn't drive CMD line if GPIO is used as CD line (at least
SAMA5D27 doesn't). Fix this by forcing card-detect in the module
if module-controlled CD is not used.

Fixed commit addresses the problem only for non-removable cards. This
amends it to also cover gpio-cd case.

Cc: stable@vger.kernel.org
Fixes: 7a1e3f143176 ("mmc: sdhci-of-at91: force card detect value for non removable devices")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/8d10950d9940468577daef4772b82a071b204716.1584290561.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-at91.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci-of-at91.c
+++ b/drivers/mmc/host/sdhci-of-at91.c
@@ -118,7 +118,8 @@ static void sdhci_at91_reset(struct sdhc
 {
 	sdhci_reset(host, mask);
 
-	if (host->mmc->caps & MMC_CAP_NONREMOVABLE)
+	if ((host->mmc->caps & MMC_CAP_NONREMOVABLE)
+	    || mmc_gpio_get_cd(host->mmc) >= 0)
 		sdhci_at91_set_force_card_detect(host);
 }
 
@@ -397,8 +398,11 @@ static int sdhci_at91_probe(struct platf
 	 * detection procedure using the SDMCC_CD signal is bypassed.
 	 * This bit is reset when a software reset for all command is performed
 	 * so we need to implement our own reset function to set back this bit.
+	 *
+	 * WA: SAMA5D2 doesn't drive CMD if using CD GPIO line.
 	 */
-	if (host->mmc->caps & MMC_CAP_NONREMOVABLE)
+	if ((host->mmc->caps & MMC_CAP_NONREMOVABLE)
+	    || mmc_gpio_get_cd(host->mmc) >= 0)
 		sdhci_at91_set_force_card_detect(host);
 
 	pm_runtime_put_autosuspend(&pdev->dev);


