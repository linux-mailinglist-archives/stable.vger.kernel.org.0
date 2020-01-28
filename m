Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B538314B96E
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733290AbgA1Obs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:31:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733288AbgA1O1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:27:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA90B24692;
        Tue, 28 Jan 2020 14:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221640;
        bh=e1HzGmXAfHbWNK3w/NNP8WqgKSs1SI9Tj+OHxgFdQuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fpCNCxe+KoGbY77saSPWEhyWHMSwg79xoPnIv5UBj/Cf0a9zYcQY2cUTxeF8tHJTe
         O1NQhSMEVfGl0m0RoFadbLJdh1dwySw3W4myzDyQ1/XRfdSJYUN3cZhMwKFjBvik7N
         FeLhseTv3zOGQVxi5Dw8V3yo30DwEF9HhQUTjirQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 31/92] mmc: sdhci: fix minimum clock rate for v3 controller
Date:   Tue, 28 Jan 2020 15:07:59 +0100
Message-Id: <20200128135813.053698865@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit 2a187d03352086e300daa2044051db00044cd171 upstream.

For SDHCIv3+ with programmable clock mode, minimal clock frequency is
still base clock / max(divider). Minimal programmable clock frequency is
always greater than minimal divided clock frequency. Without this patch,
SDHCI uses out-of-spec initial frequency when multiplier is big enough:

mmc1: mmc_rescan_try_freq: trying to init card at 468750 Hz
[for 480 MHz source clock divided by 1024]

The code in sdhci_calc_clk() already chooses a correct SDCLK clock mode.

Fixes: c3ed3877625f ("mmc: sdhci: add support for programmable clock mode")
Cc: <stable@vger.kernel.org> # 4f6aa3264af4: mmc: tegra: Only advertise UHS modes if IO regulator is present
Cc: <stable@vger.kernel.org>
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/ffb489519a446caffe7a0a05c4b9372bd52397bb.1579082031.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -3700,11 +3700,13 @@ int sdhci_setup_host(struct sdhci_host *
 	if (host->ops->get_min_clock)
 		mmc->f_min = host->ops->get_min_clock(host);
 	else if (host->version >= SDHCI_SPEC_300) {
-		if (host->clk_mul) {
-			mmc->f_min = (host->max_clk * host->clk_mul) / 1024;
+		if (host->clk_mul)
 			max_clk = host->max_clk * host->clk_mul;
-		} else
-			mmc->f_min = host->max_clk / SDHCI_MAX_DIV_SPEC_300;
+		/*
+		 * Divided Clock Mode minimum clock rate is always less than
+		 * Programmable Clock Mode minimum clock rate.
+		 */
+		mmc->f_min = host->max_clk / SDHCI_MAX_DIV_SPEC_300;
 	} else
 		mmc->f_min = host->max_clk / SDHCI_MAX_DIV_SPEC_200;
 


