Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE732303C83
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 13:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392337AbhAZMHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 07:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392339AbhAZLW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 06:22:56 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E38BC06178A
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:06 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id g12so22421174ejf.8
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S7JZ22JSG95h1zepz/8nX5FiPVxTaZFLuEXAwhmItbY=;
        b=t2z76xzqM47hgdXfHe+t3b7UlXrtKhfWJ1u5l5kn5+eO29Zp5BoG0TgV0ngPWtPLrG
         HEzWfHYcgLWRNkpwy8L6FBOedso/FbhqDvIlEuLI4paguzSz2Ey8MDf2dngXyhj4grlY
         pkA6vgdZmfiiO/FD4lHlh9ihSdIkiNA6MMVtiq7UU8eN4dofyVQKX8WTWPnwO3JoNbp0
         cOTBWk+fJTHhCgApUN99zRMYWLxm6i9icXbJNlJpS7KlTl9vTLA16y5THNTXHsFOMJ7b
         lQ/F1pn6d4Bon4IM/VZoDXT0H3uBTJp7pq6Sm+qa2jXErizH4TINy43q+OnPNgYpj+cJ
         wcWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S7JZ22JSG95h1zepz/8nX5FiPVxTaZFLuEXAwhmItbY=;
        b=C6j5YwXBayHS9i7k8Bk7o0Rp0ZTSk0LTMdb1YgyuM0VT7JRwNtmIClkGvivOSjVkLz
         qe3wdBTmqmYFz+0a/udS//XO7hueCHNbtf4gcyOJmmUKD3XMnutdlH+Gi5X+md19lV0X
         KAMX+ZToE8fGWW4kd1IB07SkeikFSFHNEVMLxrkgVwV2w6E81hTP4gqiqRMUI1AToEMy
         MjI/B37JH7/tMu97MBuzjbPgr5NAU2CyIR0CFTvKHnyl4KWPPZOMEnNAOlmLrTfEDrPn
         +lV2LMnawuP5SzM8JpFo3s8jbxzjuopoPMppISdteqVVem3tt+rQcuacDm/yOHeft38Q
         UyRw==
X-Gm-Message-State: AOAM531tBZkWIVIJAyydwIPINlppQ8zxPnXlKWZkSFNYU66W516RD9Ck
        YEVKvHyK38/8sX/5W2vWlOTBPMzMWEF5wg==
X-Google-Smtp-Source: ABdhPJwBbFCp+ci/9p69H3Y2MoX8rRZHfqNSFKzpWKE2dhFv9imRpjdwPEHvkNI7P/66uHn3RcRrUg==
X-Received: by 2002:a17:906:690:: with SMTP id u16mr3231399ejb.186.1611660065034;
        Tue, 26 Jan 2021 03:21:05 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id o17sm12167128edr.17.2021.01.26.03.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 03:21:04 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+2f5d1785dc624932da78@syzkaller.appspotmail.com
Subject: [PATCH stable 07/11] io_uring: fix false positive sqo warning on flush
Date:   Tue, 26 Jan 2021 11:17:06 +0000
Message-Id: <d880d405c12705056febe34cd7ab82dc1acb539b.1611659564.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611659564.git.asml.silence@gmail.com>
References: <cover.1611659564.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6b393a1ff1746a1c91bd95cbb2d79b104d8f15ac ]

WARNING: CPU: 1 PID: 9094 at fs/io_uring.c:8884
	io_disable_sqo_submit+0x106/0x130 fs/io_uring.c:8884
Call Trace:
 io_uring_flush+0x28b/0x3a0 fs/io_uring.c:9099
 filp_close+0xb4/0x170 fs/open.c:1280
 close_fd+0x5c/0x80 fs/file.c:626
 __do_sys_close fs/open.c:1299 [inline]
 __se_sys_close fs/open.c:1297 [inline]
 __x64_sys_close+0x2f/0xa0 fs/open.c:1297
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

io_uring's final close() may be triggered by any task not only the
creator. It's well handled by io_uring_flush() including SQPOLL case,
though a warning in io_disable_sqo_submit() will fallaciously fire by
moving this warning out to the only call site that matters.

Cc: stable@vger.kernel.org # 5.5+
Reported-by: syzbot+2f5d1785dc624932da78@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2acea64656f3..e8d0bea702a3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8719,8 +8719,6 @@ static bool __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 
 static void io_disable_sqo_submit(struct io_ring_ctx *ctx)
 {
-	WARN_ON_ONCE(ctx->sqo_task != current);
-
 	mutex_lock(&ctx->uring_lock);
 	ctx->sqo_dead = 1;
 	mutex_unlock(&ctx->uring_lock);
@@ -8742,6 +8740,7 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		/* for SQPOLL only sqo_task has task notes */
+		WARN_ON_ONCE(ctx->sqo_task != current);
 		io_disable_sqo_submit(ctx);
 		task = ctx->sq_data->thread;
 		atomic_inc(&task->io_uring->in_idle);
-- 
2.24.0

