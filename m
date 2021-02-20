Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBBA320696
	for <lists+stable@lfdr.de>; Sat, 20 Feb 2021 19:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhBTSIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Feb 2021 13:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhBTSIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Feb 2021 13:08:32 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB583C06178C;
        Sat, 20 Feb 2021 10:07:51 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id t15so14351931wrx.13;
        Sat, 20 Feb 2021 10:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0Y/6imZkqiKGlky7c1DUrdmobXIpnCmAeb06767LwoQ=;
        b=qzmNy4Ju/o9mJr1cDgjnsYZDz6XIt9VJ+xcBJuyQGeOwdaeAeLXeWIMNvUIxxjJlzN
         zrqYh7YfplkW5458YtKJ4NVGQ56MtVN7+Rf6Y2uJScKKzOVI+a9IjhkqEdOfwIA5yF3N
         48hQmkdA1nxZjXaf+eYKPOdlHPpCNU/pl/OPUF4OFh/6bLD+nt0fqUiDLqgH/f+a59b/
         bgHMGdySsCMO/LStABWBO9JFVIdAE3b+hieBlXYjRsgvf9fIH18D/N3XKD00jFw5Tj8X
         wmY4jdvVr84pXvPgXmiSyM4CN23TuAusO8yZXejm5x6j6he0R8HpAmd1yjtrBXMfZoIo
         RZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Y/6imZkqiKGlky7c1DUrdmobXIpnCmAeb06767LwoQ=;
        b=HJVNtuaGhbMqI8MxuvW4Ruwnx76yvB16qu7ozqFAM4B4RzglzGe6yuke+h9V+czTdH
         I7IDDyEsX85rzOGCXTLDC0w9/JEul0ajjRmA6teDfCkNhSGBYEZsY3sbqsWedbcO7Esz
         Jl/MRUbWxFrq1/BHbJwgIIYv2Az6L1259AyIsqIUKwvNAe0ZuBaB0AGO3+sq57eXDmQj
         w5tmIMEMAZwp8JgJiGZgnthmiAWLcGUukxm3dM7CXdpn5H11cs00RNhSAG9V5tY5NMYi
         eVPRyfA1BGSLLSNG2xBtGJMlAUaG9MjI4CkiV6w2lzRjSMJP7nt4lLyfkQPMhO3YJJDT
         GtvQ==
X-Gm-Message-State: AOAM532w1fr3sB4r+pKJZAtYAAVMf6hB0QH6TNujB6A3knE/JISXkxUn
        Zygs1UtSzVzieI6k8EMxPn0=
X-Google-Smtp-Source: ABdhPJytxm/V5LNfErCU2EI+ywksRRHtu/cQ3dFyeu9kyKSNEfMXl5ZRBAakiBa0mxT2dbmX0fI6MQ==
X-Received: by 2002:a5d:6951:: with SMTP id r17mr13964867wrw.279.1613844470653;
        Sat, 20 Feb 2021 10:07:50 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id b83sm13594918wmd.4.2021.02.20.10.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 10:07:50 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2 4/4] io_uring: wait potential ->release() on resurrect
Date:   Sat, 20 Feb 2021 18:03:50 +0000
Message-Id: <394bfff8aba9353db8270ecd89f590a539f82dca.1613844023.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613844023.git.asml.silence@gmail.com>
References: <cover.1613844023.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is a short window where percpu_refs are already turned zero, but
we try to do resurrect(). Play nicer and wait for ->release() to happen
in this case and proceed as everything is ok. One downside for ctx refs
is that we can ignore signal_pending() on a rare occasion, but someone
else should check for it later if needed.

Cc: <stable@vger.kernel.org> # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b00ab7138410..ce197af2d3c6 100644
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
@@ -7353,13 +7368,11 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 		flush_delayed_work(&ctx->rsrc_put_work);
 
 		ret = wait_for_completion_interruptible(&data->done);
-		if (!ret)
+		if (!ret || !io_refs_resurrect(&data->refs, &data->done))
 			break;
 
-		percpu_ref_resurrect(&data->refs);
 		io_sqe_rsrc_set_node(ctx, data, backup_node);
 		backup_node = NULL;
-		reinit_completion(&data->done);
 		mutex_unlock(&ctx->uring_lock);
 		ret = io_run_task_work_sig();
 		mutex_lock(&ctx->uring_lock);
@@ -10094,10 +10107,8 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 
 		mutex_lock(&ctx->uring_lock);
 
-		if (ret) {
-			percpu_ref_resurrect(&ctx->refs);
-			goto out_quiesce;
-		}
+		if (ret && io_refs_resurrect(&ctx->refs, &ctx->ref_comp))
+			return ret;
 	}
 
 	if (ctx->restricted) {
@@ -10189,7 +10200,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	if (io_register_op_must_quiesce(opcode)) {
 		/* bring the ctx back to life */
 		percpu_ref_reinit(&ctx->refs);
-out_quiesce:
 		reinit_completion(&ctx->ref_comp);
 	}
 	return ret;
-- 
2.24.0

