Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAD326B67A
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgIPAFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726844AbgIOO27 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:28:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30C472223E;
        Tue, 15 Sep 2020 14:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179656;
        bh=DwLkYfmvYqguFFhhJqxU6FsNbRSd9t4OArP9WW2CiEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKqvBc3Ke11VGvpP+YDy581OOAQN97exDw4wnZW5jAO/OZUlP1g+bHwwpqDRpCln1
         nWoOKBMVRGMkylW+kJtIUoAi86UJ8zR2kc+ZrG13CCwJVWSMM7K9S/rRCY0JK+waP9
         hoyKcq25xPnV0IUI4tV1HdThVyiSCsLLYa6eYFEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Veerabhadrarao Badiganti <vbadigan@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/132] mmc: sdhci-msm: Add retries when all tuning phases are found valid
Date:   Tue, 15 Sep 2020 16:12:08 +0200
Message-Id: <20200915140645.407529458@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 9d5dcefb7b114d610aeb2371f6a6f119af316e43 ]

As the comments in this patch say, if we tune and find all phases are
valid it's _almost_ as bad as no phases being found valid.  Probably
all phases are not really reliable but we didn't detect where the
unreliable place is.  That means we'll essentially be guessing and
hoping we get a good phase.

This is not just a problem in theory.  It was causing real problems on
a real board.  On that board, most often phase 10 is found as the only
invalid phase, though sometimes 10 and 11 are invalid and sometimes
just 11.  Some percentage of the time, however, all phases are found
to be valid.  When this happens, the current logic will decide to use
phase 11.  Since phase 11 is sometimes found to be invalid, this is a
bad choice.  Sure enough, when phase 11 is picked we often get mmc
errors later in boot.

I have seen cases where all phases were found to be valid 3 times in a
row, so increase the retry count to 10 just to be extra sure.

Fixes: 415b5a75da43 ("mmc: sdhci-msm: Add platform_execute_tuning implementation")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20200827075809.1.If179abf5ecb67c963494db79c3bc4247d987419b@changeid
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-msm.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 84cffdef264b7..8bed81cf03adc 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1096,7 +1096,7 @@ static void sdhci_msm_set_cdr(struct sdhci_host *host, bool enable)
 static int sdhci_msm_execute_tuning(struct mmc_host *mmc, u32 opcode)
 {
 	struct sdhci_host *host = mmc_priv(mmc);
-	int tuning_seq_cnt = 3;
+	int tuning_seq_cnt = 10;
 	u8 phase, tuned_phases[16], tuned_phase_cnt = 0;
 	int rc;
 	struct mmc_ios ios = host->mmc->ios;
@@ -1152,6 +1152,22 @@ retry:
 	} while (++phase < ARRAY_SIZE(tuned_phases));
 
 	if (tuned_phase_cnt) {
+		if (tuned_phase_cnt == ARRAY_SIZE(tuned_phases)) {
+			/*
+			 * All phases valid is _almost_ as bad as no phases
+			 * valid.  Probably all phases are not really reliable
+			 * but we didn't detect where the unreliable place is.
+			 * That means we'll essentially be guessing and hoping
+			 * we get a good phase.  Better to try a few times.
+			 */
+			dev_dbg(mmc_dev(mmc), "%s: All phases valid; try again\n",
+				mmc_hostname(mmc));
+			if (--tuning_seq_cnt) {
+				tuned_phase_cnt = 0;
+				goto retry;
+			}
+		}
+
 		rc = msm_find_most_appropriate_phase(host, tuned_phases,
 						     tuned_phase_cnt);
 		if (rc < 0)
-- 
2.25.1



