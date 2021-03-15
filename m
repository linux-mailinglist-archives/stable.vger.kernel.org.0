Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D173F33B961
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhCOOCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232909AbhCOOAJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7E1064EF9;
        Mon, 15 Mar 2021 13:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816794;
        bh=shv8udy1T5SfdI4X3meTtkkgWarnyXMjCjXWe/98JHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHpRXDPXy+zYG/ym2WxBnhFvqniOool+kcFs/frmjJGmiEu5hCr/VjIkIGqUuM6fw
         luuvBCRwnvvQkoW3xFkGKtr7qun3Soijc46jI+mmQ+eTMdp3rAfBObQ8iEj0dU8oSU
         EyNQlJs6PBapQa2M6w8M9OZx3NZYu25KFCwhOgYQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 128/306] scsi: ufs: Protect some contexts from unexpected clock scaling
Date:   Mon, 15 Mar 2021 14:53:11 +0100
Message-Id: <20210315135511.986893769@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Can Guo <cang@codeaurora.org>

[ Upstream commit 0e9d4ca43ba8112821397f56a26d20682001c011 ]

In contexts like suspend, shutdown, and error handling we need to
suspend devfreq to make sure these contexts won't be disturbed by
clock scaling.  However, suspending devfreq is not enough since users
can still trigger a clock scaling by manipulating the devfreq sysfs
nodes like min/max_freq and governor even after devfreq is
suspended. Moreover, mere suspending devfreq cannot synchroinze a
clock scaling which has already been invoked through these sysfs
nodes. Add one more flag in struct clk_scaling and wrap the entire
func ufshcd_devfreq_scale() with the clk_scaling_lock, so that we can
use this flag and clk_scaling_lock to control and synchronize clock
scaling invoked through devfreq sysfs nodes.

Link: https://lore.kernel.org/r/1611137065-14266-2-git-send-email-cang@codeaurora.org
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 80 ++++++++++++++++++++++++---------------
 drivers/scsi/ufs/ufshcd.h |  6 ++-
 2 files changed, 54 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a568f7ae0566..16e1bd1aa49d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1184,19 +1184,30 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	 */
 	ufshcd_scsi_block_requests(hba);
 	down_write(&hba->clk_scaling_lock);
-	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
+
+	if (!hba->clk_scaling.is_allowed ||
+	    ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
 		ret = -EBUSY;
 		up_write(&hba->clk_scaling_lock);
 		ufshcd_scsi_unblock_requests(hba);
+		goto out;
 	}
 
+	/* let's not get into low power until clock scaling is completed */
+	ufshcd_hold(hba, false);
+
+out:
 	return ret;
 }
 
-static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
+static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
 {
-	up_write(&hba->clk_scaling_lock);
+	if (writelock)
+		up_write(&hba->clk_scaling_lock);
+	else
+		up_read(&hba->clk_scaling_lock);
 	ufshcd_scsi_unblock_requests(hba);
+	ufshcd_release(hba);
 }
 
 /**
@@ -1211,13 +1222,11 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
 static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 {
 	int ret = 0;
-
-	/* let's not get into low power until clock scaling is completed */
-	ufshcd_hold(hba, false);
+	bool is_writelock = true;
 
 	ret = ufshcd_clock_scaling_prepare(hba);
 	if (ret)
-		goto out;
+		return ret;
 
 	/* scale down the gear before scaling down clocks */
 	if (!scale_up) {
@@ -1243,14 +1252,12 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 	}
 
 	/* Enable Write Booster if we have scaled up else disable it */
-	up_write(&hba->clk_scaling_lock);
+	downgrade_write(&hba->clk_scaling_lock);
+	is_writelock = false;
 	ufshcd_wb_ctrl(hba, scale_up);
-	down_write(&hba->clk_scaling_lock);
 
 out_unprepare:
-	ufshcd_clock_scaling_unprepare(hba);
-out:
-	ufshcd_release(hba);
+	ufshcd_clock_scaling_unprepare(hba, is_writelock);
 	return ret;
 }
 
