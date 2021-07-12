Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573833C53A0
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348233AbhGLHzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350548AbhGLHvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C57561179;
        Mon, 12 Jul 2021 07:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075966;
        bh=V0GEwTp2O4MimcRdykcDePVlcRr0UcFVRwsPHO086jE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FU37C8jj0YgBoEo04mTehAIpeVJgvKW1P798pTMe8h/21eiT+St/FU+knAOrASca0
         TmQLf9ujJujG4hw9Fgn6uVl3k8mbLZroOnFk0e8zYbdrDQ1xPWLS7bSL+Q5W+3xEPD
         veSOokTG+LLMimRd4EuHH1NSK59CdUB8x6g5nsiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 442/800] Revert "IB/cm: Mark stale CM ids whenever the mad agent was unregistered"
Date:   Mon, 12 Jul 2021 08:07:45 +0200
Message-Id: <20210712061014.123721107@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit 3595c398f6dbab79a38550ff26104c6ec1035cd3 ]

This reverts commit 9db0ff53cb9b43ed75bacd42a89c1a0ab048b2b0, which wasn't
a full fix and still causes to the following panic:

panic @ time 1605623870.843, thread 0xfffffeb63b552000: vm_fault_lookup: fault on nofault entry, addr: 0xfffffe811a94e000
    time = 1605623870
    cpuid = 9, TSC = 0xb7937acc1b6
    Panic occurred in module kernel loaded at 0xffffffff80200000:Stack: --------------------------------------------------
    kernel:vm_fault+0x19da
    kernel:vm_fault_trap+0x6e
    kernel:trap_pfault+0x1f1
    kernel:trap+0x31e
    kernel:cm_destroy_id+0x38c
    kernel:rdma_destroy_id+0x127
    kernel:sdp_shutdown_task+0x3ae
    kernel:taskqueue_run_locked+0x10b
    kernel:taskqueue_thread_loop+0x87
    kernel:fork_exit+0x83

Link: https://lore.kernel.org/r/4346449a7cdacc7a4eedc89cb1b42d8434ec9814.1622629024.git.leonro@nvidia.com
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 123 ++++-------------------------------
 1 file changed, 14 insertions(+), 109 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 94613275edcc..162261fd16d6 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -121,8 +121,6 @@ static struct ib_cm {
 	__be32 random_id_operand;
 	struct list_head timewait_list;
 	struct workqueue_struct *wq;
-	/* Sync on cm change port state */
-	spinlock_t state_lock;
 } cm;
 
 /* Counter indexes ordered by attribute ID */
@@ -203,8 +201,6 @@ struct cm_port {
 	struct cm_device *cm_dev;
 	struct ib_mad_agent *mad_agent;
 	u32 port_num;
-	struct list_head cm_priv_prim_list;
-	struct list_head cm_priv_altr_list;
 	struct cm_counter_group counter_group[CM_COUNTER_GROUPS];
 };
 
