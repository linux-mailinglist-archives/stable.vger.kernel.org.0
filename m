Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD7E60034D
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 22:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiJPUfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 16:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiJPUfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 16:35:44 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4235336DFD
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:35:43 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id m15so13395385edb.13
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z8ta4yUpPa4GMeYpbdiNmVRJHo9IZTko0q0dv3E9ezM=;
        b=nH9OZcMLw4IOLkAo74TqlMjV1ToqaKQBso5BYTCtAXwzalXu1TxR3Lfp8h/oyMH4W7
         9V6+B6GZ3HJ9aTeG6p8j6qCnXDp6sl3Fx4AFQ797pPKui162bUrlJn5lG6onS+JY3ZNt
         PxW4yf4E8IW5XkTKQ1+auN/srRII2uA+dutrlZRuVS8N+aYtPg4KIIr5AzDMeZzaDi9/
         So9dGiwodcwU9FZcQiNETK31FhY6ET+NGzrUE3gtBuNaYjIfyiLyFyZebKpyqHtksITS
         /1Hul8jO1JnryqzerR9znO+KDbf3Q/qi6+2Yh5URmJtQuc6BOvzSxrLX00rhJiVPZJku
         e0IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z8ta4yUpPa4GMeYpbdiNmVRJHo9IZTko0q0dv3E9ezM=;
        b=MK/+iMTs1y5aulc3xML/kNSz1l9P9CDIvYmloYDnMhIQ5eMQ3wymB/rJ2nv0de8DYr
         SJXDQg7Ksgrfa7LdJhbb2kiztBgYgzHvUMuDwoh+FUlH20TdnFV2UKLdRC1rJaPoQhqH
         iTHCNrZWPe0yDwcGB4WvNDMO+KKQ/zUeUuPh6XZcxBtM78tUQRV1rrRcGKp+2nxgaQvY
         2zJt19wtViQqZOueE9AeEb28rfPwjvaRsbmzbyF4dy0cfG/KJ9ldrqfVfvhzr/HmR+os
         BWoo7FJZzEty70jxejgAC9rblIfnDNUbMn0/M5SNmAh5NfWtYQTyLly6fk+Q7/Suiq24
         CdNA==
X-Gm-Message-State: ACrzQf0nIm1jqpPCTdUzgLw1WLEV6kNHEFLPYAZ5aUSV0urqb+Z9dZzl
        T1dSsHu5oNBf34MkQEWysVLqN5XR9cs=
X-Google-Smtp-Source: AMsMyM491gR7y5zlPG3nTWAEpkamQHvJMHw++hZsiBERJ4QGFLOfkdH7HKENRHO7zXus3wITvWzq5A==
X-Received: by 2002:aa7:ce02:0:b0:459:4833:380a with SMTP id d2-20020aa7ce02000000b004594833380amr7431667edv.359.1665952541472;
        Sun, 16 Oct 2022 13:35:41 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id m3-20020a170906160300b0078194737761sm5008083ejd.124.2022.10.16.13.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 13:35:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-6.0 5/6] io_uring/net: don't skip notifs for failed requests
Date:   Sun, 16 Oct 2022 21:33:29 +0100
Message-Id: <6e84a6e0dbfbbb43379a82abd262ce0bd4311ca2.1665951939.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1665951939.git.asml.silence@gmail.com>
References: <cover.1665951939.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ upstream commit 6ae91ac9a6aa7d6005c3c6d0f4d263fbab9f377f ]

We currently only add a notification CQE when the send succeded, i.e.
cqe.res >= 0. However, it'd be more robust to do buffer notifications
for failed requests as well in case drivers decide do something fanky.

Always return a buffer notification after initial prep, don't hide it.
This behaviour is better aligned with documentation and the patch also
helps the userspace to respect it.

Cc: stable@vger.kernel.org # 6.0
Suggested-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/9c8bead87b2b980fcec441b8faef52188b4a6588.1664292100.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 3dbb2bf99b4d..b0324775e6ce 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -875,7 +875,6 @@ void io_send_zc_cleanup(struct io_kiocb *req)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 
-	zc->notif->flags |= REQ_F_CQE_SKIP;
 	io_notif_flush(zc->notif);
 	zc->notif = NULL;
 }
@@ -992,7 +991,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	struct msghdr msg;
 	struct iovec iov;
 	struct socket *sock;
-	unsigned msg_flags, cflags;
+	unsigned msg_flags;
 	int ret, min_ret = 0;
 
 	sock = sock_from_file(req->file);
@@ -1060,8 +1059,6 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_addr(req, addr, issue_flags);
 		}
-		if (ret < 0 && !zc->done_io)
-			zc->notif->flags |= REQ_F_CQE_SKIP;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
@@ -1074,8 +1071,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 
 	io_notif_flush(zc->notif);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	cflags = ret >= 0 ? IORING_CQE_F_MORE : 0;
-	io_req_set_res(req, ret, cflags);
+	io_req_set_res(req, ret, IORING_CQE_F_MORE);
 	return IOU_OK;
 }
 
@@ -1092,17 +1088,11 @@ void io_sendrecv_fail(struct io_kiocb *req)
 void io_send_zc_fail(struct io_kiocb *req)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	int res = req->cqe.res;
 
-	if (req->flags & REQ_F_PARTIAL_IO) {
-		if (req->flags & REQ_F_NEED_CLEANUP) {
-			io_notif_flush(sr->notif);
-			sr->notif = NULL;
-			req->flags &= ~REQ_F_NEED_CLEANUP;
-		}
-		res = sr->done_io;
-	}
-	io_req_set_res(req, res, req->cqe.flags);
+	if (req->flags & REQ_F_PARTIAL_IO)
+		req->cqe.res = sr->done_io;
+	if (req->flags & REQ_F_NEED_CLEANUP)
+		req->cqe.flags |= IORING_CQE_F_MORE;
 }
 
 int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-- 
2.38.0

