Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBA16BD5B9
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 17:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjCPQdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 12:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjCPQdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 12:33:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EAAE4C6B;
        Thu, 16 Mar 2023 09:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A776B82271;
        Thu, 16 Mar 2023 16:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22515C4339C;
        Thu, 16 Mar 2023 16:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678984372;
        bh=lDiWoWQ+GwADVgkaV1LC3rRiuX5euPjHLyQ5cmQYoRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8df/iDQgcnKy2hIy8i/4XboLQKLYFXonwunsHrTjSvdpSMhEow3p/K833vMc9sLn
         8A7SbMYfYL+fQEQKVvWGlSwT1VhUaccHiCHD/U2tbdO10gDtGjk40x3gNUGLIJi96E
         rY9ilaQwZ3FYFM4474turREcR1Mr4doHm6RsxXGwfTdlQPEkwqikHivC/9pjMyQOn3
         vHea1qo3RwICrprcz7ZWNhWLSzQjc+2KMPoTQ1Mu4sWWMtiLi0mfdzEtzt+zORBlJa
         8WvtcW/N7kNf4WK+q/Xt+rSvo1HE7T+COV05mPiK8wv408OvP+HUwGwA6nnomAqY3Y
         Lm2SumywdSJeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrien Thierry <athierry@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        beanhuo@micron.com, avri.altman@wdc.com, stanley.chu@mediatek.com,
        quic_asutoshd@quicinc.com, mani@kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 3/7] scsi: ufs: core: Initialize devfreq synchronously
Date:   Thu, 16 Mar 2023 12:32:20 -0400
Message-Id: <20230316163227.708614-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230316163227.708614-1-sashal@kernel.org>
References: <20230316163227.708614-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrien Thierry <athierry@redhat.com>

[ Upstream commit 7dafc3e007918384c8693ff8d70381b5c1e9c247 ]

During UFS initialization, devfreq initialization is asynchronous:
ufshcd_async_scan() calls ufshcd_add_lus(), which in turn initializes
devfreq for UFS. The simple ondemand governor is then loaded. If it is
built as a module, request_module() is called and throws a warning:

  WARNING: CPU: 7 PID: 167 at kernel/kmod.c:136 __request_module+0x1e0/0x460
  Modules linked in: crct10dif_ce llcc_qcom phy_qcom_qmp_usb ufs_qcom phy_qcom_snps_femto_v2 ufshcd_pltfrm phy_qcom_qmp_combo ufshcd_core phy_qcom_qmp_ufs qcom_wdt socinfo fuse ipv6
  CPU: 7 PID: 167 Comm: kworker/u16:3 Not tainted 6.2.0-rc6-00009-g58706f7fb045 #1
  Hardware name: Qualcomm SA8540P Ride (DT)
  Workqueue: events_unbound async_run_entry_fn
  pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : __request_module+0x1e0/0x460
  lr : __request_module+0x1d8/0x460
  sp : ffff800009323b90
  x29: ffff800009323b90 x28: 0000000000000000 x27: 0000000000000000
  x26: ffff800009323d50 x25: ffff7b9045f57810 x24: ffff7b9045f57830
  x23: ffffdc5a83e426e8 x22: ffffdc5ae80a9818 x21: 0000000000000001
  x20: ffffdc5ae7502f98 x19: ffff7b9045f57800 x18: ffffffffffffffff
  x17: 312f716572667665 x16: 642f7366752e3030 x15: 0000000000000000
  x14: 000000000000021c x13: 0000000000005400 x12: ffff7b9042ed7614
  x11: ffff7b9042ed7600 x10: 00000000636c0890 x9 : 0000000000000038
  x8 : ffff7b9045f2c880 x7 : ffff7b9045f57c68 x6 : 0000000000000080
  x5 : 0000000000000000 x4 : 8000000000000000 x3 : 0000000000000000
  x2 : 0000000000000000 x1 : ffffdc5ae5d382f0 x0 : 0000000000000001
  Call trace:
   __request_module+0x1e0/0x460
   try_then_request_governor+0x7c/0x100
   devfreq_add_device+0x4b0/0x5fc
   ufshcd_async_scan+0x1d4/0x310 [ufshcd_core]
   async_run_entry_fn+0x34/0xe0
   process_one_work+0x1d0/0x320
   worker_thread+0x14c/0x444
   kthread+0x10c/0x110
   ret_from_fork+0x10/0x20

