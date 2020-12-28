Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E252E3CB1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437667AbgL1OFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:05:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437662AbgL1OFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:05:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E927206D4;
        Mon, 28 Dec 2020 14:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164324;
        bh=Y7L97WsSKLmGlDzuXevLO3J+b4i+9NqUyQun7aE6UeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fxz7lk8Q6+8V0t8I0jqwQCFb3ZxgcE2fd/iWy/UNDrq1pRq6Otsey5NcXl6EqZ+Fh
         PnERrJxOfVlkGxRQiRJPITHyA9ItPHm0hfrQAyXwXRB5RTXsKR6XNL37k4BUhfP4VA
         ew5ZEyKS86XbpawZInO+rckYZYtICA4r+FIwf5y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/717] mmc: sdhci: tegra: fix wrong unit with busy_timeout
Date:   Mon, 28 Dec 2020 13:42:17 +0100
Message-Id: <20201228125027.617068660@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit fcc541fea394d67ad607ee41acfa891e79fe17a2 ]

'busy_timeout' is in msecs, not in jiffies. Use the correct factor.

Fixes: 5e958e4aacf4 ("sdhci: tegra: Implement Tegra specific set_timeout callback")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Acked-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20201116132206.23518-1-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index ed12aacb1c736..41d193fa77bbf 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -1272,7 +1272,7 @@ static void tegra_sdhci_set_timeout(struct sdhci_host *host,
 	 * busy wait mode.
 	 */
 	val = sdhci_readl(host, SDHCI_TEGRA_VENDOR_MISC_CTRL);
-	if (cmd && cmd->busy_timeout >= 11 * HZ)
+	if (cmd && cmd->busy_timeout >= 11 * MSEC_PER_SEC)
 		val |= SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT;
 	else
 		val &= ~SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT;
-- 
2.27.0



