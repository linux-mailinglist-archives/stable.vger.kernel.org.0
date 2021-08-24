Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BF93F5615
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 04:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbhHXC7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 22:59:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234252AbhHXC6u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 22:58:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 413F1611EF;
        Tue, 24 Aug 2021 02:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629773887;
        bh=3GPkwAvSqeA9j71s1XPhU9PZVq8GRC3CXo4NSfJGBrE=;
        h=From:To:Cc:Subject:Date:From;
        b=cJ/BHt6ovUdcz9F7319nsQYtYJ5M6DSw5OB4d0mCbUYlUz9T2McnJ8isMnZY855JB
         Su980aD86Wq0pEyrwy3CYOlMBXnZxlXiYRtHb8l6NlI88eC8b5AS7QZB4UUuebIuXa
         1T0Om+LXUhhVZrnNuQM83zPSMzyObkmalisQjgsESQOeO3ZCKzi8Rh6umuQYugByrM
         34rIBQ8tWsuqLsaksheFK2HaSoMsnEdhB1PWqheFy/O/b/flAKYT2FEsP2oS6GCDk7
         p/3Tcb3wAT2Qhz6PaWuoQu8pszhCglyBzFb7MY/eqTi6nE42noUXdlOc6xigbdf4ju
         szd4o+TD/g3fA==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, nsaenz@kernel.org
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: FAILED: Patch "mmc: sdhci-iproc: Set SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN on BCM2711" failed to apply to 5.4-stable tree
Date:   Mon, 23 Aug 2021 22:58:04 -0400
Message-Id: <20210824025805.658683-1-sashal@kernel.org>
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

From 419dd626e357e89fc9c4e3863592c8b38cfe1571 Mon Sep 17 00:00:00 2001
From: Nicolas Saenz Julienne <nsaenz@kernel.org>
Date: Sat, 7 Aug 2021 13:06:36 +0200
Subject: [PATCH] mmc: sdhci-iproc: Set SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN on
 BCM2711

The controller doesn't seem to pick-up on clock changes, so set the
SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN flag to query the clock frequency
directly from the clock.

Fixes: f84e411c85be ("mmc: sdhci-iproc: Add support for emmc2 of the BCM2711")
Signed-off-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1628334401-6577-6-git-send-email-stefan.wahren@i2se.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/sdhci-iproc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-iproc.c b/drivers/mmc/host/sdhci-iproc.c
index 032bf852397f..e7565c671998 100644
--- a/drivers/mmc/host/sdhci-iproc.c
+++ b/drivers/mmc/host/sdhci-iproc.c
@@ -295,7 +295,8 @@ static const struct sdhci_ops sdhci_iproc_bcm2711_ops = {
 };
 
 static const struct sdhci_pltfm_data sdhci_bcm2711_pltfm_data = {
-	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
+	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 |
+		  SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
 	.ops = &sdhci_iproc_bcm2711_ops,
 };
 
-- 
2.30.2




