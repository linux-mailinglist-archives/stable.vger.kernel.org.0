Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8C25FFDCB
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 09:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiJPHTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 03:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiJPHTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 03:19:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092361A3AD
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 00:19:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFE2DB80B7C
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 07:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FDEC433C1;
        Sun, 16 Oct 2022 07:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665904782;
        bh=St7Ktxbq6rvNlYHrnfDHrOk7cZoMkJswVKdFzAYPKSM=;
        h=Subject:To:Cc:From:Date:From;
        b=QjDMHK48T+q3XqkPx6kbY/VXqGcTN9edEIHlJ01SnEg5XMKAunZWpxoRCLSiYcFyd
         KrnfHIhKEq5lOvf6bY47NeU7uzsVpRtSJTh8QqFRJFwicjGX1Bo5/Ul+gNTg7FbCLQ
         FXvLmWPYYybiI7lvJRMZvY14VZZ8n4Z3Y4GQZO/c=
Subject: FAILED: patch "[PATCH] io_uring/net: don't lose partial send_zc on fail" failed to apply to 6.0-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 09:20:29 +0200
Message-ID: <16659048292160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

5693bcce892d ("io_uring/net: don't lose partial send_zc on fail")
7e6b638ed501 ("io_uring/net: don't lose partial send/recv on fail")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5693bcce892d7b8b15a7a92b011d3d40a023b53c Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Wed, 21 Sep 2022 12:17:49 +0100
Subject: [PATCH] io_uring/net: don't lose partial send_zc on fail

Partial zc send may end up in io_req_complete_failed(), which not only
would return invalid result but also mask out the notification leading
to lifetime issues.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/5673285b5e83e6ceca323727b4ddaa584b5cc91e.1663668091.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/net.c b/io_uring/net.c
index 4aabd476499c..8d90f8eeb2d0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1103,6 +1103,22 @@ void io_sendrecv_fail(struct io_kiocb *req)
 	io_req_set_res(req, res, req->cqe.flags);
 }
 
+void io_send_zc_fail(struct io_kiocb *req)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	int res = req->cqe.res;
+
+	if (req->flags & REQ_F_PARTIAL_IO) {
+		if (req->flags & REQ_F_NEED_CLEANUP) {
+			io_notif_flush(sr->notif);
+			sr->notif = NULL;
+			req->flags &= ~REQ_F_NEED_CLEANUP;
+		}
+		res = sr->done_io;
+	}
+	io_req_set_res(req, res, req->cqe.flags);
+}
+
 int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept = io_kiocb_to_cmd(req, struct io_accept);
diff --git a/io_uring/net.h b/io_uring/net.h
index 109ffb3a1a3f..e7366aac335c 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -58,6 +58,7 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags);
 int io_sendzc(struct io_kiocb *req, unsigned int issue_flags);
 int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 void io_sendzc_cleanup(struct io_kiocb *req);
+void io_send_zc_fail(struct io_kiocb *req);
 
 void io_netmsg_cache_free(struct io_cache_entry *entry);
 #else
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index f0f4ae33b99b..4fbefb7d70c7 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -497,6 +497,7 @@ const struct io_op_def io_op_defs[] = {
 		.issue			= io_sendzc,
 		.prep_async		= io_sendzc_prep_async,
 		.cleanup		= io_sendzc_cleanup,
+		.fail			= io_send_zc_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif

