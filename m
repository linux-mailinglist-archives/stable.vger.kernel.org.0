Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC3A537DB3
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237595AbiE3Ngw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237612AbiE3Nfc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:35:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FA9939D6;
        Mon, 30 May 2022 06:28:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84E4860F17;
        Mon, 30 May 2022 13:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03159C3411E;
        Mon, 30 May 2022 13:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917319;
        bh=OkvOHVTj+0RUFez+W4m7EDCBB4EaSlENkTb8ZwkIaAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+TUJ7YYk43zLBEddZRRSD5k/8gJ4eRd2zSqpwXx7DzNXckKjhHF/WsENlTOdaAK0
         nM+U48cRAn8wuKRdgRL/fzfZwu6W69H+ItUZrWgUWeCYH1QHzV6mboxb5wVlNabVGK
         cDNtxG4QTqsIwt4/m3r2anzUbCgwVwVG3nokCyU/8ttyqX7Jm+vrDmVURgDg8VGCNQ
         LIfG743zrVtzIcmjqIao/EXCrdnPjT11hIodwX+qi/ElhjHs/14dIZ31B7l/LrJMrr
         NHhSKQteLDuYB7nAgDoIEWsJ2E6E0F48IFNXirP5IJ7Z0z6VC5VxkAhmOTvmPwJQmQ
         kXgAjo0jezInw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Yihang Li <liyihang6@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 092/159] scsi: hisi_sas: Undo RPM resume for failed notify phy event for v3 HW
Date:   Mon, 30 May 2022 09:23:17 -0400
Message-Id: <20220530132425.1929512-92-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 9b5387fe5af38116b452259d87cd66594b6277c1 ]

If we fail to notify the phy up event then undo the RPM resume, as the phy
up notify event handling pairs with that RPM resume.

Link: https://lore.kernel.org/r/1651839939-101188-1-git-send-email-john.garry@huawei.com
Reported-by: Yihang Li <liyihang6@hisilicon.com>
Tested-by: Yihang Li <liyihang6@hisilicon.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 79f87d7c3e68..7d819fc0395e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1563,9 +1563,15 @@ static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 
 	phy->port_id = port_id;
 
-	/* Call pm_runtime_put_sync() with pairs in hisi_sas_phyup_pm_work() */
+	/*
+	 * Call pm_runtime_get_noresume() which pairs with
+	 * hisi_sas_phyup_pm_work() -> pm_runtime_put_sync().
+	 * For failure call pm_runtime_put() as we are in a hardirq context.
+	 */
 	pm_runtime_get_noresume(dev);
-	hisi_sas_notify_phy_event(phy, HISI_PHYE_PHY_UP_PM);
+	res = hisi_sas_notify_phy_event(phy, HISI_PHYE_PHY_UP_PM);
+	if (!res)
+		pm_runtime_put(dev);
 
 	res = IRQ_HANDLED;
 
-- 
2.35.1

