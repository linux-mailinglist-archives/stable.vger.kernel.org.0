Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C983F5613
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 04:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbhHXC7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 22:59:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234088AbhHXC6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 22:58:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D40D61184;
        Tue, 24 Aug 2021 02:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629773884;
        bh=GsLBtKM8GIulhflTz4jlqezXmXHzOGox4fKOkWCYwv8=;
        h=From:To:Cc:Subject:Date:From;
        b=mAuhZWOKDzZdd3PbJsF3yMcv9dXRkNTOD5nL5wlKoe6qa69VpEVgqecTFGhlxPBpz
         jpmxBefLjVu/QanTejOTvNmgnvUpsQYhJPKa9d3vq5h5V5gB8T6L+aJasRS/q9qI2V
         DAadGc1UWaa3wTr1CVngUvuBhNDP7VjAxNN3qWVxmmhxJCspCRqHMypZOaAglMyX1M
         uFDXia/Hv9n13K8JV3rzeEIf/h3bOcdsqpaHNPoeqjL9xt+akgXY06X0GypDk+DGBA
         3rNjZzapZv0JB7VaLztCoX+7qVmRJMDfYTmSTcxFMc6nk/fjKP+o7kUDi8VQH0zldZ
         AzjFQVfSmzMOg==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, nsaenz@kernel.org
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: FAILED: Patch "mmc: sdhci-iproc: Cap min clock frequency on BCM2711" failed to apply to 5.4-stable tree
Date:   Mon, 23 Aug 2021 22:58:02 -0400
Message-Id: <20210824025802.658609-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From c9107dd0b851777d7e134420baf13a5c5343bc16 Mon Sep 17 00:00:00 2001
From: Nicolas Saenz Julienne <nsaenz@kernel.org>
Date: Sat, 7 Aug 2021 13:06:35 +0200
Subject: [PATCH] mmc: sdhci-iproc: Cap min clock frequency on BCM2711

There is a known bug on BCM2711's SDHCI core integration where the
controller will hang when the difference between the core clock and the
bus clock is too great. Specifically this can be reproduced under the
following conditions:

- No SD card plugged in, polling thread is running, probing cards at
  100 kHz.
- BCM2711's core clock configured at 500MHz or more.

So set 200 kHz as the minimum clock frequency available for that board.

For more information on the issue see this:
https://lore.kernel.org/linux-mmc/20210322185816.27582-1-nsaenz@kernel.org/T/#m11f2783a09b581da6b8a15f302625b43a6ecdeca

Fixes: f84e411c85be ("mmc: sdhci-iproc: Add support for emmc2 of the BCM2711")
Signed-off-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1628334401-6577-5-git-send-email-stefan.wahren@i2se.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/sdhci-iproc.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mmc/host/sdhci-iproc.c b/drivers/mmc/host/sdhci-iproc.c
index cce390fe9cf3..032bf852397f 100644
--- a/drivers/mmc/host/sdhci-iproc.c
+++ b/drivers/mmc/host/sdhci-iproc.c
@@ -173,6 +173,23 @@ static unsigned int sdhci_iproc_get_max_clock(struct sdhci_host *host)
 		return pltfm_host->clock;
 }
 
+/*
+ * There is a known bug on BCM2711's SDHCI core integration where the
+ * controller will hang when the difference between the core clock and the bus
+ * clock is too great. Specifically this can be reproduced under the following
+ * conditions:
+ *
+ *  - No SD card plugged in, polling thread is running, probing cards at
+ *    100 kHz.
+ *  - BCM2711's core clock configured at 500MHz or more
+ *
+ * So we set 200kHz as the minimum clock frequency available for that SoC.
+ */
+static unsigned int sdhci_iproc_bcm2711_get_min_clock(struct sdhci_host *host)
+{
+	return 200000;
+}
+
 static const struct sdhci_ops sdhci_iproc_ops = {
 	.set_clock = sdhci_set_clock,
 	.get_max_clock = sdhci_iproc_get_max_clock,
@@ -271,6 +288,7 @@ static const struct sdhci_ops sdhci_iproc_bcm2711_ops = {
 	.set_clock = sdhci_set_clock,
 	.set_power = sdhci_set_power_and_bus_voltage,
 	.get_max_clock = sdhci_iproc_get_max_clock,
+	.get_min_clock = sdhci_iproc_bcm2711_get_min_clock,
 	.set_bus_width = sdhci_set_bus_width,
 	.reset = sdhci_reset,
 	.set_uhs_signaling = sdhci_set_uhs_signaling,
-- 
2.30.2




