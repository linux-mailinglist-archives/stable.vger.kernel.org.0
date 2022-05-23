Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A395531883
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239753AbiEWRMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240531AbiEWRMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:12:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C458762CCB;
        Mon, 23 May 2022 10:11:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B47861509;
        Mon, 23 May 2022 17:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E404C34118;
        Mon, 23 May 2022 17:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325809;
        bh=G9ZRHRw/SjKlN1Cm8RgRF6kGTUhjJSALMeiIry7VasE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0qKOAybkDRj3DRcDBWp6VXdpzjCvAuBs9PSdcs7NPV1f+/DX703bfjCguU337i3Lq
         +fVttgc9PnTegps2jxDEEUl0PyR5Nn8+8Yvw+YWusL3YqzEc0WcBCg7NHrMO1APeph
         tZjmeeLR8sAk2aOpqTUlq8t8o7VNLT7OSJcy7flo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 4.19 18/44] mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH for eMMC
Date:   Mon, 23 May 2022 19:05:02 +0200
Message-Id: <20220523165756.536633554@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165752.797318097@linuxfoundation.org>
References: <20220523165752.797318097@linuxfoundation.org>
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

commit 24ed3bd01d6a844fd5e8a75f48d0a3d10ed71bf9 upstream

The timeout values used while waiting for a CMD6 for BKOPS or a CACHE_FLUSH
to complete, are not defined by the eMMC spec. However, a timeout of 10
minutes as is currently being used, is just silly for both of these cases.
Instead, let's specify more reasonable timeouts, 120s for BKOPS and 30s for
CACHE_FLUSH.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20200122142747.5690-2-ulf.hansson@linaro.org
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/mmc_ops.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -23,7 +23,9 @@
 #include "host.h"
 #include "mmc_ops.h"
 
-#define MMC_OPS_TIMEOUT_MS	(10 * 60 * 1000) /* 10 minute timeout */
+#define MMC_OPS_TIMEOUT_MS		(10 * 60 * 1000) /* 10min*/
+#define MMC_BKOPS_TIMEOUT_MS		(120 * 1000) /* 120s */
+#define MMC_CACHE_FLUSH_TIMEOUT_MS	(30 * 1000) /* 30s */
 
 static const u8 tuning_blk_pattern_4bit[] = {
 	0xff, 0x0f, 0xff, 0x00, 0xff, 0xcc, 0xc3, 0xcc,
@@ -947,7 +949,7 @@ void mmc_run_bkops(struct mmc_card *card
 	 * urgent levels by using an asynchronous background task, when idle.
 	 */
 	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-			EXT_CSD_BKOPS_START, 1, MMC_OPS_TIMEOUT_MS);
+			 EXT_CSD_BKOPS_START, 1, MMC_BKOPS_TIMEOUT_MS);
 	if (err)
 		pr_warn("%s: Error %d starting bkops\n",
 			mmc_hostname(card->host), err);
@@ -965,7 +967,8 @@ int mmc_flush_cache(struct mmc_card *car
 
 	if (mmc_cache_enabled(card->host)) {
 		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-				EXT_CSD_FLUSH_CACHE, 1, 0);
+				 EXT_CSD_FLUSH_CACHE, 1,
+				 MMC_CACHE_FLUSH_TIMEOUT_MS);
 		if (err)
 			pr_err("%s: cache flush error %d\n",
 					mmc_hostname(card->host), err);


