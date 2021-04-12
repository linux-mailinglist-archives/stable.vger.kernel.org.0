Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858FC35BEE3
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238993AbhDLJCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239213AbhDLI71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:59:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61B1261244;
        Mon, 12 Apr 2021 08:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217873;
        bh=Jd2AWhfXkzVNuGiCaTyWYyBojlL7KDdfAqfNE0XYASY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBzQY2fJUpbC+w3w87b4hHzN0aST+OTdJRx7F9wUTSamhTgv12NjBYj6udA/FZt/O
         kOb2m+TUHwcenV4Yqx3nAZEARVITzoY1z5/t2VKxPOSZ/TmPNkuYX8HpognOwbhNa7
         bA9XoSdqvseCsFgK++/kfn6zFxo5L5jKs8fK1anM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 142/188] scsi: ufs: core: Fix task management request completion timeout
Date:   Mon, 12 Apr 2021 10:40:56 +0200
Message-Id: <20210412084018.353268797@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit 1235fc569e0bf541ddda0a1224d4c6fa6d914890 ]

ufshcd_tmc_handler() calls blk_mq_tagset_busy_iter(fn = ufshcd_compl_tm()),
but since blk_mq_tagset_busy_iter() only iterates over all reserved tags
and requests which are not in IDLE state, ufshcd_compl_tm() never gets a
chance to run. Thus, TMR always ends up with completion timeout. Fix it by
calling blk_mq_start_request() in __ufshcd_issue_tm_cmd().

Link: https://lore.kernel.org/r/1617262750-4864-2-git-send-email-cang@codeaurora.org
Fixes: 69a6c269c097 ("scsi: ufs: Use blk_{get,put}_request() to allocate and free TMFs")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 97d9d5d99adc..7e1168ee2474 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6274,6 +6274,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 
 	spin_lock_irqsave(host->host_lock, flags);
 	task_tag = hba->nutrs + free_slot;
+	blk_mq_start_request(req);
 
 	treq->req_header.dword_0 |= cpu_to_be32(task_tag);
 
-- 
2.30.2



