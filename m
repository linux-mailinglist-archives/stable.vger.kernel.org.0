Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC1D46E8ED
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 14:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237747AbhLINUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 08:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbhLINUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 08:20:15 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE70C0617A1
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 05:16:41 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso4807872pjl.3
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 05:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JdDY5ij0RZVpRPH4PPkpJNHpzmZFEQMl/Zl2mv0q3gY=;
        b=lDl1VuXtMXA7wRFoKDUgDn3q4xhysFr5zJMACY+32x88H0EOmVtCZE34vaTW79/KJb
         qKIRo8w9JCRojsRqtmeZ7IM1HreQv4j1s21YPkanWoQ7c43yKaMUw2nztLkTflJz8lEJ
         VhRRzUKp00tXFBeQP8vBQ7P0KseWxGLBz6OnKZmP5Bs89UNVDEEJG4K3DQVjbPDTKYqW
         rgUPPOSlDM81fOld08rILF7VqxrexIeRJ5s1QCSfVUzri8nNII/l4biOrFz2+oUpwL10
         dQC8i7tsHf4voyvnOH4Co2MiX6kI08s/+qT4WiFxXwg78SoIYzT+iJZBLKfK0KLz0Tfq
         +DVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JdDY5ij0RZVpRPH4PPkpJNHpzmZFEQMl/Zl2mv0q3gY=;
        b=HJu0X4Ld1y0xikpbnXcEbUXro8/j/oBSnDzKy7VFBERr2UPZhFFghj7X4lx6M3+/qM
         NVWaxt+MZZgn+Up2WNyXS8eVt7UlVDjTFKgKuhsj9cpHfBGVJwH23E4ZkDo4zzY61uaB
         EmzivuBR8GSAD4ngbY2fOLQiTeC9K6AwhiWcEuv/AkCskqJ0jSE/2hsnGWyn55gmJZ8m
         Qvmrmg2l2YWj24syTVUvUIt6zvPe/KhCWHFQ8SQObTF6ylrbog8ivUrFFpYoXTQRssv7
         sLUjWqtsgBrdn7v6GEAoE79Qpmt/dfbWJec3DRZn2L1zMvuKtvdGup6aqjqU4aVU96kN
         CsKg==
X-Gm-Message-State: AOAM533sB8SjVg0XkOwLeJ2CAZTxgyZoQW0rQBmRVegeSVBpf4CZWLQU
        72P9F3auro0+c12M//OPdg+b
X-Google-Smtp-Source: ABdhPJwoPqUPuxXvgZszBjudXWUF9FIm/paRD0EaLXFP5jSKiuwj93WOjzmB1wi7bg5tOXdMiOoSRA==
X-Received: by 2002:a17:90b:4f49:: with SMTP id pj9mr15037953pjb.159.1639055801240;
        Thu, 09 Dec 2021 05:16:41 -0800 (PST)
Received: from localhost.localdomain ([202.21.42.41])
        by smtp.gmail.com with ESMTPSA id q6sm5591169pgs.19.2021.12.09.05.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 05:16:40 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     mhi@lists.linux.dev, hemantk@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        stable@vger.kernel.org, Pengyu Ma <mapengyu@gmail.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2] bus: mhi: core: Add support for forced PM resume
Date:   Thu,  9 Dec 2021 18:46:33 +0530
Message-Id: <20211209131633.4168-1-manivannan.sadhasivam@linaro.org>
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

Add an API mhi_pm_resume_force(), to force resuming irrespective of the
current MHI state. This fixes a regression with non functional ath11k WiFi
after suspend/resume cycle on some machines.

Bug report: https://bugzilla.kernel.org/show_bug.cgi?id=214179

Fixes: 020d3b26c07a ("bus: mhi: Early MHI resume failure in non M3 state")
Cc: stable@vger.kernel.org #5.13
Link: https://lore.kernel.org/regressions/871r5p0x2u.fsf@codeaurora.org/
Reported-by: Kalle Valo <kvalo@codeaurora.org>
Reported-by: Pengyu Ma <mapengyu@gmail.com>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
[mani: Switched to API, added bug report, reported-by tags and CCed stable]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---

Changes in v2:

* Switched to a new API "mhi_pm_resume_force()" instead of the "force" flag as
  suggested by Greg. The "force" flag is now used inside the API.

Greg: I'm sending this patch directly to you so that you can apply it to
char-misc once we get an ACK from Kalle.

 drivers/bus/mhi/core/pm.c             | 21 ++++++++++++++++++---
 drivers/net/wireless/ath/ath11k/mhi.c |  6 +++++-
 include/linux/mhi.h                   | 13 +++++++++++++
 3 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index fb99e3727155..547e6e769546 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -881,7 +881,7 @@ int mhi_pm_suspend(struct mhi_controller *mhi_cntrl)
 }
 EXPORT_SYMBOL_GPL(mhi_pm_suspend);
 
-int mhi_pm_resume(struct mhi_controller *mhi_cntrl)
+static int __mhi_pm_resume(struct mhi_controller *mhi_cntrl, bool force)
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
@@ -940,8 +944,19 @@ int mhi_pm_resume(struct mhi_controller *mhi_cntrl)
 
 	return 0;
 }
+
+int mhi_pm_resume(struct mhi_controller *mhi_cntrl)
+{
+	return __mhi_pm_resume(mhi_cntrl, false);
+}
 EXPORT_SYMBOL_GPL(mhi_pm_resume);
 
+int mhi_pm_resume_force(struct mhi_controller *mhi_cntrl)
+{
+	return __mhi_pm_resume(mhi_cntrl, true);
+}
+EXPORT_SYMBOL_GPL(mhi_pm_resume_force);
+
 int __mhi_device_get_sync(struct mhi_controller *mhi_cntrl)
 {
 	int ret;
diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index 26c7ae242db6..49c0b1ad40a0 100644
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
+		ret = mhi_pm_resume_force(ab_pci->mhi_ctrl);
 		break;
 	case ATH11K_MHI_TRIGGER_RDDM:
 		ret = mhi_force_rddm_mode(ab_pci->mhi_ctrl);
diff --git a/include/linux/mhi.h b/include/linux/mhi.h
index 723985879035..a5cc4cdf9cc8 100644
--- a/include/linux/mhi.h
+++ b/include/linux/mhi.h
@@ -663,6 +663,19 @@ int mhi_pm_suspend(struct mhi_controller *mhi_cntrl);
  */
 int mhi_pm_resume(struct mhi_controller *mhi_cntrl);
 
+/**
+ * mhi_pm_resume_force - Force resume MHI from suspended state
+ * @mhi_cntrl: MHI controller
+ *
+ * Resume the device irrespective of its MHI state. As per the MHI spec, devices
+ * has to be in M3 state during resume. But some devices seem to be in a
+ * different MHI state other than M3 but they continue working fine if allowed.
+ * This API is intented to be used for such devices.
+ *
+ * Return: 0 if the resume succeeds, a negative error code otherwise
+ */
+int mhi_pm_resume_force(struct mhi_controller *mhi_cntrl);
+
 /**
  * mhi_download_rddm_image - Download ramdump image from device for
  *                           debugging purpose.
-- 
2.25.1