@@ -285,12 +281,6 @@ struct cm_id_private {
 	u8 service_timeout;
 	u8 target_ack_delay;
 
-	struct list_head prim_list;
-	struct list_head altr_list;
-	/* Indicates that the send port mad is registered and av is set */
-	int prim_send_port_not_ready;
-	int altr_send_port_not_ready;
-
 	struct list_head work_list;
 	atomic_t work_count;
 
@@ -310,47 +300,20 @@ static struct ib_mad_send_buf *cm_alloc_msg(struct cm_id_private *cm_id_priv)
 	struct ib_mad_agent *mad_agent;
 	struct ib_mad_send_buf *m;
 	struct ib_ah *ah;
-	struct cm_av *av;
-	unsigned long flags, flags2;
-	int ret = 0;
 
-	/* don't let the port to be released till the agent is down */
-	spin_lock_irqsave(&cm.state_lock, flags2);
-	spin_lock_irqsave(&cm.lock, flags);
-	if (!cm_id_priv->prim_send_port_not_ready)
-		av = &cm_id_priv->av;
-	else if (!cm_id_priv->altr_send_port_not_ready &&
-		 (cm_id_priv->alt_av.port))
-		av = &cm_id_priv->alt_av;
-	else {
-		pr_info("%s: not valid CM id\n", __func__);
-		ret = -ENODEV;
-		spin_unlock_irqrestore(&cm.lock, flags);
-		goto out;
-	}
-	spin_unlock_irqrestore(&cm.lock, flags);
-	/* Make sure the port haven't released the mad yet */
 	mad_agent = cm_id_priv->av.port->mad_agent;
-	if (!mad_agent) {
-		pr_info("%s: not a valid MAD agent\n", __func__);
-		ret = -ENODEV;
-		goto out;
-	}
-	ah = rdma_create_ah(mad_agent->qp->pd, &av->ah_attr, 0);
-	if (IS_ERR(ah)) {
-		ret = PTR_ERR(ah);
-		goto out;
-	}
+	ah = rdma_create_ah(mad_agent->qp->pd, &cm_id_priv->av.ah_attr, 0);
+	if (IS_ERR(ah))
+		return (void *)ah;
 
 	m = ib_create_send_mad(mad_agent, cm_id_priv->id.remote_cm_qpn,
-			       av->pkey_index,
+			       cm_id_priv->av.pkey_index,
 			       0, IB_MGMT_MAD_HDR, IB_MGMT_MAD_DATA,
 			       GFP_ATOMIC,
 			       IB_MGMT_BASE_VERSION);
 	if (IS_ERR(m)) {
 		rdma_destroy_ah(ah, 0);
-		ret = PTR_ERR(m);
-		goto out;
+		return m;
 	}
 
 	/* Timeout set by caller if response is expected. */
@@ -358,13 +321,8 @@ static struct ib_mad_send_buf *cm_alloc_msg(struct cm_id_private *cm_id_priv)
 	m->retries = cm_id_priv->max_cm_retries;
 
 	refcount_inc(&cm_id_priv->refcount);
-	spin_unlock_irqrestore(&cm.state_lock, flags2);
 	m->context[0] = cm_id_priv;
 	return m;
-
-out:
-	spin_unlock_irqrestore(&cm.state_lock, flags2);
-	return ERR_PTR(ret);
 }
 
 static struct ib_mad_send_buf *
@@ -517,21 +475,6 @@ static int cm_init_av_for_response(struct cm_port *port, struct ib_wc *wc,
 				       grh, &av->ah_attr);
 }
 
