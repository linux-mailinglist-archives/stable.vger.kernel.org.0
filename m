Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00F659D8AA
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241101AbiHWJQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348371AbiHWJMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:12:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6082786FE3;
        Tue, 23 Aug 2022 01:31:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5961661326;
        Tue, 23 Aug 2022 08:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49ACBC433C1;
        Tue, 23 Aug 2022 08:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243488;
        bh=qt61o7YewrXnnLL9ocm5HDs/bnCH6kg7cv3t1Ds3lw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eADwtF/8Y3SzTRsvsabIRkRDcFXDvTppzb3BEolvMOt1xSOx+tY0NCF4RiGR2ayPo
         N3Kr3+vPHRl/n3n4su7wZFK4htMzvDlhopbOdKbdaN423ppTNUVM3LXfNGp2hd0Op9
         9lAX3SkksxOy8iBZmTxqyJ9TTBxfkltYDC/R5l0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Chanho Park <chanho61.park@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 293/365] scsi: ufs: ufs-exynos: Change ufs phy control sequence
Date:   Tue, 23 Aug 2022 10:03:14 +0200
Message-Id: <20220823080130.466427548@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chanho Park <chanho61.park@samsung.com>

[ Upstream commit 3d73b200f9893d8f5ba5d105e8b69c8d16744fa2 ]

Since commit 1599069a62c6 ("phy: core: Warn when phy_power_on is called
before phy_init"), the following warning has been reported:

	phy_power_on was called before phy_init

To address this, we need to remove phy_power_on from exynos_ufs_phy_init()
and move it after phy_init. phy_power_off and phy_exit are also necessary
in exynos_ufs_remove().

Link: https://lore.kernel.org/r/20220706020255.151177-4-chanho61.park@samsung.com
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-exynos.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index a81d8cbd542f..25995667c832 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -910,9 +910,13 @@ static int exynos_ufs_phy_init(struct exynos_ufs *ufs)
 	if (ret) {
 		dev_err(hba->dev, "%s: phy init failed, ret = %d\n",
 			__func__, ret);
-		goto out_exit_phy;
+		return ret;
 	}
 
+	ret = phy_power_on(generic_phy);
+	if (ret)
+		goto out_exit_phy;
+
 	return 0;
 
 out_exit_phy:
@@ -1174,10 +1178,6 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 		goto out;
 	}
 
-	ret = phy_power_on(ufs->phy);
-	if (ret)
-		goto phy_off;
-
 	exynos_ufs_priv_init(hba, ufs);
 
 	if (ufs->drv_data->drv_init) {
@@ -1195,8 +1195,6 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 	exynos_ufs_config_smu(ufs);
 	return 0;
 
-phy_off:
-	phy_power_off(ufs->phy);
 out:
 	hba->priv = NULL;
 	return ret;
@@ -1514,9 +1512,14 @@ static int exynos_ufs_probe(struct platform_device *pdev)
 static int exynos_ufs_remove(struct platform_device *pdev)
 {
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 
 	pm_runtime_get_sync(&(pdev)->dev);
 	ufshcd_remove(hba);
+
+	phy_power_off(ufs->phy);
+	phy_exit(ufs->phy);
+
 	return 0;
 }
 
-- 
2.35.1