This occurs because synchronous module loading from async is not
allowed. According to __request_module():

  /*
   * We don't allow synchronous module loading from async.  Module
   * init may invoke async_synchronize_full() which will end up
   * waiting for this task which already is waiting for the module
   * loading to complete, leading to a deadlock.
   */

Such a deadlock was experienced on the Qualcomm QDrive3/sa8540p-ride. With
DEVFREQ_GOV_SIMPLE_ONDEMAND=m, the boot hangs after the warning.

Fix both the warning and the deadlock by moving devfreq initialization out
of the async routine.

Tested on the sa8540p-ride by using fio to put the UFS under load, and
printing the trace generated by
/sys/kernel/tracing/events/ufs/ufshcd_clk_scaling events. The trace looks
similar with and without the change.

Link: https://lore.kernel.org/r/20230217194423.42553-1-athierry@redhat.com
Signed-off-by: Adrien Thierry <athierry@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 47 ++++++++++++++++++++++++++-------------
 include/ufs/ufshcd.h      |  1 +
 2 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ddc1aba0ad75..d7fa053a78965 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1357,6 +1357,13 @@ static int ufshcd_devfreq_target(struct device *dev,
 	struct ufs_clk_info *clki;
 	unsigned long irq_flags;
 
+	/*
+	 * Skip devfreq if UFS initialization is not finished.
+	 * Otherwise ufs could be in a inconsistent state.
+	 */
+	if (!smp_load_acquire(&hba->logical_unit_scan_finished))
+		return 0;
+
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return -EINVAL;
 
@@ -8152,22 +8159,6 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
-	/* Initialize devfreq after UFS device is detected */
-	if (ufshcd_is_clkscaling_supported(hba)) {
-		memcpy(&hba->clk_scaling.saved_pwr_info.info,
-			&hba->pwr_info,
-			sizeof(struct ufs_pa_layer_attr));
-		hba->clk_scaling.saved_pwr_info.is_valid = true;
-		hba->clk_scaling.is_allowed = true;
-
-		ret = ufshcd_devfreq_init(hba);
-		if (ret)
-			goto out;
-
-		hba->clk_scaling.is_enabled = true;
-		ufshcd_init_clk_scaling_sysfs(hba);
-	}
-
 	ufs_bsg_probe(hba);
 	ufshpb_init(hba);
 	scsi_scan_host(hba->host);
@@ -8306,6 +8297,12 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	if (ret) {
 		pm_runtime_put_sync(hba->dev);
 		ufshcd_hba_exit(hba);
+	} else {
+		/*
+		 * Make sure that when reader code sees UFS initialization has finished,
+		 * all initialization steps have really been executed.
+		 */
+		smp_store_release(&hba->logical_unit_scan_finished, true);
 	}
 }
 
@@ -9912,12 +9909,30 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
 
+	/* Initialize devfreq */
+	if (ufshcd_is_clkscaling_supported(hba)) {
+		memcpy(&hba->clk_scaling.saved_pwr_info.info,
+			&hba->pwr_info,
+			sizeof(struct ufs_pa_layer_attr));
+		hba->clk_scaling.saved_pwr_info.is_valid = true;
+		hba->clk_scaling.is_allowed = true;
+
+		err = ufshcd_devfreq_init(hba);
+		if (err)
+			goto rpm_put_sync;
+
+		hba->clk_scaling.is_enabled = true;
+		ufshcd_init_clk_scaling_sysfs(hba);
+	}
+
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
 
 	device_enable_async_suspend(dev);
 	return 0;
 
+rpm_put_sync:
+	pm_runtime_put_sync(dev);
 free_tmf_queue:
 	blk_mq_destroy_queue(hba->tmf_queue);
 	blk_put_queue(hba->tmf_queue);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 97a09a14c6349..4b6d63ca8c5d8 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -896,6 +896,7 @@ struct ufs_hba {
 	struct completion *uic_async_done;
 
 	enum ufshcd_state ufshcd_state;
+	bool logical_unit_scan_finished;
 	u32 eh_flags;
 	u32 intr_mask;
 	u16 ee_ctrl_mask;
-- 
2.39.2

