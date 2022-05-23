Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC26531B95
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239933AbiEWRRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240085AbiEWROn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:14:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF20DEBF;
        Mon, 23 May 2022 10:12:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DC63B811F6;
        Mon, 23 May 2022 17:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9820C385AA;
        Mon, 23 May 2022 17:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325953;
        bh=0bHuKlaZyD4pTHB6Ty/v9KNYAtL/A59eG8fgVGdQav4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H67gd2QqLOy/zoVHP6UqEWGPKGFTY3XZmzR+Aq3MOWofr+Q6+ELEhVaoBM4yhgum6
         BTPoNPORnAmsNBvJKYJvfkbCJaFtY+dx8gFIo812eUr0YjvoMHVmxf6RNJovSh/7b1
         vefUFlcnZWB8Wft+4JnHy9+FzTcxMM2Os9yVFjd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.4 21/68] mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()
Date:   Mon, 23 May 2022 19:04:48 +0200
Message-Id: <20220523165806.139716938@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
References: <20220523165802.500642349@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 533a6cfe08f96a7b5c65e06d20916d552c11b256 upstream

All callers of __mmc_switch() should now be specifying a valid timeout for
the CMD6 command. However, just to be sure, let's print a warning and
default to use the generic_cmd6_time in case the provided timeout_ms
argument is zero.

In this context, let's also simplify some of the corresponding code and
clarify some related comments.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20200122142747.5690-4-ulf.hansson@linaro.org
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/mmc_ops.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -460,10 +460,6 @@ static int mmc_poll_for_busy(struct mmc_
 	bool expired = false;
 	bool busy = false;
 
-	/* We have an unspecified cmd timeout, use the fallback value. */
-	if (!timeout_ms)
-		timeout_ms = MMC_OPS_TIMEOUT_MS;
-
 	/*
 	 * In cases when not allowed to poll by using CMD13 or because we aren't
 	 * capable of polling by using ->card_busy(), then rely on waiting the
@@ -536,6 +532,12 @@ int __mmc_switch(struct mmc_card *card,
 
 	mmc_retune_hold(host);
 
+	if (!timeout_ms) {
+		pr_warn("%s: unspecified timeout for CMD6 - use generic\n",
+			mmc_hostname(host));
+		timeout_ms = card->ext_csd.generic_cmd6_time;
+	}
+
 	/*
 	 * If the cmd timeout and the max_busy_timeout of the host are both
 	 * specified, let's validate them. A failure means we need to prevent
@@ -544,7 +546,7 @@ int __mmc_switch(struct mmc_card *card,
 	 * which also means they are on their own when it comes to deal with the
 	 * busy timeout.
 	 */
-	if (!(host->caps & MMC_CAP_NEED_RSP_BUSY) && timeout_ms &&
+	if (!(host->caps & MMC_CAP_NEED_RSP_BUSY) &&
 	    host->max_busy_timeout && (timeout_ms > host->max_busy_timeout))
 		use_r1b_resp = false;
 
@@ -556,10 +558,6 @@ int __mmc_switch(struct mmc_card *card,
 	cmd.flags = MMC_CMD_AC;
 	if (use_r1b_resp) {
 		cmd.flags |= MMC_RSP_SPI_R1B | MMC_RSP_R1B;
-		/*
-		 * A busy_timeout of zero means the host can decide to use
-		 * whatever value it finds suitable.
-		 */
 		cmd.busy_timeout = timeout_ms;
 	} else {
 		cmd.flags |= MMC_RSP_SPI_R1 | MMC_RSP_R1;


