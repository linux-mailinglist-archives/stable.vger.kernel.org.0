Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7471A5189
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgDKMZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727942AbgDKMQG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:16:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8904621775;
        Sat, 11 Apr 2020 12:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607366;
        bh=GJbNefvUwMlJrQducROtdksojVFFnS7Ma6pcTY09hLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5dgroqk8VQcAY8VR0F2FAlGSoxDqfCxc5U0RFA7PEUo/34WWQuPQ+9GZd641Umo+
         hSDR6fa4Ko6CgGgjrOr8tQPUqgODLpDzzGiau6PaGnkD3AnN53Ok98zeRjd2mV18Lb
         u8CcYpu9+pVoJLCEmbZ5oboWi+VdLccL+QCTLbLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+adb15cf8c2798e4e0db4@syzkaller.appspotmail.com,
        syzbot+e5579222b6a3edd96522@syzkaller.appspotmail.com,
        syzbot+4b628fcc748474003457@syzkaller.appspotmail.com,
        syzbot+29ee8f76017ce6cf03da@syzkaller.appspotmail.com,
        syzbot+6956235342b7317ec564@syzkaller.appspotmail.com,
        syzbot+b358909d8d01556b790b@syzkaller.appspotmail.com,
        syzbot+6b46b135602a3f3ac99e@syzkaller.appspotmail.com,
        syzbot+8458d13b13562abf6b77@syzkaller.appspotmail.com,
        syzbot+bd034f3fdc0402e942ed@syzkaller.appspotmail.com,
        syzbot+c92378b32760a4eef756@syzkaller.appspotmail.com,
        syzbot+68b44a1597636e0b342c@syzkaller.appspotmail.com,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.19 44/54] RDMA/ucma: Put a lock around every call to the rdma_cm layer
Date:   Sat, 11 Apr 2020 14:09:26 +0200
Message-Id: <20200411115513.031279873@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115508.284500414@linuxfoundation.org>
References: <20200411115508.284500414@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 7c11910783a1ea17e88777552ef146cace607b3c upstream.

The rdma_cm must be used single threaded.

This appears to be a bug in the design, as it does have lots of locking
that seems like it should allow concurrency. However, when it is all said
and done every single place that uses the cma_exch() scheme is broken, and
all the unlocked reads from the ucma of the cm_id data are wrong too.

syzkaller has been finding endless bugs related to this.

Fixing this in any elegant way is some enormous amount of work. Take a
very big hammer and put a mutex around everything to do with the
ucma_context at the top of every syscall.

Fixes: 75216638572f ("RDMA/cma: Export rdma cm interface to userspace")
Link: https://lore.kernel.org/r/20200218210432.GA31966@ziepe.ca
Reported-by: syzbot+adb15cf8c2798e4e0db4@syzkaller.appspotmail.com
Reported-by: syzbot+e5579222b6a3edd96522@syzkaller.appspotmail.com
Reported-by: syzbot+4b628fcc748474003457@syzkaller.appspotmail.com
Reported-by: syzbot+29ee8f76017ce6cf03da@syzkaller.appspotmail.com
Reported-by: syzbot+6956235342b7317ec564@syzkaller.appspotmail.com
Reported-by: syzbot+b358909d8d01556b790b@syzkaller.appspotmail.com
Reported-by: syzbot+6b46b135602a3f3ac99e@syzkaller.appspotmail.com
Reported-by: syzbot+8458d13b13562abf6b77@syzkaller.appspotmail.com
Reported-by: syzbot+bd034f3fdc0402e942ed@syzkaller.appspotmail.com
Reported-by: syzbot+c92378b32760a4eef756@syzkaller.appspotmail.com
Reported-by: syzbot+68b44a1597636e0b342c@syzkaller.appspotmail.com
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/ucma.c |   49 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -89,6 +89,7 @@ struct ucma_context {
 
 	struct ucma_file	*file;
 	struct rdma_cm_id	*cm_id;
+	struct mutex		mutex;
 	u64			uid;
 
 	struct list_head	list;
@@ -215,6 +216,7 @@ static struct ucma_context *ucma_alloc_c
 	init_completion(&ctx->comp);
 	INIT_LIST_HEAD(&ctx->mc_list);
 	ctx->file = file;
+	mutex_init(&ctx->mutex);
 
 	mutex_lock(&mut);
 	ctx->id = idr_alloc(&ctx_idr, ctx, 0, 0, GFP_KERNEL);
@@ -596,6 +598,7 @@ static int ucma_free_ctx(struct ucma_con
 	}
 
 	events_reported = ctx->events_reported;
+	mutex_destroy(&ctx->mutex);
 	kfree(ctx);
 	return events_reported;
 }
