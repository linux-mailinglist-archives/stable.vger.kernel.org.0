Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11C2320664
	for <lists+stable@lfdr.de>; Sat, 20 Feb 2021 18:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhBTR0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Feb 2021 12:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhBTR0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Feb 2021 12:26:16 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC1AC061786;
        Sat, 20 Feb 2021 09:25:35 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id l13so1069259wmg.5;
        Sat, 20 Feb 2021 09:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FSzAt33U8ZbfwRFXQCgS+lqwQoN3SOb0JS+peXp72X0=;
        b=KJuiNFP73MZJpu7ZYIRwDxrxUUqO4J/VSg18SLgsj4K4Htgd9TACEVja/PkN6Ctwhq
         yyzWrbtoaNTJWyp5CopUN4yU6VeO5jHpBnShoECLo7PCyLmya6qPyaRlKheWOR8qGdTy
         hB1yuwbwrZHp5hfAomHwrIPab/Eo5LaeE6FHKzhZoAMLh52/+LiRyqwezbr1jef9/EMc
         /IgjPJmXLx1S2I8XJ823RthSxqJkBP9fiPCbFJ5eQIHpLMHyEmjRQLhb42z4UmO956pl
         wzVRPsPi1ifx2jgucnyOajnbx7LlYTkEuKGlYORiqIzI+oBgS5wvnOfGv/lTWbbD0b23
         3IlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FSzAt33U8ZbfwRFXQCgS+lqwQoN3SOb0JS+peXp72X0=;
        b=kovgmfv36nDXrtywjLWIPnpo8x1oqsJ/qEh2E+dRF1f3ala1G2nvXWGat1Jav9vm8C
         qJnV8+ZTeEYEXPtSkiAvemP1JUakdKVAX+hmbdm0Mmkbc5RYTuG9XvfIIquSL2qLErkZ
         Y3tWVfvB3ZODirHIGKoNfE/bPPKnKcgb7qCIP07hTGGHaKdMegjBvhYycCdPidn3A6Dg
         xV4e0oS5TvohxghBGCYXvK0qk9rZaMRihnGnmzKh235/5NT9NSID53AMaDrtqSPZT44s
         6x2x9DhYLb4cQl9wNQIkJs7Yoc1MUas/NJx1q7E1fzFgv6db1T5CI1KUW/nkUsaZ7N6H
         EIdQ==
X-Gm-Message-State: AOAM533onLehMApUJNGnx4uN1G0sNBn30xJK3dyZcz7JrQ9XEnGjKbqu
        bh1d0LNzwmhDawyVBM4t32f4N0KlmBtLXg==
X-Google-Smtp-Source: ABdhPJw1VVSZQfROdDWES9P8ngZt5tphHPLAA9Xy+0NQWcGuty/XJbjNT1ntd+HBh307xlIchP6ZCw==
X-Received: by 2002:a1c:cc08:: with SMTP id h8mr13357668wmb.188.1613841934254;
        Sat, 20 Feb 2021 09:25:34 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id r1sm19908520wrl.95.2021.02.20.09.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 09:25:33 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring: wait potential ->release() on resurrect
Date:   Sat, 20 Feb 2021 17:21:35 +0000
Message-Id: <6d3e737d3590ca3875754646aa788baea14da3e4.1613841429.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613841429.git.asml.silence@gmail.com>
References: <cover.1613841429.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is a short window where percpu_refs are already turned zero, but
we try to do resurrect(). Play nicer and wait for ->release() to happen
in this case and proceed as everything is ok. One little downside is
that we can ignore signal_pending() on a rare occasion, but someone
else should check for it later if needed.

Cc: <stable@vger.kernel.org> # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f2fdebaf28fe..6ea4633e5ed5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1104,6 +1104,21 @@ static inline void io_set_resource_node(struct io_kiocb *req)
 	}
 }
 
+static bool io_refs_resurrect(struct percpu_ref *ref, struct completion *compl)
+{
+	if (!percpu_ref_tryget(ref)) {
+		/* already at zero, wait for ->release() */
+		if (!try_wait_for_completion(compl))
+			synchronize_rcu();
+		return false;
+	}
+
+	percpu_ref_resurrect(ref);
+	reinit_completion(compl);
+	percpu_ref_put(ref);
+	return true;
+}
+
 static bool io_match_task(struct io_kiocb *head,
 			  struct task_struct *task,
 			  struct files_struct *files)
@@ -10094,10 +10109,8 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 
 		mutex_lock(&ctx->uring_lock);
 
-		if (ret) {
-			percpu_ref_resurrect(&ctx->refs);
-			goto out_quiesce;
-		}
+		if (ret && io_refs_resurrect(&ctx->refs, &ctx->ref_comp))
+			return ret;
 	}
 
 	if (ctx->restricted) {
@@ -10189,7 +10202,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	if (io_register_op_must_quiesce(opcode)) {
 		/* bring the ctx back to life */
 		percpu_ref_reinit(&ctx->refs);
-out_quiesce:
 		reinit_completion(&ctx->ref_comp);
 	}
 	return ret;
-- 
2.24.0

