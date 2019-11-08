Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0366F466A
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389897AbfKHLmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:42:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:56092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389879AbfKHLmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:42:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2780E21D6C;
        Fri,  8 Nov 2019 11:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213336;
        bh=ZBUarJcRbt5B3LCR0U1Unw1x/sHcp5/3339eiUcDDvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLnciQXqj2MnlxBh3wwb6Ve4lyM+PV+lxtjDr2JtVyWFmckniNJ6j9n/dH2XUytMf
         Wp+ufd5pmK1sivie5bME+HdogJlRn/uW0kSpheYDaTGUHWlipVG7VvJBAjsWecKcsB
         3wXLXUCQiaauPmiy4ZMVhhWRrRn11qw7gWADb/io=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 174/205] soc: qcom: geni: Don't ignore clk_round_rate() errors in geni_se_clk_tbl_get()
Date:   Fri,  8 Nov 2019 06:37:21 -0500
Message-Id: <20191108113752.12502-174-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit e11bbcedecae85ce60a5d99ea03528c2d6f867e0 ]

The function clk_round_rate() is defined to return a "long", not an
"unsigned long".  That's because it might return a negative error
code.  Change the call in geni_se_clk_tbl_get() to check for errors.

While we're at it, get rid of a useless init of "freq".

NOTE: overall the idea that we should iterate over clk_round_rate() to
try to reconstruct a table already present in the clock driver is
questionable.  Specifically:
- This method relies on "clk_round_rate()" rounding up.
- This method only works if the table is sorted and has no duplicates.
...this patch doesn't try to fix those problems, it just makes the
error handling more correct.

Fixes: eddac5af0654 ("soc: qcom: Add GENI based QUP Wrapper driver")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom-geni-se.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/qcom-geni-se.c b/drivers/soc/qcom/qcom-geni-se.c
index feed3db21c108..1b19b8428c4ac 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -513,7 +513,7 @@ EXPORT_SYMBOL(geni_se_resources_on);
  */
 int geni_se_clk_tbl_get(struct geni_se *se, unsigned long **tbl)
 {
-	unsigned long freq = 0;
+	long freq = 0;
 	int i;
 
 	if (se->clk_perf_tbl) {
@@ -529,7 +529,7 @@ int geni_se_clk_tbl_get(struct geni_se *se, unsigned long **tbl)
 
 	for (i = 0; i < MAX_CLK_PERF_LEVEL; i++) {
 		freq = clk_round_rate(se->clk, freq + 1);
-		if (!freq || freq == se->clk_perf_tbl[i - 1])
+		if (freq <= 0 || freq == se->clk_perf_tbl[i - 1])
 			break;
 		se->clk_perf_tbl[i] = freq;
 	}
-- 
2.20.1