-static void add_cm_id_to_port_list(struct cm_id_private *cm_id_priv,
-				   struct cm_av *av, struct cm_port *port)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cm.lock, flags);
-	if (&cm_id_priv->av == av)
-		list_add_tail(&cm_id_priv->prim_list, &port->cm_priv_prim_list);
-	else if (&cm_id_priv->alt_av == av)
-		list_add_tail(&cm_id_priv->altr_list, &port->cm_priv_altr_list);
-	else
-		WARN_ON(true);
-	spin_unlock_irqrestore(&cm.lock, flags);
-}
-
 static struct cm_port *
 get_cm_port_from_path(struct sa_path_rec *path, const struct ib_gid_attr *attr)
 {
@@ -575,8 +518,7 @@ get_cm_port_from_path(struct sa_path_rec *path, const struct ib_gid_attr *attr)
 
 static int cm_init_av_by_path(struct sa_path_rec *path,
 			      const struct ib_gid_attr *sgid_attr,
-			      struct cm_av *av,
-			      struct cm_id_private *cm_id_priv)
+			      struct cm_av *av)
 {
 	struct rdma_ah_attr new_ah_attr;
 	struct cm_device *cm_dev;
@@ -610,7 +552,6 @@ static int cm_init_av_by_path(struct sa_path_rec *path,
 		return ret;
 
 	av->timeout = path->packet_life_time + 1;
-	add_cm_id_to_port_list(cm_id_priv, av, port);
 	rdma_move_ah_attr(&av->ah_attr, &new_ah_attr);
 	return 0;
 }
@@ -890,8 +831,6 @@ static struct cm_id_private *cm_alloc_id_priv(struct ib_device *device,
 	spin_lock_init(&cm_id_priv->lock);
 	init_completion(&cm_id_priv->comp);
 	INIT_LIST_HEAD(&cm_id_priv->work_list);
-	INIT_LIST_HEAD(&cm_id_priv->prim_list);
-	INIT_LIST_HEAD(&cm_id_priv->altr_list);
 	atomic_set(&cm_id_priv->work_count, -1);
 	refcount_set(&cm_id_priv->refcount, 1);
 
@@ -1192,12 +1131,7 @@ retest:
 		kfree(cm_id_priv->timewait_info);
 		cm_id_priv->timewait_info = NULL;
 	}
-	if (!list_empty(&cm_id_priv->altr_list) &&
-	    (!cm_id_priv->altr_send_port_not_ready))
-		list_del(&cm_id_priv->altr_list);
-	if (!list_empty(&cm_id_priv->prim_list) &&
-	    (!cm_id_priv->prim_send_port_not_ready))
-		list_del(&cm_id_priv->prim_list);
+
 	WARN_ON(cm_id_priv->listen_sharecount);
 	WARN_ON(!RB_EMPTY_NODE(&cm_id_priv->service_node));
 	if (!RB_EMPTY_NODE(&cm_id_priv->sidr_id_node))
@@ -1565,13 +1499,12 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
 	}
 
 	ret = cm_init_av_by_path(param->primary_path,
-				 param->ppath_sgid_attr, &cm_id_priv->av,
-				 cm_id_priv);
+				 param->ppath_sgid_attr, &cm_id_priv->av);
 	if (ret)
 		goto out;
 	if (param->alternate_path) {
 		ret = cm_init_av_by_path(param->alternate_path, NULL,
-					 &cm_id_priv->alt_av, cm_id_priv);
+					 &cm_id_priv->alt_av);
 		if (ret)
 			goto out;
 	}
@@ -2203,8 +2136,7 @@ static int cm_req_handler(struct cm_work *work)
 		sa_path_set_dmac(&work->path[0],
 				 cm_id_priv->av.ah_attr.roce.dmac);
 	work->path[0].hop_limit = grh->hop_limit;
