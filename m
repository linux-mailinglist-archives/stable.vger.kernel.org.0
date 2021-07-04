Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B5A3BB070
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhGDXI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:08:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231157AbhGDXIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:08:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98B9161283;
        Sun,  4 Jul 2021 23:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439934;
        bh=g9qfdaST5Xg4hE7mjON8bksK/iUulk9ir5gSDX6PlSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=stK+WvIdpe0Iiat6uBMwOAGvASdKTq4SyEoEOxHocMXLRjhbkbZN2JVrUvZDDH3NC
         UYiuxskOsTUZp5xm4pGPURboWVzNuEBMdCey6bi/jipweKi5EbrMln+iAgxCT85Nej
         yNF5D2iRHy+p/W8d3/82E4cgrEkoxscpOYqeRwlQdsEJrU3uZdPH1UceohBawdbst5
         yO90zs9wxgYPlxGTNZ+lKuj5Kl9mZRN28321BWZIvkPcST28fz0dLCgYyQre3IqoZ/
         Sj6VUMKE8ZbIFTtZ7AMC1du4feuwSg0a9W+4VdKPSEhvPKumvQq4s1aTWkJKuU/bqu
         ZhCx3SV3t+/tw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Jeffery <andrew@aj.id.au>, Joel Stanley <joel@jms.id.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-aspeed@lists.ozlabs.org,
        openbmc@lists.ozlabs.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 54/85] mmc: sdhci-of-aspeed: Turn down a phase correction warning
Date:   Sun,  4 Jul 2021 19:03:49 -0400
Message-Id: <20210704230420.1488358-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jeffery <andrew@aj.id.au>

[ Upstream commit a7ab186f60785850b5af1be183867000485ad491 ]

The card timing and the bus frequency are not changed atomically with
respect to calls to the set_clock() callback in the driver. The result
is the driver sees a transient state where there's a mismatch between
the two and thus the inputs to the phase correction calculation
formula are garbage.

Switch from dev_warn() to dev_dbg() to avoid noise in the normal case,
though the change does make bad configurations less likely to be
noticed.

Reported-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20210607013020.85885-1-andrew@aj.id.au
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-aspeed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-of-aspeed.c b/drivers/mmc/host/sdhci-of-aspeed.c
index d001c51074a0..e4665a438ec5 100644
--- a/drivers/mmc/host/sdhci-of-aspeed.c
+++ b/drivers/mmc/host/sdhci-of-aspeed.c
@@ -150,7 +150,7 @@ static int aspeed_sdhci_phase_to_tap(struct device *dev, unsigned long rate_hz,
 
 	tap = div_u64(phase_period_ps, prop_delay_ps);
 	if (tap > ASPEED_SDHCI_NR_TAPS) {
-		dev_warn(dev,
+		dev_dbg(dev,
 			 "Requested out of range phase tap %d for %d degrees of phase compensation at %luHz, clamping to tap %d\n",
 			 tap, phase_deg, rate_hz, ASPEED_SDHCI_NR_TAPS);
 		tap = ASPEED_SDHCI_NR_TAPS;
-- 
2.30.2

