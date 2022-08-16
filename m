Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3917C594987
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244274AbiHOXcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353520AbiHOX2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:28:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658A714ECA3;
        Mon, 15 Aug 2022 13:07:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BD3B60B69;
        Mon, 15 Aug 2022 20:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFEFC433D6;
        Mon, 15 Aug 2022 20:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594068;
        bh=Ycp0s2Glg8mhvTj7X08fjKGg5VeHENMBJ1BiPadpejc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1ZsTV26xlaci6EevSOFWAn5Ny/oRo5vfCF6c5UzPXn8I37x4BYvIXvEhO1ZI5S4F
         6aQMZ0AbZwYrE/MgpB1MUo9AfGeUN0DpwIih/RCLNLFyPCeHE50UviiWfy+VHclBzW
         UHNo6EHeLMv5gmT/LajrUa+FN0vrHb8uEq31is1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1050/1095] ksmbd: smbd: introduce read/write credits for RDMA read/write
Date:   Mon, 15 Aug 2022 20:07:29 +0200
Message-Id: <20220815180512.513026047@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit ddbdc861e37c168cf2fb8a7b7477f5d18b4daf76 ]

SMB2_READ/SMB2_WRITE request has to be granted the number
of rw credits, the pages the request wants to transfer
/ the maximum pages which can be registered with one
MR to read and write a file.
And allocate enough RDMA resources for the maximum
number of rw credits allowed by ksmbd.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/transport_rdma.c | 120 ++++++++++++++++++++++----------------
 1 file changed, 71 insertions(+), 49 deletions(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 479d279ee146..b44a5e584bac 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -80,9 +80,7 @@ static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
 /*  The maximum single-message size which can be received */
 static int smb_direct_max_receive_size = 8192;
 
-static int smb_direct_max_read_write_size = 524224;
-
-static int smb_direct_max_outstanding_rw_ops = 8;
+static int smb_direct_max_read_write_size = 8 * 1024 * 1024;
 
 static LIST_HEAD(smb_direct_device_list);
 static DEFINE_RWLOCK(smb_direct_device_lock);
@@ -147,10 +145,12 @@ struct smb_direct_transport {
 	atomic_t		send_credits;
 	spinlock_t		lock_new_recv_credits;
 	int			new_recv_credits;
-	atomic_t		rw_avail_ops;
+	int			max_rw_credits;
+	int			pages_per_rw_credit;
+	atomic_t		rw_credits;
 
 	wait_queue_head_t	wait_send_credits;
-	wait_queue_head_t	wait_rw_avail_ops;
+	wait_queue_head_t	wait_rw_credits;
 
 	mempool_t		*sendmsg_mempool;
 	struct kmem_cache	*sendmsg_cache;
@@ -377,7 +377,7 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	t->reassembly_queue_length = 0;
 	init_waitqueue_head(&t->wait_reassembly_queue);
 	init_waitqueue_head(&t->wait_send_credits);
-	init_waitqueue_head(&t->wait_rw_avail_ops);
+	init_waitqueue_head(&t->wait_rw_credits);
 
 	spin_lock_init(&t->receive_credit_lock);
 	spin_lock_init(&t->recvmsg_queue_lock);
@@ -984,18 +984,19 @@ static int smb_direct_flush_send_list(struct smb_direct_transport *t,
 }
 
 static int wait_for_credits(struct smb_direct_transport *t,
-			    wait_queue_head_t *waitq, atomic_t *credits)
+			    wait_queue_head_t *waitq, atomic_t *total_credits,
+			    int needed)
 {
 	int ret;
 
 	do {
-		if (atomic_dec_return(credits) >= 0)
+		if (atomic_sub_return(needed, total_credits) >= 0)
 			return 0;
 
-		atomic_inc(credits);
+		atomic_add(needed, total_credits);
 		ret = wait_event_interruptible(*waitq,
-					       atomic_read(credits) > 0 ||
-						t->status != SMB_DIRECT_CS_CONNECTED);
+					       atomic_read(total_credits) >= needed ||
+					       t->status != SMB_DIRECT_CS_CONNECTED);
 
 		if (t->status != SMB_DIRECT_CS_CONNECTED)
 			return -ENOTCONN;
@@ -1016,7 +1017,19 @@ static int wait_for_send_credits(struct smb_direct_transport *t,
 			return ret;
 	}
 
-	return wait_for_credits(t, &t->wait_send_credits, &t->send_credits);
+	return wait_for_credits(t, &t->wait_send_credits, &t->send_credits, 1);
+}
+
+static int wait_for_rw_credits(struct smb_direct_transport *t, int credits)
+{
+	return wait_for_credits(t, &t->wait_rw_credits, &t->rw_credits, credits);
+}
+
+static int calc_rw_credits(struct smb_direct_transport *t,
+			   char *buf, unsigned int len)
+{
+	return DIV_ROUND_UP(get_buf_page_count(buf, len),
+			    t->pages_per_rw_credit);
 }
 
 static int smb_direct_create_header(struct smb_direct_transport *t,
@@ -1332,8 +1345,8 @@ static void read_write_done(struct ib_cq *cq, struct ib_wc *wc,
 		smb_direct_disconnect_rdma_connection(t);
 	}
 
-	if (atomic_inc_return(&t->rw_avail_ops) > 0)
-		wake_up(&t->wait_rw_avail_ops);
+	if (atomic_inc_return(&t->rw_credits) > 0)
+		wake_up(&t->wait_rw_credits);
 
 	rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
 			    msg->sg_list, msg->sgt.nents, dir);
@@ -1364,8 +1377,10 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 	struct ib_send_wr *first_wr = NULL;
 	u32 remote_key = le32_to_cpu(desc[0].token);
 	u64 remote_offset = le64_to_cpu(desc[0].offset);
+	int credits_needed;
 
-	ret = wait_for_credits(t, &t->wait_rw_avail_ops, &t->rw_avail_ops);
+	credits_needed = calc_rw_credits(t, buf, buf_len);
+	ret = wait_for_rw_credits(t, credits_needed);
 	if (ret < 0)
 		return ret;
 
@@ -1373,7 +1388,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 	msg = kmalloc(offsetof(struct smb_direct_rdma_rw_msg, sg_list) +
 		      sizeof(struct scatterlist) * SG_CHUNK_SIZE, GFP_KERNEL);
 	if (!msg) {
-		atomic_inc(&t->rw_avail_ops);
+		atomic_add(credits_needed, &t->rw_credits);
 		return -ENOMEM;
 	}
 
@@ -1382,7 +1397,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 				     get_buf_page_count(buf, buf_len),
 				     msg->sg_list, SG_CHUNK_SIZE);
 	if (ret) {
-		atomic_inc(&t->rw_avail_ops);
+		atomic_add(credits_needed, &t->rw_credits);
 		kfree(msg);
 		return -ENOMEM;
 	}
