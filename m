Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEF62E7CBA
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 22:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgL3Vif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 16:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgL3Vie (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 16:38:34 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B08C061575;
        Wed, 30 Dec 2020 13:37:54 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id g185so5872167wmf.3;
        Wed, 30 Dec 2020 13:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7+SMm2iKQGITJSuVgJmlWHkODg8DnWAlieYuuZCnEEw=;
        b=A4DU6IU+SW2/8+RRLgJ9GzfI2VDqCbRF1AmKMedgt4MWMSsKQAX8HHhzWcWPxHL5kk
         nGMEW+AowP37h/ePP9CTbjm82ii7ZjyTkTLiCHUtd7IKZdVSAVjLQHRX+Cj91xpE7zAZ
         FNiGQyOrpIhNm06EuLmsDGIFRzn/8xhyz97C6mMg4HiHjAJk5ITk1tq5SgNgfWs1uNld
         g8hHZfBRSMQKDv27xKmIRw0A4qaeQA9dBjF6QwEL+aP+IP7cf9Y3GtM2qa3niJyDNJQA
         OeNVGl2o6bM/ezMtUtwHl6mj2d1l0poNmD4SC+CGWtzw8Bbm/3jqUujrM6SJ/9Z5Uq9+
         22nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7+SMm2iKQGITJSuVgJmlWHkODg8DnWAlieYuuZCnEEw=;
        b=J0/rNTQP1pkh30zQKNrXNcj2YoOdYU/KS3/Vvwnq3HxEi0UO5UvCLlWSX7/VKwsiUo
         XhISa/O7+vod7IKK/lsChmXK7kzeIimpBlNpTgDPxmdf7Di+2By529abZmhPVBnerTqS
         kCS+ipSjq41WfoUAHP/3Zm3nhc2lONHzr3axtXf3oN4JQmWU4f1TyYDQt4rV4jyDZmvu
         It9t0gdfAMpeUcqNWlezcGMBk5Q22CkgYKy6N8jDRonr+9fxUzLfwnIo7E8tv2PawiI4
         FM11Q5AhCmHUU8PVwGb439o/iOvrSEkcNyBzzfn4wary/LzFmMjpGNujnuC8yh9mILBf
         J66w==
X-Gm-Message-State: AOAM533SbyPZBv28/5Ve8/fPAqhcqhn/CtL5+wPnVfRLaTXkglErpgf6
        YMD+MRKunZCtkzG1ga3vbpoWw9teUQw=
X-Google-Smtp-Source: ABdhPJxOqBwH4sNBfZxX3rp6+qbg0rqynhrm7ze6FaFmdXlKdyA8MfIELKwiwYNTXAp3VT7lZhcFeg==
X-Received: by 2002:a1c:61c3:: with SMTP id v186mr9115093wmb.146.1609364272314;
        Wed, 30 Dec 2020 13:37:52 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.61])
        by smtp.gmail.com with ESMTPSA id 125sm8823626wmc.27.2020.12.30.13.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 13:37:51 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/4] io_uring: add a helper for setting a ref node
Date:   Wed, 30 Dec 2020 21:34:14 +0000
Message-Id: <2fecebc9ab028ca5ea52198b615c30fab6151114.1609361865.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609361865.git.asml.silence@gmail.com>
References: <cover.1609361865.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Setting a new reference node to a file data is not trivial, don't repeat
it, add and use a helper.

Cc: stable@vger.kernel.org # 5.6+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index eb4620ff638e..6372aba8d0c2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7231,6 +7231,16 @@ static void io_file_ref_kill(struct percpu_ref *ref)
 	complete(&data->done);
 }
 
+static void io_sqe_files_set_node(struct fixed_file_data *file_data,
+				  struct fixed_file_ref_node *ref_node)
+{
+	spin_lock_bh(&file_data->lock);
+	file_data->node = ref_node;
+	list_add_tail(&ref_node->node, &file_data->ref_list);
+	spin_unlock_bh(&file_data->lock);
+	percpu_ref_get(&file_data->refs);
+}
+
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 	struct fixed_file_data *data = ctx->file_data;
@@ -7758,11 +7768,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return PTR_ERR(ref_node);
 	}
 
-	file_data->node = ref_node;
-	spin_lock_bh(&file_data->lock);
-	list_add_tail(&ref_node->node, &file_data->ref_list);
-	spin_unlock_bh(&file_data->lock);
-	percpu_ref_get(&file_data->refs);
+	io_sqe_files_set_node(file_data, ref_node);
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -7918,11 +7924,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 	if (needs_switch) {
 		percpu_ref_kill(&data->node->refs);
-		spin_lock_bh(&data->lock);
-		list_add_tail(&ref_node->node, &data->ref_list);
-		data->node = ref_node;
-		spin_unlock_bh(&data->lock);
-		percpu_ref_get(&ctx->file_data->refs);
+		io_sqe_files_set_node(data, ref_node);
 	} else
 		destroy_fixed_file_ref_node(ref_node);
 
-- 
2.24.0

