Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 178CB19112
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfEISwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbfEISwj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:52:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DF5F217F5;
        Thu,  9 May 2019 18:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427958;
        bh=elQt22/biHgS3BwJJnZmglVqRpzudAYH7FQIJFh32wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hVsYbYOOYRrTcF0mhsF8AsXVjOk9j75Mwjr/djHIxQDmcClGYdZ3OYTLk0v2CyK7i
         MtsO9RiIIUaYJ2H2bz1UG6J0G3sPEQpWGxPK2x5BSRWu9hJ15zfoDco7Mlc2xKYk+X
         28djoIhnMQdD8xOlnys+fDMmCnLRBXku5NTApZWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 67/95] nvme-fc: correct csn initialization and increments on error
Date:   Thu,  9 May 2019 20:42:24 +0200
Message-Id: <20190509181314.146030798@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 67f471b6ed3b09033c4ac77ea03f92afdb1989fe ]

This patch fixes a long-standing bug that initialized the FC-NVME
cmnd iu CSN value to 1. Early FC-NVME specs had the connection starting
with CSN=1. By the time the spec reached approval, the language had
changed to state a connection should start with CSN=0.  This patch
corrects the initialization value for FC-NVME connections.

Additionally, in reviewing the transport, the CSN value is assigned to
the new IU early in the start routine. It's possible that a later dma
map request may fail, causing the command to never be sent to the
controller.  Change the location of the assignment so that it is
immediately prior to calling the lldd. Add a comment block to explain
the impacts if the lldd were to additionally fail sending the command.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index c37d5bbd72ab6..8625b73d94bf7 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1857,7 +1857,7 @@ nvme_fc_init_queue(struct nvme_fc_ctrl *ctrl, int idx)
 	memset(queue, 0, sizeof(*queue));
 	queue->ctrl = ctrl;
 	queue->qnum = idx;
-	atomic_set(&queue->csn, 1);
+	atomic_set(&queue->csn, 0);
 	queue->dev = ctrl->dev;
 
 	if (idx > 0)
@@ -1899,7 +1899,7 @@ nvme_fc_free_queue(struct nvme_fc_queue *queue)
 	 */
 
 	queue->connection_id = 0;
-	atomic_set(&queue->csn, 1);
+	atomic_set(&queue->csn, 0);
 }
 
 static void
@@ -2195,7 +2195,6 @@ nvme_fc_start_fcp_op(struct nvme_fc_ctrl *ctrl, struct nvme_fc_queue *queue,
 {
 	struct nvme_fc_cmd_iu *cmdiu = &op->cmd_iu;
 	struct nvme_command *sqe = &cmdiu->sqe;
-	u32 csn;
 	int ret, opstate;
 
 	/*
@@ -2210,8 +2209,6 @@ nvme_fc_start_fcp_op(struct nvme_fc_ctrl *ctrl, struct nvme_fc_queue *queue,
 
 	/* format the FC-NVME CMD IU and fcp_req */
 	cmdiu->connection_id = cpu_to_be64(queue->connection_id);
-	csn = atomic_inc_return(&queue->csn);
-	cmdiu->csn = cpu_to_be32(csn);
 	cmdiu->data_len = cpu_to_be32(data_len);
 	switch (io_dir) {
 	case NVMEFC_FCP_WRITE:
@@ -2269,11 +2266,24 @@ nvme_fc_start_fcp_op(struct nvme_fc_ctrl *ctrl, struct nvme_fc_queue *queue,
 	if (!(op->flags & FCOP_FLAGS_AEN))
 		blk_mq_start_request(op->rq);
 
+	cmdiu->csn = cpu_to_be32(atomic_inc_return(&queue->csn));
 	ret = ctrl->lport->ops->fcp_io(&ctrl->lport->localport,
 					&ctrl->rport->remoteport,
 					queue->lldd_handle, &op->fcp_req);
 
 	if (ret) {
+		/*
+		 * If the lld fails to send the command is there an issue with
+		 * the csn value?  If the command that fails is the Connect,
+		 * no - as the connection won't be live.  If it is a command
+		 * post-connect, it's possible a gap in csn may be created.
+		 * Does this matter?  As Linux initiators don't send fused
+		 * commands, no.  The gap would exist, but as there's nothing
+		 * that depends on csn order to be delivered on the target
+		 * side, it shouldn't hurt.  It would be difficult for a
+		 * target to even detect the csn gap as it has no idea when the
+		 * cmd with the csn was supposed to arrive.
+		 */
 		opstate = atomic_xchg(&op->state, FCPOP_STATE_COMPLETE);
 		__nvme_fc_fcpop_chk_teardowns(ctrl, op, opstate);
 
-- 
2.20.1



