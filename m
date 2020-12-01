Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BD12C9B69
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgLAJIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:08:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389166AbgLAJIB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:08:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A04D620809;
        Tue,  1 Dec 2020 09:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813640;
        bh=9xLDaTi0dTlAzNe8cBS4SZWGr7Ub7YMtIZ7IP9DxpDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dzq5dRk+IICbVOYiYGbQ2oZxj3ywJNP8/qj6m7VJuW28qQ2Hrz/YJq10evI4FyCdJ
         m+2LkpqIn90sDOZvNWfc8NrlUX+pJSJoZD21yUBGMrHhkd3NP8jp1KUnT1zxbgquS/
         jCnRXfqzeiKR8DGr+Tsyawi6BZvoQEzxOuSyH9Gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 002/152] io_uring: order refnode recycling
Date:   Tue,  1 Dec 2020 09:51:57 +0100
Message-Id: <20201201084711.960794113@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit e297822b20e7fe683e107aea46e6402adcf99c70 upstream.

Don't recycle a refnode until we're done with all requests of nodes
ejected before.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -200,6 +200,7 @@ struct fixed_file_ref_node {
 	struct list_head		file_list;
 	struct fixed_file_data		*file_data;
 	struct llist_node		llist;
+	bool				done;
 };
 
 struct fixed_file_data {
@@ -7106,10 +7107,6 @@ static void __io_file_put_work(struct fi
 		kfree(pfile);
 	}
 
-	spin_lock(&file_data->lock);
-	list_del(&ref_node->node);
-	spin_unlock(&file_data->lock);
-
 	percpu_ref_exit(&ref_node->refs);
 	kfree(ref_node);
 	percpu_ref_put(&file_data->refs);
@@ -7136,17 +7133,33 @@ static void io_file_put_work(struct work
 static void io_file_data_ref_zero(struct percpu_ref *ref)
 {
 	struct fixed_file_ref_node *ref_node;
+	struct fixed_file_data *data;
 	struct io_ring_ctx *ctx;
-	bool first_add;
+	bool first_add = false;
 	int delay = HZ;
 
 	ref_node = container_of(ref, struct fixed_file_ref_node, refs);
-	ctx = ref_node->file_data->ctx;
+	data = ref_node->file_data;
+	ctx = data->ctx;
+
+	spin_lock(&data->lock);
+	ref_node->done = true;
+
+	while (!list_empty(&data->ref_list)) {
+		ref_node = list_first_entry(&data->ref_list,
+					struct fixed_file_ref_node, node);
+		/* recycle ref nodes in order */
+		if (!ref_node->done)
+			break;
+		list_del(&ref_node->node);
+		first_add |= llist_add(&ref_node->llist, &ctx->file_put_llist);
+	}
+	spin_unlock(&data->lock);
+
 
-	if (percpu_ref_is_dying(&ctx->file_data->refs))
+	if (percpu_ref_is_dying(&data->refs))
 		delay = 0;
 
-	first_add = llist_add(&ref_node->llist, &ctx->file_put_llist);
 	if (!delay)
 		mod_delayed_work(system_wq, &ctx->file_put_work, 0);
 	else if (first_add)
@@ -7170,6 +7183,7 @@ static struct fixed_file_ref_node *alloc
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->file_list);
 	ref_node->file_data = ctx->file_data;
+	ref_node->done = false;
 	return ref_node;
 }
 
@@ -7297,7 +7311,7 @@ static int io_sqe_files_register(struct
 
 	ctx->file_data->cur_refs = &ref_node->refs;
 	spin_lock(&ctx->file_data->lock);
-	list_add(&ref_node->node, &ctx->file_data->ref_list);
+	list_add_tail(&ref_node->node, &ctx->file_data->ref_list);
 	spin_unlock(&ctx->file_data->lock);
 	percpu_ref_get(&ctx->file_data->refs);
 	return ret;
@@ -7442,7 +7456,7 @@ static int __io_sqe_files_update(struct
 	if (needs_switch) {
 		percpu_ref_kill(data->cur_refs);
 		spin_lock(&data->lock);
-		list_add(&ref_node->node, &data->ref_list);
+		list_add_tail(&ref_node->node, &data->ref_list);
 		data->cur_refs = &ref_node->refs;
 		spin_unlock(&data->lock);
 		percpu_ref_get(&ctx->file_data->refs);


