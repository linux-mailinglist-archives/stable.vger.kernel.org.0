Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E5E2C9A02
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 09:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgLAIyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:54:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728664AbgLAIyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:54:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8245721D7A;
        Tue,  1 Dec 2020 08:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606812820;
        bh=zKKapAvPt+jJptUDwooX5mUsC4KSeReGhpncMDE0sjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NjtdQkyf73QpsF5IxKYcqVnvfl0EMa9GWtsbg89CLvD18vIWXWKZoESyhPU++zHVk
         Hl3D+TC4oowPYWiIkBPZ4Fiia/ZmP6XY7rvn+mTDWQ4SwGjHdrl+0WYTyDYHJYgOc3
         mTqshti/WU4OxGmzoQv4kg9I6VK+IVgBl+3A2Qxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 12/24] scsi: ufs: Fix race between shutdown and runtime resume flow
Date:   Tue,  1 Dec 2020 09:53:18 +0100
Message-Id: <20201201084638.360712530@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084637.754785180@linuxfoundation.org>
References: <20201201084637.754785180@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit e92643db514803c2c87d72caf5950b4c0a8faf4a ]

If UFS host device is in runtime-suspended state while UFS shutdown
callback is invoked, UFS device shall be resumed for register
accesses. Currently only UFS local runtime resume function will be invoked
to wake up the host.  This is not enough because if someone triggers
runtime resume from block layer, then race may happen between shutdown and
runtime resume flow, and finally lead to unlocked register access.

To fix this, in ufshcd_shutdown(), use pm_runtime_get_sync() instead of
resuming UFS device by ufshcd_runtime_resume() "internally" to let runtime
PM framework manage the whole resume flow.

Link: https://lore.kernel.org/r/20201119062916.12931-1-stanley.chu@mediatek.com
Fixes: 57d104c153d3 ("ufs: add UFS power management support")
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d7a0a64f64536..e37f6db0dd156 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5387,11 +5387,7 @@ int ufshcd_shutdown(struct ufs_hba *hba)
 	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
 		goto out;
 
-	if (pm_runtime_suspended(hba->dev)) {
-		ret = ufshcd_runtime_resume(hba);
-		if (ret)
-			goto out;
-	}
+	pm_runtime_get_sync(hba->dev);
 
 	ret = ufshcd_suspend(hba, UFS_SHUTDOWN_PM);
 out:
-- 
2.27.0



