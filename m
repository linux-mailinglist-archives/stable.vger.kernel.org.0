Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CF4472A03
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240420AbhLMK3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344593AbhLMK1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:27:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A6DC09B10A;
        Mon, 13 Dec 2021 02:01:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B122FB80E0E;
        Mon, 13 Dec 2021 10:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC19C34613;
        Mon, 13 Dec 2021 10:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389680;
        bh=REq1PlgmIlPZkkXhatpIYtHZqCoVyQX8kVoRk5jt8Co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lArD2BoY33+ClYY5PP96bya0NGZejVByVhzVdRfoaDns3cE8FMY/3Q+mt+KQtxXqt
         enK2/mY9a7MI/lKGQXIyY+uY6JzJr6LKz5O3HuggxXkKALyXN5rLNfNlqAWgW6h8j2
         Arcbn9JX3egeD4+konHO5kTTIep+9XdmFtoc+bhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Pengyu Ma <mapengyu@gmail.com>, Kalle Valo <kvalo@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.15 161/171] bus: mhi: core: Add support for forced PM resume
Date:   Mon, 13 Dec 2021 10:31:16 +0100
Message-Id: <20211213092950.434881701@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

commit cab2d3fd6866e089b5c50db09dece131f85bfebd upstream.

For whatever reason, some devices like QCA6390, WCN6855 using ath11k
are not in M3 state during PM resume, but still functional. The
mhi_pm_resume should then not fail in those cases, and let the higher
level device specific stack continue resuming process.

Add an API mhi_pm_resume_force(), to force resuming irrespective of the
current MHI state. This fixes a regression with non functional ath11k WiFi
after suspend/resume cycle on some machines.

Bug report: https://bugzilla.kernel.org/show_bug.cgi?id=214179

Link: https://lore.kernel.org/regressions/871r5p0x2u.fsf@codeaurora.org/
Fixes: 020d3b26c07a ("bus: mhi: Early MHI resume failure in non M3 state")
Cc: stable@vger.kernel.org #5.13
Reported-by: Kalle Valo <kvalo@codeaurora.org>
Reported-by: Pengyu Ma <mapengyu@gmail.com>
Tested-by: Kalle Valo <kvalo@kernel.org>
Acked-by: Kalle Valo <kvalo@kernel.org>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
[mani: Switched to API, added bug report, reported-by tags and CCed stable]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20211209131633.4168-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/core/pm.c             |   21 ++++++++++++++++++---
 drivers/net/wireless/ath/ath11k/mhi.c |    6 +++++-
 include/linux/mhi.h                   |   13 +++++++++++++
 3 files changed, 36 insertions(+), 4 deletions(-)

--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -881,7 +881,7 @@ int mhi_pm_suspend(struct mhi_controller
 }
 EXPORT_SYMBOL_GPL(mhi_pm_suspend);
 
-int mhi_pm_resume(struct mhi_controller *mhi_cntrl)
+static int __mhi_pm_resume(struct mhi_controller *mhi_cntrl, bool force)
 {
 	struct mhi_chan *itr, *tmp;
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
@@ -898,8 +898,12 @@ int mhi_pm_resume(struct mhi_controller
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
@@ -940,8 +944,19 @@ int mhi_pm_resume(struct mhi_controller
 
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
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -533,7 +533,11 @@ static int ath11k_mhi_set_state(struct a
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
--- a/include/linux/mhi.h
+++ b/include/linux/mhi.h
@@ -664,6 +664,19 @@ int mhi_pm_suspend(struct mhi_controller
 int mhi_pm_resume(struct mhi_controller *mhi_cntrl);
 
 /**
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
+/**
  * mhi_download_rddm_image - Download ramdump image from device for
  *                           debugging purpose.
  * @mhi_cntrl: MHI controller


