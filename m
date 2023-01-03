Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7167765C687
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 19:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238186AbjACSlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 13:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238353AbjACSka (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 13:40:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3F71401A;
        Tue,  3 Jan 2023 10:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C84B0B810AB;
        Tue,  3 Jan 2023 18:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1949DC43392;
        Tue,  3 Jan 2023 18:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672771216;
        bh=EYYODYU5xhTm5lqUmHwKoRocFW9VkfRsy65wxeT7Or8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bih9dV8OFpft02v2u2cCGEZwNWhxbRRfhA6cGSd4cQIIxwSZED+0X35SEONOszDUW
         T2vlrQeTjYNMJzBYPe6EAol3xvO+M7MdLEdg47jcdvSv3a2GuL9ycyV/wxDc3Uxuow
         wsw451oYG0IV0njCqjeEGhzyh1Bx1ZPLaVRUhWLQ4UzQ7Kcp4v6jgtPkbju0oMwQ4R
         EQAB5r1LTA+C+8Fp3lTjxyHM6EhFepQFZepM9A4N+2iIELzkwmXHIF9+0H9zJHAaMe
         7OsiRwL7ZuWPo+vLtoPy8zFXVp1OnyxRYZZURM895Zbn9nDvuOnjfYtefwgAwkfH36
         gnVaiC5iDUwfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 2/4] io_uring: check for valid register opcode earlier
Date:   Tue,  3 Jan 2023 13:40:10 -0500
Message-Id: <20230103184013.2022849-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230103184013.2022849-1-sashal@kernel.org>
References: <20230103184013.2022849-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 343190841a1f22b96996d9f8cfab902a4d1bfd0e ]

We only check the register opcode value inside the restricted ring
section, move it into the main io_uring_register() function instead
and check it up front.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index eebbe8a6da0c..52a08632326a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -10895,8 +10895,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		return -ENXIO;
 
 	if (ctx->restricted) {
-		if (opcode >= IORING_REGISTER_LAST)
-			return -EINVAL;
 		opcode = array_index_nospec(opcode, IORING_REGISTER_LAST);
 		if (!test_bit(opcode, ctx->restrictions.register_op))
 			return -EACCES;
@@ -11028,6 +11026,9 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 	long ret = -EBADF;
 	struct fd f;
 
+	if (opcode >= IORING_REGISTER_LAST)
+		return -EINVAL;
+
 	f = fdget(fd);
 	if (!f.file)
 		return -EBADF;
-- 
2.35.1

