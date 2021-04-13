Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD4A35D516
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 04:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241506AbhDMCDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 22:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240831AbhDMCDY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 22:03:24 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C57EC061574;
        Mon, 12 Apr 2021 19:03:05 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id f12so14833863wro.0;
        Mon, 12 Apr 2021 19:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KgTdmIPWjlDYb1zlzGsCYbP8TgXluOQ1r6Ejfcu4Ea8=;
        b=hRG6T0AuCgm5Ro8YvgKy0y8L6EdJ7FnjibCwkO1IqIy4AUzo6xDoRjIRJ+ACEaaHMG
         gmJX3VbKuhxRQ6UHcyRZrdGOLIXNFSkmP4JIuuqrcDUEBbosXjCMYTvXJB9s76hTpp6k
         ntPqYUyVWBaYNRiBauZf75mGGa90lUukfIV/9wcIVlXrYlAFmIc/6JqrTfVtoK/Wi8c4
         jX0UOcGn5HO4ZRPHRXJBArqFU2kjSlGRSnWvoGfa6AHS+5tqB6W7gFx8kGAMpKrpJCvR
         QwHQkjIttNtjqsUh8RRwsUFpar+VQJmHVISWkjmc0scw7iJRdg+BH1ib8Oz79DNnJxdI
         MAMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KgTdmIPWjlDYb1zlzGsCYbP8TgXluOQ1r6Ejfcu4Ea8=;
        b=qkKrFK3PzNlIRGSoEk/WXO4o/jGawrFfWmGzX4FUCoO5v8v3U+j6XpxufPFAyDJGW7
         /w4ojCodJ21WWkDinCZnRd37QGPGH7akGeMO1dtI8CkBnCmFJB0UFeKZ9uDdt7YTJeUp
         M5sQvQk2fjoWKdnzwUUlJjDdwwkhqS3HSS7OXwNYq0k8hkoabd4AkA0DNRqYg57+hevh
         kY6nQOAfMapejy1KqY28FvfIqmKmfXLL/7JD7OPK0o/pcu5KM8aMkIgd2gd1P2bET/uD
         ITb37z2XV6LfNfcS7vDALzqjVf/h36+DOfaaoP6SytwlGL5L2zdRkJfBzF2+DBZe/cU8
         ps7A==
X-Gm-Message-State: AOAM530aIMU56SjFVBUqK7llJpbF+hnFVZVXtquQqyLit29ZddyL1Zav
        T8JIwB9Y0Lc0XkEuVnvnb/Z/ZFHEjZ8=
X-Google-Smtp-Source: ABdhPJxENjq673bL/JceROU/asRr0Pp8tdxaSCPbs9Eo5ns5SHshu6S8Sg8Cp9US+qqHmT/vX5uChw==
X-Received: by 2002:adf:9cc1:: with SMTP id h1mr33672126wre.135.1618279383584;
        Mon, 12 Apr 2021 19:03:03 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.208])
        by smtp.gmail.com with ESMTPSA id k7sm18771331wrw.64.2021.04.12.19.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 19:03:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/9] io_uring: fix leaking reg files on exit
Date:   Tue, 13 Apr 2021 02:58:38 +0100
Message-Id: <e696e9eade571b51997d0dc1d01f144c6d685c05.1618278933.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618278933.git.asml.silence@gmail.com>
References: <cover.1618278933.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If io_sqe_files_unregister() faults on io_rsrc_ref_quiesce(), it will
fail to do unregister leaving files referenced. And that may well happen
because of a strayed signal or just because it does allocations inside.

In io_ring_ctx_free() do an unsafe version of unregister, as it's
guaranteed to not have requests by that point and so quiesce is useless.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 257eddd4cd82..44342ff5c4e1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7094,6 +7094,10 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 			fput(file);
 	}
 #endif
+	io_free_file_tables(&ctx->file_table, ctx->nr_user_files);
+	kfree(ctx->file_data);
+	ctx->file_data = NULL;
+	ctx->nr_user_files = 0;
 }
 
 static inline void io_rsrc_ref_lock(struct io_ring_ctx *ctx)
@@ -7200,21 +7204,14 @@ static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx,
 
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
-	struct io_rsrc_data *data = ctx->file_data;
 	int ret;
 
-	if (!data)
+	if (!ctx->file_data)
 		return -ENXIO;
-	ret = io_rsrc_ref_quiesce(data, ctx);
-	if (ret)
-		return ret;
-
-	__io_sqe_files_unregister(ctx);
-	io_free_file_tables(&ctx->file_table, ctx->nr_user_files);
-	kfree(data);
-	ctx->file_data = NULL;
-	ctx->nr_user_files = 0;
-	return 0;
+	ret = io_rsrc_ref_quiesce(ctx->file_data, ctx);
+	if (!ret)
+		__io_sqe_files_unregister(ctx);
+	return ret;
 }
 
 static void io_sq_thread_unpark(struct io_sq_data *sqd)
@@ -7664,7 +7661,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 
 	ret = io_sqe_files_scm(ctx);
 	if (ret) {
-		io_sqe_files_unregister(ctx);
+		__io_sqe_files_unregister(ctx);
 		return ret;
 	}
 
@@ -8465,7 +8462,11 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	}
 
 	mutex_lock(&ctx->uring_lock);
-	io_sqe_files_unregister(ctx);
+	if (ctx->file_data) {
+		if (!atomic_dec_and_test(&ctx->file_data->refs))
+			wait_for_completion(&ctx->file_data->done);
+		__io_sqe_files_unregister(ctx);
+	}
 	if (ctx->rings)
 		__io_cqring_overflow_flush(ctx, true);
 	mutex_unlock(&ctx->uring_lock);
-- 
2.24.0

