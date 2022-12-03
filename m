Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE65464162F
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 11:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiLCK6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 05:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiLCK6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 05:58:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4059745082
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 02:58:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFDC160B5B
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 10:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF8FC433D6;
        Sat,  3 Dec 2022 10:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670065091;
        bh=hqZEgSZFwhiy5T1ODgSt9ExpXty+uCOaZXdk/hgbBdM=;
        h=Subject:To:Cc:From:Date:From;
        b=xv2RcpIBcdtiTvGF/Ymyfhn0KH8Yo7XKkPRY6GnjgAlpdVFJChl8xgfufbU3h+oHq
         44JPxy3nKgPxVihypY+YFk8vRIG7xmTzH6y2I2OuXNFQj4Ai6eykij7O2u4DsAadA8
         FHZCazvxJaaLrMb2i8sJwxllh8UjCO/l0ndccdFo=
Subject: FAILED: patch "[PATCH] mmc: core: Fix ambiguous TRIM and DISCARD arg" failed to apply to 4.9-stable tree
To:     CLoehle@hyperstone.com, adrian.hunter@intel.com,
        cloehle@hyperstone.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Dec 2022 11:57:58 +0100
Message-ID: <167006507818032@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

489d144563f2 ("mmc: core: Fix ambiguous TRIM and DISCARD arg")
bc47e2f6f9e2 ("mmc: core: Add discard support to sd")
01904ff77676 ("mmc: core: Calculate the discard arg only once")
06c9ccb78e68 ("mmc: core: add proper be32 annotation")
c0a3e080f929 ("mmc: core: Move erase/trim/discard defines from public core.h to mmc.h")
55244c5659b5 ("mmc: core: Move public functions from core.h to private headers")
066185d69063 ("mmc: core: First step in cleaning up private mmc header files")
164b50b35390 ("mmc: block: Replace "goto retry" by a proper do / while loop")
e85baa8868b0 ("mmc: sd: Meet alignment requirements for raw_ssr DMA")
f397c8d80a5e ("mmc: block: Move files to core")
e711f0309109 ("mmc: mmc: Introduce mmc_abort_tuning()")
aa33ce3c411a ("mmc: core: Enable __mmc_switch() to change bus speed timing for the host")
625228fa3e01 ("mmc: core: Rename ignore_crc to retry_crc_err to reflect its purpose")
437590a123b6 ("mmc: core: Retry instead of ignore at CRC errors when polling for busy")
8e8b3f514c12 ("mmc: core: use enum mmc_blk_status properly")
70562644f4ee ("mmc: core: Don't use ->card_busy() and CMD13 in combination when polling")
716bdb8953c7 ("mmc: core: Factor out code related to polling in __mmc_switch()")
cb26ce069ffa ("mmc: core: Clarify code which deals with polling in __mmc_switch()")
20348d1981da ("mmc: core: Make mmc_switch_status() available for mmc core")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 489d144563f23911262a652234b80c70c89c978b Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Christian=20L=C3=B6hle?= <CLoehle@hyperstone.com>
Date: Thu, 17 Nov 2022 14:42:09 +0000
Subject: [PATCH] mmc: core: Fix ambiguous TRIM and DISCARD arg

Clean up the MMC_TRIM_ARGS define that became ambiguous with DISCARD
introduction.  While at it, let's fix one usage where MMC_TRIM_ARGS falsely
included DISCARD too.

Fixes: b3bf915308ca ("mmc: core: new discard feature support at eMMC v4.5")
Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/11376b5714964345908f3990f17e0701@hyperstone.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index c5de202f530a..de1cc9e1ae57 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1484,6 +1484,11 @@ void mmc_init_erase(struct mmc_card *card)
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
@@ -1766,7 +1771,7 @@ int mmc_erase(struct mmc_card *card, unsigned int from, unsigned int nr,
 	    !(card->ext_csd.sec_feature_support & EXT_CSD_SEC_ER_EN))
 		return -EOPNOTSUPP;
 
-	if (mmc_card_mmc(card) && (arg & MMC_TRIM_ARGS) &&
+	if (mmc_card_mmc(card) && is_trim_arg(arg) &&
 	    !(card->ext_csd.sec_feature_support & EXT_CSD_SEC_GB_CL_EN))
 		return -EOPNOTSUPP;
 
@@ -1796,7 +1801,7 @@ int mmc_erase(struct mmc_card *card, unsigned int from, unsigned int nr,
 	 * identified by the card->eg_boundary flag.
 	 */
 	rem = card->erase_size - (from % card->erase_size);
-	if ((arg & MMC_TRIM_ARGS) && (card->eg_boundary) && (nr > rem)) {
+	if ((arg & MMC_TRIM_OR_DISCARD_ARGS) && card->eg_boundary && nr > rem) {
 		err = mmc_do_erase(card, from, from + rem - 1, arg);
 		from += rem;
 		if ((err) || (to <= from))
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 9c50bc40f8ff..6f7993803ee7 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -451,7 +451,7 @@ static inline bool mmc_ready_for_data(u32 status)
 #define MMC_SECURE_TRIM1_ARG		0x80000001
 #define MMC_SECURE_TRIM2_ARG		0x80008000
 #define MMC_SECURE_ARGS			0x80000000
-#define MMC_TRIM_ARGS			0x00008001
+#define MMC_TRIM_OR_DISCARD_ARGS	0x00008003
 
 #define mmc_driver_type_mask(n)		(1 << (n))
 

