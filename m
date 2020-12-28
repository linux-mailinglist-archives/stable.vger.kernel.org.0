Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2EF52E41D4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437916AbgL1OGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:06:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438256AbgL1OGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E7F52063A;
        Mon, 28 Dec 2020 14:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164398;
        bh=CImXwjZ5kicmSfGd16UneT6nC4Z6JBmbZMY8SmL1zJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doYYQamt7Q85Vdk8wIpdRtWyXQg4cHIe789Yo8+NN5tJ3Pq5IBuB2ihfTRYxfTGfD
         COzMSGvWfubtJ8vV0KFbtifsXivuT7ausMAe0fyCBYPglI4PT5ParD2trcYOd6v8cJ
         nHbSkMyNgLLZXlIqNATfyPc7liSkq0RHAY/Ct/ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 166/717] scsi: ufs: Fix clkgating on/off
Date:   Mon, 28 Dec 2020 13:42:44 +0100
Message-Id: <20201228125028.910146440@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 8eb456be75af7e5a7ac0cd223eaa198cf7ee2ac1 ]

The following call stack prevents clk_gating at every I/O completion.  We
can remove the condition, ufshcd_any_tag_in_use(), since clkgating_work
will check it again.

ufshcd_complete_requests(struct ufs_hba *hba)
  ufshcd_transfer_req_compl()
    __ufshcd_transfer_req_compl()
      __ufshcd_release(hba)
        if (ufshcd_any_tag_in_use() == 1)
           return;
  ufshcd_tmc_handler(hba);
    blk_mq_tagset_busy_iter();

Note that this still requires work to deal with a potential race condition
when user sets clkgating.delay_ms to very small value. That can cause
preventing clkgating by the check of ufshcd_any_tag_in_use() in gate_work.

Link: https://lore.kernel.org/r/20201117165839.1643377-7-jaegeuk@kernel.org
Fixes: 7252a3603015 ("scsi: ufs: Avoid busy-waiting by eliminating tag conflicts")
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1ad7d6c130f5b..911aba3e7675c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1751,7 +1751,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
 
 	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
 	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
-	    ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks ||
+	    hba->outstanding_tasks ||
 	    hba->active_uic_cmd || hba->uic_async_done ||
 	    hba->clk_gating.state == CLKS_OFF)
 		return;
-- 
2.27.0



