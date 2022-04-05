Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26A04F2A22
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238547AbiDEIoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241253AbiDEIc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9796240;
        Tue,  5 Apr 2022 01:30:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1065609D0;
        Tue,  5 Apr 2022 08:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84FCC385A0;
        Tue,  5 Apr 2022 08:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147440;
        bh=ExR9OgwnusTJKSrNCVHWa9/0YVov40hwrNn7KXjpx1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AM0QvQaTzkZpy+fKi54FWCn5xVMTXvQSkKhhNZJJWokYvxcAsNbo7FwXrk6qgjEm+
         Lph5N9TNcwnAnmG1+stwhx3zvDyWB4vgwAxrzpbCYLdu6SFQuUbaxEY9qw36mfwccS
         ie9DuGpITYP+yyJS7puZfGyW1Tgk014CwnzX25wQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricky WU <ricky_wu@realtek.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH 5.17 1088/1126] mmc: rtsx: Use pm_runtime_{get,put}() to handle runtime PM
Date:   Tue,  5 Apr 2022 09:30:35 +0200
Message-Id: <20220405070439.384666474@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 7499b529d97f752124fa62fefa1d6d44b371215a upstream.

Commit 5b4258f6721f ("misc: rtsx: rts5249 support runtime PM") doesn't
use pm_runtime_{get,put}() helpers when it should, so the RPM refcount
keeps at zero, hence its parent driver, rtsx_pci, has to do lots of
weird tricks to keep it from runtime suspending.

So use those helpers at right places to properly manage runtime PM.

Fixes: 5b4258f6721f ("misc: rtsx: rts5249 support runtime PM")
Cc: Ricky WU <ricky_wu@realtek.com>
Tested-by: Ricky WU <ricky_wu@realtek.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20220125055010.1866563-1-kai.heng.feng@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c |   44 ++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 11 deletions(-)

--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -806,6 +806,7 @@ static void sd_request(struct work_struc
 	struct mmc_request *mrq = host->mrq;
 	struct mmc_command *cmd = mrq->cmd;
 	struct mmc_data *data = mrq->data;
+	struct device *dev = &host->pdev->dev;
 
 	unsigned int data_size = 0;
 	int err;
@@ -822,6 +823,7 @@ static void sd_request(struct work_struc
 	}
 
 	mutex_lock(&pcr->pcr_mutex);
+	pm_runtime_get_sync(dev);
 
 	rtsx_pci_start_run(pcr);
 
@@ -858,6 +860,8 @@ static void sd_request(struct work_struc
 			data->bytes_xfered = data->blocks * data->blksz;
 	}
 
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
 	mutex_unlock(&pcr->pcr_mutex);
 
 finish:
@@ -1080,6 +1084,7 @@ static void sdmmc_set_ios(struct mmc_hos
 {
 	struct realtek_pci_sdmmc *host = mmc_priv(mmc);
 	struct rtsx_pcr *pcr = host->pcr;
+	struct device *dev = &host->pdev->dev;
 
 	if (host->eject)
 		return;
@@ -1088,6 +1093,7 @@ static void sdmmc_set_ios(struct mmc_hos
 		return;
 
 	mutex_lock(&pcr->pcr_mutex);
+	pm_runtime_get_sync(dev);
 
 	rtsx_pci_start_run(pcr);
 
@@ -1121,6 +1127,8 @@ static void sdmmc_set_ios(struct mmc_hos
 	rtsx_pci_switch_clock(pcr, ios->clock, host->ssc_depth,
 			host->initial_mode, host->double_clk, host->vpclk);
 
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
 	mutex_unlock(&pcr->pcr_mutex);
 }
 
@@ -1128,6 +1136,7 @@ static int sdmmc_get_ro(struct mmc_host
 {
 	struct realtek_pci_sdmmc *host = mmc_priv(mmc);
 	struct rtsx_pcr *pcr = host->pcr;
+	struct device *dev = &host->pdev->dev;
 	int ro = 0;
 	u32 val;
 
@@ -1135,6 +1144,7 @@ static int sdmmc_get_ro(struct mmc_host
 		return -ENOMEDIUM;
 
 	mutex_lock(&pcr->pcr_mutex);
+	pm_runtime_get_sync(dev);
 
 	rtsx_pci_start_run(pcr);
 
@@ -1144,6 +1154,8 @@ static int sdmmc_get_ro(struct mmc_host
 	if (val & SD_WRITE_PROTECT)
 		ro = 1;
 
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
 	mutex_unlock(&pcr->pcr_mutex);
 
 	return ro;
@@ -1153,6 +1165,7 @@ static int sdmmc_get_cd(struct mmc_host
 {
 	struct realtek_pci_sdmmc *host = mmc_priv(mmc);
 	struct rtsx_pcr *pcr = host->pcr;
+	struct device *dev = &host->pdev->dev;
 	int cd = 0;
 	u32 val;
 
@@ -1160,6 +1173,7 @@ static int sdmmc_get_cd(struct mmc_host
 		return cd;
 
 	mutex_lock(&pcr->pcr_mutex);
+	pm_runtime_get_sync(dev);
 
 	rtsx_pci_start_run(pcr);
 
@@ -1169,6 +1183,8 @@ static int sdmmc_get_cd(struct mmc_host
 	if (val & SD_EXIST)
 		cd = 1;
 
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
 	mutex_unlock(&pcr->pcr_mutex);
 
 	return cd;
@@ -1251,6 +1267,7 @@ static int sdmmc_switch_voltage(struct m
 {
 	struct realtek_pci_sdmmc *host = mmc_priv(mmc);
 	struct rtsx_pcr *pcr = host->pcr;
+	struct device *dev = &host->pdev->dev;
 	int err = 0;
 	u8 voltage;
 
@@ -1265,6 +1282,7 @@ static int sdmmc_switch_voltage(struct m
 		return err;
 
 	mutex_lock(&pcr->pcr_mutex);
+	pm_runtime_get_sync(dev);
 
 	rtsx_pci_start_run(pcr);
 
@@ -1294,6 +1312,8 @@ out:
 	err = rtsx_pci_write_register(pcr, SD_BUS_STAT,
 			SD_CLK_TOGGLE_EN | SD_CLK_FORCE_STOP, 0);
 
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
 	mutex_unlock(&pcr->pcr_mutex);
 
 	return err;
@@ -1303,6 +1323,7 @@ static int sdmmc_execute_tuning(struct m
 {
 	struct realtek_pci_sdmmc *host = mmc_priv(mmc);
 	struct rtsx_pcr *pcr = host->pcr;
+	struct device *dev = &host->pdev->dev;
 	int err = 0;
 
 	if (host->eject)
@@ -1313,6 +1334,7 @@ static int sdmmc_execute_tuning(struct m
 		return err;
 
 	mutex_lock(&pcr->pcr_mutex);
+	pm_runtime_get_sync(dev);
 
 	rtsx_pci_start_run(pcr);
 
@@ -1345,6 +1367,8 @@ static int sdmmc_execute_tuning(struct m
 		err = sd_change_phase(host, DDR50_RX_PHASE(pcr), true);
 
 out:
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
 	mutex_unlock(&pcr->pcr_mutex);
 
 	return err;
@@ -1495,12 +1519,12 @@ static int rtsx_pci_sdmmc_drv_probe(stru
 
 	realtek_init_host(host);
 
-	if (pcr->rtd3_en) {
-		pm_runtime_set_autosuspend_delay(&pdev->dev, 5000);
-		pm_runtime_use_autosuspend(&pdev->dev);
-		pm_runtime_enable(&pdev->dev);
-	}
-
+	pm_runtime_no_callbacks(&pdev->dev);
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, 200);
+	pm_runtime_mark_last_busy(&pdev->dev);
+	pm_runtime_use_autosuspend(&pdev->dev);
 
 	mmc_add_host(mmc);
 
@@ -1521,11 +1545,6 @@ static int rtsx_pci_sdmmc_drv_remove(str
 	pcr->slots[RTSX_SD_CARD].card_event = NULL;
 	mmc = host->mmc;
 
-	if (pcr->rtd3_en) {
-		pm_runtime_dont_use_autosuspend(&pdev->dev);
-		pm_runtime_disable(&pdev->dev);
-	}
-
 	cancel_work_sync(&host->work);
 
 	mutex_lock(&host->host_mutex);
@@ -1548,6 +1567,9 @@ static int rtsx_pci_sdmmc_drv_remove(str
 
 	flush_work(&host->work);
 
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	mmc_free_host(mmc);
 
 	dev_dbg(&(pdev->dev),


