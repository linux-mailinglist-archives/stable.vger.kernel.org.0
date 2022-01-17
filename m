Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AD0490CF7
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241342AbiAQRAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:00:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49190 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241378AbiAQQ7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 11:59:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 194B16119C;
        Mon, 17 Jan 2022 16:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48276C36AE3;
        Mon, 17 Jan 2022 16:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438790;
        bh=T5lGh52JeEu1CZY68znQjYVnm7s1mBjFu+Hynb084Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfWXoDSWl+HWN1yq44MKQNyThLZqV1vKHS/82h7FNF8299jvhR7cuIzh5kBLk+Rqp
         Q+YdEODEfJmcAchxhTRLbgwuFBJMoxibra6BnyYhLvrGyou2gw5l7JnrXCsesA8Crc
         wCFE/4ZYebgSr2UPmOZ3DPxOcR0vvnCp6tflGmwzUolSleQvMNIbCgJsOXsfE8Tmvc
         nSVirsUO7KqDxiOm6zs3/3aPhZQdbVPSsm7PY9JICgQhR7dsBLP1EYtZuPQ/KbPeF0
         nwIKfizf/upY1BHD6HrSFkRIqiChHtoZ8vhVuxMWrC9uZG4qei0/6pFCgFGKs7u1Cs
         AOojNOmy7K6EQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        avri.altman@wdc.com, cang@codeaurora.org, adrian.hunter@intel.com,
        asutoshd@codeaurora.org, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 22/52] scsi: ufs: Fix a kernel crash during shutdown
Date:   Mon, 17 Jan 2022 11:58:23 -0500
Message-Id: <20220117165853.1470420-22-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 3489c34bd02b73a72646037d673a122a53cee174 ]

Fix the following kernel crash:

Unable to handle kernel paging request at virtual address ffffffc91e735000
Call trace:
 __queue_work+0x26c/0x624
 queue_work_on+0x6c/0xf0
 ufshcd_hold+0x12c/0x210
 __ufshcd_wl_suspend+0xc0/0x400
 ufshcd_wl_shutdown+0xb8/0xcc
 device_shutdown+0x184/0x224
 kernel_restart+0x4c/0x124
 __arm64_sys_reboot+0x194/0x264
 el0_svc_common+0xc8/0x1d4
 do_el0_svc+0x30/0x8c
 el0_svc+0x20/0x30
 el0_sync_handler+0x84/0xe4
 el0_sync+0x1bc/0x1c0

Fix this crash by ungating the clock before destroying the work queue on
which clock gating work is queued.

Link: https://lore.kernel.org/r/20211203231950.193369-15-bvanassche@acm.org
Tested-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 13c09dbd99b92..52e92fae63cee 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1666,7 +1666,8 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 	bool flush_result;
 	unsigned long flags;
 
-	if (!ufshcd_is_clkgating_allowed(hba))
+	if (!ufshcd_is_clkgating_allowed(hba) ||
+	    !hba->clk_gating.is_initialized)
 		goto out;
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->clk_gating.active_reqs++;
@@ -1826,7 +1827,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
 
 	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
 	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
-	    hba->outstanding_tasks ||
+	    hba->outstanding_tasks || !hba->clk_gating.is_initialized ||
 	    hba->active_uic_cmd || hba->uic_async_done ||
 	    hba->clk_gating.state == CLKS_OFF)
 		return;
@@ -1961,11 +1962,15 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 {
 	if (!hba->clk_gating.is_initialized)
 		return;
+
 	ufshcd_remove_clk_gating_sysfs(hba);
-	cancel_work_sync(&hba->clk_gating.ungate_work);
-	cancel_delayed_work_sync(&hba->clk_gating.gate_work);
-	destroy_workqueue(hba->clk_gating.clk_gating_workq);
+
+	/* Ungate the clock if necessary. */
+	ufshcd_hold(hba, false);
 	hba->clk_gating.is_initialized = false;
+	ufshcd_release(hba);
+
+	destroy_workqueue(hba->clk_gating.clk_gating_workq);
 }
 
 /* Must be called with host lock acquired */
-- 
2.34.1

