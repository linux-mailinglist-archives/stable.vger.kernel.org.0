Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11723836A7
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242374AbhEQPfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244702AbhEQPce (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:32:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EA5661CCC;
        Mon, 17 May 2021 14:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262317;
        bh=mK5r0kOx9y1Xc7P5+IfiO+Zkaf0n4VtedVrTqK0Zg3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5XxEy4oqLqF//s3E7iV7UtbaPlOFg7uDg/eZ0Eb4NNHLITXWle6rXv9sCjFtL6Mj
         lbMhCbh/mZ4hmjd0YnJbr6yehZpQySeOukopwQ2a39wZ4SjVHdd+ohYvbZtyZHmLRC
         cTPCfJrhuKV7i3Jrz15as+DOIJDp+XVQ1BzSMYec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 142/289] scsi: ufs: core: Cancel rpm_dev_flush_recheck_work during system suspend
Date:   Mon, 17 May 2021 16:01:07 +0200
Message-Id: <20210517140309.926715838@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit 637822e63b79ee8a729f7ba2645a26cf5a524ee4 ]

During ufs system suspend, leaving rpm_dev_flush_recheck_work running or
pending is risky because concurrency may happen between system
suspend/resume and runtime resume routine. Fix this by cancelling
rpm_dev_flush_recheck_work synchronously during system suspend.

Link: https://lore.kernel.org/r/1619408921-30426-3-git-send-email-cang@codeaurora.org
Fixes: 51dd905bd2f6 ("scsi: ufs: Fix WriteBooster flush during runtime suspend")
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d1900ea31b0d..96f9c81d42b2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8819,6 +8819,8 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	if (!hba || !hba->is_powered)
 		return 0;
 
+	cancel_delayed_work_sync(&hba->rpm_dev_flush_recheck_work);
+
 	if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
 	     hba->curr_dev_pwr_mode) &&
 	    (ufs_get_pm_lvl_to_link_pwr_state(hba->spm_lvl) ==
-- 
2.30.2



