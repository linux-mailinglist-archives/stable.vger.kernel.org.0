Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59AC12C9BC6
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389879AbgLAJLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:11:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389869AbgLAJLw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:11:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1930206CA;
        Tue,  1 Dec 2020 09:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813866;
        bh=gZUy9sOtSVHr5uqtxS43GBHqAB8ImEcW8gdBUwymuYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fiOkyTm/pqiGjdqNPaibUa/402lkkg3WawUQbe82Rp/IUC10XLLbABWv7kfa6ZJb1
         MZxMJ5B2aB3SckY6uYDYHdAJZa6jRj8TPSLcF+b18oO7C7wxwbg5XjbXjLxs3F7tsm
         e32adSHWxwJ15E+FDg1e6H297XGJi5WOjICrbSYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 087/152] scsi: ufs: Fix race between shutdown and runtime resume flow
Date:   Tue,  1 Dec 2020 09:53:22 +0100
Message-Id: <20201201084723.274391017@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
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
index 54928a837dad0..9dd32bb0ff2be 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8677,11 +8677,7 @@ int ufshcd_shutdown(struct ufs_hba *hba)
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



