Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0368953CF5F
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345505AbiFCRxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345815AbiFCRu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:50:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E4F590BE;
        Fri,  3 Jun 2022 10:46:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60FE7B82430;
        Fri,  3 Jun 2022 17:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C92DC385A9;
        Fri,  3 Jun 2022 17:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278380;
        bh=EZhGGfDHtywe2gnNldpG1wtwGHl1pTHgN+kbhnSDUkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFQvZLegxb7+4d4sPSHdw2Ve3AGz9Wbhq7rVH6EEcN1YkM25dqNWyhyvsjKJ6w8H8
         Kcjy1YUErzGzjm1A9sIaiX2ZfmKxv1WG1GVjFdbQBKe3Hl+j1DcpQKVomn8otE+JaU
         WrsF774pm6FQ7u1lTlcOhXEprP1dQ4NO4j0DFd0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.10 14/53] io_uring: fix using under-expanded iters
Date:   Fri,  3 Jun 2022 19:42:59 +0200
Message-Id: <20220603173819.137177057@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173818.716010877@linuxfoundation.org>
References: <20220603173818.716010877@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3389,6 +3389,7 @@ static int io_read(struct io_kiocb *req,
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter __iter, *iter = &__iter;
+	struct iov_iter iter_cp;
 	struct io_async_rw *rw = req->async_data;
 	ssize_t io_size, ret, ret2;
 	bool no_async;
@@ -3399,6 +3400,7 @@ static int io_read(struct io_kiocb *req,
 	ret = io_import_iovec(READ, req, &iovec, iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
+	iter_cp = *iter;
 	io_size = iov_iter_count(iter);
 	req->result = io_size;
 	ret = 0;
@@ -3434,7 +3436,7 @@ static int io_read(struct io_kiocb *req,
 		if (req->file->f_flags & O_NONBLOCK)
 			goto done;
 		/* some cases will consume bytes even on error returns */
-		iov_iter_revert(iter, io_size - iov_iter_count(iter));
+		*iter = iter_cp;
 		ret = 0;
 		goto copy_iov;
 	} else if (ret < 0) {
@@ -3517,6 +3519,7 @@ static int io_write(struct io_kiocb *req
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter __iter, *iter = &__iter;
+	struct iov_iter iter_cp;
 	struct io_async_rw *rw = req->async_data;
 	ssize_t ret, ret2, io_size;
 
@@ -3526,6 +3529,7 @@ static int io_write(struct io_kiocb *req
 	ret = io_import_iovec(WRITE, req, &iovec, iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
+	iter_cp = *iter;
 	io_size = iov_iter_count(iter);
 	req->result = io_size;
 
@@ -3587,7 +3591,7 @@ done:
 	} else {
 copy_iov:
 		/* some cases will consume bytes even on error returns */
-		iov_iter_revert(iter, io_size - iov_iter_count(iter));
+		*iter = iter_cp;
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
 		if (!ret)
 			return -EAGAIN;


