Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB04B605250
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 23:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbiJSVzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 17:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiJSVzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 17:55:15 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764CA12B360
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 14:55:04 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso1677346pjq.1
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 14:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wM2IDLgue12Ad+DXG6n65QaMf2Usako+kvEgT4ayRuw=;
        b=P9xh6e4apUo13+Bt+rHIp6EuqJMIiUwXM/U5iOlFltsDzYC4M2zMfANe3ac58Df+ky
         UYxhWgd939/1ubf4zs5WLE0o2W9F3CORrm8/JKY4Or2z15NzJ0BGgH+C6pR3U37vL1UK
         /KY+ka3bAw4D0/6GDa+0iz80u3IAPzKerGtKQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wM2IDLgue12Ad+DXG6n65QaMf2Usako+kvEgT4ayRuw=;
        b=TBNem6a6mYuB4Mm9C48Gy7OscwxCmIbA5103KPeaOBxlfO/gDCvJS1LxLQr6gIVMXs
         PYtndO6Yv3dQrFU14mzR5mocjEnJrssfO4rwQVKnZpVUeumkWvVgIw9RymT0lMxzS0S/
         o+uey+8XqpEk5mcWLW//1G9Byb7UoQ7oAmL5nAhOUx7FG10C5YxXu7eLtzu8BDA6TdS2
         tthSxhsBoONOJiJymc34OVllPoM1h1XJwNyOtcJQH2FjI7BKHNXI8kTKzHyYw1ltZ0+3
         bpwPOyB3C2SY+7CiKz3IiACbhFsgAhH8d7HRLwU1BOZ1DcMi9y5aPRvD3lc8UqCdm4Bj
         PIiQ==
X-Gm-Message-State: ACrzQf1CYJF4kzhR++kfjUwjh5ibvkDesxyvg8WLdv6xWmxEioR/ZD41
        WL6lLQoPGYS/wFFpoYSwNVVFhA==
X-Google-Smtp-Source: AMsMyM7vUE8Fp5kcHD6AC+bhdyPVFMm4OFEH49dApU6rqHJa/RST4C6r/WJjKQp+vLJkH2kqDi+mFw==
X-Received: by 2002:a17:902:b402:b0:179:e5b0:96d3 with SMTP id x2-20020a170902b40200b00179e5b096d3mr10441531plr.142.1666216503892;
        Wed, 19 Oct 2022 14:55:03 -0700 (PDT)
Received: from localhost ([2620:15c:9d:2:57b7:1f0e:44d1:f252])
        by smtp.gmail.com with UTF8SMTPSA id z28-20020aa7949c000000b0052d4b0d0c74sm11831033pfk.70.2022.10.19.14.55.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 14:55:03 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Shawn Lin <shawn.lin@rock-chips.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Faiz Abbas <faiz_abbas@ti.com>, linux-mmc@vger.kernel.org,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Al Cooper <alcooperx@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v2 2/7] mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for CQHCI
Date:   Wed, 19 Oct 2022 14:54:35 -0700
Message-Id: <20221019145246.v2.2.I29f6a2189e84e35ad89c1833793dca9e36c64297@changeid>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
In-Reply-To: <20221019215440.277643-1-briannorris@chromium.org>
References: <20221019215440.277643-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
controller.

Fixes: 84362d79f436 ("mmc: sdhci-of-arasan: Add CQHCI support for arasan,sdhci-5.1")
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---

Changes in v2:
 - Rely on cqhci_deactivate() to safely handle (ignore)
   not-yet-initialized CQE support

 drivers/mmc/host/sdhci-of-arasan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
index 3997cad1f793..b30f0d6baf5b 100644
--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -366,6 +366,9 @@ static void sdhci_arasan_reset(struct sdhci_host *host, u8 mask)
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_arasan_data *sdhci_arasan = sdhci_pltfm_priv(pltfm_host);
 
+	if ((host->mmc->caps2 & MMC_CAP2_CQE) && (mask & SDHCI_RESET_ALL))
+		cqhci_deactivate(host->mmc);
+
 	sdhci_reset(host, mask);
 
 	if (sdhci_arasan->quirks & SDHCI_ARASAN_QUIRK_FORCE_CDTEST) {
-- 
2.38.0.413.g74048e4d9e-goog

