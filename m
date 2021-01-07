Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127D92ED293
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbhAGOeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:34:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727885AbhAGOeW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:34:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B7DE22AAA;
        Thu,  7 Jan 2021 14:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610030021;
        bh=yYA+MGHW/+TtHZWGYi2rBWDMZ0naSYSzdR8S3kuTsrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYWIG+4iHBggd4QjsrNVJHcTFZP0szZeuSDVhKn3ctOrY9s5VQkThzj4P8x6vRCel
         vj57fOc6calXEcJyOosvObG3dL+yz+E3algYPwW1sjabZ5yrVBgPvS58Ghw8gvVlHW
         KutK32qc2umoR9Y8QI1TK9Tnk3W/UROnTiqKvjjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 11/20] scsi: ufs: Allow an error return value from ->device_reset()
Date:   Thu,  7 Jan 2021 15:34:06 +0100
Message-Id: <20210107143053.949330774@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.392839477@linuxfoundation.org>
References: <20210107143052.392839477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



