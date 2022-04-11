Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105AF4FB4FB
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 09:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245505AbiDKHfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 03:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245510AbiDKHfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 03:35:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D613DA4B
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 00:33:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E7E8613DC
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 07:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FE8C385A4;
        Mon, 11 Apr 2022 07:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649662402;
        bh=YY4Qu0zHef7yl+tNy+Sj2b7/6jJq3FCdfDwAoWZskcQ=;
        h=Subject:To:Cc:From:Date:From;
        b=ROAr0zYuDA3qgGmB03KlKYntUAUz0hiVtEXmeG7lNw4cZExyjY77RJAv0rw6YzQ51
         6+R2Kx+Bq8B00qbbzH7E6wNiPJ4M+ELLgl/DTHuKiQ4EWnJD1z7q02tncXdxY8RLqP
         QStG4f+dWI6MWvpwycCx85f/4sS8z4M1KBO1eHuQ=
Subject: FAILED: patch "[PATCH] mmc: mmci: stm32: correctly check all elements of sg list" failed to apply to 5.4-stable tree
To:     yann.gautier@foss.st.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 09:33:12 +0200
Message-ID: <164966239220895@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0d319dd5a27183b75d984e3dc495248e59f99334 Mon Sep 17 00:00:00 2001
From: Yann Gautier <yann.gautier@foss.st.com>
Date: Thu, 17 Mar 2022 12:19:43 +0100
Subject: [PATCH] mmc: mmci: stm32: correctly check all elements of sg list

Use sg and not data->sg when checking sg list elements. Else only the
first element alignment is checked.
The last element should be checked the same way, for_each_sg already set
sg to sg_next(sg).

Fixes: 46b723dd867d ("mmc: mmci: add stm32 sdmmc variant")
Cc: stable@vger.kernel.org
Signed-off-by: Yann Gautier <yann.gautier@foss.st.com>
Link: https://lore.kernel.org/r/20220317111944.116148-2-yann.gautier@foss.st.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/mmci_stm32_sdmmc.c b/drivers/mmc/host/mmci_stm32_sdmmc.c
index 9c13f2c31365..4566d7fc9055 100644
--- a/drivers/mmc/host/mmci_stm32_sdmmc.c
+++ b/drivers/mmc/host/mmci_stm32_sdmmc.c
@@ -62,8 +62,8 @@ static int sdmmc_idma_validate_data(struct mmci_host *host,
 	 * excepted the last element which has no constraint on idmasize
 	 */
 	for_each_sg(data->sg, sg, data->sg_len - 1, i) {
-		if (!IS_ALIGNED(data->sg->offset, sizeof(u32)) ||
-		    !IS_ALIGNED(data->sg->length, SDMMC_IDMA_BURST)) {
+		if (!IS_ALIGNED(sg->offset, sizeof(u32)) ||
+		    !IS_ALIGNED(sg->length, SDMMC_IDMA_BURST)) {
 			dev_err(mmc_dev(host->mmc),
 				"unaligned scatterlist: ofst:%x length:%d\n",
 				data->sg->offset, data->sg->length);
@@ -71,7 +71,7 @@ static int sdmmc_idma_validate_data(struct mmci_host *host,
 		}
 	}
 
-	if (!IS_ALIGNED(data->sg->offset, sizeof(u32))) {
+	if (!IS_ALIGNED(sg->offset, sizeof(u32))) {
 		dev_err(mmc_dev(host->mmc),
 			"unaligned last scatterlist: ofst:%x length:%d\n",
 			data->sg->offset, data->sg->length);

