Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE805012AD
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245644AbiDNOI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347690AbiDNN71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:59:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D0B6CA7D;
        Thu, 14 Apr 2022 06:51:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22A0461DF0;
        Thu, 14 Apr 2022 13:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28619C385A5;
        Thu, 14 Apr 2022 13:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944285;
        bh=lkG/jii9kM2C+ITLvFttIvjANoTf3Gajm1ddtt4spd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CH5kb43p7Ybt7Kom5hlmUn1/P5sL5rJShm/tPb2F5LKf19gQU44Xg/Y9gW5RDrmT0
         GAhk4XEpDmPwtWr1FVKj8sQNeyyx1OCVKgYBlDYQB2JwwoRkhDaweM5lEzCvM4u9LP
         XroflGrZCh9bhbDCkWsIJ5Od6/4dy/sIDnw0Gp7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ludovic Barre <ludovic.barre@st.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 460/475] mmc: mmci_sdmmc: Replace sg_dma_xxx macros
Date:   Thu, 14 Apr 2022 15:14:05 +0200
Message-Id: <20220414110907.930335570@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Ludovic Barre <ludovic.barre@st.com>

commit 127e6e98ca9b8ac4f87698ebce1508e3449bb791 upstream.

sg_dma_xxx should be used after a dma_map_sg call has been done to get bus
addresses of each of the SG entries and their lengths.  But mmci_host_ops
validate_data can be called before dma_map_sg.  This patch replaces theses
macros by sg->offset and sg->length which are always defined.

Signed-off-by: Ludovic Barre <ludovic.barre@st.com>
Link: https://lore.kernel.org/r/20200128090636.13689-2-ludovic.barre@st.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmci_stm32_sdmmc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/mmci_stm32_sdmmc.c
+++ b/drivers/mmc/host/mmci_stm32_sdmmc.c
@@ -36,8 +36,8 @@ int sdmmc_idma_validate_data(struct mmci
 	 * excepted the last element which has no constraint on idmasize
 	 */
 	for_each_sg(data->sg, sg, data->sg_len - 1, i) {
-		if (!IS_ALIGNED(sg_dma_address(data->sg), sizeof(u32)) ||
-		    !IS_ALIGNED(sg_dma_len(data->sg), SDMMC_IDMA_BURST)) {
+		if (!IS_ALIGNED(data->sg->offset, sizeof(u32)) ||
+		    !IS_ALIGNED(data->sg->length, SDMMC_IDMA_BURST)) {
 			dev_err(mmc_dev(host->mmc),
 				"unaligned scatterlist: ofst:%x length:%d\n",
 				data->sg->offset, data->sg->length);
@@ -45,7 +45,7 @@ int sdmmc_idma_validate_data(struct mmci
 		}
 	}
 
-	if (!IS_ALIGNED(sg_dma_address(data->sg), sizeof(u32))) {
+	if (!IS_ALIGNED(data->sg->offset, sizeof(u32))) {
 		dev_err(mmc_dev(host->mmc),
 			"unaligned last scatterlist: ofst:%x length:%d\n",
 			data->sg->offset, data->sg->length);


