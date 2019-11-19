Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84804101454
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbfKSFcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:32:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729445AbfKSFcq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:32:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51B36222A2;
        Tue, 19 Nov 2019 05:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141565;
        bh=ZBUarJcRbt5B3LCR0U1Unw1x/sHcp5/3339eiUcDDvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwhbDPgeo6T2hLMdPhnjkQCgKG78Lx+/BUqcI7tMpaycTs9gVOrCESNze8AVUUYjg
         3NcqK6tRXYsLY8TeVeB7Hb9kr53qgEei03ggKDov3L47UusCt8L37nvG3DQk7L0Q5a
         vI6XWs4n54m4a5rAVj90OBivoieh6i/ZV0uzvFHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 204/422] soc: qcom: geni: Dont ignore clk_round_rate() errors in geni_se_clk_tbl_get()
Date:   Tue, 19 Nov 2019 06:16:41 +0100
Message-Id: <20191119051411.801774598@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



