Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9CCB4269B9
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242763AbhJHLkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243267AbhJHLjH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:39:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02DA2615E4;
        Fri,  8 Oct 2021 11:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692799;
        bh=Xx8XNef/Ah1URcpUcd9gYhA9FzcFJC/bwUpwcEW4G/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ImEhwtxBOXd61qZRNht4MS4XRQvD6SD5o3Dyr7PYXsI3lDqahubYlUAwZtrSbA06q
         0zA1MBVJKlhULC3YcdpA8dxET4PjHY6z0iqmrX56kx0fYsA84KVxLmM8MLtRmEwIPR
         1RR61AF6/wdzTQx7UYVUT5qZB1x+iQIsPhxUb66A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+111d2a03f51f5ae73775@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 36/48] io_uring: allow conditional reschedule for intensive iterators
Date:   Fri,  8 Oct 2021 13:28:12 +0200
Message-Id: <20211008112721.235054662@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 699a08d724c2..675216f7022d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8648,8 +8648,10 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 	struct io_buffer *buf;
 	unsigned long index;
 
-	xa_for_each(&ctx->io_buffers, index, buf)
+	xa_for_each(&ctx->io_buffers, index, buf) {
 		__io_remove_buffers(ctx, buf, index, -1U);
+		cond_resched();
+	}
 }
 
 static void io_req_cache_free(struct list_head *list, struct task_struct *tsk)
@@ -9145,8 +9147,10 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
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



