Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC74E6648A4
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239051AbjAJSNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239045AbjAJSMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:12:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C914015723
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:11:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64DD86182C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A730C433F0;
        Tue, 10 Jan 2023 18:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374274;
        bh=eTul3JhgtCBxB7GAR+jgLpBfGozJx5b7tq2cmV2RYkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3L8lygNqtsjeVGfo+BeGVJfp0DwXaeE11/9caURhF6EyES2rFazIEhzLgBGSndgd
         52/gqlQWK7Gafh0OkLGNTC2mib3v9enhW/thoma9nDAuUw3y2EmYO6kgxiqfKEj8P8
         37aVlmADY8KO1ZFKkui6gKAdZLMb63HB3ynl0UQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 112/148] io_uring: check for valid register opcode earlier
Date:   Tue, 10 Jan 2023 19:03:36 +0100
Message-Id: <20230110180020.740551695@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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
index b8a39be3bcb4..cfcf1d415521 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3725,8 +3725,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		return -EEXIST;
 
 	if (ctx->restricted) {
-		if (opcode >= IORING_REGISTER_LAST)
-			return -EINVAL;
 		opcode = array_index_nospec(opcode, IORING_REGISTER_LAST);
 		if (!test_bit(opcode, ctx->restrictions.register_op))
 			return -EACCES;
@@ -3882,6 +3880,9 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
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



