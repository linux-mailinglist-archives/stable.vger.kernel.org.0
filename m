Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336ED604114
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiJSKhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiJSKgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:36:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207D32DAAC;
        Wed, 19 Oct 2022 03:15:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8987FCE20F8;
        Wed, 19 Oct 2022 09:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B44C433C1;
        Wed, 19 Oct 2022 09:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170940;
        bh=MkIi4jrqmZHmgC/zrV72MkjhZQBFd9b63fKVqNoJHcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mRTqgi9zVuPXXuoCgdCdLQZpK72VcrAwJGYGea9HwBx5fUYw/pKyuja+E9WixwZyb
         HMpwCKgsXeDHfiWBJ5TpkTouOKuSXM6q8bqJbeVUc+ziwY24UthZTXMyZnKskXhh6p
         1NzClprVuDFA3wQoXWFy+SnDhM90L289KniPIsYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 844/862] io_uring/net: dont lose partial send_zc on fail
Date:   Wed, 19 Oct 2022 10:35:31 +0200
Message-Id: <20221019083327.183139680@linuxfoundation.org>
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

[ upstream commit 5693bcce892d7b8b15a7a92b011d3d40a023b53c ]

Partial zc send may end up in io_req_complete_failed(), which not only
would return invalid result but also mask out the notification leading
to lifetime issues.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/5673285b5e83e6ceca323727b4ddaa584b5cc91e.1663668091.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c   |   16 ++++++++++++++++
 io_uring/net.h   |    1 +
 io_uring/opdef.c |    1 +
 3 files changed, 18 insertions(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1093,6 +1093,22 @@ void io_sendrecv_fail(struct io_kiocb *r
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
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -58,6 +58,7 @@ int io_connect(struct io_kiocb *req, uns
 int io_sendzc(struct io_kiocb *req, unsigned int issue_flags);
 int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 void io_sendzc_cleanup(struct io_kiocb *req);
+void io_send_zc_fail(struct io_kiocb *req);
 
 void io_netmsg_cache_free(struct io_cache_entry *entry);
 #else
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -494,6 +494,7 @@ const struct io_op_def io_op_defs[] = {
 		.issue			= io_sendzc,
 		.prep_async		= io_sendzc_prep_async,
 		.cleanup		= io_sendzc_cleanup,
+		.fail			= io_send_zc_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif


