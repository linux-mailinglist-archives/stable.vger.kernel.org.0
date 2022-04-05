Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA95F4F3A1B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379135AbiDELk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354391AbiDEKOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14246A00E;
        Tue,  5 Apr 2022 02:59:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75DA061745;
        Tue,  5 Apr 2022 09:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D82C385A2;
        Tue,  5 Apr 2022 09:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152788;
        bh=WzivcXSmnyAyLc6VtEfU3zcYJ5LcHw/WrmshFZPnr7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbI2/cZGeQl8EEMYF6ZG71ZuIgmPy6sQztmIWwuE4Zu/vuOBLvBb35XT+raJfeFFS
         vnFAa2uXDm+/lqmczHDtRa6Eg9Ea8Pw07VEpSAsJujxIGqYqyFvwaY4sCazS917dTs
         zFG/WdbSctcXLO3+57CgoAnOx4c+nk/yo9/us12A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH 5.15 902/913] mmc: rtsx: Let MMC core handle runtime PM
Date:   Tue,  5 Apr 2022 09:32:44 +0200
Message-Id: <20220405070406.856556924@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

commit 7570fb41e450ba37bf9335fe3751fa9f502c30fa upstream.

Since MMC core handles runtime PM reference counting, we can avoid doing
redundant runtime PM work in the driver. That means the only thing
commit 5b4258f6721f ("misc: rtsx: rts5249 support runtime PM") misses is
to always enable runtime PM, to let its parent driver enable ASPM in the
runtime idle routine.

Fixes: 7499b529d97f ("mmc: rtsx: Use pm_runtime_{get,put}() to handle runtime PM")
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20220216055435.2335297-1-kai.heng.feng@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c |   18 ------------------
 1 file changed, 18 deletions(-)

--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -823,7 +823,6 @@ static void sd_request(struct work_struc
 	}
 
 	mutex_lock(&pcr->pcr_mutex);
-	pm_runtime_get_sync(dev);
 
 	rtsx_pci_start_run(pcr);
 
@@ -860,8 +859,6 @@ static void sd_request(struct work_struc
 			data->bytes_xfered = data->blocks * data->blksz;
 	}
 
-	pm_runtime_mark_last_busy(dev);
-	pm_runtime_put_autosuspend(dev);
 	mutex_unlock(&pcr->pcr_mutex);
 
 finish:
@@ -1093,7 +1090,6 @@ static void sdmmc_set_ios(struct mmc_hos
 		return;
 
 	mutex_lock(&pcr->pcr_mutex);
-	pm_runtime_get_sync(dev);
 
 	rtsx_pci_start_run(pcr);
 
@@ -1127,8 +1123,6 @@ static void sdmmc_set_ios(struct mmc_hos
 	rtsx_pci_switch_clock(pcr, ios->clock, host->ssc_depth,
 			host->initial_mode, host->double_clk, host->vpclk);
 
-	pm_runtime_mark_last_busy(dev);
-	pm_runtime_put_autosuspend(dev);
 	mutex_unlock(&pcr->pcr_mutex);
 }
 
@@ -1144,7 +1138,6 @@ static int sdmmc_get_ro(struct mmc_host
 		return -ENOMEDIUM;
 
 	mutex_lock(&pcr->pcr_mutex);
-	pm_runtime_get_sync(dev);
 
 	rtsx_pci_start_run(pcr);
 
@@ -1154,8 +1147,6 @@ static int sdmmc_get_ro(struct mmc_host
 	if (val & SD_WRITE_PROTECT)
 		ro = 1;
 
-	pm_runtime_mark_last_busy(dev);
-	pm_runtime_put_autosuspend(dev);
 	mutex_unlock(&pcr->pcr_mutex);
 
 	return ro;
@@ -1173,7 +1164,6 @@ static int sdmmc_get_cd(struct mmc_host
 		return cd;
 
 	mutex_lock(&pcr->pcr_mutex);
-	pm_runtime_get_sync(dev);
 
 	rtsx_pci_start_run(pcr);
 
@@ -1183,8 +1173,6 @@ static int sdmmc_get_cd(struct mmc_host
 	if (val & SD_EXIST)
 		cd = 1;
 
-	pm_runtime_mark_last_busy(dev);
-	pm_runtime_put_autosuspend(dev);
 	mutex_unlock(&pcr->pcr_mutex);
 
 	return cd;
@@ -1282,7 +1270,6 @@ static int sdmmc_switch_voltage(struct m
 		return err;
 
 	mutex_lock(&pcr->pcr_mutex);
-	pm_runtime_get_sync(dev);
 
 	rtsx_pci_start_run(pcr);
 
@@ -1312,8 +1299,6 @@ out:
 	err = rtsx_pci_write_register(pcr, SD_BUS_STAT,
 			SD_CLK_TOGGLE_EN | SD_CLK_FORCE_STOP, 0);
 
-	pm_runtime_mark_last_busy(dev);
-	pm_runtime_put_autosuspend(dev);
 	mutex_unlock(&pcr->pcr_mutex);
 
 	return err;
@@ -1334,7 +1319,6 @@ static int sdmmc_execute_tuning(struct m
 		return err;
 
 	mutex_lock(&pcr->pcr_mutex);
-	pm_runtime_get_sync(dev);
 
 	rtsx_pci_start_run(pcr);
 
@@ -1367,8 +1351,6 @@ static int sdmmc_execute_tuning(struct m
 		err = sd_change_phase(host, DDR50_RX_PHASE(pcr), true);
 
 out:
-	pm_runtime_mark_last_busy(dev);
-	pm_runtime_put_autosuspend(dev);
 	mutex_unlock(&pcr->pcr_mutex);
 
 	return err;


