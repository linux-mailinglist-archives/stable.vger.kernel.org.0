Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F8A4FD390
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 11:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377337AbiDLHtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358839AbiDLHmQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2002753E3C;
        Tue, 12 Apr 2022 00:19:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA2DEB81A8F;
        Tue, 12 Apr 2022 07:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0DCC385A5;
        Tue, 12 Apr 2022 07:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747962;
        bh=QhsvxtWGhK5wtgUU105j/Ut1BdLJxJR/yoBWlg8U0ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GRy/1z54+wobF+Sd+OUhWCeiuYkQ+wwZmyZp4tLX9e5NztBq8kOF6ZtuO6gS2fCER
         PVlN+Zgmj/vhUGwJlAUBvy+phmdooT/z2mbCFI9QHLyAS2pv86alK1szKrZ/fgdj70
         /NP9ptZhTD6ktAWNyJ1hlEhGZwEVGqPYpV4Uzn34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yann Gautier <yann.gautier@foss.st.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.17 268/343] mmc: mmci: stm32: correctly check all elements of sg list
Date:   Tue, 12 Apr 2022 08:31:26 +0200
Message-Id: <20220412062959.058808790@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Yann Gautier <yann.gautier@foss.st.com>

commit 0d319dd5a27183b75d984e3dc495248e59f99334 upstream.

Use sg and not data->sg when checking sg list elements. Else only the
first element alignment is checked.
The last element should be checked the same way, for_each_sg already set
sg to sg_next(sg).

Fixes: 46b723dd867d ("mmc: mmci: add stm32 sdmmc variant")
Cc: stable@vger.kernel.org
Signed-off-by: Yann Gautier <yann.gautier@foss.st.com>
Link: https://lore.kernel.org/r/20220317111944.116148-2-yann.gautier@foss.st.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmci_stm32_sdmmc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/mmci_stm32_sdmmc.c
+++ b/drivers/mmc/host/mmci_stm32_sdmmc.c
@@ -62,8 +62,8 @@ static int sdmmc_idma_validate_data(stru
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
@@ -71,7 +71,7 @@ static int sdmmc_idma_validate_data(stru
 		}
 	}
 
-	if (!IS_ALIGNED(data->sg->offset, sizeof(u32))) {
+	if (!IS_ALIGNED(sg->offset, sizeof(u32))) {
 		dev_err(mmc_dev(host->mmc),
 			"unaligned last scatterlist: ofst:%x length:%d\n",
 			data->sg->offset, data->sg->length);


