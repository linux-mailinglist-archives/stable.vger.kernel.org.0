Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7A4382FF2
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239073AbhEQOW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:22:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239506AbhEQOU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:20:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBBE261442;
        Mon, 17 May 2021 14:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260673;
        bh=SvmAOzvBXIJjTkdfh5SVQyJbmwM8zlUHiP2hORC6ijc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LaU5mj9GGpkQbduArJ/s1pdFvbx48JGSAhXt1JlOCmuxIBtQfp5eP1dQmiZDleAXR
         Ys15XtoeQDEDE3pZdB2emEuZKZNjCLM2dMlw0LevDRdyPdguuU0DWPL4TtN46oPWAv
         46PiSj1EzdhhfCWWDBu/MEtQlNRpod5RQ+Jj6EpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 189/363] scsi: ufs: core: Cancel rpm_dev_flush_recheck_work during system suspend
Date:   Mon, 17 May 2021 16:00:55 +0200
Message-Id: <20210517140308.983171280@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
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
index fed32517d7d1..4631a609b0e3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8978,6 +8978,8 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	if (!hba->is_powered)
 		return 0;
 
+	cancel_delayed_work_sync(&hba->rpm_dev_flush_recheck_work);
+
 	if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
 	     hba->curr_dev_pwr_mode) &&
 	    (ufs_get_pm_lvl_to_link_pwr_state(hba->spm_lvl) ==
-- 
2.30.2



