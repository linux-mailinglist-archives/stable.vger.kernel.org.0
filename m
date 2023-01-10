Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490B2664B3A
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239603AbjAJSkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239604AbjAJSjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:39:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3F392369
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:34:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B3FC61880
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C81C433F0;
        Tue, 10 Jan 2023 18:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375661;
        bh=EYYODYU5xhTm5lqUmHwKoRocFW9VkfRsy65wxeT7Or8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XuRZdOROrKDzvMQaokxwrfWMC45BqdcbGwTNS5yw/6J3jM5VupXAg3jAGxCUvWe7D
         fNkLkHrCHiL0OiAoJx2g9iq9IkavEbqy89B2Edw3pkSe4LkILB4GE6weYNaspEg21C
         Rqkz7B7W2FBpWRxKsWJKKwS4P6off+AL1LcDbaiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 261/290] io_uring: check for valid register opcode earlier
Date:   Tue, 10 Jan 2023 19:05:53 +0100
Message-Id: <20230110180040.994446965@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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



