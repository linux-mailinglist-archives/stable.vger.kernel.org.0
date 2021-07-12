Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333443C5395
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348135AbhGLHzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350522AbhGLHvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 852D761183;
        Mon, 12 Jul 2021 07:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075962;
        bh=++QdyRPWhQUvLt9FQabo6Zfp5N9ZiaERRBMRZ9pXZwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZ7f7+tVZUqV4ZbOgXctadYHZyqlMVWELblERcn5Jkk6FuD7J/SXpFK+C6QTpaOCL
         NnDae0s0OnpERPTqaQtYD7b+Anyvv9t6L4f2Rg7K0ZRkO9gQjQkChYyE/sUeP9Wtgh
         RQ5oQZXGZ6jUJCN6hrQ3B6krgNSGcPvLSuZBYKK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 440/800] IB/cm: Pair cm_alloc_response_msg() with a cm_free_response_msg()
Date:   Mon, 12 Jul 2021 08:07:43 +0200
Message-Id: <20210712061013.891320777@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 96376a40959e32502208210c62e68a6c60acfb48 ]

This is not a functional change, but it helps make the purpose of all the
cm_free_msg() calls clearer. In this case a response msg has a NULL
context[0], and is never placed in cm_id_priv->msg.

Link: https://lore.kernel.org/r/5cd53163be7df0a94f0d4ef7294546bc674fb74a.1622629024.git.leonro@nvidia.com
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 0ead0d223154..6e20ba5d32e1 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -413,7 +413,7 @@ static int cm_alloc_response_msg(struct cm_port *port,
 
 	ret = cm_create_response_msg_ah(port, mad_recv_wc, m);
 	if (ret) {
-		cm_free_msg(m);
+		ib_free_send_mad(m);
 		return ret;
 	}
 
@@ -421,6 +421,13 @@ static int cm_alloc_response_msg(struct cm_port *port,
 	return 0;
 }
 
+static void cm_free_response_msg(struct ib_mad_send_buf *msg)
+{
+	if (msg->ah)
+		rdma_destroy_ah(msg->ah, 0);
+	ib_free_send_mad(msg);
+}
+
 static void *cm_copy_private_data(const void *private_data, u8 private_data_len)
 {
 	void *data;
@@ -1569,16 +1576,16 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
 	spin_lock_irqsave(&cm_id_priv->lock, flags);
 	ret = ib_post_send_mad(cm_id_priv->msg, NULL);
 	if (ret) {
+		cm_free_msg(cm_id_priv->msg);
 		spin_unlock_irqrestore(&cm_id_priv->lock, flags);
-		goto error2;
+		goto out;
 	}
 	BUG_ON(cm_id->state != IB_CM_IDLE);
 	cm_id->state = IB_CM_REQ_SENT;
 	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 	return 0;
-
-error2:	cm_free_msg(cm_id_priv->msg);
-out:	return ret;
+out:
+	return ret;
 }
 EXPORT_SYMBOL(ib_send_cm_req);
 
@@ -1618,7 +1625,7 @@ static int cm_issue_rej(struct cm_port *port,
 		IBA_GET(CM_REJ_REMOTE_COMM_ID, rcv_msg));
 	ret = ib_post_send_mad(msg, NULL);
 	if (ret)
-		cm_free_msg(msg);
+		cm_free_response_msg(msg);
 
 	return ret;
 }
@@ -1974,7 +1981,7 @@ static void cm_dup_req_handler(struct cm_work *work,
 	return;
 
 unlock:	spin_unlock_irq(&cm_id_priv->lock);
-free:	cm_free_msg(msg);
+free:	cm_free_response_msg(msg);
 }
 
 static struct cm_id_private *cm_match_req(struct cm_work *work,
@@ -2453,7 +2460,7 @@ static void cm_dup_rep_handler(struct cm_work *work)
 	goto deref;
 
 unlock:	spin_unlock_irq(&cm_id_priv->lock);
-free:	cm_free_msg(msg);
+free:	cm_free_response_msg(msg);
 deref:	cm_deref_id(cm_id_priv);
 }
 
@@ -2794,7 +2801,7 @@ static int cm_issue_drep(struct cm_port *port,
 		IBA_GET(CM_DREQ_REMOTE_COMM_ID, dreq_msg));
 	ret = ib_post_send_mad(msg, NULL);
 	if (ret)
-		cm_free_msg(msg);
+		cm_free_response_msg(msg);
 
 	return ret;
 }
@@ -2853,7 +2860,7 @@ static int cm_dreq_handler(struct cm_work *work)
 
 		if (cm_create_response_msg_ah(work->port, work->mad_recv_wc, msg) ||
 		    ib_post_send_mad(msg, NULL))
-			cm_free_msg(msg);
+			cm_free_response_msg(msg);
 		goto deref;
 	case IB_CM_DREQ_RCVD:
 		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
@@ -3343,7 +3350,7 @@ static int cm_lap_handler(struct cm_work *work)
 
 		if (cm_create_response_msg_ah(work->port, work->mad_recv_wc, msg) ||
 		    ib_post_send_mad(msg, NULL))
-			cm_free_msg(msg);
+			cm_free_response_msg(msg);
 		goto deref;
 	case IB_CM_LAP_RCVD:
 		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
-- 
2.30.2



