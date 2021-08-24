Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBB23F6559
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239693AbhHXRMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:12:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240185AbhHXRKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:10:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A08861A04;
        Tue, 24 Aug 2021 17:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824435;
        bh=nK5MH3n4nmvDkjpNZ4AgOhZtHVbWau0UkJU48ygO+K8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q7EXujPjiX/2y2XQ0ZXtLfceoA6YIc/dAK8sJt9MvK2EsCqI47ZsS5F3b2h/F8TAG
         moWRYebqIDdoygMAbrodPXH4uuyJRjbulhZPGycLqzRZxUKxlu6sdGAM2Acq16PRK3
         6ZeISeSvjhatQEXc2nhbIO3rOXZuO/aHtInhFRRfAsUdmW1ennXV5LFPi+WugRpKXU
         BkeMNoTE6st/DkZuJr/XDUYI7zbdv3f9UhGXEeWviZgx6aV1MVN3q8AW+UXYxl2rxN
         EAdauafBvHvkghv8U9aLompc/9O48yBWAa73fFWicMk1kG+ys9vj+xPz8p7c1fTM5t
         w2tBFJfEB1nmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 86/98] mmc: sdhci-iproc: Cap min clock frequency on BCM2711
Date:   Tue, 24 Aug 2021 12:58:56 -0400
Message-Id: <20210824165908.709932-87-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenz@kernel.org>

[ Upstream commit c9107dd0b851777d7e134420baf13a5c5343bc16 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-iproc.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mmc/host/sdhci-iproc.c b/drivers/mmc/host/sdhci-iproc.c
index ddeaf8e1f72f..b9eb2ec61a83 100644
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

