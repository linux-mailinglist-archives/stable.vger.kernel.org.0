Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6284E41A7DE
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239032AbhI1F7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:59:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238930AbhI1F6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C0D16120D;
        Tue, 28 Sep 2021 05:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808600;
        bh=q8aU+U8lTVh8CINqSKYARRqQ6O1xiQO3SrerIuVz560=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4vHJ6djVfcomM4qTVV/s/xmftaCNQaEI94SryM6fgZvyEUbJ5MxCtcrR00tjlHHj
         obZ/UCHC5khfg5zgXarqktFVQ2tkNvKL0967wJ2SjyjJN9VTZ2dnF9iH8ZIe406Sw4
         Qh3cIj79DsBzPP1mBTsnMgg4+PynZB8SSs61dyYTV6Ga0UL3DQdkQktS9DaTO1so22
         S9N4yhu5V5P/qKIMU8JBmkY9OhFMIr4cYDH6ieR5w7hbkcE7b970go3B61bTZDSg/X
         cRfW2LAdQCSGCYm1AuWLXTTuCaPXd2DO9u2GxK2267GBCas8DdblapjVnGerSdBbHq
         AYicWunvQ6Ykg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+111d2a03f51f5ae73775@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 37/40] io_uring: allow conditional reschedule for intensive iterators
Date:   Tue, 28 Sep 2021 01:55:21 -0400
Message-Id: <20210928055524.172051-37-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 8bab4c09f24ec8d4a7a78ab343620f89d3a24804 ]

If we have a lot of threads and rings, the tctx list can get quite big.
This is especially true if we keep creating new threads and rings.
Likewise for the provided buffers list. Be nice and insert a conditional
reschedule point while iterating the nodes for deletion.

Link: https://lore.kernel.org/io-uring/00000000000064b6b405ccb41113@google.com/
Reported-by: syzbot+111d2a03f51f5ae73775@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 754d59f734d8..ddd241b28f91 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8649,8 +8649,10 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 	struct io_buffer *buf;
 	unsigned long index;
 
-	xa_for_each(&ctx->io_buffers, index, buf)
+	xa_for_each(&ctx->io_buffers, index, buf) {
 		__io_remove_buffers(ctx, buf, index, -1U);
+		cond_resched();
+	}
 }
 
 static void io_req_cache_free(struct list_head *list, struct task_struct *tsk)
@@ -9146,8 +9148,10 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 	struct io_tctx_node *node;
 	unsigned long index;
 
-	xa_for_each(&tctx->xa, index, node)
+	xa_for_each(&tctx->xa, index, node) {
 		io_uring_del_tctx_node(index);
+		cond_resched();
+	}
 	if (wq) {
 		/*
 		 * Must be after io_uring_del_task_file() (removes nodes under
-- 
2.33.0

