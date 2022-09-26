Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8A05EA1C9
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236900AbiIZK5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236897AbiIZK4K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:56:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7D61155;
        Mon, 26 Sep 2022 03:29:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 754D5B8091E;
        Mon, 26 Sep 2022 10:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9BCC433C1;
        Mon, 26 Sep 2022 10:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188097;
        bh=F3auYVdCRpTlIuUnMHJnN2IZNOqdqNBg44h/HUF2Hkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oGAVDLaufLnslQ1qgSBzG3GMfb9bLeO7BBAu6hb+7uQ9+xraGEKNH6/t9YHu6p06H
         7kJlo8FJyPC9ah3cYn8MupVfXm3yIIZnNWcbSDQOMvIUPl9k3HYk3eDzAi3wjAs0Cc
         SJgKyPdYT4s5CIhSJILaZe/Pjs00xnzerGssvOKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seunghui Lee <sh043.lee@samsung.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/141] mmc: core: Fix inconsistent sd3_bus_mode at UHS-I SD voltage switch failure
Date:   Mon, 26 Sep 2022 12:10:48 +0200
Message-Id: <20220926100755.364891571@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 63f1560930e4e1c4f6279b8ae715c9841fe1a6d3 ]

If re-initialization results is a different signal voltage, because the
voltage switch failed previously, but not this time (or vice versa), then
sd3_bus_mode will be inconsistent with the card because the SD_SWITCH
command is done only upon first initialization.

Fix by always reading SD_SWITCH information during re-initialization, which
also means it does not need to be re-read later for the 1.8V fixup
workaround.

Note, brief testing showed SD_SWITCH took about 1.8ms to 2ms which added
about 1% to 1.5% to the re-initialization time, so it's not particularly
significant.

Reported-by: Seunghui Lee <sh043.lee@samsung.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Seunghui Lee <sh043.lee@samsung.com>
Tested-by: Seunghui Lee <sh043.lee@samsung.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220815073321.63382-3-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/sd.c | 42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 0b09cdaaeb6c..899768ed1688 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -932,15 +932,16 @@ int mmc_sd_setup_card(struct mmc_host *host, struct mmc_card *card,
 
 		/* Erase init depends on CSD and SSR */
 		mmc_init_erase(card);
-
-		/*
-		 * Fetch switch information from card.
-		 */
-		err = mmc_read_switch(card);
-		if (err)
-			return err;
 	}
 
+	/*
+	 * Fetch switch information from card. Note, sd3_bus_mode can change if
+	 * voltage switch outcome changes, so do this always.
+	 */
+	err = mmc_read_switch(card);
+	if (err)
+		return err;
+
 	/*
 	 * For SPI, enable CRC as appropriate.
 	 * This CRC enable is located AFTER the reading of the
@@ -1089,26 +1090,15 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 	if (!v18_fixup_failed && !mmc_host_is_spi(host) && mmc_host_uhs(host) &&
 	    mmc_sd_card_using_v18(card) &&
 	    host->ios.signal_voltage != MMC_SIGNAL_VOLTAGE_180) {
-		/*
-		 * Re-read switch information in case it has changed since
-		 * oldcard was initialized.
-		 */
-		if (oldcard) {
-			err = mmc_read_switch(card);
-			if (err)
-				goto free_card;
-		}
-		if (mmc_sd_card_using_v18(card)) {
-			if (mmc_host_set_uhs_voltage(host) ||
-			    mmc_sd_init_uhs_card(card)) {
-				v18_fixup_failed = true;
-				mmc_power_cycle(host, ocr);
-				if (!oldcard)
-					mmc_remove_card(card);
-				goto retry;
-			}
-			goto cont;
+		if (mmc_host_set_uhs_voltage(host) ||
+		    mmc_sd_init_uhs_card(card)) {
+			v18_fixup_failed = true;
+			mmc_power_cycle(host, ocr);
+			if (!oldcard)
+				mmc_remove_card(card);
+			goto retry;
 		}
+		goto cont;
 	}
 
 	/* Initialization sequence for UHS-I cards */
-- 
2.35.1



