Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DCD521A0C
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242359AbiEJNxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244999AbiEJNrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F4235250;
        Tue, 10 May 2022 06:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C31CF6182F;
        Tue, 10 May 2022 13:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD270C385C2;
        Tue, 10 May 2022 13:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189598;
        bh=omCwwj1V9gdXnPBkxflgMCC/ZXqPVg3mzsyBr2cA380=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxd4+SSO9QQv/6hNpEmR/ZCgwALgZFnaLEHg3NRTYdMMSbiA9t9SUr15tKhHFnaaH
         ToXlV77+RCFlDTjXlkVyB05NRO3ekoKylKhQqDGud0s7rd04UoZZquyPbE2rO60Fm4
         nDcoQyhgRs4pbr+7YZM56jdElC8qWX2ZUO//gjeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricky Wu <ricky_wu@realtek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?Christian=20L=C3=B6hle?= <CLoehle@hyperstone.com>
Subject: [PATCH 5.15 102/135] mmc: rtsx: add 74 Clocks in power on flow
Date:   Tue, 10 May 2022 15:08:04 +0200
Message-Id: <20220510130743.333952227@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricky WU <ricky_wu@realtek.com>

commit 1f311c94aabdb419c28e3147bcc8ab89269f1a7e upstream.

SD spec definition:
"Host provides at least 74 Clocks before issuing first command"
After 1ms for the voltage stable then start issuing the Clock signals

if POWER STATE is
MMC_POWER_OFF to MMC_POWER_UP to issue Clock signal to card
MMC_POWER_UP to MMC_POWER_ON to stop issuing signal to card

Signed-off-by: Ricky Wu <ricky_wu@realtek.com>
Link: https://lore.kernel.org/r/1badf10aba764191a1a752edcbf90389@realtek.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Christian Löhle <CLoehle@hyperstone.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -38,10 +38,7 @@ struct realtek_pci_sdmmc {
 	bool			double_clk;
 	bool			eject;
 	bool			initial_mode;
-	int			power_state;
-#define SDMMC_POWER_ON		1
-#define SDMMC_POWER_OFF		0
-
+	int			prev_power_state;
 	int			sg_count;
 	s32			cookie;
 	int			cookie_sg_count;
@@ -905,7 +902,7 @@ static int sd_set_bus_width(struct realt
 	return err;
 }
 
-static int sd_power_on(struct realtek_pci_sdmmc *host)
+static int sd_power_on(struct realtek_pci_sdmmc *host, unsigned char power_mode)
 {
 	struct rtsx_pcr *pcr = host->pcr;
 	struct mmc_host *mmc = host->mmc;
@@ -913,9 +910,14 @@ static int sd_power_on(struct realtek_pc
 	u32 val;
 	u8 test_mode;
 
-	if (host->power_state == SDMMC_POWER_ON)
+	if (host->prev_power_state == MMC_POWER_ON)
 		return 0;
 
+	if (host->prev_power_state == MMC_POWER_UP) {
+		rtsx_pci_write_register(pcr, SD_BUS_STAT, SD_CLK_TOGGLE_EN, 0);
+		goto finish;
+	}
+
 	msleep(100);
 
 	rtsx_pci_init_cmd(pcr);
@@ -936,10 +938,15 @@ static int sd_power_on(struct realtek_pc
 	if (err < 0)
 		return err;
 
+	mdelay(1);
+
 	err = rtsx_pci_write_register(pcr, CARD_OE, SD_OUTPUT_EN, SD_OUTPUT_EN);
 	if (err < 0)
 		return err;
 
+	/* send at least 74 clocks */
+	rtsx_pci_write_register(pcr, SD_BUS_STAT, SD_CLK_TOGGLE_EN, SD_CLK_TOGGLE_EN);
+
 	if (PCI_PID(pcr) == PID_5261) {
 		/*
 		 * If test mode is set switch to SD Express mandatorily,
@@ -964,7 +971,8 @@ static int sd_power_on(struct realtek_pc
 		}
 	}
 
-	host->power_state = SDMMC_POWER_ON;
+finish:
+	host->prev_power_state = power_mode;
 	return 0;
 }
 
@@ -973,7 +981,7 @@ static int sd_power_off(struct realtek_p
 	struct rtsx_pcr *pcr = host->pcr;
 	int err;
 
-	host->power_state = SDMMC_POWER_OFF;
+	host->prev_power_state = MMC_POWER_OFF;
 
 	rtsx_pci_init_cmd(pcr);
 
@@ -999,7 +1007,7 @@ static int sd_set_power_mode(struct real
 	if (power_mode == MMC_POWER_OFF)
 		err = sd_power_off(host);
 	else
-		err = sd_power_on(host);
+		err = sd_power_on(host, power_mode);
 
 	return err;
 }
@@ -1482,10 +1490,11 @@ static int rtsx_pci_sdmmc_drv_probe(stru
 
 	host = mmc_priv(mmc);
 	host->pcr = pcr;
+	mmc->ios.power_delay_ms = 5;
 	host->mmc = mmc;
 	host->pdev = pdev;
 	host->cookie = -1;
-	host->power_state = SDMMC_POWER_OFF;
+	host->prev_power_state = MMC_POWER_OFF;
 	INIT_WORK(&host->work, sd_request);
 	platform_set_drvdata(pdev, host);
 	pcr->slots[RTSX_SD_CARD].p_dev = pdev;


