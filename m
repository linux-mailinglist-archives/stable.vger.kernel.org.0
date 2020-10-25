Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A456329821A
	for <lists+stable@lfdr.de>; Sun, 25 Oct 2020 15:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1414940AbgJYO36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Oct 2020 10:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1415156AbgJYO36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Oct 2020 10:29:58 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CD9C0613CE;
        Sun, 25 Oct 2020 07:29:57 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id g12so9596832wrp.10;
        Sun, 25 Oct 2020 07:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Fm+k4mfERo/btl/ehcAl5ycC8uINNC7MrL/HCfcrAk=;
        b=STAvj0LYucRrZRWdG6jK0qYTGLYjtzE2Il1/OdAo2mjtwQO9TMHW8kK26fXSkfIWQQ
         Qzh0SPV9rRE0qKE5O4CoqB0rpBcn1e2g+kMLQ4DXsDARA4cAcsboKC/hVYOlDiY82EdX
         0/nnNPPAf0xLo5kyOmkFG6wTauVweq51zHhierAqkAZZG/VGXAh3qDHd4QHc7Xqh+utQ
         sc5xilvs4jJ8rORvo6JY+B3e7Lix5evCfBb1NOUVF1q5K2Di6sxKiA5HSet7U/l6o7dV
         jGfB1qnS5fzK1M4mPX3uQi8QW8TImdnEqlQCXuN79c7Q2RojxVHNSTwZGQDDnFERd5pn
         1lQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Fm+k4mfERo/btl/ehcAl5ycC8uINNC7MrL/HCfcrAk=;
        b=AXQQgKfEJvRw8AzgexhNkjj2CQdZ3fX+LmKhvqZyTLfcMsXStppMwJdhD/xTIUV7c1
         rIFO2fDtJ0mAal32BTcshGqXC1GI8v2iLKPJ848JW/R2TFfue3JeS3Dzc7m2oA7K2QIl
         6vQzcDjNTL4UlA9hM5eLxO80ZDtbeX0fEbjSHZU++cd1jfaVcAPzPIsEb3NbM/zT8WKB
         OHQm73QLUKCRb5dqLMxsQefpmaMEs/rQ9tuNiJkcPqM/LC/mgiSL7fQ3CuaokQ1+0tg8
         L3deMa9Htk2YP0a1wkXkqvYxl2VnRL41HjQ6GMbaK0RBiM2xU39GbwsXU7/WyyKOYAwY
         3O2g==
X-Gm-Message-State: AOAM5321XuNOeH6eNVI8xyzsiVyP/IfhMpj7Q4Krp4U4FN5/oqZkByrJ
        qcB2Gq3lY9ViuQ27e+evP6Y+kPD4eTOBFw==
X-Google-Smtp-Source: ABdhPJzo9NHDFiZaHSRdXjIiT38Pze6TstC7vXmV9hXTiKAlf/wfhjPSzNzeYih8OeOWKtM/WV9R2w==
X-Received: by 2002:adf:f4d2:: with SMTP id h18mr12378307wrp.99.1603636196387;
        Sun, 25 Oct 2020 07:29:56 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id k18sm16751077wrx.96.2020.10.25.07.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 07:29:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] io_uring: fix invalid handler for double apoll
Date:   Sun, 25 Oct 2020 14:26:52 +0000
Message-Id: <1bf1093730a68f8939bfd7e6747add7af37ad321.1603635991.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

io_poll_double_wake() is called for both: poll requests and as apoll
(internal poll to make rw and other requests), hence when it calls
__io_async_wake() it should use a right callback depending on the
current poll type.

Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 20781e939940..b2d72bd18fcf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4927,6 +4927,8 @@ static void io_poll_task_func(struct callback_head *cb)
 	percpu_ref_put(&ctx->refs);
 }
 
+static void io_async_task_func(struct callback_head *cb);
+
 static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 			       int sync, void *key)
 {
@@ -4950,8 +4952,12 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 		/* make sure double remove sees this as being gone */
 		wait->private = NULL;
 		spin_unlock(&poll->head->lock);
-		if (!done)
-			__io_async_wake(req, poll, mask, io_poll_task_func);
+		if (!done) {
+			if (req->opcode == IORING_OP_POLL_ADD)
+				__io_async_wake(req, poll, mask, io_poll_task_func);
+			else
+				__io_async_wake(req, poll, mask, io_async_task_func);
+		}
 	}
 	refcount_dec(&req->refs);
 	return 1;
-- 
2.24.0

