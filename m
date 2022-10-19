Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2CE603C5D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiJSIqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiJSIo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:44:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C927B78A;
        Wed, 19 Oct 2022 01:43:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCD19B822BE;
        Wed, 19 Oct 2022 08:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4BEC433D6;
        Wed, 19 Oct 2022 08:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168850;
        bh=OQ5+raYgpwxt5gHw9gmhOZpaGz9bNoTbg+XUHADCeTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qtvKdoGJl1iteh8VtgSsBMc+Ct4Rrr21IbG+RUBATX8zO7ZEiC4eZoikmeJzb7Lzd
         CE6bHGcucG0xRkmiTAO6bChVJejDR3owPsYkgN4BuU85Rko2cMDLC/qGWa4kmW9vzZ
         RKMG6DEf9k571Yp+Sz8A2lpHv5AxPHXCdKph3lMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.0 037/862] mmc: renesas_sdhi: Fix rounding errors
Date:   Wed, 19 Oct 2022 10:22:04 +0200
Message-Id: <20221019083251.643994926@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

commit f0c00454bf78975925eccc9737faaa4d4951edbf upstream.

Due to clk rounding errors on RZ/G2L platforms, it selects a clock source
with a lower clock rate compared to a higher one.
For eg: The rounding error (533333333 Hz / 4 * 4 = 533333332 Hz < 5333333
33 Hz) selects a clk source of 400 MHz instead of 533.333333 MHz.

This patch fixes this issue by adding a margin of (1/1024) higher to
the clock rate.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Fixes: bb6d3fa98a41 ("clk: renesas: rcar-gen3: Switch to new SD clock handling")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220928110755.849275-1-biju.das.jz@bp.renesas.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/renesas_sdhi_core.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -128,6 +128,7 @@ static unsigned int renesas_sdhi_clk_upd
 	struct clk *ref_clk = priv->clk;
 	unsigned int freq, diff, best_freq = 0, diff_min = ~0;
 	unsigned int new_clock, clkh_shift = 0;
+	unsigned int new_upper_limit;
 	int i;
 
 	/*
@@ -153,13 +154,20 @@ static unsigned int renesas_sdhi_clk_upd
 	 * greater than, new_clock.  As we can divide by 1 << i for
 	 * any i in [0, 9] we want the input clock to be as close as
 	 * possible, but no greater than, new_clock << i.
+	 *
+	 * Add an upper limit of 1/1024 rate higher to the clock rate to fix
+	 * clk rate jumping to lower rate due to rounding error (eg: RZ/G2L has
+	 * 3 clk sources 533.333333 MHz, 400 MHz and 266.666666 MHz. The request
+	 * for 533.333333 MHz will selects a slower 400 MHz due to rounding
+	 * error (533333333 Hz / 4 * 4 = 533333332 Hz < 533333333 Hz)).
 	 */
 	for (i = min(9, ilog2(UINT_MAX / new_clock)); i >= 0; i--) {
 		freq = clk_round_rate(ref_clk, new_clock << i);
-		if (freq > (new_clock << i)) {
+		new_upper_limit = (new_clock << i) + ((new_clock << i) >> 10);
+		if (freq > new_upper_limit) {
 			/* Too fast; look for a slightly slower option */
 			freq = clk_round_rate(ref_clk, (new_clock << i) / 4 * 3);
-			if (freq > (new_clock << i))
+			if (freq > new_upper_limit)
 				continue;
 		}
 
@@ -181,6 +189,7 @@ static unsigned int renesas_sdhi_clk_upd
 static void renesas_sdhi_set_clock(struct tmio_mmc_host *host,
 				   unsigned int new_clock)
 {
+	unsigned int clk_margin;
 	u32 clk = 0, clock;
 
 	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, ~CLK_CTL_SCLKEN &
@@ -194,7 +203,13 @@ static void renesas_sdhi_set_clock(struc
 	host->mmc->actual_clock = renesas_sdhi_clk_update(host, new_clock);
 	clock = host->mmc->actual_clock / 512;
 
-	for (clk = 0x80000080; new_clock >= (clock << 1); clk >>= 1)
+	/*
+	 * Add a margin of 1/1024 rate higher to the clock rate in order
+	 * to avoid clk variable setting a value of 0 due to the margin
+	 * provided for actual_clock in renesas_sdhi_clk_update().
+	 */
+	clk_margin = new_clock >> 10;
+	for (clk = 0x80000080; new_clock + clk_margin >= (clock << 1); clk >>= 1)
 		clock <<= 1;
 
 	/* 1/1 clock is option */


