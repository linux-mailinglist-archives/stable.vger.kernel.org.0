Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5CC603E89
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbiJSJQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233612AbiJSJP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:15:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE32A8794;
        Wed, 19 Oct 2022 02:06:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2ECB61843;
        Wed, 19 Oct 2022 09:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16ED7C4314C;
        Wed, 19 Oct 2022 09:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170151;
        bh=pCi2CnpLXCNPWmrEJl7lbBc+7SY2enWuUJG3lZBk1PE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6T9u4iCaSJ5S4q9mdWmNYxNrpxWQCwdgBtgF3XNNS3mQVG+cIfhj9vUF24Pyzl7f
         bkyGme7uI+SlNqBQ1yK57SgNldaA7V2Jh1wAxyImAm9FvYQHS+1/iUtGJfaiSuQQ9m
         u9YQjI/pbO2C2R12Dnqk9r+PAboiFLAB/t231AlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 546/862] io_uring/fdinfo: fix sqe dumping for IORING_SETUP_SQE128
Date:   Wed, 19 Oct 2022 10:30:33 +0200
Message-Id: <20221019083314.075537817@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 3b8fdd1dc35e395d19efbc8391a809a5b954ecf4 ]

If we have doubly sized SQEs, then we need to shift the sq index by 1
to account for using two entries for a single request. The CQE dumping
gets this right, but the SQE one does not.

Improve the SQE dumping in general, the information dumped is pretty
sparse and doesn't even cover the whole basic part of the SQE. Include
information on the extended part of the SQE, if doubly sized SQEs are
in use. A typical dump now looks like the following:

[...]
SQEs:	32
   32: opcode:URING_CMD, fd:0, flags:1, off:3225964160, addr:0x0, rw_flags:0x0, buf_index:0 user_data:2721, e0:0x0, e1:0xffffb8041000, e2:0x100000000000, e3:0x5500, e4:0x7, e5:0x0, e6:0x0, e7:0x0
   33: opcode:URING_CMD, fd:0, flags:1, off:3225964160, addr:0x0, rw_flags:0x0, buf_index:0 user_data:2722, e0:0x0, e1:0xffffb8043000, e2:0x100000000000, e3:0x5508, e4:0x7, e5:0x0, e6:0x0, e7:0x0
   34: opcode:URING_CMD, fd:0, flags:1, off:3225964160, addr:0x0, rw_flags:0x0, buf_index:0 user_data:2723, e0:0x0, e1:0xffffb8045000, e2:0x100000000000, e3:0x5510, e4:0x7, e5:0x0, e6:0x0, e7:0x0
[...]

Fixes: ebdeb7c01d02 ("io_uring: add support for 128-byte SQEs")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/fdinfo.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index b29e2d02216f..6d4cc7a92724 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -60,6 +60,7 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 	unsigned int cq_head = READ_ONCE(r->cq.head);
 	unsigned int cq_tail = READ_ONCE(r->cq.tail);
 	unsigned int cq_shift = 0;
+	unsigned int sq_shift = 0;
 	unsigned int sq_entries, cq_entries;
 	bool has_lock;
 	bool is_cqe32 = (ctx->flags & IORING_SETUP_CQE32);
@@ -67,6 +68,8 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 
 	if (is_cqe32)
 		cq_shift = 1;
+	if (ctx->flags & IORING_SETUP_SQE128)
+		sq_shift = 1;
 
 	/*
 	 * we may get imprecise sqe and cqe info if uring is actively running
@@ -82,19 +85,36 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 	seq_printf(m, "CqHead:\t%u\n", cq_head);
 	seq_printf(m, "CqTail:\t%u\n", cq_tail);
 	seq_printf(m, "CachedCqTail:\t%u\n", ctx->cached_cq_tail);
-	seq_printf(m, "SQEs:\t%u\n", sq_tail - ctx->cached_sq_head);
+	seq_printf(m, "SQEs:\t%u\n", sq_tail - sq_head);
 	sq_entries = min(sq_tail - sq_head, ctx->sq_entries);
 	for (i = 0; i < sq_entries; i++) {
 		unsigned int entry = i + sq_head;
-		unsigned int sq_idx = READ_ONCE(ctx->sq_array[entry & sq_mask]);
 		struct io_uring_sqe *sqe;
+		unsigned int sq_idx;
 
+		sq_idx = READ_ONCE(ctx->sq_array[entry & sq_mask]);
 		if (sq_idx > sq_mask)
 			continue;
-		sqe = &ctx->sq_sqes[sq_idx];
-		seq_printf(m, "%5u: opcode:%d, fd:%d, flags:%x, user_data:%llu\n",
-			   sq_idx, sqe->opcode, sqe->fd, sqe->flags,
-			   sqe->user_data);
+		sqe = &ctx->sq_sqes[sq_idx << 1];
+		seq_printf(m, "%5u: opcode:%s, fd:%d, flags:%x, off:%llu, "
+			      "addr:0x%llx, rw_flags:0x%x, buf_index:%d "
+			      "user_data:%llu",
+			   sq_idx, io_uring_get_opcode(sqe->opcode), sqe->fd,
+			   sqe->flags, (unsigned long long) sqe->off,
+			   (unsigned long long) sqe->addr, sqe->rw_flags,
+			   sqe->buf_index, sqe->user_data);
+		if (sq_shift) {
+			u64 *sqeb = (void *) (sqe + 1);
+			int size = sizeof(struct io_uring_sqe) / sizeof(u64);
+			int j;
+
+			for (j = 0; j < size; j++) {
+				seq_printf(m, ", e%d:0x%llx", j,
+						(unsigned long long) *sqeb);
+				sqeb++;
+			}
+		}
+		seq_printf(m, "\n");
 	}
 	seq_printf(m, "CQEs:\t%u\n", cq_tail - cq_head);
 	cq_entries = min(cq_tail - cq_head, ctx->cq_entries);
-- 
2.35.1



