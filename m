Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD6B46A0FC
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 17:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385852AbhLFQTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 11:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386031AbhLFQSq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 11:18:46 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB46C08E843
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 08:11:07 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 8so10592987pfo.4
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 08:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/dZMe5fXW3JmkstQUnuTxaguikQO8croA43e/A9yBnw=;
        b=wsxIo8iRiao/IrGDfq47xrllVJ4TjbrPMq5pi3ujnxN/VKCJ3gsfxKRCeoeCqPfYQu
         kOwY5U32UUnpRggGW8w10rv9Qb+gMMChBODZE8cet49sqH0aXLIuy3Hy/fNcF2I49xtW
         w/tPBkVH6OZ0gml4qbyNHA2LKoSRu2Duh75QZw7O02/WxlK7y7iu/eS+gRwq5vnZ0TMf
         4NrQWs80FVlPsg+02Ay9mkBOTx6d4n9cp8+8F0Dpa7NfdGkA7BMrgrVXUDuNa+sp9Oa0
         tBWh2Wm8WKIWHNKf1R7ackwqOJUltuACyxAA6XpX27PTUDAPkFN9K/s0tPCDvwcBdLVB
         v8Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/dZMe5fXW3JmkstQUnuTxaguikQO8croA43e/A9yBnw=;
        b=WpD0cQnkmsrwCCW//RuC9Czm90wDPjN8h46boQ7GHhT8icpDPuJbE2UQMmoNUnz9t5
         e2rm9IfS8vVEZhhnPlPEj8fbym7SuAxHM46lqpffGO68cDSjwMhb7Utmdp8nEWV4gwml
         G1zs7F2o8290ySEACbz+ZLi+GTWrQp5owIpNDosttpHwtkvnP1pMI0VYrU+3ZXhVgF1m
         7cQKBUzfZ2wjIvWS6jngFG4URXOsHWBTZ/0aTPvCfw88vGpulZS2NchueuVR/WH9TgqF
         sppPwswuPTEDSW9AIAw1JeJQJcMOp9XgYiBYk5AdUf5KCo0AE+egvqy2v+oqDjm8wBuy
         PyFQ==
X-Gm-Message-State: AOAM5329omIU8l7RAV6IAchJB8PkdOreAeXznN9so7DE3QOOz8ZX8ceT
        bSOczzzhPd6FuhzW4R/N7EH6
X-Google-Smtp-Source: ABdhPJzHztOd8XGPiN1RUx+EQUVKeXqRT/D1cHtxog5GiB7PeT8WgTwjvv+39GKJ//C4Nqx58PR66g==
X-Received: by 2002:a05:6a00:1594:b0:4ae:dc6:f344 with SMTP id u20-20020a056a00159400b004ae0dc6f344mr7919655pfk.56.1638807066912;
        Mon, 06 Dec 2021 08:11:06 -0800 (PST)
Received: from localhost.localdomain ([117.217.176.38])
        by smtp.gmail.com with ESMTPSA id lr6sm11288968pjb.0.2021.12.06.08.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 08:11:06 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     mhi@lists.linux.dev
Cc:     hemantk@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        stable@vger.kernel.org, Pengyu Ma <mapengyu@gmail.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH] bus: mhi: core: Add support for forced PM resume
Date:   Mon,  6 Dec 2021 21:40:59 +0530
Message-Id: <20211206161059.107007-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

For whatever reason, some devices like QCA6390, WCN6855 using ath11k
are not in M3 state during PM resume, but still functional. The
mhi_pm_resume should then not fail in those cases, and let the higher
level device specific stack continue resuming process.

Add a new parameter to mhi_pm_resume, to force resuming, whatever the
current MHI state is. This fixes a regression with non functional
ath11k WiFi after suspend/resume cycle on some machines.

Bug report: https://bugzilla.kernel.org/show_bug.cgi?id=214179

