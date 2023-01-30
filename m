Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429DF6810AD
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237065AbjA3OFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237072AbjA3OFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:05:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C4C3A5AD
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:05:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A693561034
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C8AC433EF;
        Mon, 30 Jan 2023 14:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087538;
        bh=dqoIHuAh9Vz9V3ISN2ZbHD0R2FT3+WztuRMp5knEIOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zn6VThYgFBfVLmFWYi6t+8lZ2QjmhxSUeJoMNRW6J5mmBnp+8K1lScgAU09IYea93
         dxyCQLEz1xR+qfz8jX6h8yRcTDdhY7W2ICl+A8pHGNKrUQ8yTwf4/37/pG6+a7n70H
         0TY3dG/lcjD1w+ihCMysEITUrsFJNpVp8qVniAJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 242/313] io_uring: hold locks for io_req_complete_failed
Date:   Mon, 30 Jan 2023 14:51:17 +0100
Message-Id: <20230130134347.964702150@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit e276ae344a770f91912a81c6a338d92efd319be2 ]

A preparation patch, make sure we always hold uring_lock around
io_req_complete_failed(). The only place deviating from the rule
is io_cancel_defer_files(), queue a tw instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/70760344eadaecf2939287084b9d4ba5c05a6984.1669203009.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: ef5c600adb1d ("io_uring: always prep_async for drain requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9b1c917c99d9..6b81a0d2d9bc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -871,9 +871,12 @@ inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags)
 }
 
 void io_req_complete_failed(struct io_kiocb *req, s32 res)
+	__must_hold(&ctx->uring_lock)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 
+	lockdep_assert_held(&req->ctx->uring_lock);
+
 	req_set_fail(req);
 	io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
 	if (def->fail)
@@ -1631,6 +1634,7 @@ static u32 io_get_sequence(struct io_kiocb *req)
 }
 
 static __cold void io_drain_req(struct io_kiocb *req)
+	__must_hold(&ctx->uring_lock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_defer_entry *de;
@@ -2867,7 +2871,7 @@ static __cold bool io_cancel_defer_files(struct io_ring_ctx *ctx,
 	while (!list_empty(&list)) {
 		de = list_first_entry(&list, struct io_defer_entry, list);
 		list_del_init(&de->list);
-		io_req_complete_failed(de->req, -ECANCELED);
+		io_req_task_queue_fail(de->req, -ECANCELED);
 		kfree(de);
 	}
 	return true;
-- 
2.39.0



