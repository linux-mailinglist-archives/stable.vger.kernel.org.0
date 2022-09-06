Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1975AEB01
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbiIFNs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbiIFNq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:46:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176D579A44;
        Tue,  6 Sep 2022 06:39:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3875661522;
        Tue,  6 Sep 2022 13:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF365C433D7;
        Tue,  6 Sep 2022 13:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471491;
        bh=F8XlWJ7j78gS3bNsvswtAqGim42mcPtLxw7mVqvTRO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npMAQqzxychgiU89ZIrmQOr8Z98+07D5nEmsyAVV9Ly3RLPr5RbH2yaD/a3WU5tOu
         L7Z0oEPfKPS7us41R19Meb9TRQ0SaV5I+HNukSooC6PT1kjEWB9MegYQvaKSxaNYJZ
         LqnnxHg/ZYxc4NiMDYZMBDyy4HBvkJSe71Re+uxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seunghui Lee <sh043.lee@samsung.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 045/107] mmc: core: Fix inconsistent sd3_bus_mode at UHS-I SD voltage switch failure
Date:   Tue,  6 Sep 2022 15:30:26 +0200
Message-Id: <20220906132823.734423850@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 63f1560930e4e1c4f6279b8ae715c9841fe1a6d3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/sd.c |   42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -942,16 +942,17 @@ int mmc_sd_setup_card(struct mmc_host *h
 
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
 
 	/*
+	 * Fetch switch information from card. Note, sd3_bus_mode can change if
+	 * voltage switch outcome changes, so do this always.
+	 */
+	err = mmc_read_switch(card);
+	if (err)
+		return err;
+
+	/*
 	 * For SPI, enable CRC as appropriate.
 	 * This CRC enable is located AFTER the reading of the
 	 * card registers because some SDHC cards are not able
@@ -1473,26 +1474,15 @@ retry:
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