@@ -1524,7 +1531,7 @@ static ssize_t ufshcd_clkscale_enable_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", hba->clk_scaling.is_allowed);
+	return snprintf(buf, PAGE_SIZE, "%d\n", hba->clk_scaling.is_enabled);
 }
 
 static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
@@ -1538,7 +1545,7 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 		return -EINVAL;
 
 	value = !!value;
-	if (value == hba->clk_scaling.is_allowed)
+	if (value == hba->clk_scaling.is_enabled)
 		goto out;
 
 	pm_runtime_get_sync(hba->dev);
@@ -1547,7 +1554,7 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 	cancel_work_sync(&hba->clk_scaling.suspend_work);
 	cancel_work_sync(&hba->clk_scaling.resume_work);
 
-	hba->clk_scaling.is_allowed = value;
+	hba->clk_scaling.is_enabled = value;
 
 	if (value) {
 		ufshcd_resume_clkscaling(hba);
@@ -1885,8 +1892,6 @@ static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
 	snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
 		 hba->host->host_no);
 	hba->clk_scaling.workq = create_singlethread_workqueue(wq_name);
-
-	ufshcd_clkscaling_init_sysfs(hba);
 }
 
 static void ufshcd_exit_clk_scaling(struct ufs_hba *hba)
@@ -1894,6 +1899,8 @@ static void ufshcd_exit_clk_scaling(struct ufs_hba *hba)
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
 
+	if (hba->clk_scaling.enable_attr.attr.name)
+		device_remove_file(hba->dev, &hba->clk_scaling.enable_attr);
 	destroy_workqueue(hba->clk_scaling.workq);
 	ufshcd_devfreq_remove(hba);
 }
@@ -1958,7 +1965,7 @@ static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 	if (!hba->clk_scaling.active_reqs++)
 		queue_resume_work = true;
 
-	if (!hba->clk_scaling.is_allowed || hba->pm_op_in_progress)
+	if (!hba->clk_scaling.is_enabled || hba->pm_op_in_progress)
 		return;
 
 	if (queue_resume_work)
@@ -5744,18 +5751,24 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 		ufshcd_vops_resume(hba, pm_op);
 	} else {
 		ufshcd_hold(hba, false);
-		if (hba->clk_scaling.is_allowed) {
+		if (hba->clk_scaling.is_enabled) {
 			cancel_work_sync(&hba->clk_scaling.suspend_work);
 			cancel_work_sync(&hba->clk_scaling.resume_work);
 			ufshcd_suspend_clkscaling(hba);
 		}
+		down_write(&hba->clk_scaling_lock);
+		hba->clk_scaling.is_allowed = false;
+		up_write(&hba->clk_scaling_lock);
 	}
 }
 
 static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 {
 	ufshcd_release(hba);
-	if (hba->clk_scaling.is_allowed)
+	down_write(&hba->clk_scaling_lock);
+	hba->clk_scaling.is_allowed = true;
+	up_write(&hba->clk_scaling_lock);
+	if (hba->clk_scaling.is_enabled)
 		ufshcd_resume_clkscaling(hba);
 	pm_runtime_put(hba->dev);
 }
@@ -7741,12 +7754,14 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 			sizeof(struct ufs_pa_layer_attr));
 		hba->clk_scaling.saved_pwr_info.is_valid = true;
 		if (!hba->devfreq) {
+			hba->clk_scaling.is_allowed = true;
 			ret = ufshcd_devfreq_init(hba);
 			if (ret)
 				goto out;
-		}
 
-		hba->clk_scaling.is_allowed = true;
+			hba->clk_scaling.is_enabled = true;
+			ufshcd_clkscaling_init_sysfs(hba);
+		}
 	}
 
 	ufs_bsg_probe(hba);
@@ -8661,11 +8676,14 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	ufshcd_hold(hba, false);
 	hba->clk_gating.is_suspended = true;
 
