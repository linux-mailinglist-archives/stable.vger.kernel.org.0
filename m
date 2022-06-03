Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAE853C9DA
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 14:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbiFCMRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 08:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbiFCMRg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 08:17:36 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FA822F
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 05:17:35 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id u8so5840152wrm.13
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 05:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IuEsILa4Lz4ZTJEt4MdG/8+MaVWvT0ox5jkpmsgGe9E=;
        b=E+A1Ak2GH2g+zaWfq079kSHeq5W4AYBAM3aZ7t71u0Voku1/WEEtFXTovL+fjqGrPf
         +nG+7t8KelLgZzXc5/QIYl1KzscXqVJWe4uyWgIU8fE6nU0QDNI580uEPUga6AXEBvob
         TQk61Ih3DUmUK//nPYMYuiOOdeOb5mwylDqlxhYU5KUbdWAxf0whLMi1eXiNpW8srdcn
         JRVOGKX0d+18LDmwwaRSefgIYbKLhr/TfyFXj2UOfX3nnWGFWN3VAKVp73zvWiAS0pN6
         s41HAUw/wwORqdrEWeyOFmQnlVHDnPKaIFLozeoVpZM4zGcTS3UYZAMuVk4HHC6H9txt
         Gndg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IuEsILa4Lz4ZTJEt4MdG/8+MaVWvT0ox5jkpmsgGe9E=;
        b=2RuyYDExy08Xi5gaDQkMVcu374SptHUG59CGf113wkVhPc2J39Oj7ibffR/mmpGkHr
         pyBWZTilIgADfIKj21FDDFPk54HqeOyH5f5u0F3xAo2ycSIzs6rJwsZOth4/lR8xkGHA
         0l5jLCKmLeJZxYqLmobwlLXdBn+j+x2F4BE30/hQKXAm5TDh9JC2b28s3sfJUYFo6RjU
         9jhqIMaGU+0z+SEvdHExx3K2y5WQtsdXaxg2iCo47skT+rNhjV99+XDX6kQyDByaIqTD
         zRJyqThlm62h7w0pQptgCQNKijsrp6cJl+7YJ/tipUGtsvfb3EZEhB6uFDCjKL9jr/K2
         BPTA==
X-Gm-Message-State: AOAM53041gRjSL8mp+5ohtgBM17NOi2YU+LQDTVikVEh3ECETHPGvEbk
        sFwWDA6ti49LMMqNqgleF7yZj9bUb3prHg==
X-Google-Smtp-Source: ABdhPJyNwKf6MITxwM1/rvPHXYOxsk8OcD8+gBIgtPX+rhkJCBgPgJHbmFdjYrqEArq/UnBvVrEyfw==
X-Received: by 2002:a5d:47a1:0:b0:20f:ecc4:7f6c with SMTP id 1-20020a5d47a1000000b0020fecc47f6cmr7971549wrb.236.1654258653777;
        Fri, 03 Jun 2022 05:17:33 -0700 (PDT)
Received: from 127.0.0.fr ([193.52.24.5])
        by smtp.gmail.com with ESMTPSA id c16-20020a056000105000b002100aa69469sm7240362wrx.2.2022.06.03.05.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 05:17:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/2] io_uring: fix using under-expanded iters
Date:   Fri,  3 Jun 2022 13:17:05 +0100
Message-Id: <5d1530f17820142cfe98a8fff6d425d47c4b18ca.1654258554.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1654258554.git.asml.silence@gmail.com>
References: <cover.1654258554.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ upstream commit cd65869512ab5668a5d16f789bc4da1319c435c4 ]

The issue was first described and addressed in
89c2b3b7491820 ("io_uring: reexpand under-reexpanded iters"), but
shortly after reimplemented as.
cd65869512ab56 ("io_uring: use iov_iter state save/restore helpers").

Here we follow the approach from the second patch but without in-callback
resubmissions, fixups for not yet supported in 5.10 short read retries
and replacing iov_iter_state with iter copies to not pull even more
dependencies, and because it's just much simpler.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index aded83f20a15..b2b5edee1512 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3389,6 +3389,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter __iter, *iter = &__iter;
+	struct iov_iter iter_cp;
 	struct io_async_rw *rw = req->async_data;
 	ssize_t io_size, ret, ret2;
 	bool no_async;
@@ -3399,6 +3400,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	ret = io_import_iovec(READ, req, &iovec, iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
+	iter_cp = *iter;
 	io_size = iov_iter_count(iter);
 	req->result = io_size;
 	ret = 0;
@@ -3434,7 +3436,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		if (req->file->f_flags & O_NONBLOCK)
 			goto done;
 		/* some cases will consume bytes even on error returns */
-		iov_iter_revert(iter, io_size - iov_iter_count(iter));
+		*iter = iter_cp;
 		ret = 0;
 		goto copy_iov;
 	} else if (ret < 0) {
@@ -3517,6 +3519,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter __iter, *iter = &__iter;
+	struct iov_iter iter_cp;
 	struct io_async_rw *rw = req->async_data;
 	ssize_t ret, ret2, io_size;
 
@@ -3526,6 +3529,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	ret = io_import_iovec(WRITE, req, &iovec, iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
+	iter_cp = *iter;
 	io_size = iov_iter_count(iter);
 	req->result = io_size;
 
@@ -3587,7 +3591,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	} else {
 copy_iov:
 		/* some cases will consume bytes even on error returns */
-		iov_iter_revert(iter, io_size - iov_iter_count(iter));
+		*iter = iter_cp;
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
 		if (!ret)
 			return -EAGAIN;
-- 
2.36.1

