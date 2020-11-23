Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9AC2C08D0
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387908AbgKWNBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:01:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387861AbgKWMxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:53:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 844F4217A0;
        Mon, 23 Nov 2020 12:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135965;
        bh=qe3canwC/rYv71jhEHIlOUzNRuEPBPKmSOy1eCQk/uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ra3F8RxwcQ/HexHDhFvk5r0L/rTOy9eSQ2UZxB3WQS5FBQmr2h2UPZ+3ct1ZGrD/s
         Yew+JJw7ElpZOHeo4waCMd/QFelURti+S/1PqDg+WnSDKwa0PY7myWzKlSje0OC/Ko
         9rQm4fK+ZHGW04KwvzbkxJTZ0Dhr66vQzeyB5NGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>,
        Manish Narani <manish.narani@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.9 241/252] mmc: sdhci-of-arasan: Allow configuring zero tap values
Date:   Mon, 23 Nov 2020 13:23:11 +0100
Message-Id: <20201123121847.213490484@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Narani <manish.narani@xilinx.com>

commit 9e9534329306fcd7ea1b84f14860a3c04ebe7f1a upstream.

Allow configuring the Output and Input tap values with zero to avoid
failures in some cases (one of them is SD boot mode) where the output
and input tap values may be already set to non-zero.

Fixes: a5c8b2ae2e51 ("mmc: sdhci-of-arasan: Add support for ZynqMP Platform Tap Delays Setup")
Signed-off-by: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
Signed-off-by: Manish Narani <manish.narani@xilinx.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1605515565-117562-2-git-send-email-manish.narani@xilinx.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-arasan.c |   40 +++++++------------------------------
 1 file changed, 8 insertions(+), 32 deletions(-)

--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -600,14 +600,8 @@ static int sdhci_zynqmp_sdcardclk_set_ph
 	u8 tap_delay, tap_max = 0;
 	int ret;
 
-	/*
-	 * This is applicable for SDHCI_SPEC_300 and above
-	 * ZynqMP does not set phase for <=25MHz clock.
-	 * If degrees is zero, no need to do anything.
-	 */
-	if (host->version < SDHCI_SPEC_300 ||
-	    host->timing == MMC_TIMING_LEGACY ||
-	    host->timing == MMC_TIMING_UHS_SDR12 || !degrees)
+	/* This is applicable for SDHCI_SPEC_300 and above */
+	if (host->version < SDHCI_SPEC_300)
 		return 0;
 
 	switch (host->timing) {
@@ -668,14 +662,8 @@ static int sdhci_zynqmp_sampleclk_set_ph
 	u8 tap_delay, tap_max = 0;
 	int ret;
 
-	/*
-	 * This is applicable for SDHCI_SPEC_300 and above
-	 * ZynqMP does not set phase for <=25MHz clock.
-	 * If degrees is zero, no need to do anything.
-	 */
-	if (host->version < SDHCI_SPEC_300 ||
-	    host->timing == MMC_TIMING_LEGACY ||
-	    host->timing == MMC_TIMING_UHS_SDR12 || !degrees)
+	/* This is applicable for SDHCI_SPEC_300 and above */
+	if (host->version < SDHCI_SPEC_300)
 		return 0;
 
 	switch (host->timing) {
@@ -733,14 +721,8 @@ static int sdhci_versal_sdcardclk_set_ph
 	struct sdhci_host *host = sdhci_arasan->host;
 	u8 tap_delay, tap_max = 0;
 
-	/*
-	 * This is applicable for SDHCI_SPEC_300 and above
-	 * Versal does not set phase for <=25MHz clock.
-	 * If degrees is zero, no need to do anything.
-	 */
-	if (host->version < SDHCI_SPEC_300 ||
-	    host->timing == MMC_TIMING_LEGACY ||
-	    host->timing == MMC_TIMING_UHS_SDR12 || !degrees)
+	/* This is applicable for SDHCI_SPEC_300 and above */
+	if (host->version < SDHCI_SPEC_300)
 		return 0;
 
 	switch (host->timing) {
@@ -804,14 +786,8 @@ static int sdhci_versal_sampleclk_set_ph
 	struct sdhci_host *host = sdhci_arasan->host;
 	u8 tap_delay, tap_max = 0;
 
-	/*
-	 * This is applicable for SDHCI_SPEC_300 and above
-	 * Versal does not set phase for <=25MHz clock.
-	 * If degrees is zero, no need to do anything.
-	 */
-	if (host->version < SDHCI_SPEC_300 ||
-	    host->timing == MMC_TIMING_LEGACY ||
-	    host->timing == MMC_TIMING_UHS_SDR12 || !degrees)
+	/* This is applicable for SDHCI_SPEC_300 and above */
+	if (host->version < SDHCI_SPEC_300)
 		return 0;
 
 	switch (host->timing) {