Cc: stable@vger.kernel.org #5.13
Fixes: 020d3b26c07a ("bus: mhi: Early MHI resume failure in non M3 state")
Reported-by: Kalle Valo <kvalo@codeaurora.org>
Reported-by: Pengyu Ma <mapengyu@gmail.com>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
[mani: Added comment, bug report, added reported-by tags and CCed stable]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/core/pm.c             | 10 +++++++---
 drivers/bus/mhi/pci_generic.c         |  2 +-
 drivers/net/wireless/ath/ath11k/mhi.c |  6 +++++-
 include/linux/mhi.h                   |  3 ++-
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index 7464f5d09973..4ddd266e042e 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -881,7 +881,7 @@ int mhi_pm_suspend(struct mhi_controller *mhi_cntrl)
 }
 EXPORT_SYMBOL_GPL(mhi_pm_suspend);
 
-int mhi_pm_resume(struct mhi_controller *mhi_cntrl)
+int mhi_pm_resume(struct mhi_controller *mhi_cntrl, bool force)
 {
 	struct mhi_chan *itr, *tmp;
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
@@ -898,8 +898,12 @@ int mhi_pm_resume(struct mhi_controller *mhi_cntrl)
 	if (MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state))
 		return -EIO;
 
-	if (mhi_get_mhi_state(mhi_cntrl) != MHI_STATE_M3)
-		return -EINVAL;
+	if (mhi_get_mhi_state(mhi_cntrl) != MHI_STATE_M3) {
+		dev_warn(dev, "Resuming from non M3 state (%s)\n",
+			 TO_MHI_STATE_STR(mhi_get_mhi_state(mhi_cntrl)));
+		if (!force)
+			return -EINVAL;
+	}
 
 	/* Notify clients about exiting LPM */
 	list_for_each_entry_safe(itr, tmp, &mhi_cntrl->lpm_chans, node) {
diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 9ef41354237c..efd1da66fdf9 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -959,7 +959,7 @@ static int __maybe_unused mhi_pci_runtime_resume(struct device *dev)
 		return 0; /* Nothing to do at MHI level */
 
 	/* Exit M3, transition to M0 state */
-	err = mhi_pm_resume(mhi_cntrl);
+	err = mhi_pm_resume(mhi_cntrl, false);
 	if (err) {
 		dev_err(&pdev->dev, "failed to resume device: %d\n", err);
 		goto err_recovery;
diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index 26c7ae242db6..f1f2fa2d690d 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -533,7 +533,11 @@ static int ath11k_mhi_set_state(struct ath11k_pci *ab_pci,
 		ret = mhi_pm_suspend(ab_pci->mhi_ctrl);
 		break;
 	case ATH11K_MHI_RESUME:
-		ret = mhi_pm_resume(ab_pci->mhi_ctrl);
+		/* Do force MHI resume as some devices like QCA6390, WCN6855
+		 * are not in M3 state but they are functional. So just ignore
+		 * the MHI state while resuming.
+		 */
+		ret = mhi_pm_resume(ab_pci->mhi_ctrl, true);
 		break;
 	case ATH11K_MHI_TRIGGER_RDDM:
 		ret = mhi_force_rddm_mode(ab_pci->mhi_ctrl);
diff --git a/include/linux/mhi.h b/include/linux/mhi.h
index 723985879035..102303288cee 100644
--- a/include/linux/mhi.h
+++ b/include/linux/mhi.h
@@ -660,8 +660,9 @@ int mhi_pm_suspend(struct mhi_controller *mhi_cntrl);
 /**
  * mhi_pm_resume - Resume MHI from suspended state
  * @mhi_cntrl: MHI controller
+ * @force: Force resuming to M0 irrespective of the device MHI state
  */
-int mhi_pm_resume(struct mhi_controller *mhi_cntrl);
+int mhi_pm_resume(struct mhi_controller *mhi_cntrl, bool force);
 
 /**
  * mhi_download_rddm_image - Download ramdump image from device for
-- 
2.25.1

