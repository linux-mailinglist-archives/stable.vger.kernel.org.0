Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC1666C51D
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbjAPQBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbjAPQBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:01:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122D91CAC1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:01:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25D896102D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3911EC433D2;
        Mon, 16 Jan 2023 16:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884882;
        bh=cMzVHi6y81arKg8yTwml2AJUiL/SRH1fF4NxImU0KTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xElkhIHhzqfTwoUuDlWqEiSk3CZQsCZv7wKSSZetuG7E7WdRMfwsyDOCyRNmcIBOl
         +XQF4PtdI2XFinT5TrFeWMuuRf3fz0iFR9y2cHcsuDILS6a1khs02M20wg8rphrFcF
         DiVzZnAEW5oIl3fMOOpGOWGZZDiKvznTUzhpeW0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        syzbot+6805087452d72929404e@syzkaller.appspotmail.com
Subject: [PATCH 6.1 176/183] io_uring: lock overflowing for IOPOLL
Date:   Mon, 16 Jan 2023 16:51:39 +0100
Message-Id: <20230116154810.730325486@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

commit 544d163d659d45a206d8929370d5a2984e546cb7 upstream.

syzbot reports an issue with overflow filling for IOPOLL:

WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
CPU: 0 PID: 28 Comm: kworker/u4:1 Not tainted 6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Workqueue: events_unbound io_ring_exit_work
Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863

There is no real problem for normal IOPOLL as flush is also called with
uring_lock taken, but it's getting more complicated for IOPOLL|SQPOLL,
for which __io_cqring_overflow_flush() happens from the CQ waiting path.

Reported-and-tested-by: syzbot+6805087452d72929404e@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index bb47cc4da713..6223472095d2 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1055,7 +1055,11 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 			continue;
 
 		req->cqe.flags = io_put_kbuf(req, 0);
-		__io_fill_cqe_req(req->ctx, req);
+		if (unlikely(!__io_fill_cqe_req(ctx, req))) {
+			spin_lock(&ctx->completion_lock);
+			io_req_cqe_overflow(req);
+			spin_unlock(&ctx->completion_lock);
+		}
 	}
 
 	if (unlikely(!nr_events))
-- 
2.35.1



