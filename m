Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856864D8383
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240934AbiCNMQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241156AbiCNMOs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:14:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A48C3ED1B;
        Mon, 14 Mar 2022 05:11:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FDE1612FC;
        Mon, 14 Mar 2022 12:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FE8C340EC;
        Mon, 14 Mar 2022 12:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259892;
        bh=Wsxqznz+IquJ0SiSvvBnpxlHeNi7tUeAdIQmNX7KyFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlI6bVD4C1pN5MlJJkUCrlE1DgmH0khNpNGtLgA8o7wuPnfcZY5TspMHQ1gfhKq1d
         OaQqyXDTwhTwCr1yUdHYLNegP6Q1+y7XV8jQrAbt1y2/yQZxcMitEaN1ICzXbgb+Sm
         +ro6RGqhIOX2IlFGInH6qyLXjoOIw4ew1UBbiWh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rong Chen <rong.chen@amlogic.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 081/110] mmc: meson: Fix usage of meson_mmc_post_req()
Date:   Mon, 14 Mar 2022 12:54:23 +0100
Message-Id: <20220314112745.291836765@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rong Chen <rong.chen@amlogic.com>

commit f0d2f15362f02444c5d7ffd5a5eb03e4aa54b685 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -173,6 +173,8 @@ struct meson_host {
 	int irq;
 
 	bool vqmmc_enabled;
+	bool needs_pre_post_req;
+
 };
 
 #define CMD_CFG_LENGTH_MASK GENMASK(8, 0)
@@ -663,6 +665,8 @@ static void meson_mmc_request_done(struc
 	struct meson_host *host = mmc_priv(mmc);
 
 	host->cmd = NULL;
+	if (host->needs_pre_post_req)
+		meson_mmc_post_req(mmc, mrq, 0);
 	mmc_request_done(host->mmc, mrq);
 }
 
@@ -880,7 +884,7 @@ static int meson_mmc_validate_dram_acces
 static void meson_mmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 {
 	struct meson_host *host = mmc_priv(mmc);
-	bool needs_pre_post_req = mrq->data &&
+	host->needs_pre_post_req = mrq->data &&
 			!(mrq->data->host_cookie & SD_EMMC_PRE_REQ_DONE);
 
 	/*
@@ -896,22 +900,19 @@ static void meson_mmc_request(struct mmc
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


