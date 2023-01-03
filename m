Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4209F65C673
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 19:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbjACSkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 13:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238247AbjACSkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 13:40:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C47713F0D;
        Tue,  3 Jan 2023 10:39:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24B81614E5;
        Tue,  3 Jan 2023 18:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128ADC433D2;
        Tue,  3 Jan 2023 18:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672771191;
        bh=7j96stny4xRJJcFxNxwU9ofJo/3YYYadpzJrqZbEx5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6pQAJQ5nvNhFYPPsuP57dhRzV5otWvDaCF6F6dmmdwqkwjgPl1Dzy5HK1zbNCiaD
         30CFeR6oNvlVY8JIRJU5WR60CyE+ADZXMPmwGA8zg5CWHSveA1frG+snvu00H53GA+
         onTnlavs8B2GVOyitf+gcQzwEiNd2QX9+pe9YfxZNQRws0bKXI5PY+fxY7POEwJNxK
         tHXkvm9TCIbVrbN2WfhLsMCzl2vd42CN0VBCAGbGS7R66xuSeGmWjgc2VGRg2I6hBT
         m9lDxRSK8SzIgf0IV5snufTitAQXXrvwrudfxTSrPlleAnD7YVU4YVyzZDCvEGYwts
         CI4qrxVcL4IyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 07/10] io_uring: check for valid register opcode earlier
Date:   Tue,  3 Jan 2023 13:39:31 -0500
Message-Id: <20230103183934.2022663-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230103183934.2022663-1-sashal@kernel.org>
References: <20230103183934.2022663-1-sashal@kernel.org>
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
index 17771cb3c333..01528a919751 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3897,8 +3897,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		return -EEXIST;
 
 	if (ctx->restricted) {
-		if (opcode >= IORING_REGISTER_LAST)
-			return -EINVAL;
 		opcode = array_index_nospec(opcode, IORING_REGISTER_LAST);
 		if (!test_bit(opcode, ctx->restrictions.register_op))
 			return -EACCES;
@@ -4054,6 +4052,9 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
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

