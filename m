Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB1410180B
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbfKSFfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:35:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:56930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729874AbfKSFfz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:35:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 638C9214DE;
        Tue, 19 Nov 2019 05:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141753;
        bh=KIk9cKBAlYSu52MEBaNKdwuUofEr+nQ0flIVxSGQwz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gE9EUP+o69r12C6GwDqJREGwdCd6SwKp9XV1EFcvGWz8uUxPksa380OZNgrlMHDJE
         QNCFcBSfvg21cD5xxq8L45b5vDKLjTOhSbw+AQoMa6d4VaEkNpE0FLtUN844TiHngQ
         nJHrJOKd/7Wm6UzylVJhz5h+IFcmZLpaXj//Bd28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Evan Green <evgreen@chromium.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 229/422] scsi: ufshcd: Fix NULL pointer dereference for in ufshcd_init
Date:   Tue, 19 Nov 2019 06:17:06 +0100
Message-Id: <20191119051413.481349501@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vivek Gautam <vivek.gautam@codeaurora.org>

[ Upstream commit eebcc19646489b68399ce7b35d9c38eb9f4ec40f ]

Error paths in ufshcd_init() ufshcd_hba_exit() killed clk_scaling workqueue
when the workqueue is actually created quite late in ufshcd_init().  So, we
end up getting NULL pointer dereference in such error paths.  Fix this by
moving clk_scaling initialization and kill codes to two separate methods, and
call them at required places.

Fixes: 401f1e4490ee ("scsi: ufs: don't suspend clock scaling during clock
gating")

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Evan Green <evgreen@chromium.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 53 +++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4aaba3e030554..8bce755e0f5bc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1772,6 +1772,34 @@ out:
 	return count;
 }
 
+static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
+{
+	char wq_name[sizeof("ufs_clkscaling_00")];
+
+	if (!ufshcd_is_clkscaling_supported(hba))
+		return;
+
+	INIT_WORK(&hba->clk_scaling.suspend_work,
+		  ufshcd_clk_scaling_suspend_work);
+	INIT_WORK(&hba->clk_scaling.resume_work,
+		  ufshcd_clk_scaling_resume_work);
+
+	snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
+		 hba->host->host_no);
+	hba->clk_scaling.workq = create_singlethread_workqueue(wq_name);
+
+	ufshcd_clkscaling_init_sysfs(hba);
+}
+
+static void ufshcd_exit_clk_scaling(struct ufs_hba *hba)
+{
+	if (!ufshcd_is_clkscaling_supported(hba))
+		return;
+
+	destroy_workqueue(hba->clk_scaling.workq);
+	ufshcd_devfreq_remove(hba);
+}
+
 static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 {
 	char wq_name[sizeof("ufs_clk_gating_00")];
@@ -6676,6 +6704,7 @@ out:
 	 */
 	if (ret && !ufshcd_eh_in_progress(hba) && !hba->pm_op_in_progress) {
 		pm_runtime_put_sync(hba->dev);
+		ufshcd_exit_clk_scaling(hba);
 		ufshcd_hba_exit(hba);
 	}
 
@@ -7223,12 +7252,9 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 		ufshcd_variant_hba_exit(hba);
 		ufshcd_setup_vreg(hba, false);
 		ufshcd_suspend_clkscaling(hba);
-		if (ufshcd_is_clkscaling_supported(hba)) {
+		if (ufshcd_is_clkscaling_supported(hba))
 			if (hba->devfreq)
 				ufshcd_suspend_clkscaling(hba);
-			destroy_workqueue(hba->clk_scaling.workq);
-			ufshcd_devfreq_remove(hba);
-		}
 		ufshcd_setup_clocks(hba, false);
 		ufshcd_setup_hba_vreg(hba, false);
 		hba->is_powered = false;
@@ -7908,6 +7934,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 	ufshcd_disable_intr(hba, hba->intr_mask);
 	ufshcd_hba_stop(hba, true);
 
+	ufshcd_exit_clk_scaling(hba);
 	ufshcd_exit_clk_gating(hba);
 	if (ufshcd_is_clkscaling_supported(hba))
 		device_remove_file(hba->dev, &hba->clk_scaling.enable_attr);
@@ -8079,6 +8106,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	ufshcd_init_clk_gating(hba);
 
+	ufshcd_init_clk_scaling(hba);
+
 	/*
 	 * In order to avoid any spurious interrupt immediately after
 	 * registering UFS controller interrupt handler, clear any pending UFS
@@ -8117,21 +8146,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		goto out_remove_scsi_host;
 	}
 
-	if (ufshcd_is_clkscaling_supported(hba)) {
-		char wq_name[sizeof("ufs_clkscaling_00")];
-
-		INIT_WORK(&hba->clk_scaling.suspend_work,
-			  ufshcd_clk_scaling_suspend_work);
-		INIT_WORK(&hba->clk_scaling.resume_work,
-			  ufshcd_clk_scaling_resume_work);
-
-		snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
-			 host->host_no);
-		hba->clk_scaling.workq = create_singlethread_workqueue(wq_name);
-
-		ufshcd_clkscaling_init_sysfs(hba);
-	}
-
 	/*
 	 * Set the default power management level for runtime and system PM.
 	 * Default power saving mode is to keep UFS link in Hibern8 state
@@ -8169,6 +8183,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 out_remove_scsi_host:
 	scsi_remove_host(hba->host);
 exit_gating:
+	ufshcd_exit_clk_scaling(hba);
 	ufshcd_exit_clk_gating(hba);
 out_disable:
 	hba->is_irq_enabled = false;
-- 
2.20.1