@@ -665,7 +668,10 @@ static ssize_t ucma_bind_ip(struct ucma_
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
+	mutex_lock(&ctx->mutex);
 	ret = rdma_bind_addr(ctx->cm_id, (struct sockaddr *) &cmd.addr);
+	mutex_unlock(&ctx->mutex);
+
 	ucma_put_ctx(ctx);
 	return ret;
 }
@@ -688,7 +694,9 @@ static ssize_t ucma_bind(struct ucma_fil
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
+	mutex_lock(&ctx->mutex);
 	ret = rdma_bind_addr(ctx->cm_id, (struct sockaddr *) &cmd.addr);
+	mutex_unlock(&ctx->mutex);
 	ucma_put_ctx(ctx);
 	return ret;
 }
@@ -712,8 +720,10 @@ static ssize_t ucma_resolve_ip(struct uc
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
+	mutex_lock(&ctx->mutex);
 	ret = rdma_resolve_addr(ctx->cm_id, (struct sockaddr *) &cmd.src_addr,
 				(struct sockaddr *) &cmd.dst_addr, cmd.timeout_ms);
+	mutex_unlock(&ctx->mutex);
 	ucma_put_ctx(ctx);
 	return ret;
 }
@@ -738,8 +748,10 @@ static ssize_t ucma_resolve_addr(struct
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
+	mutex_lock(&ctx->mutex);
 	ret = rdma_resolve_addr(ctx->cm_id, (struct sockaddr *) &cmd.src_addr,
 				(struct sockaddr *) &cmd.dst_addr, cmd.timeout_ms);
+	mutex_unlock(&ctx->mutex);
 	ucma_put_ctx(ctx);
 	return ret;
 }
@@ -759,7 +771,9 @@ static ssize_t ucma_resolve_route(struct
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
+	mutex_lock(&ctx->mutex);
 	ret = rdma_resolve_route(ctx->cm_id, cmd.timeout_ms);
+	mutex_unlock(&ctx->mutex);
 	ucma_put_ctx(ctx);
 	return ret;
 }
