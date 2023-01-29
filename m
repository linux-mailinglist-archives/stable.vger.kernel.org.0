Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D52667FF5B
	for <lists+stable@lfdr.de>; Sun, 29 Jan 2023 14:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjA2N1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Jan 2023 08:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2N1b (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Jan 2023 08:27:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26778125B8
        for <stable@vger.kernel.org>; Sun, 29 Jan 2023 05:27:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B79860D41
        for <stable@vger.kernel.org>; Sun, 29 Jan 2023 13:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C431C433EF;
        Sun, 29 Jan 2023 13:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674998849;
        bh=4hUgc1vm58HNbmqsKiNkkWuWGP4AetqP+5CgUzYSCQY=;
        h=Subject:To:Cc:From:Date:From;
        b=0x6Qi1/fCvPyOMT6FM9FDxuRVUcFZepjvP5QVCwuJbBYntnoVl3JOZZy78XJlqbsP
         bu96/e0VbIiy3K5YtnCjM2W05QEKzuLAKrvWlQHGjOC48zAoNEiEQjlaEu+zClLByr
         KYEch2qiaJodYxGYr3BSDIRIDtm7ivp4uvuCRpEY=
Subject: FAILED: patch "[PATCH] scsi: ufs: core: Fix devfreq deadlocks" failed to apply to 5.15-stable tree
To:     johan+linaro@kernel.org, ahalaney@redhat.com, bvanassche@acm.org,
        martin.petersen@oracle.com, quic_cang@quicinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Jan 2023 14:27:25 +0100
Message-ID: <167499884527163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ba81043753ff ("scsi: ufs: core: Fix devfreq deadlocks")
87bd05016a64 ("scsi: ufs: core: Allow host driver to disable wb toggling during clock scaling")
dd11376b9f1b ("scsi: ufs: Split the drivers/scsi/ufs directory")
4bc26113c603 ("scsi: ufs: Split the ufshcd.h header file")
3f06f7800b80 ("scsi: ufs: Minimize #include directives")
cff91daf52d3 ("scsi: ufs: Fix kernel-doc syntax in ufshcd.h")
c10d52d73ae0 ("scsi: ufs: Remove unnecessary ufshcd-crypto.h include directives")
e2106584d011 ("scsi: ufs: Rename sdev_ufs_device into ufs_device_wlun")
c906e8328de8 ("scsi: ufs: Make the config_scaling_param calls type safe")
8d077ede48c1 ("scsi: ufs: Optimize the command queueing code")
5675c381ea51 ("scsi: ufs: Stop using the clock scaling lock in the error handler")
511a083b8b6b ("scsi: ufs: Remove hba->cmd_queue")
59830c095cf0 ("scsi: ufs: Remove the sdev_rpmb member")
db33028647a3 ("scsi: Remove superfluous #include <linux/async.h> directives")
ddba1cf7a506 ("scsi: ufs: Let devices remain runtime suspended during system suspend")
659109a45c6c ("scsi: ufs: Fix double space in SCSI_UFS_HWMON description")
d28a78537d1d ("scsi: ufs: Wrap Universal Flash Storage drivers in SCSI_UFSHCD")
fe91c4725aee ("Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ba81043753fffbc2ad6e0c5ff2659f12ac2f46b4 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 16 Jan 2023 17:12:01 +0100
Subject: [PATCH] scsi: ufs: core: Fix devfreq deadlocks

There is a lock inversion and rwsem read-lock recursion in the devfreq
target callback which can lead to deadlocks.

Specifically, ufshcd_devfreq_scale() already holds a clk_scaling_lock
read lock when toggling the write booster, which involves taking the
dev_cmd mutex before taking another clk_scaling_lock read lock.

This can lead to a deadlock if another thread:

  1) tries to acquire the dev_cmd and clk_scaling locks in the correct
     order, or

  2) takes a clk_scaling write lock before the attempt to take the
     clk_scaling read lock a second time.

