Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0761C490DD5
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241283AbiAQRF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241592AbiAQRD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:03:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CFFC061746;
        Mon, 17 Jan 2022 09:02:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D763D61213;
        Mon, 17 Jan 2022 17:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2481DC36AED;
        Mon, 17 Jan 2022 17:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438976;
        bh=YXBDOB0oCSKS1lj5s5dvau3YvJ0D92OK3LAuRsBUZ8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VEYG+VvX0Ecdji0cUJfihW/WYFcUpVYQIRL9iEHDf8k31G4j8aKjVBdueB04Zv/9p
         B/pN0PzK3SBXd3PpJv8khDBazDlIbulOPQU6qprXr70ROF3o05SpzZbAT/dXa7cEcP
         WSeKGEeuENq2Dx76a4X6UU+e8BPhBhdnGSEwF7i8IpzKdvacx1CUzHuhijKxIQgyuS
         U/XPuygvWsaf661rPhud6IgHIT88/4aTvGG94N4B1JYEWYL/7ze6rXCn6HNOC0HC7K
         pu4cO4G6hlKdMOoIsVYhuf45YY5qnah5KNtRTqoj81Lj2GxTIs4BPuwgZRB32BTolq
         zPW6BeDFfEtyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        jejb@linux.ibm.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 36/44] scsi: mpi3mr: Fixes around reply request queues
Date:   Mon, 17 Jan 2022 12:01:19 -0500
Message-Id: <20220117170127.1471115-36-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 243bcc8efdb1f44b1a1d415e6821a246714c68ce ]

Set reply queue depth of 1K for B0 and 4K for A0.

While freeing the segmented request queues use the actual queue depth that
is used while creating them.

Link: https://lore.kernel.org/r/20211220141159.16117-25-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h    | 3 ++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 9787b53a2b598..2cc42432bd0c0 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -79,7 +79,8 @@ extern int prot_mask;
 
 /* Operational queue management definitions */
 #define MPI3MR_OP_REQ_Q_QD		512
-#define MPI3MR_OP_REP_Q_QD		4096
+#define MPI3MR_OP_REP_Q_QD		1024
+#define MPI3MR_OP_REP_Q_QD4K		4096
 #define MPI3MR_OP_REQ_Q_SEG_SIZE	4096
 #define MPI3MR_OP_REP_Q_SEG_SIZE	4096
 #define MPI3MR_MAX_SEG_LIST_SIZE	4096
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 4a8316c6bd41a..5af36c54cb596 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1278,7 +1278,7 @@ static void mpi3mr_free_op_req_q_segments(struct mpi3mr_ioc *mrioc, u16 q_idx)
 			mrioc->op_reply_qinfo[q_idx].q_segment_list = NULL;
 		}
 	} else
-		size = mrioc->req_qinfo[q_idx].num_requests *
+		size = mrioc->req_qinfo[q_idx].segment_qd *
 		    mrioc->facts.op_req_sz;
 
 	for (j = 0; j < mrioc->req_qinfo[q_idx].num_segments; j++) {
@@ -1565,6 +1565,8 @@ static int mpi3mr_create_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
 
 	reply_qid = qidx + 1;
 	op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD;
+	if (!mrioc->pdev->revision)
+		op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD4K;
 	op_reply_q->ci = 0;
 	op_reply_q->ephase = 1;
 	atomic_set(&op_reply_q->pend_ios, 0);
-- 
2.34.1