-	ret = cm_init_av_by_path(&work->path[0], gid_attr, &cm_id_priv->av,
-				 cm_id_priv);
+	ret = cm_init_av_by_path(&work->path[0], gid_attr, &cm_id_priv->av);
 	if (ret) {
 		int err;
 
@@ -2223,7 +2155,7 @@ static int cm_req_handler(struct cm_work *work)
 	}
 	if (cm_req_has_alt_path(req_msg)) {
 		ret = cm_init_av_by_path(&work->path[1], NULL,
-					 &cm_id_priv->alt_av, cm_id_priv);
+					 &cm_id_priv->alt_av);
 		if (ret) {
 			ib_send_cm_rej(&cm_id_priv->id,
 				       IB_CM_REJ_INVALID_ALT_GID,
@@ -3404,7 +3336,7 @@ static int cm_lap_handler(struct cm_work *work)
 		goto unlock;
 
 	ret = cm_init_av_by_path(param->alternate_path, NULL,
-				 &cm_id_priv->alt_av, cm_id_priv);
+				 &cm_id_priv->alt_av);
 	if (ret)
 		goto unlock;
 
@@ -3524,8 +3456,7 @@ int ib_send_cm_sidr_req(struct ib_cm_id *cm_id,
 
 	cm_id_priv = container_of(cm_id, struct cm_id_private, id);
 	ret = cm_init_av_by_path(param->path, param->sgid_attr,
-				 &cm_id_priv->av,
-				 cm_id_priv);
+				 &cm_id_priv->av);
 	if (ret)
 		return ret;
 
@@ -4010,9 +3941,7 @@ out:
 static int cm_migrate(struct ib_cm_id *cm_id)
 {
 	struct cm_id_private *cm_id_priv;
-	struct cm_av tmp_av;
 	unsigned long flags;
-	int tmp_send_port_not_ready;
 	int ret = 0;
 
 	cm_id_priv = container_of(cm_id, struct cm_id_private, id);
@@ -4021,14 +3950,7 @@ static int cm_migrate(struct ib_cm_id *cm_id)
 	    (cm_id->lap_state == IB_CM_LAP_UNINIT ||
 	     cm_id->lap_state == IB_CM_LAP_IDLE)) {
 		cm_id->lap_state = IB_CM_LAP_IDLE;
-		/* Swap address vector */
-		tmp_av = cm_id_priv->av;
 		cm_id_priv->av = cm_id_priv->alt_av;
-		cm_id_priv->alt_av = tmp_av;
-		/* Swap port send ready state */
-		tmp_send_port_not_ready = cm_id_priv->prim_send_port_not_ready;
-		cm_id_priv->prim_send_port_not_ready = cm_id_priv->altr_send_port_not_ready;
-		cm_id_priv->altr_send_port_not_ready = tmp_send_port_not_ready;
 	} else
 		ret = -EINVAL;
 	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
@@ -4403,9 +4325,6 @@ static int cm_add_one(struct ib_device *ib_device)
 		port->cm_dev = cm_dev;
 		port->port_num = i;
 
-		INIT_LIST_HEAD(&port->cm_priv_prim_list);
-		INIT_LIST_HEAD(&port->cm_priv_altr_list);
-
 		ret = cm_create_port_fs(port);
 		if (ret)
 			goto error1;
@@ -4469,8 +4388,6 @@ static void cm_remove_one(struct ib_device *ib_device, void *client_data)
 {
 	struct cm_device *cm_dev = client_data;
 	struct cm_port *port;
-	struct cm_id_private *cm_id_priv;
-	struct ib_mad_agent *cur_mad_agent;
 	struct ib_port_modify port_modify = {
 		.clr_port_cap_mask = IB_PORT_CM_SUP
 	};
@@ -4491,24 +4408,13 @@ static void cm_remove_one(struct ib_device *ib_device, void *client_data)
 
 		port = cm_dev->port[i-1];
 		ib_modify_port(ib_device, port->port_num, 0, &port_modify);
-		/* Mark all the cm_id's as not valid */
-		spin_lock_irq(&cm.lock);
-		list_for_each_entry(cm_id_priv, &port->cm_priv_altr_list, altr_list)
-			cm_id_priv->altr_send_port_not_ready = 1;
-		list_for_each_entry(cm_id_priv, &port->cm_priv_prim_list, prim_list)
-			cm_id_priv->prim_send_port_not_ready = 1;
-		spin_unlock_irq(&cm.lock);
 		/*
 		 * We flush the queue here after the going_down set, this
 		 * verify that no new works will be queued in the recv handler,
 		 * after that we can call the unregister_mad_agent
 		 */
 		flush_workqueue(cm.wq);
-		spin_lock_irq(&cm.state_lock);
-		cur_mad_agent = port->mad_agent;
-		port->mad_agent = NULL;
-		spin_unlock_irq(&cm.state_lock);
-		ib_unregister_mad_agent(cur_mad_agent);
+		ib_unregister_mad_agent(port->mad_agent);
 		cm_remove_port_fs(port);
 		kfree(port);
 	}
@@ -4523,7 +4429,6 @@ static int __init ib_cm_init(void)
 	INIT_LIST_HEAD(&cm.device_list);
 	rwlock_init(&cm.device_lock);
 	spin_lock_init(&cm.lock);
-	spin_lock_init(&cm.state_lock);
 	cm.listen_service_table = RB_ROOT;
 	cm.listen_service_id = be64_to_cpu(IB_CM_ASSIGN_SERVICE_ID);
 	cm.remote_id_table = RB_ROOT;
-- 
2.30.2



