Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3422E2CD7A6
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 14:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436703AbgLCNfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 08:35:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:47780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436688AbgLCNap (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 08:30:45 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 08/23] scsi: ufs: Make sure clk scaling happens only when HBA is runtime ACTIVE
Date:   Thu,  3 Dec 2020 08:29:20 -0500
Message-Id: <20201203132935.931362-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203132935.931362-1-sashal@kernel.org>
References: <20201203132935.931362-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit 73cc291c270248567245f084dcdf5078069af6b5 ]

If someone plays with the UFS clk scaling devfreq governor through sysfs,
ufshcd_devfreq_scale may be called even when HBA is not runtime ACTIVE.
This can lead to unexpected error. We cannot just protect it by calling
pm_runtime_get_sync() because that may cause a race condition since HBA
runtime suspend ops need to suspend clk scaling. To fix this call
pm_runtime_get_noresume() and check HBA's runtime status. Only proceed if
HBA is runtime ACTIVE, otherwise just bail.

governor_store
 devfreq_performance_handler
  update_devfreq
   devfreq_set_target
    ufshcd_devfreq_target
     ufshcd_devfreq_scale

Link: https://lore.kernel.org/r/1600758548-28576-1-git-send-email-cang@codeaurora.org
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b6ce880ddd153..675e16e61ebdd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1257,8 +1257,15 @@ static int ufshcd_devfreq_target(struct device *dev,
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
 
+	pm_runtime_get_noresume(hba->dev);
+	if (!pm_runtime_active(hba->dev)) {
+		pm_runtime_put_noidle(hba->dev);
+		ret = -EAGAIN;
+		goto out;
+	}
 	start = ktime_get();
 	ret = ufshcd_devfreq_scale(hba, scale_up);
+	pm_runtime_put(hba->dev);
 
 	trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
 		(scale_up ? "up" : "down"),
-- 
2.27.0

