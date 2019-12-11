Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E5311B674
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732019AbfLKQBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:01:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:37362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731453AbfLKPNh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD7CD24658;
        Wed, 11 Dec 2019 15:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077215;
        bh=QzZyIlv3e+f0yiiUgnn5LfILedViL6/F9hkS/D/ZS0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sp2Mk/PEHveU86AgPk/5/dRMmQdBSNXnLSnf1AL0/58zYpjXmarM4TInFomt+rKxY
         riW1G4p1jr0yGRtT0YdtWtpCzt8F96zqOjESwlbW7ja5dyHdl/eTF/pUux3rrzBC2P
         LpcukhZjLwOki6ZGZ36PHoG6azvyzlza8mioSv1M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 096/134] scsi: ufs: Fix up auto hibern8 enablement
Date:   Wed, 11 Dec 2019 10:11:12 -0500
Message-Id: <20191211151150.19073-96-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit 71d848b8d97ec0f8e993d63cf9de6ac8b3f7c43d ]

Fix up possible unclocked register access to auto hibern8 register in
resume path and through sysfs entry. Meanwhile, enable auto hibern8 only
after device is fully initialized in probe path.

Link: https://lore.kernel.org/r/1573798172-20534-4-git-send-email-cang@codeaurora.org
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-sysfs.c | 15 +++++++++------
 drivers/scsi/ufs/ufshcd.c    | 14 +++++++-------
 drivers/scsi/ufs/ufshcd.h    |  2 ++
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 969a36b15897b..ad2abc96c0f19 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -126,13 +126,16 @@ static void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 		return;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->ahit == ahit)
-		goto out_unlock;
-	hba->ahit = ahit;
-	if (!pm_runtime_suspended(hba->dev))
-		ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
-out_unlock:
+	if (hba->ahit != ahit)
+		hba->ahit = ahit;
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	if (!pm_runtime_suspended(hba->dev)) {
+		pm_runtime_get_sync(hba->dev);
+		ufshcd_hold(hba, false);
+		ufshcd_auto_hibern8_enable(hba);
+		ufshcd_release(hba);
+		pm_runtime_put(hba->dev);
+	}
 }
 
 /* Convert Auto-Hibernate Idle Timer register value to microseconds */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0036dcffc4a90..25a6a25b17a28 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3950,7 +3950,7 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 	return ret;
 }
 
-static void ufshcd_auto_hibern8_enable(struct ufs_hba *hba)
+void ufshcd_auto_hibern8_enable(struct ufs_hba *hba)
 {
 	unsigned long flags;
 
@@ -6890,9 +6890,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	/* UniPro link is active now */
 	ufshcd_set_link_active(hba);
 
-	/* Enable Auto-Hibernate if configured */
-	ufshcd_auto_hibern8_enable(hba);
-
 	ret = ufshcd_verify_dev_init(hba);
 	if (ret)
 		goto out;
@@ -6943,6 +6940,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	/* set the state as operational after switching to desired gear */
 	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
 
+	/* Enable Auto-Hibernate if configured */
+	ufshcd_auto_hibern8_enable(hba);
+
 	/*
 	 * If we are in error handling context or in power management callbacks
 	 * context, no need to scan the host
@@ -7959,12 +7959,12 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (hba->clk_scaling.is_allowed)
 		ufshcd_resume_clkscaling(hba);
 
-	/* Schedule clock gating in case of no access to UFS device yet */
-	ufshcd_release(hba);
-
 	/* Enable Auto-Hibernate if configured */
 	ufshcd_auto_hibern8_enable(hba);
 
+	/* Schedule clock gating in case of no access to UFS device yet */
+	ufshcd_release(hba);
+
 	goto out;
 
 set_old_link_state:
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c94cfda528290..52c9676a12425 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -916,6 +916,8 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	enum flag_idn idn, bool *flag_res);
 
+void ufshcd_auto_hibern8_enable(struct ufs_hba *hba);
+
 #define SD_ASCII_STD true
 #define SD_RAW false
 int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
-- 
2.20.1