Fix this by dropping the clk_scaling_lock before toggling the write booster
as was done before commit 0e9d4ca43ba8 ("scsi: ufs: Protect some contexts
from unexpected clock scaling").

While the devfreq callbacks are already serialised, add a second
serialising mutex to handle the unlikely case where a callback triggered
through the devfreq sysfs interface is racing with a request to disable
clock scaling through the UFS controller 'clkscale_enable' sysfs
attribute. This could otherwise lead to the write booster being left
disabled after having disabled clock scaling.

Also take the new mutex in ufshcd_clk_scaling_allow() to make sure that any
pending write booster update has completed on return.

Note that this currently only affects Qualcomm platforms since commit
87bd05016a64 ("scsi: ufs: core: Allow host driver to disable wb toggling
during clock scaling").

The lock inversion (i.e. 1 above) was reported by lockdep as:

 ======================================================
 WARNING: possible circular locking dependency detected
 6.1.0-next-20221216 #211 Not tainted
 ------------------------------------------------------
 kworker/u16:2/71 is trying to acquire lock:
 ffff076280ba98a0 (&hba->dev_cmd.lock){+.+.}-{3:3}, at: ufshcd_query_flag+0x50/0x1c0

 but task is already holding lock:
 ffff076280ba9cf0 (&hba->clk_scaling_lock){++++}-{3:3}, at: ufshcd_devfreq_scale+0x2b8/0x380

 which lock already depends on the new lock.
[  +0.011606]
 the existing dependency chain (in reverse order) is:

 -> #1 (&hba->clk_scaling_lock){++++}-{3:3}:
        lock_acquire+0x68/0x90
        down_read+0x58/0x80
        ufshcd_exec_dev_cmd+0x70/0x2c0
        ufshcd_verify_dev_init+0x68/0x170
        ufshcd_probe_hba+0x398/0x1180
        ufshcd_async_scan+0x30/0x320
        async_run_entry_fn+0x34/0x150
        process_one_work+0x288/0x6c0
        worker_thread+0x74/0x450
        kthread+0x118/0x120
        ret_from_fork+0x10/0x20

 -> #0 (&hba->dev_cmd.lock){+.+.}-{3:3}:
        __lock_acquire+0x12a0/0x2240
        lock_acquire.part.0+0xcc/0x220
        lock_acquire+0x68/0x90
        __mutex_lock+0x98/0x430
        mutex_lock_nested+0x2c/0x40
        ufshcd_query_flag+0x50/0x1c0
        ufshcd_query_flag_retry+0x64/0x100
        ufshcd_wb_toggle+0x5c/0x120
        ufshcd_devfreq_scale+0x2c4/0x380
        ufshcd_devfreq_target+0xf4/0x230
        devfreq_set_target+0x84/0x2f0
        devfreq_update_target+0xc4/0xf0
        devfreq_monitor+0x38/0x1f0
        process_one_work+0x288/0x6c0
        worker_thread+0x74/0x450
        kthread+0x118/0x120
        ret_from_fork+0x10/0x20

 other info that might help us debug this:
  Possible unsafe locking scenario:
        CPU0                    CPU1
        ----                    ----
   lock(&hba->clk_scaling_lock);
                                lock(&hba->dev_cmd.lock);
                                lock(&hba->clk_scaling_lock);
   lock(&hba->dev_cmd.lock);

  *** DEADLOCK ***

Fixes: 0e9d4ca43ba8 ("scsi: ufs: Protect some contexts from unexpected clock scaling")
Cc: stable@vger.kernel.org      # 5.12
Cc: Can Guo <quic_cang@quicinc.com>
Tested-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20230116161201.16923-1-johan+linaro@kernel.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bda61be5f035..3a1c4d31e010 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1234,12 +1234,14 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	 * clock scaling is in progress
 	 */
 	ufshcd_scsi_block_requests(hba);
+	mutex_lock(&hba->wb_mutex);
 	down_write(&hba->clk_scaling_lock);
 
 	if (!hba->clk_scaling.is_allowed ||
 	    ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
 		ret = -EBUSY;
 		up_write(&hba->clk_scaling_lock);
+		mutex_unlock(&hba->wb_mutex);
 		ufshcd_scsi_unblock_requests(hba);
 		goto out;
 	}
@@ -1251,12 +1253,16 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	return ret;
 }
 
-static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
+static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err, bool scale_up)
 {
-	if (writelock)
-		up_write(&hba->clk_scaling_lock);
-	else
-		up_read(&hba->clk_scaling_lock);
+	up_write(&hba->clk_scaling_lock);
+
+	/* Enable Write Booster if we have scaled up else disable it */
+	if (ufshcd_enable_wb_if_scaling_up(hba) && !err)
+		ufshcd_wb_toggle(hba, scale_up);
+
+	mutex_unlock(&hba->wb_mutex);
+
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 }
@@ -1273,7 +1279,6 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
 static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 {
 	int ret = 0;
-	bool is_writelock = true;
 
 	ret = ufshcd_clock_scaling_prepare(hba);
 	if (ret)
@@ -1302,15 +1307,8 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 		}
 	}
 
-	/* Enable Write Booster if we have scaled up else disable it */
-	if (ufshcd_enable_wb_if_scaling_up(hba)) {
-		downgrade_write(&hba->clk_scaling_lock);
-		is_writelock = false;
-		ufshcd_wb_toggle(hba, scale_up);
-	}
-
 out_unprepare:
-	ufshcd_clock_scaling_unprepare(hba, is_writelock);
+	ufshcd_clock_scaling_unprepare(hba, ret, scale_up);
 	return ret;
 }
 
@@ -6066,9 +6064,11 @@ static void ufshcd_force_error_recovery(struct ufs_hba *hba)
 
 static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
 {
+	mutex_lock(&hba->wb_mutex);
 	down_write(&hba->clk_scaling_lock);
 	hba->clk_scaling.is_allowed = allow;
 	up_write(&hba->clk_scaling_lock);
+	mutex_unlock(&hba->wb_mutex);
 }
 
 static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
@@ -9793,6 +9793,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Initialize mutex for exception event control */
 	mutex_init(&hba->ee_ctrl_mutex);
 
+	mutex_init(&hba->wb_mutex);
 	init_rwsem(&hba->clk_scaling_lock);
 
 	ufshcd_init_clk_gating(hba);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 5cf81dff60aa..727084cd79be 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -808,6 +808,7 @@ struct ufs_hba_monitor {
  * @urgent_bkops_lvl: keeps track of urgent bkops level for device
  * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
  *  device is known or not.
+ * @wb_mutex: used to serialize devfreq and sysfs write booster toggling
  * @clk_scaling_lock: used to serialize device commands and clock scaling
  * @desc_size: descriptor sizes reported by device
  * @scsi_block_reqs_cnt: reference counting for scsi block requests
@@ -951,6 +952,7 @@ struct ufs_hba {
 	enum bkops_status urgent_bkops_lvl;
 	bool is_urgent_bkops_lvl_checked;
 
+	struct mutex wb_mutex;
 	struct rw_semaphore clk_scaling_lock;
 	unsigned char desc_size[QUERY_DESC_IDN_MAX];
 	atomic_t scsi_block_reqs_cnt;

