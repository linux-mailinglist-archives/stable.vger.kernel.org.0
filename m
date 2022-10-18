Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90ADA6022F6
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 05:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiJRD5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 23:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiJRD5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 23:57:41 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAE087681
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 20:57:39 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id k9so12220662pll.11
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 20:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/5SY8Nah0OJo40Eqd9ufrxakceznyXcaJJucJXEE6R0=;
        b=m3Yt3QI6+Z/DrLslxPJ/GzJKEJbJxlIPy8KAYZmEIRcp609iOKz/1AXizo0Chsx+uk
         ldcx7+d5tpLrsL/TW3piXuuC9bCYwaXfh7MoSV69B5rEG0ycLHN/v2/PNpBvwi03yFqu
         gFUwj9zrzvuH1GSY26F8RA0v/zQ7eMhlGc7ko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/5SY8Nah0OJo40Eqd9ufrxakceznyXcaJJucJXEE6R0=;
        b=NCPYDCQstEhKttb91dtfeIoxnxTHrwU6ciwASXH4hPqsFkN2HK8olDPfYUVzIR8MwN
         UtuAYta8JqTqgvSehABYv0nbf1klGiGK8bDFPbzpqSGh+c0w+G++394ERq/VfXsrLf2T
         +DuAsS5vUWB8EqTRiWl88a5jO3OUuau2PhbBhWmc+gvcs99UWluPr1Nq16czZGQ/C+Mj
         Ax4e4mJwMFQYu/P+tupZI22vYZV9Y5cca/KxGMmxe5Ku3SA86gPP1RBUPApbvyoaLNoi
         wM3+nNSv7/Yq6h1oF9ylLrxEObn3T7hW+B2hkgHPMiWI0b2XCauaFPF7sjh6D2SLAkBL
         wUMg==
X-Gm-Message-State: ACrzQf0qCr3Th6KKU1tWz4Eomr2cy06JtoYRqm5qgcxzOn9AW4RW0rPA
        VOu+zVoccBqWoTGUMkHq79UQsQ==
X-Google-Smtp-Source: AMsMyM6NWclKdvs2x3bS5AOs5cN15w5Ryx1WxcO+ICS16eS1oY7gmJdDCaLLyh3ZZaWCGlKUVoUPWw==
X-Received: by 2002:a17:902:8e84:b0:178:71f2:113c with SMTP id bg4-20020a1709028e8400b0017871f2113cmr948888plb.79.1666065459409;
        Mon, 17 Oct 2022 20:57:39 -0700 (PDT)
Received: from localhost ([2620:15c:9d:2:2ac3:f4e2:e908:c393])
        by smtp.gmail.com with UTF8SMTPSA id h9-20020aa79f49000000b00537fb1f9f25sm7972272pfr.110.2022.10.17.20.57.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 20:57:38 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Shawn Lin <shawn.lin@rock-chips.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Al Cooper <alcooperx@gmail.com>, linux-mmc@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        linux-arm-kernel@lists.infradead.org,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Subject: [PATCH 1/5] mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for CQHCI
Date:   Mon, 17 Oct 2022 20:57:20 -0700
Message-Id: <20221017205610.1.I29f6a2189e84e35ad89c1833793dca9e36c64297@changeid>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
In-Reply-To: <20221018035724.2061127-1-briannorris@chromium.org>
References: <20221018035724.2061127-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SDHCI_RESET_ALL resets will reset the hardware CQE state, but we aren't
tracking that properly in software. When out of sync, we may trigger
various timeouts.

It's not typical to perform resets while CQE is enabled, but one
particular case I hit commonly enough: mmc_suspend() -> mmc_power_off().
Typically we will eventually deactivate CQE (cqhci_suspend() ->
cqhci_deactivate()), but that's not guaranteed -- in particular, if
we perform a partial (e.g., interrupted) system suspend.

The same bug was already found and fixed for two other drivers, in v5.7
and v5.9:

5cf583f1fb9c mmc: sdhci-msm: Deactivate CQE during SDHC reset
df57d73276b8 mmc: sdhci-pci: Fix SDHCI_RESET_ALL for CQHCI for Intel GLK-based controllers

The latter is especially prescient, saying "other drivers using CQHCI
might benefit from a similar change, if they also have CQHCI reset by
SDHCI_RESET_ALL."

So like these other patches, deactivate CQHCI when resetting the
controller. Also, move around the DT/caps handling, because
sdhci_setup_host() performs resets before we've initialized CQHCI. This
is the pattern followed in other SDHCI/CQHCI drivers.

Fixes: 84362d79f436 ("mmc: sdhci-of-arasan: Add CQHCI support for arasan,sdhci-5.1")
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---

 drivers/mmc/host/sdhci-of-arasan.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
index 3997cad1f793..1988a703781a 100644
--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -366,6 +366,10 @@ static void sdhci_arasan_reset(struct sdhci_host *host, u8 mask)
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_arasan_data *sdhci_arasan = sdhci_pltfm_priv(pltfm_host);
 
+	if ((host->mmc->caps2 & MMC_CAP2_CQE) && (mask & SDHCI_RESET_ALL) &&
+	    sdhci_arasan->has_cqe)
+		cqhci_deactivate(host->mmc);
+
 	sdhci_reset(host, mask);
 
 	if (sdhci_arasan->quirks & SDHCI_ARASAN_QUIRK_FORCE_CDTEST) {
@@ -1521,7 +1525,8 @@ static int sdhci_arasan_register_sdclk(struct sdhci_arasan_data *sdhci_arasan,
 	return 0;
 }
 
-static int sdhci_arasan_add_host(struct sdhci_arasan_data *sdhci_arasan)
+static int sdhci_arasan_add_host(struct sdhci_arasan_data *sdhci_arasan,
+				 struct device_node *np)
 {
 	struct sdhci_host *host = sdhci_arasan->host;
 	struct cqhci_host *cq_host;
@@ -1549,6 +1554,10 @@ static int sdhci_arasan_add_host(struct sdhci_arasan_data *sdhci_arasan)
 	if (dma64)
 		cq_host->caps |= CQHCI_TASK_DESC_SZ_128;
 
+	host->mmc->caps2 |= MMC_CAP2_CQE;
+	if (!of_property_read_bool(np, "disable-cqe-dcmd"))
+		host->mmc->caps2 |= MMC_CAP2_CQE_DCMD;
+
 	ret = cqhci_init(cq_host, host->mmc, dma64);
 	if (ret)
 		goto cleanup;
@@ -1705,13 +1714,9 @@ static int sdhci_arasan_probe(struct platform_device *pdev)
 		host->mmc_host_ops.start_signal_voltage_switch =
 					sdhci_arasan_voltage_switch;
 		sdhci_arasan->has_cqe = true;
-		host->mmc->caps2 |= MMC_CAP2_CQE;
-
-		if (!of_property_read_bool(np, "disable-cqe-dcmd"))
-			host->mmc->caps2 |= MMC_CAP2_CQE_DCMD;
 	}
 
-	ret = sdhci_arasan_add_host(sdhci_arasan);
+	ret = sdhci_arasan_add_host(sdhci_arasan, np);
 	if (ret)
 		goto err_add_host;
 
-- 
2.38.0.413.g74048e4d9e-goog

