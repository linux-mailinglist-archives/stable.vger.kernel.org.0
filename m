Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C124D643487
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbiLETrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234862AbiLETr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:47:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF3B25EBA
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:43:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE9F5B811F3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A510C433D6;
        Mon,  5 Dec 2022 19:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269425;
        bh=ah0ma9LmBfpWkKFgzl6PzS9eiUEWr33jWVmldj+f1xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zB4v9L5Fo79b5I2KM9oTZjK1CSWBMk3cFCeaLw7onEnO/osRT05Aa8pR7e3TJADMi
         dsITz8p52raosv1eK6uYVonYjpyMdd8SxsbwhYgFtPudQMSzTpQ4xi7RBMrzULN+pu
         P74QYOZHtsCDeBnYK6AgCDuFtffP0V/h4Pl49ISY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christian Loehle <cloehle@hyperstone.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 123/153] mmc: core: Fix ambiguous TRIM and DISCARD arg
Date:   Mon,  5 Dec 2022 20:10:47 +0100
Message-Id: <20221205190812.233794404@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Löhle <CLoehle@hyperstone.com>

commit 489d144563f23911262a652234b80c70c89c978b upstream.

Clean up the MMC_TRIM_ARGS define that became ambiguous with DISCARD
introduction.  While at it, let's fix one usage where MMC_TRIM_ARGS falsely
included DISCARD too.

Fixes: b3bf915308ca ("mmc: core: new discard feature support at eMMC v4.5")
Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/11376b5714964345908f3990f17e0701@hyperstone.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/core.c |    9 +++++++--
 include/linux/mmc/mmc.h |    2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1556,6 +1556,11 @@ void mmc_init_erase(struct mmc_card *car
 		card->pref_erase = 0;
 }
 
+static bool is_trim_arg(unsigned int arg)
+{
+	return (arg & MMC_TRIM_OR_DISCARD_ARGS) && arg != MMC_DISCARD_ARG;
+}
+
 static unsigned int mmc_mmc_erase_timeout(struct mmc_card *card,
 				          unsigned int arg, unsigned int qty)
 {
@@ -1887,7 +1892,7 @@ int mmc_erase(struct mmc_card *card, uns
 	    !(card->ext_csd.sec_feature_support & EXT_CSD_SEC_ER_EN))
 		return -EOPNOTSUPP;
 
-	if (mmc_card_mmc(card) && (arg & MMC_TRIM_ARGS) &&
+	if (mmc_card_mmc(card) && is_trim_arg(arg) &&
 	    !(card->ext_csd.sec_feature_support & EXT_CSD_SEC_GB_CL_EN))
 		return -EOPNOTSUPP;
 
@@ -1917,7 +1922,7 @@ int mmc_erase(struct mmc_card *card, uns
 	 * identified by the card->eg_boundary flag.
 	 */
 	rem = card->erase_size - (from % card->erase_size);
-	if ((arg & MMC_TRIM_ARGS) && (card->eg_boundary) && (nr > rem)) {
+	if ((arg & MMC_TRIM_OR_DISCARD_ARGS) && card->eg_boundary && nr > rem) {
 		err = mmc_do_erase(card, from, from + rem - 1, arg);
 		from += rem;
 		if ((err) || (to <= from))
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -434,7 +434,7 @@ static inline bool mmc_op_multi(u32 opco
 #define MMC_SECURE_TRIM1_ARG		0x80000001
 #define MMC_SECURE_TRIM2_ARG		0x80008000
 #define MMC_SECURE_ARGS			0x80000000
-#define MMC_TRIM_ARGS			0x00008001
+#define MMC_TRIM_OR_DISCARD_ARGS	0x00008003
 
 #define mmc_driver_type_mask(n)		(1 << (n))
 


