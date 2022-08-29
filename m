Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC1F5A4E37
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 15:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiH2Neg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 09:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiH2Ned (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 09:34:33 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C61B8C00B
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:32 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id bq11so10209000wrb.12
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=njNrUuGRurzrymy+oROcb2BTk4jGgQarpupFr0wv4Tw=;
        b=k0i/TsMYAB/tvbe8bh246xUjeWymQViudmHTTye9YRsqHwoim1zyKs/Js2odtU39dD
         2JWUPMsyCvTXpI/3pR8pfddINb4T9QlTzKCwXP5Bj+MuePs+Pdgl+/vfR1x7X1zePERt
         B2lbV29zOwP/s/4iTuP9GA3EP/b3dyiwbdvDGpQjwfQm4rKUgU+6ysRMpiLQOf8MRH6c
         JEcUwsizAMJBzrS9TzuwdrK8qBdi3soAERSJEKXx1caVl4spKYAoD+Li3d/di/4AmqlJ
         iwQ7xDtL127T9LN2dIJDqLZCAynVaGQAx5xzoUJi+BPTIvEnN5P65C+7fm7E1meTvIow
         cvXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=njNrUuGRurzrymy+oROcb2BTk4jGgQarpupFr0wv4Tw=;
        b=ZXAA6y+f1rgz+LPpkMKAHO3ZSxtJqnczdxozMFHTQKA7GaGpcEQwgy3r1mvK3OtlFI
         8VV7owL+qx0oflVqtcnH5Rq9mXdS5TcaMn9YKg8rhsfm05S2kFDjYhKqasZFEP9W96Jh
         NBFGffqQoclBYh6JqfdXL3Jz0zBeh065Ny4RV4UdtNCqks2+nOj8IqBqNWJO2twZ3wzr
         TN4kDtBHOW9BLRsygSRafkrMqbxvncUkv3zSN56t8JeBEXug68RGSDUwzwUwCWJ57VK4
         ViYMWBxyFH0rwGTxpaLBZo6ARDFycQlQdZHwr/6JJ5LT8zHMNV2M13pWoCSZHHtZAo4h
         Yh1g==
X-Gm-Message-State: ACgBeo1uAayiCoeJxxWe3A6Pppgqw8XfIuxePWvn9CRtft8/rBjbwycT
        4nzqfDxzHZOA5umX+W5Qj+kASn0Y8rc=
X-Google-Smtp-Source: AA6agR5jdAL2jDmjSWSx7O1Yp4CTiwi4E1/ElSOhVQzBM2LgnU1sjFV7ck329i6ix1Dw0wpntx371A==
X-Received: by 2002:adf:ce85:0:b0:226:d242:50b0 with SMTP id r5-20020adfce85000000b00226d24250b0mr5239531wrn.506.1661780070342;
        Mon, 29 Aug 2022 06:34:30 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id bn6-20020a056000060600b00222ed7ea203sm4897361wrb.100.2022.08.29.06.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 06:34:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH stable-5.15 09/13] io_uring: remove poll entry from list when canceling all
Date:   Mon, 29 Aug 2022 14:30:20 +0100
Message-Id: <83da9963edf6789d744c4e6db4a3943e58ce8c0b.1661594698.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1661594698.git.asml.silence@gmail.com>
References: <cover.1661594698.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ upstream commmit 61bc84c4008812d784c398cfb54118c1ba396dfc ]

When the ring is exiting, as part of the shutdown, poll requests are
removed. But io_poll_remove_all() does not remove entries when finding
them, and since completions are done out-of-band, we can find and remove
the same entry multiple times.

We do guard the poll execution by poll ownership, but that does not
exclude us from reissuing a new one once the previous removal ownership
goes away.

This can race with poll execution as well, where we then end up seeing
req->apoll be NULL because a previous task_work requeue finished the
request.

Remove the poll entry when we find it and get ownership of it. This
prevents multiple invocations from finding it.

Fixes: aa43477b0402 ("io_uring: poll rework")
Reported-by: Dylan Yudaken <dylany@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c4d34b4e8fb6..4ebc47ebb77a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5714,6 +5714,7 @@ static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 		list = &ctx->cancel_hash[i];
 		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
 			if (io_match_task_safe(req, tsk, cancel_all)) {
+				hlist_del_init(&req->hash_node);
 				io_poll_cancel_req(req);
 				found = true;
 			}
-- 
2.37.2

