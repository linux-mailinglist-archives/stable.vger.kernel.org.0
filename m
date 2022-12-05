Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00666433E2
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbiLETkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234407AbiLETkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:40:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B7127B2C
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:37:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9029FCE10A6
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D635C433D6;
        Mon,  5 Dec 2022 19:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269040;
        bh=ykoymXkAusZ3EccWVUziAwo005YqCxV5S805Fh1fvmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHX9tjs9KTOtY7+b8MI/r6M73fChsHsoZCjU3aV4ypTvrEUie5j4+/6XEq2x+lFlv
         BtGuSMR6wQcWRaHESpqH3QActOSssXVMeFtnKKrxSaXYIEXtkaPtWP18fh7FiN5Dv4
         CGMLki9p3Bay0Bgd4omhGNsJAsQ4z5eKI0nVux4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christian Loehle <cloehle@hyperstone.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 077/120] mmc: core: Fix ambiguous TRIM and DISCARD arg
Date:   Mon,  5 Dec 2022 20:10:17 +0100
Message-Id: <20221205190808.925508886@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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
@@ -1482,6 +1482,11 @@ void mmc_init_erase(struct mmc_card *car
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
@@ -1764,7 +1769,7 @@ int mmc_erase(struct mmc_card *card, uns
 	    !(card->ext_csd.sec_feature_support & EXT_CSD_SEC_ER_EN))
 		return -EOPNOTSUPP;
 
-	if (mmc_card_mmc(card) && (arg & MMC_TRIM_ARGS) &&
+	if (mmc_card_mmc(card) && is_trim_arg(arg) &&
 	    !(card->ext_csd.sec_feature_support & EXT_CSD_SEC_GB_CL_EN))
 		return -EOPNOTSUPP;
 
@@ -1794,7 +1799,7 @@ int mmc_erase(struct mmc_card *card, uns
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
@@ -445,7 +445,7 @@ static inline bool mmc_ready_for_data(u3
 #define MMC_SECURE_TRIM1_ARG		0x80000001
 #define MMC_SECURE_TRIM2_ARG		0x80008000
 #define MMC_SECURE_ARGS			0x80000000
-#define MMC_TRIM_ARGS			0x00008001
+#define MMC_TRIM_OR_DISCARD_ARGS	0x00008003
 
 #define mmc_driver_type_mask(n)		(1 << (n))
 


