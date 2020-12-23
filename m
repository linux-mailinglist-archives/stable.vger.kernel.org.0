Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3957E2E120B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgLWCSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:18:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbgLWCSL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C951221E5;
        Wed, 23 Dec 2020 02:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689832;
        bh=yYA+MGHW/+TtHZWGYi2rBWDMZ0naSYSzdR8S3kuTsrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zx88YomxhB5Kw3zBAtaWmBB89/MDI996ICvSEIdBZOwjXIC0HGzfMjdtAY1NMb85g
         igmGvEjO97wKIMgFBJ65iDmEeZaJoch8Kb08niOkvZPLHSNvBmTwrVaIGO4f+VtFG2
         8jbWOA83UvJy0r7wWUkCBusH+todr5v/fwfPRzdAXehUYXWYu7W7BT5NS/AwA4Youz
         1Nsysa+Gr/bEj9+Ro3L6ZpnL9ZD+qdykaulDcEvuwdLSzgaRoOU0ekbZnHIMzz6E4h
         0C3tNJZVqC8VN3zNpjDGbIERrTMqJQNXp7SfpGS8No0gTfT/VuEUpcU/8IJwoehvcY
         Tx1i+DMNRe/3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 034/217] scsi: ufs: Allow an error return value from ->device_reset()
Date:   Tue, 22 Dec 2020 21:13:23 -0500
Message-Id: <20201223021626.2790791-34-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 151f1b664ffbb847c7fbbce5a5b8580f1b9b1d98 ]

It is simpler for drivers to provide a ->device_reset() callback
irrespective of whether the GPIO, or firmware interface necessary to do the
reset, is discovered during probe.

Change ->device_reset() to return an error code.  Drivers that provide the
callback, but do not do the reset operation should return -EOPNOTSUPP.

Link: https://lore.kernel.org/r/20201103141403.2142-3-adrian.hunter@intel.com
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bean huo <beanhuo@micron.com>
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-mediatek.c |  4 +++-
 drivers/scsi/ufs/ufs-qcom.c     |  6 ++++--
 drivers/scsi/ufs/ufshcd.h       | 11 +++++++----
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 8df73bc2f8cb2..914a827a93ee8 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -743,7 +743,7 @@ static int ufs_mtk_link_startup_notify(struct ufs_hba *hba,
 	return ret;
 }
 
-static void ufs_mtk_device_reset(struct ufs_hba *hba)
+static int ufs_mtk_device_reset(struct ufs_hba *hba)
 {
 	struct arm_smccc_res res;
 
@@ -764,6 +764,8 @@ static void ufs_mtk_device_reset(struct ufs_hba *hba)
 	usleep_range(10000, 15000);
 
 	dev_info(hba->dev, "device reset done\n");
+
+	return 0;
 }
 
 static int ufs_mtk_link_set_hpm(struct ufs_hba *hba)
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index f9d6ef3565407..a244c8ae1b4eb 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1421,13 +1421,13 @@ static void ufs_qcom_dump_dbg_regs(struct ufs_hba *hba)
  *
  * Toggles the (optional) reset line to reset the attached device.
  */
-static void ufs_qcom_device_reset(struct ufs_hba *hba)
+static int ufs_qcom_device_reset(struct ufs_hba *hba)
 {
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 
 	/* reset gpio is optional */
 	if (!host->device_reset)
-		return;
+		return -EOPNOTSUPP;
 
 	/*
 	 * The UFS device shall detect reset pulses of 1us, sleep for 10us to
@@ -1438,6 +1438,8 @@ static void ufs_qcom_device_reset(struct ufs_hba *hba)
 
 	gpiod_set_value_cansleep(host->device_reset, 0);
 	usleep_range(10, 15);
+
+	return 0;
 }
 
 #if IS_ENABLED(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e0f00a42371c5..de97971e2d865 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -318,7 +318,7 @@ struct ufs_hba_variant_ops {
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
 	int	(*phy_initialization)(struct ufs_hba *);
-	void	(*device_reset)(struct ufs_hba *hba);
+	int	(*device_reset)(struct ufs_hba *hba);
 	void	(*config_scaling_param)(struct ufs_hba *hba,
 					struct devfreq_dev_profile *profile,
 					void *data);
@@ -1181,9 +1181,12 @@ static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
 static inline void ufshcd_vops_device_reset(struct ufs_hba *hba)
 {
 	if (hba->vops && hba->vops->device_reset) {
-		hba->vops->device_reset(hba);
-		ufshcd_set_ufs_dev_active(hba);
-		ufshcd_update_reg_hist(&hba->ufs_stats.dev_reset, 0);
+		int err = hba->vops->device_reset(hba);
+
+		if (!err)
+			ufshcd_set_ufs_dev_active(hba);
+		if (err != -EOPNOTSUPP)
+			ufshcd_update_reg_hist(&hba->ufs_stats.dev_reset, err);
 	}
 }
 
-- 
2.27.0

