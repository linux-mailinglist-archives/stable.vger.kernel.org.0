Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F081C4F3007
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356170AbiDEKXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235427AbiDEJah (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:30:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0338E5414;
        Tue,  5 Apr 2022 02:17:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E7A1615E4;
        Tue,  5 Apr 2022 09:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9BDC385A3;
        Tue,  5 Apr 2022 09:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150259;
        bh=6bkja0LTQHSZqPVobeIryLZm/EoL6/GJ5Tl85AYkTlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1mj3XuvF2/w29lPKccFcuHDwIEovtmFb1znAKobbCw11kL/YlnahWPJcaUmII9gXJ
         k6uKbnMBmdmcXEtj60yWv+f8wXUWZpVteU3MHgAGZjhHnTH5RBmBD5gJCjG4wwk6+a
         tSmb32LSCRNIDARieQaSrwDddgtiq9mYLyqVXxIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        kernel test robot <lkp@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.16 1012/1017] mmc: rtsx: Fix build errors/warnings for unused variable
Date:   Tue,  5 Apr 2022 09:32:05 +0200
Message-Id: <20220405070424.236537241@linuxfoundation.org>
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

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 3dd9a926ec2308e49445f22abef149fc64e9332e upstream.

The struct device *dev, is no longer needed at various functions, let's
therefore drop it to fix the build errors/warnings.

Fixes: 7570fb41e450 ("mmc: rtsx: Let MMC core handle runtime PM")
Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20220301115300.64332-1-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -806,7 +806,6 @@ static void sd_request(struct work_struc
 	struct mmc_request *mrq = host->mrq;
 	struct mmc_command *cmd = mrq->cmd;
 	struct mmc_data *data = mrq->data;
-	struct device *dev = &host->pdev->dev;
 
 	unsigned int data_size = 0;
 	int err;
@@ -1081,7 +1080,6 @@ static void sdmmc_set_ios(struct mmc_hos
 {
 	struct realtek_pci_sdmmc *host = mmc_priv(mmc);
 	struct rtsx_pcr *pcr = host->pcr;
-	struct device *dev = &host->pdev->dev;
 
 	if (host->eject)
 		return;
@@ -1130,7 +1128,6 @@ static int sdmmc_get_ro(struct mmc_host
 {
 	struct realtek_pci_sdmmc *host = mmc_priv(mmc);
 	struct rtsx_pcr *pcr = host->pcr;
-	struct device *dev = &host->pdev->dev;
 	int ro = 0;
 	u32 val;
 
@@ -1156,7 +1153,6 @@ static int sdmmc_get_cd(struct mmc_host
 {
 	struct realtek_pci_sdmmc *host = mmc_priv(mmc);
 	struct rtsx_pcr *pcr = host->pcr;
-	struct device *dev = &host->pdev->dev;
 	int cd = 0;
 	u32 val;
 
@@ -1255,7 +1251,6 @@ static int sdmmc_switch_voltage(struct m
 {
 	struct realtek_pci_sdmmc *host = mmc_priv(mmc);
 	struct rtsx_pcr *pcr = host->pcr;
-	struct device *dev = &host->pdev->dev;
 	int err = 0;
 	u8 voltage;
 
@@ -1308,7 +1303,6 @@ static int sdmmc_execute_tuning(struct m
 {
 	struct realtek_pci_sdmmc *host = mmc_priv(mmc);
 	struct rtsx_pcr *pcr = host->pcr;
-	struct device *dev = &host->pdev->dev;
 	int err = 0;
 
 	if (host->eject)


