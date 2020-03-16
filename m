Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D8E1862F0
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbgCPCeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:34:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729777AbgCPCeJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:34:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7030120726;
        Mon, 16 Mar 2020 02:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326049;
        bh=cCg0M0loROU58Zt2BRB0MoP92hqsihIZYRkM3zwyyRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWL3pWbjXJfFfFs+oJnvQLlToapXO9JKU6+KSTFIMbNLLfYcJCQ5lxyTkl3J7J+ae
         RFbT65nzR1DX93pmt6vjUiEs7yZRBmHkABjh9Ax3Ct8iUIPsm8VssQJPRYulEqZqqy
         wvIctqijqI48aXudkADLDrEND9hnUSymkxF4ADHs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 41/41] io_uring: fix lockup with timeouts
Date:   Sun, 15 Mar 2020 22:33:19 -0400
Message-Id: <20200316023319.749-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023319.749-1-sashal@kernel.org>
References: <20200316023319.749-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit f0e20b8943509d81200cef5e30af2adfddba0f5c ]

There is a recipe to deadlock the kernel: submit a timeout sqe with a
linked_timeout (e.g.  test_single_link_timeout_ception() from liburing),
and SIGKILL the process.

Then, io_kill_timeouts() takes @ctx->completion_lock, but the timeout
isn't flagged with REQ_F_COMP_LOCKED, and will try to double grab it
during io_put_free() to cancel the linked timeout. Probably, the same
can happen with another io_kill_timeout() call site, that is
io_commit_cqring().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 60a4832089982..fd28f85677225 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -688,6 +688,7 @@ static void io_kill_timeout(struct io_kiocb *req)
 	if (ret != -1) {
 		atomic_inc(&req->ctx->cq_timeouts);
 		list_del_init(&req->list);
+		req->flags |= REQ_F_COMP_LOCKED;
 		io_cqring_fill_event(req, 0);
 		io_put_req(req);
 	}
-- 
2.20.1

