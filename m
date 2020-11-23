Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE8C2C188F
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 23:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732467AbgKWWh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 17:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731256AbgKWWh0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 17:37:26 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D0DC0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 14:37:26 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id r17so20445326wrw.1
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 14:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=scU6gpIkarUbc1xrA0JZOYOQboP9qsZNDYkgJYvYuK8=;
        b=M0Ks6MH7SUmAZjxd6GVWl8rEGa26wF7yU1F/+TfgghCJIxxWNuSrKTQlwwZLC+XcZ2
         ErUUV4UjftRXcCFKC7euEuNBoJDUDr5N21xTbfRYtobDTydinyzcvOswNRwLQBtPLi+V
         LYhF4FszoWRvirfzCiapwooMrTMWCjofNTyLS8cl1gv+7MLJPYVR0Bb9UOFfQmrqx89n
         Dab+8BOp4t3NY1QEInUzW9xpTbpC278b0Ul534m98VTekh/CcV4MgS4JRvzwS6a2KqYS
         EqVLfO3NXhiaJZD9Z2aOAAU8QAHubv2G+w1pH2fpPyBWCgGAYsnE4EUV5594nyBNQJVF
         jUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=scU6gpIkarUbc1xrA0JZOYOQboP9qsZNDYkgJYvYuK8=;
        b=SIiUZjfYylZEo8g8wm1WKM/Ixz7tCzlT05wQYz3qp4z9Dynk4FLiVM81i7Ud2vKRtp
         F/c19NrowKJtoYQfDXOHbzwewK42jxJwTnt7Nm1g/mrD9qB7k3O8F38VN91v3c5wiqSp
         1vNXCkYmpd28HdERIkfJ47nxjj9aExu9Oo0BduTJV4t+Zy44BISuRIZBEOKeGLitRWWg
         utbTxOMtrba527IJO8uuTNzv4EjEe0uDuj75mPfqBUeYgv9Fhv45adkCpSg9bjbj4yya
         ASB6Vt71XDtaVrCxmw1qBVzqypbxGrwDfP+S9Qdf6z2aeXz9to1u1RMNoZ/2gyhw/UsQ
         12CA==
X-Gm-Message-State: AOAM530aAaYXWgoY/S6D+qxJ8fnkwtDTdrEKZaVNM+4eqNdsFCqc8wMg
        aecvnKEmFgrSYbXFgDa46Ck7OdWP+TMJkQ==
X-Google-Smtp-Source: ABdhPJzfaofT5gdWjS+vBZtTu2y/DNm4e9/Ma0JSOG0K6MrOew9w7ennw8ioNbQgi0XK+Ni4/AdvFA==
X-Received: by 2002:adf:e484:: with SMTP id i4mr1931253wrm.398.1606171044714;
        Mon, 23 Nov 2020 14:37:24 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id f18sm21309868wru.42.2020.11.23.14.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 14:37:24 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2][5.9 backport] io_uring: order refnode recycling
Date:   Mon, 23 Nov 2020 22:34:07 +0000
Message-Id: <43b32b9bd361c36db4926ee023b343c38d3400bf.1606170275.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <075a6b4e7a9235d13b08b1f13f461846fbb97673.1606170275.git.asml.silence@gmail.com>
References: <075a6b4e7a9235d13b08b1f13f461846fbb97673.1606170275.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e297822b20e7fe683e107aea46e6402adcf99c70 upstream

Don't recycle a refnode until we're done with all requests of nodes
ejected before.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 24c0ad17ec4c..e98e58d1f690 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -200,6 +200,7 @@ struct fixed_file_ref_node {
 	struct list_head		file_list;
 	struct fixed_file_data		*file_data;
 	struct llist_node		llist;
+	bool				done;
 };
 
 struct fixed_file_data {
@@ -7107,10 +7108,6 @@ static void __io_file_put_work(struct fixed_file_ref_node *ref_node)
 		kfree(pfile);
 	}
 
-	spin_lock(&file_data->lock);
-	list_del(&ref_node->node);
-	spin_unlock(&file_data->lock);
-
 	percpu_ref_exit(&ref_node->refs);
 	kfree(ref_node);
 	percpu_ref_put(&file_data->refs);
@@ -7137,17 +7134,33 @@ static void io_file_put_work(struct work_struct *work)
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
@@ -7171,6 +7184,7 @@ static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->file_list);
 	ref_node->file_data = ctx->file_data;
+	ref_node->done = false;
 	return ref_node;
 }
 
@@ -7298,7 +7312,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 
 	ctx->file_data->cur_refs = &ref_node->refs;
 	spin_lock(&ctx->file_data->lock);
-	list_add(&ref_node->node, &ctx->file_data->ref_list);
+	list_add_tail(&ref_node->node, &ctx->file_data->ref_list);
 	spin_unlock(&ctx->file_data->lock);
 	percpu_ref_get(&ctx->file_data->refs);
 	return ret;
@@ -7443,7 +7457,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	if (needs_switch) {
 		percpu_ref_kill(data->cur_refs);
 		spin_lock(&data->lock);
-		list_add(&ref_node->node, &data->ref_list);
+		list_add_tail(&ref_node->node, &data->ref_list);
 		data->cur_refs = &ref_node->refs;
 		spin_unlock(&data->lock);
 		percpu_ref_get(&ctx->file_data->refs);
-- 
2.24.0

