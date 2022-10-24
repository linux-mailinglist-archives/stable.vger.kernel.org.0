Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237C960A397
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbiJXL5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbiJXL4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:56:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5E21B1C2;
        Mon, 24 Oct 2022 04:46:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5A87B810F5;
        Mon, 24 Oct 2022 11:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DBCC4314A;
        Mon, 24 Oct 2022 11:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612006;
        bh=q0My1NRdS5ALMXpoYH2Fi1xX8qrY9UD0s3A2OdbcL/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJNyvUXrnaKiSVwi/BhOzUm+7JCs0+dIJrnkPt9vYXUJ8hKPVb37wdBnbP0aQ34uI
         C0YxeD+vRHFPrL5ZrkIiEI1mJ2hOSPwL6dW0jWX1ZNdtu5SGjem6F5JxEDZQeplwj+
         CZnUvzDmrpv5TGPvx5RaMXNDCbucUPnZg4VxiN9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergei Antonov <saproj@gmail.com>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.14 006/210] mmc: moxart: fix 4-bit bus width and remove 8-bit bus width
Date:   Mon, 24 Oct 2022 13:28:43 +0200
Message-Id: <20221024112957.066576791@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_SBL_A autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Antonov <saproj@gmail.com>

commit 35ca91d1338ae158f6dcc0de5d1e86197924ffda upstream.

According to the datasheet [1] at page 377, 4-bit bus width is turned on by
bit 2 of the Bus Width Register. Thus the current bitmask is wrong: define
BUS_WIDTH_4 BIT(1)

BIT(1) does not work but BIT(2) works. This has been verified on real MOXA
hardware with FTSDC010 controller revision 1_6_0.

The corrected value of BUS_WIDTH_4 mask collides with: define BUS_WIDTH_8
BIT(2). Additionally, 8-bit bus width mode isn't supported according to the
datasheet, so let's remove the corresponding code.

[1]
https://bitbucket.org/Kasreyn/mkrom-uc7112lx/src/master/documents/FIC8120_DS_v1.2.pdf

Fixes: 1b66e94e6b99 ("mmc: moxart: Add MOXA ART SD/MMC driver")
Signed-off-by: Sergei Antonov <saproj@gmail.com>
Cc: Jonas Jensen <jonas.jensen@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220907205753.1577434-1-saproj@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/moxart-mmc.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -111,8 +111,8 @@
 #define CLK_DIV_MASK		0x7f
 
 /* REG_BUS_WIDTH */
-#define BUS_WIDTH_8		BIT(2)
-#define BUS_WIDTH_4		BIT(1)
+#define BUS_WIDTH_4_SUPPORT	BIT(3)
+#define BUS_WIDTH_4		BIT(2)
 #define BUS_WIDTH_1		BIT(0)
 
 #define MMC_VDD_360		23
@@ -527,9 +527,6 @@ static void moxart_set_ios(struct mmc_ho
 	case MMC_BUS_WIDTH_4:
 		writel(BUS_WIDTH_4, host->base + REG_BUS_WIDTH);
 		break;
-	case MMC_BUS_WIDTH_8:
-		writel(BUS_WIDTH_8, host->base + REG_BUS_WIDTH);
-		break;
 	default:
 		writel(BUS_WIDTH_1, host->base + REG_BUS_WIDTH);
 		break;
@@ -646,16 +643,8 @@ static int moxart_probe(struct platform_
 		dmaengine_slave_config(host->dma_chan_rx, &cfg);
 	}
 
-	switch ((readl(host->base + REG_BUS_WIDTH) >> 3) & 3) {
-	case 1:
+	if (readl(host->base + REG_BUS_WIDTH) & BUS_WIDTH_4_SUPPORT)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
-		break;
-	case 2:
-		mmc->caps |= MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA;
-		break;
-	default:
-		break;
-	}
 
 	writel(0, host->base + REG_INTERRUPT_MASK);
 


