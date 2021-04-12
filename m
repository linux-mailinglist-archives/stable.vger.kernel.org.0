Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6599D35C07A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239855AbhDLJNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:13:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240461AbhDLJKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 014B36125F;
        Mon, 12 Apr 2021 09:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218336;
        bh=CiIe/z8OriHB/JCrkGvkTlwHMNRvzFQVNhPIW0Au80Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bLvTVgQ6nhnaV5czAACdWCwiZe2U+coUXeu748dzqGCuYgweBFMPNdRKbq1RLNwFs
         +AIgPwms68KIaVo14GQlzzFqAs+tONCOmdGg77y9ba7P+hjSmoSS7lOVhikyBYAxMS
         QSI/QSp6vfCSbMADA3Kc4Gmj85N+o/sy7kbOW2+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 158/210] scsi: ufs: core: Fix task management request completion timeout
Date:   Mon, 12 Apr 2021 10:41:03 +0200
Message-Id: <20210412084021.266878236@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
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
index 16e1bd1aa49d..c801f88007dd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6381,6 +6381,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 
 	spin_lock_irqsave(host->host_lock, flags);
 	task_tag = hba->nutrs + free_slot;
+	blk_mq_start_request(req);
 
 	treq->req_header.dword_0 |= cpu_to_be32(task_tag);
 
-- 
2.30.2



