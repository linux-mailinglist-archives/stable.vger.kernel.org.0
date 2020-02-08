Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D196D1565E0
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgBHS3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:29:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34538 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727934AbgBHS3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:48 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrN-0003iN-Uq; Sat, 08 Feb 2020 18:29:42 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrN-000CXc-Ct; Sat, 08 Feb 2020 18:29:41 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ulf Hansson" <ulf.hansson@linaro.org>,
        "Mark Brown" <broonie@linaro.org>,
        "Jaehoon Chung" <jh80.chung@samsung.com>
Date:   Sat, 08 Feb 2020 18:21:25 +0000
Message-ID: <lsq.1581185941.711632559@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 146/148] mmc: sdhci-s3c: Check if clk_set_rate() succeeds
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@linaro.org>

commit cd0cfdd2485e6252b3c69284bf09d06c4d303116 upstream.

It is possible that we may fail to set the clock rate, if we do so then
log the failure and don't bother reprogramming the IP.

Signed-off-by: Mark Brown <broonie@linaro.org>
Acked-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mmc/host/sdhci-s3c.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -300,6 +300,7 @@ static void sdhci_cmu_set_clock(struct s
 	struct device *dev = &ourhost->pdev->dev;
 	unsigned long timeout;
 	u16 clk = 0;
+	int ret;
 
 	host->mmc->actual_clock = 0;
 
@@ -311,7 +312,12 @@ static void sdhci_cmu_set_clock(struct s
 
 	sdhci_s3c_set_clock(host, clock);
 
-	clk_set_rate(ourhost->clk_bus[ourhost->cur_clk], clock);
+	ret = clk_set_rate(ourhost->clk_bus[ourhost->cur_clk], clock);
+	if (ret != 0) {
+		dev_err(dev, "%s: failed to set clock rate %uHz\n",
+			mmc_hostname(host->mmc), clock);
+		return;
+	}
 
 	clk = SDHCI_CLOCK_INT_EN;
 	sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);

