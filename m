Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A074F3124
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347816AbiDEJ22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244935AbiDEIws (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712AA2497B;
        Tue,  5 Apr 2022 01:47:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E2F67CE1BF8;
        Tue,  5 Apr 2022 08:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B55FC385A0;
        Tue,  5 Apr 2022 08:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148424;
        bh=xn5XjbNCQIGn7W+2fCIddx6tTuzdQS5XIwMYVgOCU0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lrCvAhXeYtYjZ91DWxHgAVaOctnG6sar4HSflSOmW8WTs2iYw8/kDA99ybcMSIDRd
         yBjxriaZv21RH31rsaGfC3m7EmkpiO2mcj5/wHCKdTkJNwLKDT8f3/pkjOQ2mGCHAY
         +JwFutddT6XESSWbRLDwsq0p4huK1PSepzijEYuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0353/1017] mmc: sdhci_am654: Fix the driver data of AM64 SoC
Date:   Tue,  5 Apr 2022 09:21:06 +0200
Message-Id: <20220405070404.762768265@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Aswath Govindraju <a-govindraju@ti.com>

[ Upstream commit 3b7340f1c89cc488e4df0b033bf7ae502ebbf5b2 ]

The MMCSD IPs used in AM64 are the same as the ones used in J721E.
Therefore, fix this by using the driver data from J721E for AM64 too, for
both 8 and 4 bit instances.

Fixes: 754b7f2f7d2a ("mmc: sdhci_am654: Add Support for TI's AM64 SoC")
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Link: https://lore.kernel.org/r/20220211075056.26179-1-a-govindraju@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci_am654.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/mmc/host/sdhci_am654.c b/drivers/mmc/host/sdhci_am654.c
index f654afbe8e83..b4891bb26648 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -514,26 +514,6 @@ static const struct sdhci_am654_driver_data sdhci_j721e_4bit_drvdata = {
 	.flags = IOMUX_PRESENT,
 };
 
-static const struct sdhci_pltfm_data sdhci_am64_8bit_pdata = {
-	.ops = &sdhci_j721e_8bit_ops,
-	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
-};
-
-static const struct sdhci_am654_driver_data sdhci_am64_8bit_drvdata = {
-	.pdata = &sdhci_am64_8bit_pdata,
-	.flags = DLL_PRESENT | DLL_CALIB,
-};
-
-static const struct sdhci_pltfm_data sdhci_am64_4bit_pdata = {
-	.ops = &sdhci_j721e_4bit_ops,
-	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
-};
-
-static const struct sdhci_am654_driver_data sdhci_am64_4bit_drvdata = {
-	.pdata = &sdhci_am64_4bit_pdata,
-	.flags = IOMUX_PRESENT,
-};
-
 static const struct soc_device_attribute sdhci_am654_devices[] = {
 	{ .family = "AM65X",
 	  .revision = "SR1.0",
@@ -759,11 +739,11 @@ static const struct of_device_id sdhci_am654_of_match[] = {
 	},
 	{
 		.compatible = "ti,am64-sdhci-8bit",
-		.data = &sdhci_am64_8bit_drvdata,
+		.data = &sdhci_j721e_8bit_drvdata,
 	},
 	{
 		.compatible = "ti,am64-sdhci-4bit",
-		.data = &sdhci_am64_4bit_drvdata,
+		.data = &sdhci_j721e_4bit_drvdata,
 	},
 	{ /* sentinel */ }
 };
-- 
2.34.1



