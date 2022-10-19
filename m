Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3386A604406
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbiJSL4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbiJSLzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:55:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2036924089;
        Wed, 19 Oct 2022 04:34:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AC7FB824E9;
        Wed, 19 Oct 2022 09:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A731C433C1;
        Wed, 19 Oct 2022 09:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170949;
        bh=6EIcCe0JCeCW2oNCqgy3kocnom5TmJAkZzMFCgsN+Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OzgasE9fF49qaAKCWaxI8ZXgUCJoBH3AMjbOtaVVLBCsDOyt+TVptUq6F0h8H11/j
         sjhHH+R9TR7vUnuTqjeUFyAgiYvb7ZKuzgkz9cP8iMT3nbNwgr5QOvQMOJSz3ErZpy
         NkpyPDloF6aaMRIHUMEqKgqWRcjqcr3cWngrkH7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 846/862] io_uring/net: dont skip notifs for failed requests
Date:   Wed, 19 Oct 2022 10:35:33 +0200
Message-Id: <20221019083327.264626413@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -879,7 +879,6 @@ void io_send_zc_cleanup(struct io_kiocb
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 
-	zc->notif->flags |= REQ_F_CQE_SKIP;
 	io_notif_flush(zc->notif);
 	zc->notif = NULL;
 }
@@ -996,7 +995,7 @@ int io_send_zc(struct io_kiocb *req, uns
 	struct msghdr msg;
 	struct iovec iov;
 	struct socket *sock;
-	unsigned msg_flags, cflags;
+	unsigned msg_flags;
 	int ret, min_ret = 0;
 
 	sock = sock_from_file(req->file);
@@ -1064,8 +1063,6 @@ int io_send_zc(struct io_kiocb *req, uns
 			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_addr(req, addr, issue_flags);
 		}
-		if (ret < 0 && !zc->done_io)
-			zc->notif->flags |= REQ_F_CQE_SKIP;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
@@ -1078,8 +1075,7 @@ int io_send_zc(struct io_kiocb *req, uns
 
 	io_notif_flush(zc->notif);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	cflags = ret >= 0 ? IORING_CQE_F_MORE : 0;
-	io_req_set_res(req, ret, cflags);
+	io_req_set_res(req, ret, IORING_CQE_F_MORE);
 	return IOU_OK;
 }
 
@@ -1096,17 +1092,11 @@ void io_sendrecv_fail(struct io_kiocb *r
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


