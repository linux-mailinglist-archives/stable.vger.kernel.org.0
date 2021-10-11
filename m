Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6032428FE6
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhJKOC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:02:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238279AbhJKOAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:00:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 493FC60EB4;
        Mon, 11 Oct 2021 13:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960608;
        bh=dkgC5TJpvjrMNpCc7gqjtxKbKWAE5KzEPJGx/qq1bNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2Q9umj9tzv+KxTFJeku5UD3EwcuLLbkN+xiULMHEM5ODY9i3yDoUw/3gNz6B/k29
         LBa+1jVl12ThY7Qj8GllU1AdF65ZnfvQKo8+BOIVck+hEvk5xnDdsqGb9CEgY7eJu+
         s0oGuUjxjjcJLBzagTlXn9fNTioZfyI8iHW3dC/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.14 022/151] mmc: sdhci-of-at91: wait for calibration done before proceed
Date:   Mon, 11 Oct 2021 15:44:54 +0200
Message-Id: <20211011134518.569881128@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

commit af467fad78f03a42de8b72190f6a595366b870db upstream.

Datasheet specifies that at the end of calibration the SDMMC_CALCR_EN
bit will be cleared. No commands should be send before calibration is
done.

Fixes: dbdea70f71d67 ("mmc: sdhci-of-at91: fix CALCR register being rewritten")
Fixes: 727d836a375ad ("mmc: sdhci-of-at91: add DT property to enable calibration on full reset")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210924082851.2132068-2-claudiu.beznea@microchip.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-at91.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/mmc/host/sdhci-of-at91.c
+++ b/drivers/mmc/host/sdhci-of-at91.c
@@ -11,6 +11,7 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/slot-gpio.h>
@@ -114,6 +115,7 @@ static void sdhci_at91_reset(struct sdhc
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_at91_priv *priv = sdhci_pltfm_priv(pltfm_host);
+	unsigned int tmp;
 
 	sdhci_reset(host, mask);
 
@@ -126,6 +128,10 @@ static void sdhci_at91_reset(struct sdhc
 
 		sdhci_writel(host, calcr | SDMMC_CALCR_ALWYSON | SDMMC_CALCR_EN,
 			     SDMMC_CALCR);
+
+		if (read_poll_timeout(sdhci_readl, tmp, !(tmp & SDMMC_CALCR_EN),
+				      10, 20000, false, host, SDMMC_CALCR))
+			dev_err(mmc_dev(host->mmc), "Failed to calibrate\n");
 	}
 }
 