@@ -848,6 +862,7 @@ static ssize_t ucma_query_route(struct u
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
+	mutex_lock(&ctx->mutex);
 	memset(&resp, 0, sizeof resp);
 	addr = (struct sockaddr *) &ctx->cm_id->route.addr.src_addr;
 	memcpy(&resp.src_addr, addr, addr->sa_family == AF_INET ?
@@ -871,6 +886,7 @@ static ssize_t ucma_query_route(struct u
 		ucma_copy_iw_route(&resp, &ctx->cm_id->route);
 
 out:
+	mutex_unlock(&ctx->mutex);
 	if (copy_to_user(u64_to_user_ptr(cmd.response),
 			 &resp, sizeof(resp)))
 		ret = -EFAULT;
@@ -1022,6 +1038,7 @@ static ssize_t ucma_query(struct ucma_fi
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
+	mutex_lock(&ctx->mutex);
 	switch (cmd.option) {
 	case RDMA_USER_CM_QUERY_ADDR:
 		ret = ucma_query_addr(ctx, response, out_len);
@@ -1036,6 +1053,7 @@ static ssize_t ucma_query(struct ucma_fi
 		ret = -ENOSYS;
 		break;
 	}
+	mutex_unlock(&ctx->mutex);
 
 	ucma_put_ctx(ctx);
 	return ret;
@@ -1076,7 +1094,9 @@ static ssize_t ucma_connect(struct ucma_
 		return PTR_ERR(ctx);
 
 	ucma_copy_conn_param(ctx->cm_id, &conn_param, &cmd.conn_param);
+	mutex_lock(&ctx->mutex);
 	ret = rdma_connect(ctx->cm_id, &conn_param);
+	mutex_unlock(&ctx->mutex);
 	ucma_put_ctx(ctx);
 	return ret;
 }
@@ -1097,7 +1117,9 @@ static ssize_t ucma_listen(struct ucma_f
 
 	ctx->backlog = cmd.backlog > 0 && cmd.backlog < max_backlog ?
 		       cmd.backlog : max_backlog;
+	mutex_lock(&ctx->mutex);
 	ret = rdma_listen(ctx->cm_id, ctx->backlog);
+	mutex_unlock(&ctx->mutex);
 	ucma_put_ctx(ctx);
 	return ret;
 }
@@ -1120,13 +1142,17 @@ static ssize_t ucma_accept(struct ucma_f
 	if (cmd.conn_param.valid) {
 		ucma_copy_conn_param(ctx->cm_id, &conn_param, &cmd.conn_param);
 		mutex_lock(&file->mut);
+		mutex_lock(&ctx->mutex);
 		ret = __rdma_accept(ctx->cm_id, &conn_param, NULL);
+		mutex_unlock(&ctx->mutex);
 		if (!ret)
 			ctx->uid = cmd.uid;
 		mutex_unlock(&file->mut);
-	} else
+	} else {
+		mutex_lock(&ctx->mutex);
 		ret = __rdma_accept(ctx->cm_id, NULL, NULL);
-
+		mutex_unlock(&ctx->mutex);
+	}
 	ucma_put_ctx(ctx);
 	return ret;
 }
@@ -1145,7 +1171,9 @@ static ssize_t ucma_reject(struct ucma_f
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
+	mutex_lock(&ctx->mutex);
 	ret = rdma_reject(ctx->cm_id, cmd.private_data, cmd.private_data_len);
+	mutex_unlock(&ctx->mutex);
 	ucma_put_ctx(ctx);
 	return ret;
 }
@@ -1164,7 +1192,9 @@ static ssize_t ucma_disconnect(struct uc
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
+	mutex_lock(&ctx->mutex);
 	ret = rdma_disconnect(ctx->cm_id);
+	mutex_unlock(&ctx->mutex);
 	ucma_put_ctx(ctx);
 	return ret;
 }
@@ -1195,7 +1225,9 @@ static ssize_t ucma_init_qp_attr(struct
 	resp.qp_attr_mask = 0;
 	memset(&qp_attr, 0, sizeof qp_attr);
 	qp_attr.qp_state = cmd.qp_state;
+	mutex_lock(&ctx->mutex);
 	ret = rdma_init_qp_attr(ctx->cm_id, &qp_attr, &resp.qp_attr_mask);
+	mutex_unlock(&ctx->mutex);
 	if (ret)
 		goto out;
 
@@ -1274,9 +1306,13 @@ static int ucma_set_ib_path(struct ucma_
 		struct sa_path_rec opa;
 
 		sa_convert_path_ib_to_opa(&opa, &sa_path);
+		mutex_lock(&ctx->mutex);
 		ret = rdma_set_ib_path(ctx->cm_id, &opa);
+		mutex_unlock(&ctx->mutex);
 	} else {
+		mutex_lock(&ctx->mutex);
 		ret = rdma_set_ib_path(ctx->cm_id, &sa_path);
+		mutex_unlock(&ctx->mutex);
 	}
 	if (ret)
 		return ret;
@@ -1309,7 +1345,9 @@ static int ucma_set_option_level(struct
 
 	switch (level) {
 	case RDMA_OPTION_ID:
+		mutex_lock(&ctx->mutex);
 		ret = ucma_set_option_id(ctx, optname, optval, optlen);
+		mutex_unlock(&ctx->mutex);
 		break;
 	case RDMA_OPTION_IB:
 		ret = ucma_set_option_ib(ctx, optname, optval, optlen);
@@ -1369,8 +1407,10 @@ static ssize_t ucma_notify(struct ucma_f
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
+	mutex_lock(&ctx->mutex);
 	if (ctx->cm_id->device)
 		ret = rdma_notify(ctx->cm_id, (enum ib_event_type)cmd.event);
+	mutex_unlock(&ctx->mutex);
 
 	ucma_put_ctx(ctx);
 	return ret;
@@ -1413,8 +1453,10 @@ static ssize_t ucma_process_join(struct
 	mc->join_state = join_state;
 	mc->uid = cmd->uid;
 	memcpy(&mc->addr, addr, cmd->addr_size);
+	mutex_lock(&ctx->mutex);
 	ret = rdma_join_multicast(ctx->cm_id, (struct sockaddr *)&mc->addr,
 				  join_state, mc);
+	mutex_unlock(&ctx->mutex);
 	if (ret)
 		goto err2;
 
@@ -1518,7 +1560,10 @@ static ssize_t ucma_leave_multicast(stru
 		goto out;
 	}
 
+	mutex_lock(&mc->ctx->mutex);
 	rdma_leave_multicast(mc->ctx->cm_id, (struct sockaddr *) &mc->addr);
+	mutex_unlock(&mc->ctx->mutex);
+
 	mutex_lock(&mc->ctx->file->mut);
 	ucma_cleanup_mc_events(mc);
 	list_del(&mc->list);


