Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA8D2E3847
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730789AbgL1NIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:08:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:35772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730833AbgL1NIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:08:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F31EC21D94;
        Mon, 28 Dec 2020 13:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160846;
        bh=/1r65JJhn6hoBJ6i3zDSlyOlxoR3zPYHt81bEy4DIXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+owcmLkXk8CLUuGKHKx/8PiAsYBS5oBeEiTNF1OCyy8ZwY/bKGR/7sdU/8q7aP5K
         cggiHli53aT7f62TeN4R4U2F+stxIIRo2HR2UwyvRoTANa1S9gyP0k/ZjFZgDdFmrW
         BYNsF4w8+vcpZUAvym3Dk5KJ49tzGFb9rFcUxMGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 007/242] scsi: ufs: Make sure clk scaling happens only when HBA is runtime ACTIVE
Date:   Mon, 28 Dec 2020 13:46:52 +0100
Message-Id: <20201228124905.026990042@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a3a3ee6e2a002..342e086e41991 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1215,8 +1215,15 @@ static int ufshcd_devfreq_target(struct device *dev,
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



