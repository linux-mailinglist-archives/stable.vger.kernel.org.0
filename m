Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B495349A48D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369538AbiAYACE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383889AbiAXX2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96038C01D7F7;
        Mon, 24 Jan 2022 13:31:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DCA9B8123A;
        Mon, 24 Jan 2022 21:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9584DC340E4;
        Mon, 24 Jan 2022 21:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059898;
        bh=LTV0XAwMy9g8Y7DFWmRAMBCvbCPAanzUK5p1srS9zEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5O54t8Pl34vpujvHlusIuEnjBpuEVv95udKWuzp5/vpFjE3fkHEPFMoZ6JV/paL7
         E/0POWvROMYS+Ne7HS2c+dEkZLU3UlnDe8bN9VBrn1LKkz/ORUXWFAAvzTSQ/OBi+C
         ULixIemiwRA7xMV/8+0coWn6CLJ5ar4M3/OaEaVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0772/1039] scsi: mpi3mr: Fixes around reply request queues
Date:   Mon, 24 Jan 2022 19:42:41 +0100
Message-Id: <20220124184151.254085952@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index aa5d877df6f83..2daf633ea2955 100644
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



