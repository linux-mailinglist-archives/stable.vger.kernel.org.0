Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124AB428F04
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237662AbhJKNyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:54:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237793AbhJKNwr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:52:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36962610CA;
        Mon, 11 Oct 2021 13:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960247;
        bh=Au9gKU7YCwJjew/B4WF1/ekGWTtJL8BgRHuBc/Aa5Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PclHHAzNYtbFMfbtg/hTGua6yIcQ18mAaKMpfQHjmpHuSryr1Zut3V47/gvP6ETNK
         lkwMcLlXj7AdgfUWoeIdIpd8NA7zmGWibmyF0ySdAMpojrd7eOjMP7EP9hpkAMcd4N
         47d4K3zr9/h71cmIVlbmWVJzVQD18uShFoqjErWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 10/83] mmc: sdhci-of-at91: replace while loop with read_poll_timeout
Date:   Mon, 11 Oct 2021 15:45:30 +0200
Message-Id: <20211011134508.708027648@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

commit 30d4b990ec644e8bd49ef0a2f074fabc0d189e53 upstream.

Replace while loop with read_poll_timeout().

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210924082851.2132068-3-claudiu.beznea@microchip.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-at91.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/drivers/mmc/host/sdhci-of-at91.c
+++ b/drivers/mmc/host/sdhci-of-at91.c
@@ -62,7 +62,6 @@ static void sdhci_at91_set_force_card_de
 static void sdhci_at91_set_clock(struct sdhci_host *host, unsigned int clock)
 {
 	u16 clk;
-	unsigned long timeout;
 
 	host->mmc->actual_clock = 0;
 
@@ -87,16 +86,11 @@ static void sdhci_at91_set_clock(struct
 	sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
 
 	/* Wait max 20 ms */
-	timeout = 20;
-	while (!((clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL))
-		& SDHCI_CLOCK_INT_STABLE)) {
-		if (timeout == 0) {
-			pr_err("%s: Internal clock never stabilised.\n",
-			       mmc_hostname(host->mmc));
-			return;
-		}
-		timeout--;
-		mdelay(1);
+	if (read_poll_timeout(sdhci_readw, clk, (clk & SDHCI_CLOCK_INT_STABLE),
+			      1000, 20000, false, host, SDHCI_CLOCK_CONTROL)) {
+		pr_err("%s: Internal clock never stabilised.\n",
+		       mmc_hostname(host->mmc));
+		return;
 	}
 
 	clk |= SDHCI_CLOCK_CARD_EN;


