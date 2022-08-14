Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F204592184
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240947AbiHNPhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240712AbiHNPgn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:36:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4411F2DF;
        Sun, 14 Aug 2022 08:32:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37B3860BC9;
        Sun, 14 Aug 2022 15:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB88C433D6;
        Sun, 14 Aug 2022 15:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491123;
        bh=njb5nsYY32sNatF5cFueoIMtAne14vj0zsb0g2m84FQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NIloLY7KBzihs5IXb5A/tYAMrtpyE+keWBBUlSc/+DZ1A/9SFmDqhGokBuuefLvLJ
         O5pcgvgHP58kJ35dHw2n7Oa6igbNG/GOdQ/pRIRAdgNijw0R2PMJqUYFOzZcyoqhvX
         8m8GCZy2d0aMMGGCV03GbJP+AEG2Jy9nPad2TIAhqv5uTFrAuO1yaC5igzHWJrpn7o
         JKMbJEWfYxy0uTknhfVtrXCCzhymcaTbcX2B0AMzOI8OTV6ylGW0oupF2PmJYXFT67
         7ySyPhiiFjU2epfazQBKD4k5pXJdTCNPS9wyfyZFfe8TJUvW97bfhqaVzL/NPWqxJH
         QLNAdbfNKX+Dg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chanho Park <chanho61.park@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        alim.akhtar@samsung.com, beanhuo@micron.com, bvanassche@acm.org,
        peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 34/56] scsi: ufs: ufs-exynos: Change ufs phy control sequence
Date:   Sun, 14 Aug 2022 11:30:04 -0400
Message-Id: <20220814153026.2377377-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153026.2377377-1-sashal@kernel.org>
References: <20220814153026.2377377-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/scsi/ufs/ufs-exynos.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 474a4a064a68..3ff9bd77f2c6 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -909,9 +909,13 @@ static int exynos_ufs_phy_init(struct exynos_ufs *ufs)
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
@@ -1173,10 +1177,6 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 		goto out;
 	}
 
-	ret = phy_power_on(ufs->phy);
-	if (ret)
-		goto phy_off;
-
 	exynos_ufs_priv_init(hba, ufs);
 
 	if (ufs->drv_data->drv_init) {
@@ -1194,8 +1194,6 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 	exynos_ufs_config_smu(ufs);
 	return 0;
 
-phy_off:
-	phy_power_off(ufs->phy);
 out:
 	hba->priv = NULL;
 	return ret;
@@ -1513,9 +1511,14 @@ static int exynos_ufs_probe(struct platform_device *pdev)
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

