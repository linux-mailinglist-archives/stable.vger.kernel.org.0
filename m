Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D15E592091
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiHNP25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239891AbiHNP2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:28:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5A9B1CB;
        Sun, 14 Aug 2022 08:28:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A90D1B80B27;
        Sun, 14 Aug 2022 15:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAF2C433D7;
        Sun, 14 Aug 2022 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660490913;
        bh=a4/LmbqCcfw4a/dBf+i02Qljn4gGGMGLZNQ7He7NoVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWp9wQyEuxWVxFCNGDYVRYbbPEOniSDzHwVKgsl0Ym9sbEJgwzEiaA53/xqYWws6l
         MBXXnr16QSi4KNOrn+ugD7UzqqITFGRq2OoG7BUcg6HBthDY8Ec4sc8gGXaOjlKYD+
         e+FjO3RutjLQq3Nm3UQyH3Ad1IEm5ZmzrFa/rFF4rF4rYPw5bk0ahDtq8vHXTYWddI
         viMCbmTSGDTr4CKP8CLxyd5ya35igj5QCbi0KJsHodYT4cRc7PPnuE2+L+H2KaKvDv
         u+LrQChXSJLq3d/BLzanfufj1B+ftQAMkK6jcorwYigMQkFBrqrvEcY7qXvn511hgL
         MS+5RhmRyrYcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Po-Wen Kao <powen.kao@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        matthias.bgg@gmail.com, linux-scsi@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 18/64] scsi: ufs: ufs-mediatek: Fix the timing of configuring device regulators
Date:   Sun, 14 Aug 2022 11:23:51 -0400
Message-Id: <20220814152437.2374207-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814152437.2374207-1-sashal@kernel.org>
References: <20220814152437.2374207-1-sashal@kernel.org>
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

From: Po-Wen Kao <powen.kao@mediatek.com>

[ Upstream commit 3fd23b8dfb54d9b74eba6dfdd3225db3ac116785 ]

Currently the LPM configurations of device regulators may not work since
VCC is not disabled yet while ufs_mtk_vreg_set_lpm() is executed.

Fix this by changing the timing of invoking ufs_mtk_vreg_set_lpm().

Link: https://lore.kernel.org/r/20220616053725.5681-5-stanley.chu@mediatek.com
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Po-Wen Kao <powen.kao@mediatek.com>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-mediatek.c | 58 ++++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index beabc3ccd30b..8b9daa281cc4 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1026,7 +1026,6 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 		 * ufshcd_suspend() re-enabling regulators while vreg is still
 		 * in low-power mode.
 		 */
-		ufs_mtk_vreg_set_lpm(hba, true);
 		err = ufs_mtk_mphy_power_on(hba, false);
 		if (err)
 			goto fail;
@@ -1050,12 +1049,13 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
 	int err;
 
+	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
+		ufs_mtk_vreg_set_lpm(hba, false);
+
 	err = ufs_mtk_mphy_power_on(hba, true);
 	if (err)
 		goto fail;
 
-	ufs_mtk_vreg_set_lpm(hba, false);
-
 	if (ufshcd_is_link_hibern8(hba)) {
 		err = ufs_mtk_link_set_hpm(hba);
 		if (err)
@@ -1220,9 +1220,57 @@ static int ufs_mtk_remove(struct platform_device *pdev)
 	return 0;
 }
 
+int ufs_mtk_system_suspend(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int ret;
+
+	ret = ufshcd_system_suspend(dev);
+	if (ret)
+		return ret;
+
+	ufs_mtk_vreg_set_lpm(hba, true);
+
+	return 0;
+}
+
+int ufs_mtk_system_resume(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	ufs_mtk_vreg_set_lpm(hba, false);
+
+	return ufshcd_system_resume(dev);
+}
+
+int ufs_mtk_runtime_suspend(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int ret = 0;
+
+	ret = ufshcd_runtime_suspend(dev);
+	if (ret)
+		return ret;
+
+	ufs_mtk_vreg_set_lpm(hba, true);
+
+	return 0;
+}
+
+int ufs_mtk_runtime_resume(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	ufs_mtk_vreg_set_lpm(hba, false);
+
+	return ufshcd_runtime_resume(dev);
+}
+
 static const struct dev_pm_ops ufs_mtk_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
-	SET_RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(ufs_mtk_system_suspend,
+				ufs_mtk_system_resume)
+	SET_RUNTIME_PM_OPS(ufs_mtk_runtime_suspend,
+			   ufs_mtk_runtime_resume, NULL)
 	.prepare	 = ufshcd_suspend_prepare,
 	.complete	 = ufshcd_resume_complete,
 };
-- 
2.35.1

