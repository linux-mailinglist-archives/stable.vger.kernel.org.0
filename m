Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A8A33E3CD
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhCQA5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230051AbhCQA5I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2442A64FA8;
        Wed, 17 Mar 2021 00:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942628;
        bh=F2Am5AgcwvHFfovPrzkmneKKrUDiOXkJDhQ6FIxVmD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UxhPKLnpIpGo4X6W/13KZ3QL4JX0lkxoqgloMPXoiA0H64Pvr4S1aX82Wr30q2La4
         O41J1uM3yAe7dE8thfavHUWwhgt8PB7HcYVV/Te/DFpqnrdzT56UFRck92+G4Fh6dS
         NNjcNW002J/JB+nvulxj7apKgaIhIJ1xKSFUQ8xRH0jHJxMYbz4fZSH4IbNQo25U6q
         A3RRfamAx0ZnnJEm1Foq6HKHMd61k5Lu/rLYmZsHkgxEGkcTgxfOtQQ4Alrw2efVXq
         VcsO4tMOr2SoTf60vIPB0X8p7yCrRJRr2nueUTaTu67TIyIEUVG77mZaptVsXa0G7T
         RtdHXQC0Mef7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nitin Rawat <nitirawa@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/54] scsi: ufs: ufs-qcom: Disable interrupt in reset path
Date:   Tue, 16 Mar 2021 20:56:09 -0400
Message-Id: <20210317005654.724862-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nitin Rawat <nitirawa@codeaurora.org>

[ Upstream commit 4a791574a0ccf36eb3a0a46fbd71d2768df3eef9 ]

Disable interrupt in reset path to flush pending IRQ handler in order to
avoid possible NoC issues.

Link: https://lore.kernel.org/r/1614145010-36079-3-git-send-email-cang@codeaurora.org
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Nitin Rawat <nitirawa@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index a244c8ae1b4e..20182e39cb28 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -253,12 +253,17 @@ static int ufs_qcom_host_reset(struct ufs_hba *hba)
 {
 	int ret = 0;
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+	bool reenable_intr = false;
 
 	if (!host->core_reset) {
 		dev_warn(hba->dev, "%s: reset control not set\n", __func__);
 		goto out;
 	}
 
+	reenable_intr = hba->is_irq_enabled;
+	disable_irq(hba->irq);
+	hba->is_irq_enabled = false;
+
 	ret = reset_control_assert(host->core_reset);
 	if (ret) {
 		dev_err(hba->dev, "%s: core_reset assert failed, err = %d\n",
@@ -280,6 +285,11 @@ static int ufs_qcom_host_reset(struct ufs_hba *hba)
 
 	usleep_range(1000, 1100);
 
+	if (reenable_intr) {
+		enable_irq(hba->irq);
+		hba->is_irq_enabled = true;
+	}
+
 out:
 	return ret;
 }
-- 
2.30.1

