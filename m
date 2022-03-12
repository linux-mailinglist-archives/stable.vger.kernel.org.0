Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7FA4D6E4E
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 12:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiCLLFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 06:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiCLLFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 06:05:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1BC20D53A
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 03:04:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7830BB82E30
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 11:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF631C340EB;
        Sat, 12 Mar 2022 11:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647083081;
        bh=0DCUjPPZpes9skSGQRMPsHsWI2iCTPCEWlHqrQyzKM0=;
        h=Subject:To:Cc:From:Date:From;
        b=XfCq4m0Szcz4/zJx2ye3US3rFZkE9C6W5xrdZh3y2Tjt1/gPFGXNbTfMr4cBDhhRA
         behY/PwFgJc702g+K1niq5QkOJcDN/RzdGaVfeFgUav584H0bN6tT/+373zZycpmxu
         Ht667fqEI0WPQ9MlGlq26cogvnQHkbKzXKP7JyjU=
Subject: FAILED: patch "[PATCH] mmc: meson: Fix usage of meson_mmc_post_req()" failed to apply to 4.14-stable tree
To:     rong.chen@amlogic.com, khilman@baylibre.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 12 Mar 2022 12:04:30 +0100
Message-ID: <16470830702060@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f0d2f15362f02444c5d7ffd5a5eb03e4aa54b685 Mon Sep 17 00:00:00 2001
From: Rong Chen <rong.chen@amlogic.com>
Date: Wed, 16 Feb 2022 20:42:39 +0800
Subject: [PATCH] mmc: meson: Fix usage of meson_mmc_post_req()

Currently meson_mmc_post_req() is called in meson_mmc_request() right
after meson_mmc_start_cmd(). This could lead to DMA unmapping before the request
is actually finished.

To fix, don't call meson_mmc_post_req() until meson_mmc_request_done().

Signed-off-by: Rong Chen <rong.chen@amlogic.com>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Fixes: 79ed05e329c3 ("mmc: meson-gx: add support for descriptor chain mode")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220216124239.4007667-1-rong.chen@amlogic.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/meson-gx-mmc.c b/drivers/mmc/host/meson-gx-mmc.c
index 8f36536cb1b6..58ab9d90bc8b 100644
--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -173,6 +173,8 @@ struct meson_host {
 	int irq;
 
 	bool vqmmc_enabled;
+	bool needs_pre_post_req;
+
 };
 
 #define CMD_CFG_LENGTH_MASK GENMASK(8, 0)
@@ -663,6 +665,8 @@ static void meson_mmc_request_done(struct mmc_host *mmc,
 	struct meson_host *host = mmc_priv(mmc);
 
 	host->cmd = NULL;
+	if (host->needs_pre_post_req)
+		meson_mmc_post_req(mmc, mrq, 0);
 	mmc_request_done(host->mmc, mrq);
 }
 
@@ -880,7 +884,7 @@ static int meson_mmc_validate_dram_access(struct mmc_host *mmc, struct mmc_data
 static void meson_mmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 {
 	struct meson_host *host = mmc_priv(mmc);
-	bool needs_pre_post_req = mrq->data &&
+	host->needs_pre_post_req = mrq->data &&
 			!(mrq->data->host_cookie & SD_EMMC_PRE_REQ_DONE);
 
 	/*
@@ -896,22 +900,19 @@ static void meson_mmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 		}
 	}
 
-	if (needs_pre_post_req) {
+	if (host->needs_pre_post_req) {
 		meson_mmc_get_transfer_mode(mmc, mrq);
 		if (!meson_mmc_desc_chain_mode(mrq->data))
-			needs_pre_post_req = false;
+			host->needs_pre_post_req = false;
 	}
 
-	if (needs_pre_post_req)
+	if (host->needs_pre_post_req)
 		meson_mmc_pre_req(mmc, mrq);
 
 	/* Stop execution */
 	writel(0, host->regs + SD_EMMC_START);
 
 	meson_mmc_start_cmd(mmc, mrq->sbc ?: mrq->cmd);
-
-	if (needs_pre_post_req)
-		meson_mmc_post_req(mmc, mrq, 0);
 }
 
 static void meson_mmc_read_resp(struct mmc_host *mmc, struct mmc_command *cmd)

