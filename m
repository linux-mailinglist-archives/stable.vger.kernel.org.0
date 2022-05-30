Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4FB538058
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238722AbiE3NxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239203AbiE3NvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:51:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA1D915BC;
        Mon, 30 May 2022 06:35:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA9E360F27;
        Mon, 30 May 2022 13:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099AFC341C6;
        Mon, 30 May 2022 13:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917726;
        bh=N03/B74u7sn+A4NVcosFTHskafhEW/CGOihApCtGW9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rj5jfc+9doM4HPXS4Hxl2oLB2wFMDRxQGYt5i4nHb7kREAf0NIsgKqItV9c2hNP12
         7fvk8cMZmbVfp+dWRh+TMK1nB5GHnYrt9L+gINeEjCxvxdXryPAHsaQJgEDA6tmEQ8
         93L9whc8ahvj6sj7n4hmdwY6q9RrI2mWOdvk4XDKc5QZOJwIpEA48xG8IQOIBtfCQ1
         JWRcHM51IIQe5q0IwE+ZzY5c75RgNpCFavCSd4Z69Eo5AT6+70d/1lu5YjfsKS8UJe
         gG6Xh/P4BRRgf7VAFFU4REoFlHnuZgLpB2aWbULYfw8aG/uGZik4zbU7C7zc2RfrbL
         rjq3cBn6YZ+FQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Yihang Li <liyihang6@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 076/135] scsi: hisi_sas: Undo RPM resume for failed notify phy event for v3 HW
Date:   Mon, 30 May 2022 09:30:34 -0400
Message-Id: <20220530133133.1931716-76-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
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
index 52089538e9de..b309a9d0f5b7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1561,9 +1561,15 @@ static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 
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

