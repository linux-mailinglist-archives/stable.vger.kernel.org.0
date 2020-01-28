Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA7F14B767
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgA1OOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:14:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:35882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729199AbgA1OOB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:14:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D1732468A;
        Tue, 28 Jan 2020 14:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220840;
        bh=JEZ3jSxxdzA5cJfhC2uxLflsC5h08bDwll3Dtk7S2PE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBzPq/prPS4ySj9wjtUbqR4o/mvoUYY9Qe6PBlXmKEf8i9xq/GivPIAdqf5O/Ar9a
         Jq5RJJ6qLG5cu0Y5vJSQ8gcimNZ8qTi/0Ts+FONBoYfqeJeMnQEw/2XnbcVw1WA4OR
         lYLG/87r1aZz+b2uDCbjgWe0pyQOEx9jwt/cvlbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.4 169/183] mmc: sdhci: fix minimum clock rate for v3 controller
Date:   Tue, 28 Jan 2020 15:06:28 +0100
Message-Id: <20200128135846.644221930@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
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
@@ -3096,11 +3096,13 @@ int sdhci_add_host(struct sdhci_host *ho
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
 


