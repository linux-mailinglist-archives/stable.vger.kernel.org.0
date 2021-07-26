Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2E93D61DF
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbhGZPdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232799AbhGZPbY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:31:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A337860C40;
        Mon, 26 Jul 2021 16:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315913;
        bh=8qIt4KPylJPoYvm6FArbtv2nqIyv99AxcfqleVfMvsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjUczv4PLUrVlO6k/slZYNwdrhP3D3B6aBLhMF3HryXvgaFrXfc1Nb563rZUu49gV
         xyO600yLF81jxe213Kh7lYM6i4PFszre8PB4mEgfREQ/vDYZhdzlI0RW7jab3MA4N7
         dCNf7GwXhOQaRTQAEJZTLVGblxk0IT4AxoqUtdSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 116/223] io_uring: fix memleak in io_init_wq_offload()
Date:   Mon, 26 Jul 2021 17:38:28 +0200
Message-Id: <20210726153850.066298322@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 362a9e65289284f36403058eea2462d0330c1f24 ]

I got memory leak report when doing fuzz test:

BUG: memory leak
unreferenced object 0xffff888107310a80 (size 96):
comm "syz-executor.6", pid 4610, jiffies 4295140240 (age 20.135s)
hex dump (first 32 bytes):
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00 .....N..........
backtrace:
[<000000001974933b>] kmalloc include/linux/slab.h:591 [inline]
[<000000001974933b>] kzalloc include/linux/slab.h:721 [inline]
[<000000001974933b>] io_init_wq_offload fs/io_uring.c:7920 [inline]
[<000000001974933b>] io_uring_alloc_task_context+0x466/0x640 fs/io_uring.c:7955
[<0000000039d0800d>] __io_uring_add_tctx_node+0x256/0x360 fs/io_uring.c:9016
[<000000008482e78c>] io_uring_add_tctx_node fs/io_uring.c:9052 [inline]
[<000000008482e78c>] __do_sys_io_uring_enter fs/io_uring.c:9354 [inline]
[<000000008482e78c>] __se_sys_io_uring_enter fs/io_uring.c:9301 [inline]
[<000000008482e78c>] __x64_sys_io_uring_enter+0xabc/0xc20 fs/io_uring.c:9301
[<00000000b875f18f>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
[<00000000b875f18f>] do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
[<000000006b0a8484>] entry_SYSCALL_64_after_hwframe+0x44/0xae

CPU0                          CPU1
io_uring_enter                io_uring_enter
io_uring_add_tctx_node        io_uring_add_tctx_node
__io_uring_add_tctx_node      __io_uring_add_tctx_node
io_uring_alloc_task_context   io_uring_alloc_task_context
io_init_wq_offload            io_init_wq_offload
hash = kzalloc                hash = kzalloc
ctx->hash_map = hash          ctx->hash_map = hash <- one of the hash is leaked

When calling io_uring_enter() in parallel, the 'hash_map' will be leaked,
add uring_lock to protect 'hash_map'.

Fixes: e941894eae31 ("io-wq: make buffered file write hashed work map per-ctx")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/20210720083805.3030730-1-yangyingliang@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index eeea6b8c8bee..8843f48ace27 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7859,15 +7859,19 @@ static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 	struct io_wq_data data;
 	unsigned int concurrency;
 
+	mutex_lock(&ctx->uring_lock);
 	hash = ctx->hash_map;
 	if (!hash) {
 		hash = kzalloc(sizeof(*hash), GFP_KERNEL);
-		if (!hash)
+		if (!hash) {
+			mutex_unlock(&ctx->uring_lock);
 			return ERR_PTR(-ENOMEM);
+		}
 		refcount_set(&hash->refs, 1);
 		init_waitqueue_head(&hash->wait);
 		ctx->hash_map = hash;
 	}
+	mutex_unlock(&ctx->uring_lock);
 
 	data.hash = hash;
 	data.task = task;
-- 
2.30.2



