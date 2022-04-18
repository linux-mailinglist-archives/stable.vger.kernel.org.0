Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957875050B7
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238697AbiDRM3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239200AbiDRM1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:27:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADE11F62A;
        Mon, 18 Apr 2022 05:21:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1DFEB80EC4;
        Mon, 18 Apr 2022 12:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47510C385A8;
        Mon, 18 Apr 2022 12:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284487;
        bh=2pOqRAeaT4sc7YJzTqrcaRQ8P4fOuhbgfxdJRh9NA6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZErMZL1cI1peA2hQjp4P0/pSznaLhIN+XuUOKHfeltOPEY02BHWhUgCcFkFR90Dm8
         /RMwtIoqBa8Hq47IpUGf0nMA8gCbCkxvCC6TS9hDYnoYtCnk4mmaWlCQNGGIVdIGs/
         9bWwSXHcFik1HhvytHWxd/3n2/fwgUIepEgWlLGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 107/219] io_uring: fix assign file locking issue
Date:   Mon, 18 Apr 2022 14:11:16 +0200
Message-Id: <20220418121209.893534459@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

[ Upstream commit 0f8da75b51ac863b9435368bd50691718cc454b0 ]

io-wq work cancellation path can't take uring_lock as how it's done on
file assignment, we have to handle IO_WQ_WORK_CANCEL first, this fixes
encountered hangs.

Fixes: 6bf9c47a3989 ("io_uring: defer file assignment")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/0d9b9f37841645518503f6a207e509d14a286aba.1649773463.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d05394b0c1e6..e3d1fc954933 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6892,16 +6892,18 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	if (timeout)
 		io_queue_linked_timeout(timeout);
 
-	if (!io_assign_file(req, issue_flags)) {
-		err = -EBADF;
-		work->flags |= IO_WQ_WORK_CANCEL;
-	}
 
 	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
 	if (work->flags & IO_WQ_WORK_CANCEL) {
+fail:
 		io_req_task_queue_fail(req, err);
 		return;
 	}
+	if (!io_assign_file(req, issue_flags)) {
+		err = -EBADF;
+		work->flags |= IO_WQ_WORK_CANCEL;
+		goto fail;
+	}
 
 	if (req->flags & REQ_F_FORCE_ASYNC) {
 		bool opcode_poll = def->pollin || def->pollout;
-- 
2.35.1



