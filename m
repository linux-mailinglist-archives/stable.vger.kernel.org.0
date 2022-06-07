Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E915254187E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379050AbiFGVMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379821AbiFGVLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:11:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A438B215E7F;
        Tue,  7 Jun 2022 11:52:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 259B8B81FE1;
        Tue,  7 Jun 2022 18:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED2CC385A2;
        Tue,  7 Jun 2022 18:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627925;
        bh=OkvOHVTj+0RUFez+W4m7EDCBB4EaSlENkTb8ZwkIaAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iee8egRh1HPtgHgTpiedPTd0c7uOilwPVWg18V4c+vghMrEyKOJERngoXS/guJ+Fg
         abdWb3T0etPgL3WJCLYfbC5OG7gkUuEsx+xYHaS/sl0Lo4jV5dyozeW2eOdcQ8NGEr
         1iH1WfpArBEa0sYnQQkajwBkeL4R4EjNAjBnbd0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yihang Li <liyihang6@hisilicon.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 142/879] scsi: hisi_sas: Undo RPM resume for failed notify phy event for v3 HW
Date:   Tue,  7 Jun 2022 18:54:20 +0200
Message-Id: <20220607165006.827225822@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



