Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D901B7FC6
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 22:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbgDXUHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 16:07:05 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3488 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729434AbgDXUGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 16:06:55 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ea346690000>; Fri, 24 Apr 2020 13:04:57 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 24 Apr 2020 13:06:55 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 24 Apr 2020 13:06:55 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 24 Apr
 2020 20:06:55 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 24 Apr 2020 20:06:55 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.165.152]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ea346de0002>; Fri, 24 Apr 2020 13:06:55 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <baolin.wang@linaro.org>, <kstewart@linuxfoundation.org>,
        <tglx@linutronix.de>, <bradleybolen@gmail.com>,
        <gregkh@linuxfoundation.org>, <thierry.reding@gmail.com>,
        <jonathanh@nvidia.com>, <skomatineni@nvidia.com>
CC:     <anrao@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH 4.19.113 1/3] mmc: sdhci: Refactor sdhci_set_timeout()
Date:   Fri, 24 Apr 2020 13:06:50 -0700
Message-ID: <1587758812-3331-2-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587758812-3331-1-git-send-email-skomatineni@nvidia.com>
References: <1587758812-3331-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1587758697; bh=YC4YvFj7wnCG+fm55jVe+LTRiqbi7dfas2ZLEtr2Hq4=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=ZzIXx+YWvfiWV+jUp5tq7K0sjejuIiq9dRrl22PFEHjtqCsuH9wOxfu9cJl6ux5TK
         qYH7zDeUahxrnl7F+4g1EvflxA7IEGNmZe7FkSTmm7TMoQsvqYa7TsnQ0zt928Vbzw
         6Vttz2V5csvDWAaFuVcw1Sn5GTlLuH9Pd0Cz5d9ny8crtrxAS1TIcEIFpCQjyKCv19
         sySfYH5dEYlXLjyZAhTEguUi0hp636LUeL8khr/cJzYrRo/7tbo99qyfw/L6EW+j+X
         4rFFnGN+xrbXWxwBy9jQWqDO1I4vdsH3CYv4eoziOQ9tT09+eo+U/HGHjxRJb2Tv81
         d0bJXJKQ6PZdg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 7d76ed77cfbd ("mmc: sdhci: Refactor sdhci_set_timeout()")

Refactor sdhci_set_timeout() such that platform drivers can do some
functionality in a set_timeout() callback and then call
__sdhci_set_timeout() to complete the operation.

Cc: <stable@vger.kernel.org>
Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
---
 drivers/mmc/host/sdhci.c | 38 ++++++++++++++++++++------------------
 drivers/mmc/host/sdhci.h |  1 +
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 5a7fd89..c941e81 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -860,27 +860,29 @@ static void sdhci_set_data_timeout_irq(struct sdhci_host *host, bool enable)
 	sdhci_writel(host, host->ier, SDHCI_SIGNAL_ENABLE);
 }
 
-static void sdhci_set_timeout(struct sdhci_host *host, struct mmc_command *cmd)
+void __sdhci_set_timeout(struct sdhci_host *host, struct mmc_command *cmd)
 {
-	u8 count;
-
-	if (host->ops->set_timeout) {
-		host->ops->set_timeout(host, cmd);
-	} else {
-		bool too_big = false;
-
-		count = sdhci_calc_timeout(host, cmd, &too_big);
+	bool too_big = false;
+	u8 count = sdhci_calc_timeout(host, cmd, &too_big);
+
+	if (too_big &&
+	    host->quirks2 & SDHCI_QUIRK2_DISABLE_HW_TIMEOUT) {
+		sdhci_calc_sw_timeout(host, cmd);
+		sdhci_set_data_timeout_irq(host, false);
+	} else if (!(host->ier & SDHCI_INT_DATA_TIMEOUT)) {
+		sdhci_set_data_timeout_irq(host, true);
+	}
 
-		if (too_big &&
-		    host->quirks2 & SDHCI_QUIRK2_DISABLE_HW_TIMEOUT) {
-			sdhci_calc_sw_timeout(host, cmd);
-			sdhci_set_data_timeout_irq(host, false);
-		} else if (!(host->ier & SDHCI_INT_DATA_TIMEOUT)) {
-			sdhci_set_data_timeout_irq(host, true);
-		}
+	sdhci_writeb(host, count, SDHCI_TIMEOUT_CONTROL);
+}
+EXPORT_SYMBOL_GPL(__sdhci_set_timeout);
 
-		sdhci_writeb(host, count, SDHCI_TIMEOUT_CONTROL);
-	}
+static void sdhci_set_timeout(struct sdhci_host *host, struct mmc_command *cmd)
+{
+	if (host->ops->set_timeout)
+		host->ops->set_timeout(host, cmd);
+	else
+		__sdhci_set_timeout(host, cmd);
 }
 
 static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_command *cmd)
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index c0372e3..15ef9c6 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -759,5 +759,6 @@ void sdhci_start_tuning(struct sdhci_host *host);
 void sdhci_end_tuning(struct sdhci_host *host);
 void sdhci_reset_tuning(struct sdhci_host *host);
 void sdhci_send_tuning(struct sdhci_host *host, u32 opcode);
+void __sdhci_set_timeout(struct sdhci_host *host, struct mmc_command *cmd);
 
 #endif /* __SDHCI_HW_H */
-- 
2.7.4

