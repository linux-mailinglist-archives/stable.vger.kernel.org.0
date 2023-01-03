Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F1D65C682
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 19:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238215AbjACSlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 13:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238286AbjACSk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 13:40:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C411613F0D;
        Tue,  3 Jan 2023 10:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60D01614DF;
        Tue,  3 Jan 2023 18:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50144C433D2;
        Tue,  3 Jan 2023 18:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672771209;
        bh=SuXAXhT2fhjZ69w/wKz2aFnvt+axUQVNB97E49ci9/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQo2UbI0R5TfVch6Len3om4gehk3xxRHmtfW4xFecF3adZ6goZa9wF1U/LxHpoFFR
         bMzEJEvARt/V6NHGvKU5+kD1RqeQCh8iIITMgdVm8b1U77EY6JB9U3+d2U+mmUpB2g
         dwszNVMIzeBWjk5GeYzd+RETI7+yNR4HmXQkk+R24X4R1njMdeM2+NrNdwQh4cIxML
         FejuiuoFlwkJOyjdjbn6+BHNkAy5q4gpolO+XFpyz428kn+Wl/Lm5svKv2fdC+0Fds
         itsj2qR6iz2+y2cinaaXfagxSsaRUNqBi2IPWrrVDrkSpAI2Txh35ZbbkLyoPPlTkg
         Dy16s7x+uS1jA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 2/4] io_uring: check for valid register opcode earlier
Date:   Tue,  3 Jan 2023 13:39:53 -0500
Message-Id: <20230103183956.2022789-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230103183956.2022789-1-sashal@kernel.org>
References: <20230103183956.2022789-1-sashal@kernel.org>
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
index 1b6c25dc3f0c..739fe533f2ad 100644
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

