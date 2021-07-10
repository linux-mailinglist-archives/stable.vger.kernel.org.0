Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796203C30BB
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbhGJCgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:36:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233819AbhGJCfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:35:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 044AA61411;
        Sat, 10 Jul 2021 02:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884344;
        bh=bE/IdGLh2cA14qDebd7mCLahEZQLYxLcg+ksd9ACITg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qi8EJ71nAg6s8gBirqaQsOAkBYrXM57IBGVHaIhxfG+jxBiaaEtB7r1q6rOquwSwz
         vAMJM4g3EXqCXXlrqCWP393upfQ6QmqoXeFs8Z4AP6wx0SmoLURTRoXLBPRLgZLyFY
         8uAmjWLwZ2EjvRi++4T6SQPc4d1Y8uiEhifNChzrhH6xTiYi1/QoqU8RibH3d4/7yq
         Q6ajbQf1QXnGBfrrSfnACIE2T0UC/BQ1rEwr6GkAZ2T9ci5TNWTANHTWffvpSLTH9L
         2iRtb/1DiqFYTi6xylDC2vyHaR7suTwbl9BcpTqahFE0IsFKtJxYnPaQrvRzaI1Wp0
         Tg0K+7VSff9OA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 16/39] scsi: qedi: Fix null ref during abort handling
Date:   Fri,  9 Jul 2021 22:31:41 -0400
Message-Id: <20210710023204.3171428-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023204.3171428-1-sashal@kernel.org>
References: <20210710023204.3171428-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 5777b7f0f03ce49372203b6521631f62f2810c8f ]

If qedi_process_cmd_cleanup_resp finds the cmd it frees the work and sets
list_tmf_work to NULL, so qedi_tmf_work should check if list_tmf_work is
non-NULL when it wants to force cleanup.

Link: https://lore.kernel.org/r/20210525181821.7617-20-michael.christie@oracle.com
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 357a0acc5ed2..b60b48f3b984 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1466,7 +1466,7 @@ static void qedi_tmf_work(struct work_struct *work)
 
 ldel_exit:
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
-	if (!qedi_cmd->list_tmf_work) {
+	if (qedi_cmd->list_tmf_work) {
 		list_del_init(&list_work->list);
 		qedi_cmd->list_tmf_work = NULL;
 		kfree(list_work);
-- 
2.30.2