@@ -1418,7 +1433,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 	return 0;
 
 err:
-	atomic_inc(&t->rw_avail_ops);
+	atomic_add(credits_needed, &t->rw_credits);
 	if (first_wr)
 		rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
 				    msg->sg_list, msg->sgt.nents,
@@ -1643,11 +1658,19 @@ static int smb_direct_prepare_negotiation(struct smb_direct_transport *t)
 	return ret;
 }
 
+static unsigned int smb_direct_get_max_fr_pages(struct smb_direct_transport *t)
+{
+	return min_t(unsigned int,
+		     t->cm_id->device->attrs.max_fast_reg_page_list_len,
+		     256);
+}
+
 static int smb_direct_init_params(struct smb_direct_transport *t,
 				  struct ib_qp_cap *cap)
 {
 	struct ib_device *device = t->cm_id->device;
-	int max_send_sges, max_pages, max_rw_wrs, max_send_wrs;
+	int max_send_sges, max_rw_wrs, max_send_wrs;
+	unsigned int max_sge_per_wr, wrs_per_credit;
 
 	/* need 2 more sge. because a SMB_DIRECT header will be mapped,
 	 * and maybe a send buffer could be not page aligned.
@@ -1659,25 +1682,31 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 		return -EINVAL;
 	}
 
-	/*
-	 * allow smb_direct_max_outstanding_rw_ops of in-flight RDMA
-	 * read/writes. HCA guarantees at least max_send_sge of sges for
-	 * a RDMA read/write work request, and if memory registration is used,
-	 * we need reg_mr, local_inv wrs for each read/write.
+	/* Calculate the number of work requests for RDMA R/W.
+	 * The maximum number of pages which can be registered
+	 * with one Memory region can be transferred with one
+	 * R/W credit. And at least 4 work requests for each credit
+	 * are needed for MR registration, RDMA R/W, local & remote
+	 * MR invalidation.
 	 */
 	t->max_rdma_rw_size = smb_direct_max_read_write_size;
-	max_pages = DIV_ROUND_UP(t->max_rdma_rw_size, PAGE_SIZE) + 1;
-	max_rw_wrs = DIV_ROUND_UP(max_pages, SMB_DIRECT_MAX_SEND_SGES);
-	max_rw_wrs += rdma_rw_mr_factor(device, t->cm_id->port_num,
-			max_pages) * 2;
-	max_rw_wrs *= smb_direct_max_outstanding_rw_ops;
+	t->pages_per_rw_credit = smb_direct_get_max_fr_pages(t);
+	t->max_rw_credits = DIV_ROUND_UP(t->max_rdma_rw_size,
+					 (t->pages_per_rw_credit - 1) *
+					 PAGE_SIZE);
+
+	max_sge_per_wr = min_t(unsigned int, device->attrs.max_send_sge,
+			       device->attrs.max_sge_rd);
+	wrs_per_credit = max_t(unsigned int, 4,
+			       DIV_ROUND_UP(t->pages_per_rw_credit,
+					    max_sge_per_wr) + 1);
+	max_rw_wrs = t->max_rw_credits * wrs_per_credit;
 
 	max_send_wrs = smb_direct_send_credit_target + max_rw_wrs;
 	if (max_send_wrs > device->attrs.max_cqe ||
 	    max_send_wrs > device->attrs.max_qp_wr) {
-		pr_err("consider lowering send_credit_target = %d, or max_outstanding_rw_ops = %d\n",
-		       smb_direct_send_credit_target,
-		       smb_direct_max_outstanding_rw_ops);
+		pr_err("consider lowering send_credit_target = %d\n",
+		       smb_direct_send_credit_target);
 		pr_err("Possible CQE overrun, device reporting max_cqe %d max_qp_wr %d\n",
 		       device->attrs.max_cqe, device->attrs.max_qp_wr);
 		return -EINVAL;
@@ -1712,7 +1741,7 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 
 	t->send_credit_target = smb_direct_send_credit_target;
 	atomic_set(&t->send_credits, 0);
-	atomic_set(&t->rw_avail_ops, smb_direct_max_outstanding_rw_ops);
+	atomic_set(&t->rw_credits, t->max_rw_credits);
 
 	t->max_send_size = smb_direct_max_send_size;
 	t->max_recv_size = smb_direct_max_receive_size;
@@ -1720,12 +1749,10 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 
 	cap->max_send_wr = max_send_wrs;
 	cap->max_recv_wr = t->recv_credit_max;
-	cap->max_send_sge = SMB_DIRECT_MAX_SEND_SGES;
+	cap->max_send_sge = max_sge_per_wr;
 	cap->max_recv_sge = SMB_DIRECT_MAX_RECV_SGES;
 	cap->max_inline_data = 0;
-	cap->max_rdma_ctxs =
-		rdma_rw_mr_factor(device, t->cm_id->port_num, max_pages) *
-		smb_direct_max_outstanding_rw_ops;
+	cap->max_rdma_ctxs = t->max_rw_credits;
 	return 0;
 }
 
@@ -1818,7 +1845,8 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 	}
 
 	t->send_cq = ib_alloc_cq(t->cm_id->device, t,
-				 t->send_credit_target, 0, IB_POLL_WORKQUEUE);
+				 smb_direct_send_credit_target + cap->max_rdma_ctxs,
+				 0, IB_POLL_WORKQUEUE);
 	if (IS_ERR(t->send_cq)) {
 		pr_err("Can't create RDMA send CQ\n");
 		ret = PTR_ERR(t->send_cq);
@@ -1827,8 +1855,7 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 	}
 
 	t->recv_cq = ib_alloc_cq(t->cm_id->device, t,
-				 cap->max_send_wr + cap->max_rdma_ctxs,
-				 0, IB_POLL_WORKQUEUE);
+				 t->recv_credit_max, 0, IB_POLL_WORKQUEUE);
 	if (IS_ERR(t->recv_cq)) {
 		pr_err("Can't create RDMA recv CQ\n");
 		ret = PTR_ERR(t->recv_cq);
@@ -1857,17 +1884,12 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 
 	pages_per_rw = DIV_ROUND_UP(t->max_rdma_rw_size, PAGE_SIZE) + 1;
 	if (pages_per_rw > t->cm_id->device->attrs.max_sgl_rd) {
-		int pages_per_mr, mr_count;
-
-		pages_per_mr = min_t(int, pages_per_rw,
-				     t->cm_id->device->attrs.max_fast_reg_page_list_len);
-		mr_count = DIV_ROUND_UP(pages_per_rw, pages_per_mr) *
-			atomic_read(&t->rw_avail_ops);
-		ret = ib_mr_pool_init(t->qp, &t->qp->rdma_mrs, mr_count,
-				      IB_MR_TYPE_MEM_REG, pages_per_mr, 0);
+		ret = ib_mr_pool_init(t->qp, &t->qp->rdma_mrs,
+				      t->max_rw_credits, IB_MR_TYPE_MEM_REG,
+				      t->pages_per_rw_credit, 0);
 		if (ret) {
 			pr_err("failed to init mr pool count %d pages %d\n",
-			       mr_count, pages_per_mr);
+			       t->max_rw_credits, t->pages_per_rw_credit);
 			goto err;
 		}
 	}
-- 
2.35.1



