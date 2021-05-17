Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F44383730
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244823AbhEQPkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244588AbhEQPi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:38:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3AA061943;
        Mon, 17 May 2021 14:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262464;
        bh=C69sFFjLTwRGrFM8sFyWi7PxzrJIrS93PYxgSNh2q44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lw34eqHpg0LWRqphqeH86LqS8V4k4Rkp/wXwXuGMsMtfw3Z0smDTRA010O1Arttrf
         FIwoV2NtX3YDJ2/yN0KNb8mMZrRgpeSVPLTV5rLSCEgDVNhBs7di9g+sqTjDFAEjWw
         9wVf0mU/x9zIaS3pd54H/eC7T0v18dFsWqOv1ma4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shai Malin <smalin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 274/329] nvmet-rdma: Fix NULL deref when SEND is completed with error
Date:   Mon, 17 May 2021 16:03:05 +0200
Message-Id: <20210517140311.384532229@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit 8cc365f9559b86802afc0208389f5c8d46b4ad61 ]

When running some traffic and taking down the link on peer, a
retry counter exceeded error is received. This leads to
nvmet_rdma_error_comp which tried accessing the cq_context to
obtain the queue. The cq_context is no longer valid after the
fix to use shared CQ mechanism and should be obtained similar
to how it is obtained in other functions from the wc->qp.

[ 905.786331] nvmet_rdma: SEND for CQE 0x00000000e3337f90 failed with status transport retry counter exceeded (12).
[ 905.832048] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
[ 905.839919] PGD 0 P4D 0
[ 905.842464] Oops: 0000 1 SMP NOPTI
[ 905.846144] CPU: 13 PID: 1557 Comm: kworker/13:1H Kdump: loaded Tainted: G OE --------- - - 4.18.0-304.el8.x86_64 #1
[ 905.872135] RIP: 0010:nvmet_rdma_error_comp+0x5/0x1b [nvmet_rdma]
[ 905.878259] Code: 19 4f c0 e8 89 b3 a5 f6 e9 5b e0 ff ff 0f b7 75 14 4c 89 ea 48 c7 c7 08 1a 4f c0 e8 71 b3 a5 f6 e9 4b e0 ff ff 0f 1f 44 00 00 <48> 8b 47 48 48 85 c0 74 08 48 89 c7 e9 98 bf 49 00 e9 c3 e3 ff ff
[ 905.897135] RSP: 0018:ffffab601c45fe28 EFLAGS: 00010246
[ 905.902387] RAX: 0000000000000065 RBX: ffff9e729ea2f800 RCX: 0000000000000000
[ 905.909558] RDX: 0000000000000000 RSI: ffff9e72df9567c8 RDI: 0000000000000000
[ 905.916731] RBP: ffff9e729ea2b400 R08: 000000000000074d R09: 0000000000000074
[ 905.923903] R10: 0000000000000000 R11: ffffab601c45fcc0 R12: 0000000000000010
[ 905.931074] R13: 0000000000000000 R14: 0000000000000010 R15: ffff9e729ea2f400
[ 905.938247] FS: 0000000000000000(0000) GS:ffff9e72df940000(0000) knlGS:0000000000000000
[ 905.938249] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 905.950067] nvmet_rdma: SEND for CQE 0x00000000c7356cca failed with status transport retry counter exceeded (12).
[ 905.961855] CR2: 0000000000000048 CR3: 000000678d010004 CR4: 00000000007706e0
[ 905.961855] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 905.961856] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 905.961857] PKRU: 55555554
[ 906.010315] Call Trace:
[ 906.012778] __ib_process_cq+0x89/0x170 [ib_core]
[ 906.017509] ib_cq_poll_work+0x26/0x80 [ib_core]
[ 906.022152] process_one_work+0x1a7/0x360
[ 906.026182] ? create_worker+0x1a0/0x1a0
[ 906.030123] worker_thread+0x30/0x390
[ 906.033802] ? create_worker+0x1a0/0x1a0
[ 906.037744] kthread+0x116/0x130
[ 906.040988] ? kthread_flush_work_fn+0x10/0x10
[ 906.045456] ret_from_fork+0x1f/0x40

Fixes: ca0f1a8055be2 ("nvmet-rdma: use new shared CQ mechanism")
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 6c1f3ab7649c..7d607f435e36 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -700,7 +700,7 @@ static void nvmet_rdma_send_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct nvmet_rdma_rsp *rsp =
 		container_of(wc->wr_cqe, struct nvmet_rdma_rsp, send_cqe);
-	struct nvmet_rdma_queue *queue = cq->cq_context;
+	struct nvmet_rdma_queue *queue = wc->qp->qp_context;
 
 	nvmet_rdma_release_rsp(rsp);
 
@@ -786,7 +786,7 @@ static void nvmet_rdma_write_data_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct nvmet_rdma_rsp *rsp =
 		container_of(wc->wr_cqe, struct nvmet_rdma_rsp, write_cqe);
-	struct nvmet_rdma_queue *queue = cq->cq_context;
+	struct nvmet_rdma_queue *queue = wc->qp->qp_context;
 	struct rdma_cm_id *cm_id = rsp->queue->cm_id;
 	u16 status;
 
-- 
2.30.2



