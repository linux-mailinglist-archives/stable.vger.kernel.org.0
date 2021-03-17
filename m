Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB35E33E349
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhCQA4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:56:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229866AbhCQAzv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:55:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23A4164F92;
        Wed, 17 Mar 2021 00:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942551;
        bh=Yeveyd6K8wPDqF/jDYmnasW/ztGVc7aRaNgrufzhjag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFjvg2xc/+Yx8sfANVKJI1H3uycyfON+gimFcuPW4aLeDBrdw+unto5FmmRVOf7yi
         UadFSeQuPxNyqaOdqApzWJlJYPa4bAlboVetARb0rF2ffnswZN4Czjdwh0xlD/R3/s
         WRg5QZyiUzNC/S/Zvm6a8kiCS0TCeBSy0xn91PE6OcYR1Y+hlGvAOGQw5Q1oz1btX5
         MvSUS+KsYFkTlZq7ArEJuQpgOrhXc7j6j08ecYYa+FuHyqtjJt7fHDL87waYvhlnJn
         FoAmSEXN2vZk7Ho4p8I61m7fGUGIzcb1JAKFB1ovY8hR/Mx8KdrTBz8ThweGb+taqN
         O3NVz8dqnVpyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nitin Rawat <nitirawa@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 11/61] scsi: ufs: ufs-qcom: Disable interrupt in reset path
Date:   Tue, 16 Mar 2021 20:54:45 -0400
Message-Id: <20210317005536.724046-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
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
index 2206b1e4b774..e55201f64c10 100644
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

