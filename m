Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304BB640869
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 15:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbiLBO3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 09:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbiLBO3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 09:29:47 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7B8578F0
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 06:29:46 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id ay14-20020a05600c1e0e00b003cf6ab34b61so6587375wmb.2
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 06:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=331pHa0cDGKn68xLP5ST7DRUGrjGIzB7kY2CtpQ+wfg=;
        b=UOOYr1ZOo84UgnqbvsanpHlvg3OQvkFKH4qAb7Z6U6WSz3W9Omf8gN5GilNh9Htxpt
         rP6KsmC9vuielH0T1oG2G817kx/Udrvd3evAwME6271gCsUZ0rIPYPMHO1HRWIQb0QO4
         NW1hzrF4ZdYtkfkSgx1r5xJWWOhfmDTS+g+hqM1paawNefRnlmkkS3MaLQc2HhwcuAAG
         Iv3lhyXA8EWtdnzWyXuRpdCrOnUTwCeVsYDv8/HSJwlzZFtwM3zdO4eFa0lVZIbMP+ek
         w9fgNeLe6Y7u9JzGM7imjGq5lfxcxrmX0SRpbNatljntS0JtomvQntHWNDZ45ZilgtR2
         hN1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=331pHa0cDGKn68xLP5ST7DRUGrjGIzB7kY2CtpQ+wfg=;
        b=XomSnJDPi66OottrqRrceHYa08wqOp63Jpv3KlBOSYCQkr72Lq1MUUDXd4lztfotwx
         hzeKlIu8M/5l0qoZv77NvmuAabJnpJ3r1GlZ490ZJc5UJnvzN9uf9MzfOTih48yMZM1G
         rLkxTTACDcdVbqARL76VmylT5H14LqPYm14tOzy6jjuwbJGzb/IFbM7bz2qLhhgVJs8P
         x1tgRiYWuvhR2vLaGovfJ2cL3UoaqYR6TTU1CEtbNffGsLhEnbkG0ofgLoKoLE+7kJtM
         JbZlrgqo9wx3+sS0hkdlNtK5Orb/hdUGsrBnB8B0gw0Mn6teyZgD6fOTSZdOPbm/eiI/
         ekSQ==
X-Gm-Message-State: ANoB5pn/LHm4HCvDV3Rjg/uCXU4cpNpGdLXWH/1bXUsvW437TA2GyDK8
        ZFjFwNxxOYImwpAR9Gfk2f8iKZHaujA=
X-Google-Smtp-Source: AA0mqf6nzwdPCz7kAgLnQ1jC6Xip0ONLc6X+HhlYGUI8nXTzIK4+To9r+UqeQjL3orbQI4dVxTctoA==
X-Received: by 2002:a05:600c:4f01:b0:3cf:8952:2fd2 with SMTP id l1-20020a05600c4f0100b003cf89522fd2mr43123970wmq.9.1669991384996;
        Fri, 02 Dec 2022 06:29:44 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:2dd3])
        by smtp.gmail.com with ESMTPSA id n187-20020a1ca4c4000000b003d005aab31asm8956946wme.40.2022.12.02.06.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 06:29:44 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 3/5] io_uring: cmpxchg for poll arm refs release
Date:   Fri,  2 Dec 2022 14:27:13 +0000
Message-Id: <ee156ffab31e37433493e3200e9ecb95c556e67d.1669990799.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669990799.git.asml.silence@gmail.com>
References: <cover.1669990799.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ upstream commit 2f3893437a4ebf2e892ca172e9e122841319d675 ]

Replace atomically substracting the ownership reference at the end of
arming a poll with a cmpxchg. We try to release ownership by setting 0
assuming that poll_refs didn't change while we were arming. If it did
change, we keep the ownership and use it to queue a tw, which is fully
capable to process all events and (even tolerates spurious wake ups).

It's a bit more elegant as we reduce races b/w setting the cancellation
flag and getting refs with this release, and with that we don't have to
worry about any kinds of underflows. It's not the fastest path for
polling. The performance difference b/w cmpxchg and atomic dec is
usually negligible and it's not the fastest path.

Cc: stable@vger.kernel.org
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/0c95251624397ea6def568ff040cad2d7926fd51.1668963050.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 62e0d352c78e..0e3fc80fee05 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5650,7 +5650,6 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 				 struct io_poll_table *ipt, __poll_t mask)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	int v;
 
 	INIT_HLIST_NODE(&req->hash_node);
 	io_init_poll_iocb(poll, mask, io_poll_wake);
@@ -5696,11 +5695,10 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	}
 
 	/*
-	 * Release ownership. If someone tried to queue a tw while it was
-	 * locked, kick it off for them.
+	 * Try to release ownership. If we see a change of state, e.g.
+	 * poll was waken up, queue up a tw, it'll deal with it.
 	 */
-	v = atomic_dec_return(&req->poll_refs);
-	if (unlikely(v & IO_POLL_REF_MASK))
+	if (atomic_cmpxchg(&req->poll_refs, 1, 0) != 1)
 		__io_poll_execute(req, 0);
 	return 0;
 }
-- 
2.38.1