-	if (hba->clk_scaling.is_allowed) {
+	if (hba->clk_scaling.is_enabled) {
 		cancel_work_sync(&hba->clk_scaling.suspend_work);
 		cancel_work_sync(&hba->clk_scaling.resume_work);
 		ufshcd_suspend_clkscaling(hba);
 	}
+	down_write(&hba->clk_scaling_lock);
+	hba->clk_scaling.is_allowed = false;
+	up_write(&hba->clk_scaling_lock);
 
 	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
 			req_link_state == UIC_LINK_ACTIVE_STATE) {
@@ -8762,8 +8780,6 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	goto out;
 
 set_link_active:
-	if (hba->clk_scaling.is_allowed)
-		ufshcd_resume_clkscaling(hba);
 	ufshcd_vreg_set_hpm(hba);
 	/*
 	 * Device hardware reset is required to exit DeepSleep. Also, for
@@ -8787,7 +8803,10 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (!ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE))
 		ufshcd_disable_auto_bkops(hba);
 enable_gating:
-	if (hba->clk_scaling.is_allowed)
+	down_write(&hba->clk_scaling_lock);
+	hba->clk_scaling.is_allowed = true;
+	up_write(&hba->clk_scaling_lock);
+	if (hba->clk_scaling.is_enabled)
 		ufshcd_resume_clkscaling(hba);
 	hba->clk_gating.is_suspended = false;
 	hba->dev_info.b_rpm_dev_flush_capable = false;
@@ -8891,7 +8910,10 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	hba->clk_gating.is_suspended = false;
 
-	if (hba->clk_scaling.is_allowed)
+	down_write(&hba->clk_scaling_lock);
+	hba->clk_scaling.is_allowed = true;
+	up_write(&hba->clk_scaling_lock);
+	if (hba->clk_scaling.is_enabled)
 		ufshcd_resume_clkscaling(hba);
 
 	/* Enable Auto-Hibernate if configured */
@@ -8917,8 +8939,6 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	ufshcd_vreg_set_lpm(hba);
 disable_irq_and_vops_clks:
 	ufshcd_disable_irq(hba);
-	if (hba->clk_scaling.is_allowed)
-		ufshcd_suspend_clkscaling(hba);
 	ufshcd_setup_clocks(hba, false);
 	if (ufshcd_is_clkgating_allowed(hba)) {
 		hba->clk_gating.state = CLKS_OFF;
@@ -9155,8 +9175,6 @@ void ufshcd_remove(struct ufs_hba *hba)
 
 	ufshcd_exit_clk_scaling(hba);
 	ufshcd_exit_clk_gating(hba);
-	if (ufshcd_is_clkscaling_supported(hba))
-		device_remove_file(hba->dev, &hba->clk_scaling.enable_attr);
 	ufshcd_hba_exit(hba);
 }
 EXPORT_SYMBOL_GPL(ufshcd_remove);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 1885ec9126c4..7d0b00f23761 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -419,7 +419,10 @@ struct ufs_saved_pwr_info {
  * @suspend_work: worker to suspend devfreq
  * @resume_work: worker to resume devfreq
  * @min_gear: lowest HS gear to scale down to
- * @is_allowed: tracks if scaling is currently allowed or not
+ * @is_enabled: tracks if scaling is currently enabled or not, controlled by
+		clkscale_enable sysfs node
+ * @is_allowed: tracks if scaling is currently allowed or not, used to block
+		clock scaling which is not invoked from devfreq governor
  * @is_busy_started: tracks if busy period has started or not
  * @is_suspended: tracks if devfreq is suspended or not
  */
@@ -434,6 +437,7 @@ struct ufs_clk_scaling {
 	struct work_struct suspend_work;
 	struct work_struct resume_work;
 	u32 min_gear;
+	bool is_enabled;
 	bool is_allowed;
 	bool is_busy_started;
 	bool is_suspended;
-- 
2.30.1



