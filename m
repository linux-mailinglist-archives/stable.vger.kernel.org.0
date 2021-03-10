Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A957F333B86
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 12:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhCJLf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 06:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbhCJLe7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 06:34:59 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17C6C061763
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:34:54 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id u5-20020a7bcb050000b029010e9316b9d5so7540723wmj.2
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PYOxim1KWtaTD7YRAGE9XikTFSkC3bUx4HW0Ue/begE=;
        b=W9iQ+1Ec2Q7LUhAwNkt38Otr+THRC4mvZohQkd5B6jGHxGDcNjW1RXscqsQAt7sb5p
         GYSPE/fyV7XkyCTYVtoMBFr9rYYmI7jrigvz2zlmVtCHwfOHS2KT3jNSR+amLdrutuOj
         sueaA3Xcen58dpTZ3Bh7yf/VJDjThonkX1ieTzLSjGojqWY6G83Z3sCjfipN8jbu2BsV
         y0/qb9HSI27KBC1nxrwRHmOr0w2bxxV3XK8dXWerFwOxxLoKV+A5FadervXfdKbkbAnI
         VtdQCH4T/f/j/JqTyTbyZ8Z/skwYXhv1GWt9jO9i/2hQ5R17a799C9UPBz9FttjmrcvB
         nuEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PYOxim1KWtaTD7YRAGE9XikTFSkC3bUx4HW0Ue/begE=;
        b=JLKDD8PnHWoeyat5N50un3VhAU5tXPM0ImmlaEDptGZdc6bsNJLk5VRn1qgyyKA7fM
         0p4Xyn/bPH5F3C+ZHFOovwQ942wo2NiQAYm4Lap5yGWF+OUZtkNMAjL+gqjowfT7M/4G
         4YOs/AseksHC19qcByuIwNbU236G7xTgbDe64J8nSXHHUgdhapPlLDN5X8LTbrowEYv4
         SOI8DmdQnfUxtyHy5k8Gefs4lZBQaYnoA2oGMVAw+ZgfLjsoHcsN6atEN5UGl21Zdmlw
         ewxYirsyByXkV5v8ckYnLKD6FFvI2uWuAQ8sHQesi4aEFLfREAEP1XDe4v1vlQwCjC15
         chYQ==
X-Gm-Message-State: AOAM5310Su3/+uluEl6If7dJC278LE7+gJWx27V0HqKgEmmOumLWcxWV
        uBY+F9oy01IJHzyOtXodreVsg5INjw3KTw==
X-Google-Smtp-Source: ABdhPJyTokp1HFo+IgVvssny7KiYout7zPeKEmX+lVQ0cLD10I99aFiIiU4YojHP95eZaSMZBqsjIw==
X-Received: by 2002:a7b:cf16:: with SMTP id l22mr2871089wmg.26.1615376093376;
        Wed, 10 Mar 2021 03:34:53 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.55])
        by smtp.gmail.com with ESMTPSA id s18sm25179078wrr.27.2021.03.10.03.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 03:34:53 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+695b03d82fa8e4901b06@syzkaller.appspotmail.com
Subject: [PATCH 3/9] io_uring: unpark SQPOLL thread for cancelation
Date:   Wed, 10 Mar 2021 11:30:39 +0000
Message-Id: <165b3785cd6e17ffea1e53dfab027b6f89684dde.1615375332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615375332.git.asml.silence@gmail.com>
References: <cover.1615375332.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 34343786ecc5ff493ca4d1f873b4386759ba52ee upstream

We park SQPOLL task before going into io_uring_cancel_files(), so the
task won't run task_works including those that might be important for
the cancellation passes. In this case it's io_poll_remove_one(), which
frees requests via io_put_req_deferred().

Unpark it for while waiting, it's ok as we disable submissions
beforehand, so no new requests will be generated.

INFO: task syz-executor893:8493 blocked for more than 143 seconds.
Call Trace:
 context_switch kernel/sched/core.c:4327 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
 schedule+0xcf/0x270 kernel/sched/core.c:5157
 io_uring_cancel_files fs/io_uring.c:8912 [inline]
 io_uring_cancel_task_requests+0xe70/0x11a0 fs/io_uring.c:8979
 __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9067
 io_uring_files_cancel include/linux/io_uring.h:51 [inline]
 do_exit+0x2fe/0x2ae0 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Cc: stable@vger.kernel.org # 5.5+
Reported-by: syzbot+695b03d82fa8e4901b06@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cbcd4023cf7a..842a7c017296 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8955,11 +8955,16 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			break;
 
 		io_uring_try_cancel_requests(ctx, task, files);
+
+		if (ctx->sq_data)
+			io_sq_thread_unpark(ctx->sq_data);
 		prepare_to_wait(&task->io_uring->wait, &wait,
 				TASK_UNINTERRUPTIBLE);
 		if (inflight == io_uring_count_inflight(ctx, task, files))
 			schedule();
 		finish_wait(&task->io_uring->wait, &wait);
+		if (ctx->sq_data)
+			io_sq_thread_park(ctx->sq_data);
 	}
 }
 
-- 
2.24.0

