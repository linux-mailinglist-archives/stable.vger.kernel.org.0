Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B81B2B7FF5
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 16:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgKRO7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 09:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgKRO7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 09:59:43 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1371C0613D4;
        Wed, 18 Nov 2020 06:59:42 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id p8so2516575wrx.5;
        Wed, 18 Nov 2020 06:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RecmvriZefh9IAaF/p+NfEBGaalcfKqonpY00oHO/X4=;
        b=Tr1AyoaeEsDX31h37eXlRJ8GT6nzuQJuCuvYVAJ9XNSt+Q1Jj6A4MUmCIuUdQ2CN7q
         1/CWqZ90EoPeQ2FqbFZwR84uIVpH4+opYfucCeBuUBXVjbO8ytRm3YGF/98atZlk0Ppr
         xbbucmv/U7phJeWFAeUNwzbL/SfcyR75qCdbOJ5+OWAOQXTNj+1KSaQk80yjjAIH+8WQ
         HLVn2NKrLs3b9iVum1pyzfCLhSFaoA56s2IXg9hfuUOAjp8grAESgTtuQXNgZRkIEimR
         VYzVPAAwZrORQQBHO3w/EBFQqZYBPzxXe3cF0F5WYkm+F7Sh+qZ1FiBYCtLk52aKiQsd
         nzxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RecmvriZefh9IAaF/p+NfEBGaalcfKqonpY00oHO/X4=;
        b=HDx3sdNLdZdvpEt9CWIb4QsKrE3PG9/rU/5CdllaA3BRB8fjQjerxA1e1Ok2RyHJTq
         aUbX9AHZUBSgiYT5JsUYhgtntABAH1IX1lWVzFdBHazO/ae2IEr8uG8OxV+dFs8th/OI
         VJIzmPWyOuBCH5lNk3j0Ifn+xtz5z7bmtMDnvoHfSfIk7Tnt+nqnlLeThX9SSAPN1KD/
         dWkN5uCSsdpHeNyhpbMiDcuKkMuDpQ/xhMDBgK04xsCn2CSGD+2g21k5QcRT/Lt1ldYk
         JTJryPrecaF97J8RbWgVGfFtoMNuOO57t6OZOc7DzjdsDLPN///K1u5qgGYdxkaD9VFz
         Rh8w==
X-Gm-Message-State: AOAM532i3sRrHYIqz4kjxxzrC74luQV2oG8QXgeqFx956gLXtukewORe
        n/Z0GbAT5KC5A/6I65/a15k6CNpEvkMdBA==
X-Google-Smtp-Source: ABdhPJxU/1VWXN+2tlRILE+VRqI29hxtOEpASqf7grVBJIq5XYfFtyDa8yRmDKpIg3aE4ytTaOFJoQ==
X-Received: by 2002:a5d:488f:: with SMTP id g15mr5197926wrq.151.1605711581732;
        Wed, 18 Nov 2020 06:59:41 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id c4sm13222939wrd.30.2020.11.18.06.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 06:59:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 2/2] io_uring: order refnode recycling
Date:   Wed, 18 Nov 2020 14:56:26 +0000
Message-Id: <3ba9d7672a62ad23acd9e55c1a912e619daafbcb.1605710178.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1605710178.git.asml.silence@gmail.com>
References: <cover.1605710178.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Don't recycle a refnode until we're done with all requests of nodes
ejected before.

Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5cb194ca4fce..7d4b755ab451 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -205,6 +205,7 @@ struct fixed_file_ref_node {
 	struct list_head		file_list;
 	struct fixed_file_data		*file_data;
 	struct llist_node		llist;
+	bool				done;
 };
 
 struct fixed_file_data {
@@ -7323,10 +7324,6 @@ static void __io_file_put_work(struct fixed_file_ref_node *ref_node)
 		kfree(pfile);
 	}
 
-	spin_lock(&file_data->lock);
-	list_del(&ref_node->node);
-	spin_unlock(&file_data->lock);
-
 	percpu_ref_exit(&ref_node->refs);
 	kfree(ref_node);
 	percpu_ref_put(&file_data->refs);
@@ -7353,17 +7350,32 @@ static void io_file_put_work(struct work_struct *work)
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
 
-	if (percpu_ref_is_dying(&ctx->file_data->refs))
+	if (percpu_ref_is_dying(&data->refs))
 		delay = 0;
 
-	first_add = llist_add(&ref_node->llist, &ctx->file_put_llist);
 	if (!delay)
 		mod_delayed_work(system_wq, &ctx->file_put_work, 0);
 	else if (first_add)
@@ -7387,6 +7399,7 @@ static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->file_list);
 	ref_node->file_data = ctx->file_data;
+	ref_node->done = false;
 	return ref_node;
 }
 
@@ -7482,7 +7495,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 
 	file_data->node = ref_node;
 	spin_lock(&file_data->lock);
-	list_add(&ref_node->node, &file_data->ref_list);
+	list_add_tail(&ref_node->node, &file_data->ref_list);
 	spin_unlock(&file_data->lock);
 	percpu_ref_get(&file_data->refs);
 	return ret;
@@ -7641,7 +7654,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	if (needs_switch) {
 		percpu_ref_kill(&data->node->refs);
 		spin_lock(&data->lock);
-		list_add(&ref_node->node, &data->ref_list);
+		list_add_tail(&ref_node->node, &data->ref_list);
 		data->node = ref_node;
 		spin_unlock(&data->lock);
 		percpu_ref_get(&ctx->file_data->refs);
-- 
2.24.0

