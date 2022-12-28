Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3771A6579F3
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbiL1PGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233580AbiL1PGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:06:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF3112D3A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:06:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE389B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31996C433EF;
        Wed, 28 Dec 2022 15:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239978;
        bh=9AtMiHKpoUlY9QO0Us6J1m6vzVBDH68xDzgmgBMi2Qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2W8zCHpxyB/vIMSXgnXNOz73TcB9WD/McXfQ1GLP4yaAKGTA8npenBhQmJTuTDET
         ODxyPvJZdH4pfs3mFkwTdz88XObHsUHZcwdOCaRIDixYUIPzzEgpEXP+VBVufkeH82
         vAj34G9ohA5hiGcZFK3py1VoumLMSjEqZSChte40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 295/731] mmc: rtsx_pci: fix return value check of mmc_add_host()
Date:   Wed, 28 Dec 2022 15:36:42 +0100
Message-Id: <20221228144305.124742500@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 0c87db77423a282b3b38b8a6daf057b822680516 ]

mmc_add_host() may return error, if we ignore its return value, the memory
that allocated in mmc_alloc_host() will be leaked and it will lead a kernel
crash because of deleting not added device in the remove path.

So fix this by checking the return value and calling mmc_free_host() in the
error path, beside, runtime PM also needs be disabled.

Fixes: ff984e57d36e ("mmc: Add realtek pcie sdmmc host driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221101063023.1664968-6-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index e1580f78c6b2..8098726dcc0b 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -1474,6 +1474,7 @@ static int rtsx_pci_sdmmc_drv_probe(struct platform_device *pdev)
 	struct realtek_pci_sdmmc *host;
 	struct rtsx_pcr *pcr;
 	struct pcr_handle *handle = pdev->dev.platform_data;
+	int ret;
 
 	if (!handle)
 		return -ENXIO;
@@ -1511,7 +1512,13 @@ static int rtsx_pci_sdmmc_drv_probe(struct platform_device *pdev)
 	pm_runtime_mark_last_busy(&pdev->dev);
 	pm_runtime_use_autosuspend(&pdev->dev);
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret) {
+		pm_runtime_dont_use_autosuspend(&pdev->dev);
+		pm_runtime_disable(&pdev->dev);
+		mmc_free_host(mmc);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.35.1



