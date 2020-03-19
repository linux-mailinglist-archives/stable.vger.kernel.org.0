Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3852B18B702
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbgCSNUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:20:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727954AbgCSNUN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:20:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40906206D7;
        Thu, 19 Mar 2020 13:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624012;
        bh=tYvsypGV+UX3w5mfR+9EKdJVP9kjPgrchcygUqtHAF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EGiFKwjOuG6Fs8M2wG417JkiW1V1LjvEIJRtV6AyO7ut0Y8eN2w6HZuibP7DFBelK
         nZ6KscVyNyLsq1lmxm+eeZ+0RmDdvzEYIiQOWmSDg8jnUF8JcoeBD6ERhr6k9jeMvR
         MrXUqTL5C731cQU7SJVvVAf8V6Snh+hUgtZObVyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/48] mmc: sdhci-omap: Add platform specific reset callback
Date:   Thu, 19 Mar 2020 14:03:45 +0100
Message-Id: <20200319123904.177477126@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123902.941451241@linuxfoundation.org>
References: <20200319123902.941451241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

[ Upstream commit 5b0d62108b468b13410533c0ceea3821942bf592 ]

The TRM (SPRUIC2C - January 2017 - Revised May 2018 [1]) forbids
assertion of data reset while tuning is happening. Implement a
platform specific callback that takes care of this condition.

[1] http://www.ti.com/lit/pdf/spruic2 Section 25.5.1.2.4

Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-omap.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-omap.c b/drivers/mmc/host/sdhci-omap.c
index d02f5cf76b3d1..8a172575bb64f 100644
--- a/drivers/mmc/host/sdhci-omap.c
+++ b/drivers/mmc/host/sdhci-omap.c
@@ -115,6 +115,7 @@ struct sdhci_omap_host {
 
 	struct pinctrl		*pinctrl;
 	struct pinctrl_state	**pinctrl_state;
+	bool			is_tuning;
 };
 
 static void sdhci_omap_start_clock(struct sdhci_omap_host *omap_host);
@@ -326,6 +327,8 @@ static int sdhci_omap_execute_tuning(struct mmc_host *mmc, u32 opcode)
 		dcrc_was_enabled = true;
 	}
 
+	omap_host->is_tuning = true;
+
 	while (phase_delay <= MAX_PHASE_DELAY) {
 		sdhci_omap_set_dll(omap_host, phase_delay);
 
@@ -363,9 +366,12 @@ static int sdhci_omap_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	phase_delay = max_window + 4 * (max_len >> 1);
 	sdhci_omap_set_dll(omap_host, phase_delay);
 
+	omap_host->is_tuning = false;
+
 	goto ret;
 
 tuning_error:
+	omap_host->is_tuning = false;
 	dev_err(dev, "Tuning failed\n");
 	sdhci_omap_disable_tuning(omap_host);
 
@@ -695,6 +701,18 @@ static void sdhci_omap_set_uhs_signaling(struct sdhci_host *host,
 	sdhci_omap_start_clock(omap_host);
 }
 
+void sdhci_omap_reset(struct sdhci_host *host, u8 mask)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_omap_host *omap_host = sdhci_pltfm_priv(pltfm_host);
+
+	/* Don't reset data lines during tuning operation */
+	if (omap_host->is_tuning)
+		mask &= ~SDHCI_RESET_DATA;
+
+	sdhci_reset(host, mask);
+}
+
 static struct sdhci_ops sdhci_omap_ops = {
 	.set_clock = sdhci_omap_set_clock,
 	.set_power = sdhci_omap_set_power,
@@ -703,7 +721,7 @@ static struct sdhci_ops sdhci_omap_ops = {
 	.get_min_clock = sdhci_omap_get_min_clock,
 	.set_bus_width = sdhci_omap_set_bus_width,
 	.platform_send_init_74_clocks = sdhci_omap_init_74_clocks,
-	.reset = sdhci_reset,
+	.reset = sdhci_omap_reset,
 	.set_uhs_signaling = sdhci_omap_set_uhs_signaling,
 };
 
-- 
2.20.1



