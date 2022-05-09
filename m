Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B55A51F6FF
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 10:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237356AbiEIIqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 04:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237384AbiEII2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 04:28:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320311E15E6
        for <stable@vger.kernel.org>; Mon,  9 May 2022 01:24:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA40EB8106C
        for <stable@vger.kernel.org>; Mon,  9 May 2022 08:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE68C385A8;
        Mon,  9 May 2022 08:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652084683;
        bh=BxGhyD+SqW8WSH+MurVGuQkoPV8Nt92UID9atCSMwiA=;
        h=Subject:To:Cc:From:Date:From;
        b=xsunsxQR7OTgujCZhaIqH6MPKMiPsQsAovSlmERMLXvFQtGlSlIfcelZNpJSbWAj8
         jjIZWpUyzic/HiXgjQKw8VLGDnoqWG8I8PBDYOqqVu9IHwzcm890FC8aKmYvlFEs6X
         mzi4CHYe4w0BS/GQWB5rptHj5dfWlWzSQu2b5alI=
Subject: FAILED: patch "[PATCH] mmc: core: Set HS clock speed before sending HS CMD13" failed to apply to 4.19-stable tree
To:     briannorris@chromium.org, luca@z3ntu.xyz, shawn.lin@rock-chips.com,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 10:24:38 +0200
Message-ID: <165208467826147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4bc31edebde51fcf8ad0794763b8679a7ecb5ec0 Mon Sep 17 00:00:00 2001
From: Brian Norris <briannorris@chromium.org>
Date: Fri, 22 Apr 2022 10:08:53 -0700
Subject: [PATCH] mmc: core: Set HS clock speed before sending HS CMD13

Way back in commit 4f25580fb84d ("mmc: core: changes frequency to
hs_max_dtr when selecting hs400es"), Rockchip engineers noticed that
some eMMC don't respond to SEND_STATUS commands very reliably if they're
still running at a low initial frequency. As mentioned in that commit,
JESD84-B51 P49 suggests a sequence in which the host:
1. sets HS_TIMING
2. bumps the clock ("<= 52 MHz")
3. sends further commands

It doesn't exactly require that we don't use a lower-than-52MHz
frequency, but in practice, these eMMC don't like it.

The aforementioned commit tried to get that right for HS400ES, although
it's unclear whether this ever truly worked as committed into mainline,
as other changes/refactoring adjusted the sequence in conflicting ways:

08573eaf1a70 ("mmc: mmc: do not use CMD13 to get status after speed mode
switch")

53e60650f74e ("mmc: core: Allow CMD13 polling when switching to HS mode
for mmc")

In any case, today we do step 3 before step 2. Let's fix that, and also
apply the same logic to HS200/400, where this eMMC has problems too.

Resolves errors like this seen when booting some RK3399 Gru/Scarlet
systems:

[    2.058881] mmc1: CQHCI version 5.10
[    2.097545] mmc1: SDHCI controller on fe330000.mmc [fe330000.mmc] using ADMA
[    2.209804] mmc1: mmc_select_hs400es failed, error -84
[    2.215597] mmc1: error -84 whilst initialising MMC card
[    2.417514] mmc1: mmc_select_hs400es failed, error -110
[    2.423373] mmc1: error -110 whilst initialising MMC card
[    2.605052] mmc1: mmc_select_hs400es failed, error -110
[    2.617944] mmc1: error -110 whilst initialising MMC card
[    2.835884] mmc1: mmc_select_hs400es failed, error -110
[    2.841751] mmc1: error -110 whilst initialising MMC card

Ealier versions of this patch bumped to 200MHz/HS200 speeds too early,
which caused issues on, e.g., qcom-msm8974-fairphone-fp2. (Thanks for
the report Luca!) After a second look, it appears that aligns with
JESD84 / page 45 / table 28, so we need to keep to lower (HS / 52 MHz)
rates first.

Fixes: 08573eaf1a70 ("mmc: mmc: do not use CMD13 to get status after speed mode switch")
Fixes: 53e60650f74e ("mmc: core: Allow CMD13 polling when switching to HS mode for mmc")
Fixes: 4f25580fb84d ("mmc: core: changes frequency to hs_max_dtr when selecting hs400es")
Cc: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://lore.kernel.org/linux-mmc/11962455.O9o76ZdvQC@g550jk/
Reported-by: Luca Weiss <luca@z3ntu.xyz>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Tested-by: Luca Weiss <luca@z3ntu.xyz>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220422100824.v4.1.I484f4ee35609f78b932bd50feed639c29e64997e@changeid
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index e7ea45386c22..efa95dc4fc4e 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -1384,13 +1384,17 @@ static int mmc_select_hs400es(struct mmc_card *card)
 		goto out_err;
 	}
 
+	/*
+	 * Bump to HS timing and frequency. Some cards don't handle
+	 * SEND_STATUS reliably at the initial frequency.
+	 */
 	mmc_set_timing(host, MMC_TIMING_MMC_HS);
+	mmc_set_bus_speed(card);
+
 	err = mmc_switch_status(card, true);
 	if (err)
 		goto out_err;
 
-	mmc_set_clock(host, card->ext_csd.hs_max_dtr);
-
 	/* Switch card to DDR with strobe bit */
 	val = EXT_CSD_DDR_BUS_WIDTH_8 | EXT_CSD_BUS_WIDTH_STROBE;
 	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
@@ -1448,7 +1452,7 @@ static int mmc_select_hs400es(struct mmc_card *card)
 static int mmc_select_hs200(struct mmc_card *card)
 {
 	struct mmc_host *host = card->host;
-	unsigned int old_timing, old_signal_voltage;
+	unsigned int old_timing, old_signal_voltage, old_clock;
 	int err = -EINVAL;
 	u8 val;
 
@@ -1479,8 +1483,17 @@ static int mmc_select_hs200(struct mmc_card *card)
 				   false, true, MMC_CMD_RETRIES);
 		if (err)
 			goto err;
+
+		/*
+		 * Bump to HS timing and frequency. Some cards don't handle
+		 * SEND_STATUS reliably at the initial frequency.
+		 * NB: We can't move to full (HS200) speeds until after we've
+		 * successfully switched over.
+		 */
 		old_timing = host->ios.timing;
+		old_clock = host->ios.clock;
 		mmc_set_timing(host, MMC_TIMING_MMC_HS200);
+		mmc_set_clock(card->host, card->ext_csd.hs_max_dtr);
 
 		/*
 		 * For HS200, CRC errors are not a reliable way to know the
@@ -1493,8 +1506,10 @@ static int mmc_select_hs200(struct mmc_card *card)
 		 * mmc_select_timing() assumes timing has not changed if
 		 * it is a switch error.
 		 */
-		if (err == -EBADMSG)
+		if (err == -EBADMSG) {
+			mmc_set_clock(host, old_clock);
 			mmc_set_timing(host, old_timing);
+		}
 	}
 err:
 	if (err) {

