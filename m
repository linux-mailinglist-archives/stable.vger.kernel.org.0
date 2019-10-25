Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57E8E4D0E
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 15:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505338AbfJYN5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 09:57:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505331AbfJYN5b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:57:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AF8F222BE;
        Fri, 25 Oct 2019 13:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011850;
        bh=vjVcnfY1w3GyMOyFPwp2LORsqbLMyXUQfGFsGauZl/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdNtZkoEh04Cl/LpPmQK+nIoqQzjbQmkeHaLRgzID70GmdF0p3NzBjbpe/ZrJoMFf
         Ih8opC/ZBJWlRhygN0F5JNKP5fLHM9Q8M0vc/2TCLrlkHeDT21Y0F15tFjTl+Lm4IG
         Xe/0GhFIZ6/74NBDQoOoe0nettY7rVSKVQJewCzI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Laurence Oberman <loberman@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/25] scsi: RDMA/srp: Fix a sleep-in-invalid-context bug
Date:   Fri, 25 Oct 2019 09:56:57 -0400
Message-Id: <20191025135715.25468-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135715.25468-1-sashal@kernel.org>
References: <20191025135715.25468-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit fd56141244066a6a21ef458670071c58b6402035 ]

The previous patch guarantees that srp_queuecommand() does not get
invoked while reconnecting occurs. Hence remove the code from
srp_queuecommand() that prevents command queueing while reconnecting.
This patch avoids that the following can appear in the kernel log:

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:747
in_atomic(): 1, irqs_disabled(): 0, pid: 5600, name: scsi_eh_9
1 lock held by scsi_eh_9/5600:
 #0:  (rcu_read_lock){....}, at: [<00000000cbb798c7>] __blk_mq_run_hw_queue+0xf1/0x1e0
Preemption disabled at:
[<00000000139badf2>] __blk_mq_delay_run_hw_queue+0x78/0xf0
CPU: 9 PID: 5600 Comm: scsi_eh_9 Tainted: G        W        4.15.0-rc4-dbg+ #1
Hardware name: Dell Inc. PowerEdge R720/0VWT90, BIOS 2.5.4 01/22/2016
Call Trace:
 dump_stack+0x67/0x99
 ___might_sleep+0x16a/0x250 [ib_srp]
 __mutex_lock+0x46/0x9d0
 srp_queuecommand+0x356/0x420 [ib_srp]
 scsi_dispatch_cmd+0xf6/0x3f0
 scsi_queue_rq+0x4a8/0x5f0
 blk_mq_dispatch_rq_list+0x73/0x440
 blk_mq_sched_dispatch_requests+0x109/0x1a0
 __blk_mq_run_hw_queue+0x131/0x1e0
 __blk_mq_delay_run_hw_queue+0x9a/0xf0
 blk_mq_run_hw_queue+0xc0/0x1e0
 blk_mq_start_hw_queues+0x2c/0x40
 scsi_run_queue+0x18e/0x2d0
 scsi_run_host_queues+0x22/0x40
 scsi_error_handler+0x18d/0x5f0
 kthread+0x11c/0x140
 ret_from_fork+0x24/0x30

Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 3f5b5893792cd..78e6e3b040305 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2132,7 +2132,6 @@ static void srp_handle_qp_err(struct ib_cq *cq, struct ib_wc *wc,
 static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(shost);
-	struct srp_rport *rport = target->rport;
 	struct srp_rdma_ch *ch;
 	struct srp_request *req;
 	struct srp_iu *iu;
@@ -2142,16 +2141,6 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	u32 tag;
 	u16 idx;
 	int len, ret;
-	const bool in_scsi_eh = !in_interrupt() && current == shost->ehandler;
-
-	/*
-	 * The SCSI EH thread is the only context from which srp_queuecommand()
-	 * can get invoked for blocked devices (SDEV_BLOCK /
-	 * SDEV_CREATED_BLOCK). Avoid racing with srp_reconnect_rport() by
-	 * locking the rport mutex if invoked from inside the SCSI EH.
-	 */
-	if (in_scsi_eh)
-		mutex_lock(&rport->mutex);
 
 	scmnd->result = srp_chkready(target->rport);
 	if (unlikely(scmnd->result))
@@ -2213,13 +2202,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 		goto err_unmap;
 	}
 
-	ret = 0;
-
-unlock_rport:
-	if (in_scsi_eh)
-		mutex_unlock(&rport->mutex);
-
-	return ret;
+	return 0;
 
 err_unmap:
 	srp_unmap_data(scmnd, ch, req);
@@ -2241,7 +2224,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 		ret = SCSI_MLQUEUE_HOST_BUSY;
 	}
 
-	goto unlock_rport;
+	return ret;
 }
 
 /*
-- 
2.20.1

