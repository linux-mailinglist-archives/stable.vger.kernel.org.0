Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44B2653E32
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 11:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235241AbiLVKXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 05:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiLVKXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 05:23:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51371AA0C;
        Thu, 22 Dec 2022 02:22:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3423061A43;
        Thu, 22 Dec 2022 10:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A5CC433D2;
        Thu, 22 Dec 2022 10:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671704577;
        bh=cM7TUd+Vfgn4cVRylX8wENasOWsMi1NSfeV+TnAKspU=;
        h=From:To:Cc:Subject:Date:From;
        b=oP27wqV+6wPSFOVUlj2bwtJLJXFS4BNjkkEYu3CYae2Pwr+9i1Np+6f0BlWCxD7S2
         qXamNN6X0tVmbY4qyWd276Oy6MXmrFpHAE2H+XNM6EDHuhN4p0lXBeLt1jkGtQ43g5
         KqJE5NsxizzfSvT+/y6HU4G+yM7jKtxSu0e5gHVfNlv1GminMAffKx4bvtcoCavJbe
         j9Rgoc3rvKNXugi79pmMDrTCGraPoTf6IZacqL4o2bcyQgzdMH31s6lAbT/1w8sQnX
         EBeMXvZBmTmIh7+sPzomlScUYA4QwbSQLtOH/5my+gxY2t6AIwqU5/vQWsnCRBTbuN
         Q+bMUkXnmaGSw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1p8Ijr-0004tZ-Og; Thu, 22 Dec 2022 11:23:47 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org,
        Can Guo <quic_cang@quicinc.com>
Subject: [PATCH] scsi: ufs: core: fix devfreq deadlocks
Date:   Thu, 22 Dec 2022 11:21:21 +0100
Message-Id: <20221222102121.18682-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.37.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Fix this by dropping the clk_scaling_lock before toggling the write
booster as was done before commit 0e9d4ca43ba8 ("scsi: ufs: Protect some
contexts from unexpected clock scaling").

While the devfreq callbacks are already serialised, add a second
serialising mutex to handle the unlikely case where a callback triggered
through the devfreq sysfs interface is racing with a request to disable
clock scaling through the UFS controller 'clkscale_enable' sysfs
attribute. This could otherwise lead to the write booster being left
disabled after having disabled clock scaling.

Also take the new mutex in ufshcd_clk_scaling_allow() to make sure that
any pending write booster update has completed on return.

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
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---

This issue has apparently been known for over a year [1] without anyone
bothering to fix it. Aside from the potential deadlocks, this also leads
to developers using Qualcomm platforms not being able to use lockdep to
prevent further issues like this from being introduced in other places.

Johan

[1] https://lore.kernel.org/lkml/1631843521-2863-1-git-send-email-cang@codeaurora.org


 drivers/ufs/core/ufshcd.c | 29 +++++++++++++++--------------
 include/ufs/ufshcd.h      |  2 ++
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bda61be5f035..5c3821b2fcf8 100644
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
+static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool scale_up)
 {
-	if (writelock)
-		up_write(&hba->clk_scaling_lock);
-	else
-		up_read(&hba->clk_scaling_lock);
+	up_write(&hba->clk_scaling_lock);
+
+	/* Enable Write Booster if we have scaled up else disable it */
+	if (ufshcd_enable_wb_if_scaling_up(hba))
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
+	ufshcd_clock_scaling_unprepare(hba, scale_up);
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
-- 
2.37.4

