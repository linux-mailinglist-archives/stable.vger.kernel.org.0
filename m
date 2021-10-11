Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A883428FE7
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238264AbhJKOC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:02:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237351AbhJKOAe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:00:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB67A61108;
        Mon, 11 Oct 2021 13:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960612;
        bh=Au9gKU7YCwJjew/B4WF1/ekGWTtJL8BgRHuBc/Aa5Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1xhwjg3PoplC+DS/vM9pPFlrlVciatKWpc7WO7ZO4qcdvd0knSllDbqR1ozRrVjy
         LgPL9+aRg+atPYPQaRxjlQfPPGgk8pLXXomk/oT51eSogWuoS2qhTS2CxiyeQ0xMiJ
         uLk0jwEp2cKGeaYywHLc0+Hrsjrfd1R8zhcTBguM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.14 023/151] mmc: sdhci-of-at91: replace while loop with read_poll_timeout
Date:   Mon, 11 Oct 2021 15:44:55 +0200
Message-Id: <20211011134518.600045992@linuxfoundation.org>
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


