Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A2F2D9DF1
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 18:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408625AbgLNRja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:39:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408628AbgLNRjZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:39:25 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.9 087/105] mmc: sdhci-of-arasan: Fix clock registration error for Keem Bay SOC
Date:   Mon, 14 Dec 2020 18:29:01 +0100
Message-Id: <20201214172559.469182044@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

commit a42a7ec9bb99a17869c3b9f3d365aaf2bdb1a554 upstream.

The commit 16ada730a759 ("mmc: sdhci-of-arasan: Modify clock operations
handling") introduced support for platform specific clock operations.
Around the same point in time the commit 36c6aadaae86 ("mmc:
sdhci-of-arasan: Add support for Intel Keem Bay") was also  merged.
Unfortunate it was not really tested on top of the previously mentioned
commit, which causes clock registration failures for Keem Bay SOC devices.

Let's fix this, by properly declaring the clock operation for Keem Bay SOC
devices.

Fixes: 36c6aadaae86 ("mmc: sdhci-of-arasan: Add support for Intel Keem Bay")
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20201118120120.24908-2-muhammad.husaini.zulkifli@intel.com
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-arasan.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -1186,16 +1186,19 @@ static struct sdhci_arasan_of_data sdhci
 static struct sdhci_arasan_of_data intel_keembay_emmc_data = {
 	.soc_ctl_map = &intel_keembay_soc_ctl_map,
 	.pdata = &sdhci_keembay_emmc_pdata,
+	.clk_ops = &arasan_clk_ops,
 };
 
 static struct sdhci_arasan_of_data intel_keembay_sd_data = {
 	.soc_ctl_map = &intel_keembay_soc_ctl_map,
 	.pdata = &sdhci_keembay_sd_pdata,
+	.clk_ops = &arasan_clk_ops,
 };
 
 static struct sdhci_arasan_of_data intel_keembay_sdio_data = {
 	.soc_ctl_map = &intel_keembay_soc_ctl_map,
 	.pdata = &sdhci_keembay_sdio_pdata,
+	.clk_ops = &arasan_clk_ops,
 };
 
 static const struct of_device_id sdhci_arasan_of_match[] = {


