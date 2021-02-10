Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8113165B5
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 12:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhBJLwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 06:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhBJLuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 06:50:18 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A12C06178B;
        Wed, 10 Feb 2021 03:49:38 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id q8so2093757wru.13;
        Wed, 10 Feb 2021 03:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=muilweOhBZtIDDJj2uc98hfZ9vV4PGLrpjQGboLbWnU=;
        b=Kp5/LoyoLTFWv7/InTjDPW079ac1b3Tf3sNV93lsxy98zG5Y2XcJMtp/UbBUxxLh13
         3mXecfVUvlpzr6oQl9k7d2c4RieWkopiayqLX73+M1xqFEsdl8rpsDgPwaFKatmXvBTI
         fqhbu8oNYrVHphyWvrzr96ElMsB7/zFinf8zTzTm1bc/YNPRJgHw8OP/lP1Il21wv3HI
         r/J6dVjUbxAATJruS295rflhfWfGIUsYcsRNeC9zDAGeJ6UiKO2XE2zwsD/uPhPQ2fLr
         NGlKkF8vJ/tbx//kmqMzKXoTtn7yCGDoOEMf2pT/rdw4wtpeR9O4ugFlYKNKB9C/sVbb
         X/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=muilweOhBZtIDDJj2uc98hfZ9vV4PGLrpjQGboLbWnU=;
        b=mH+uJRoMhzJtVRa7avryK4VAEphlDkZEDoH1k0xsnbs9HX2BOtMIg2ij4Zr7tlQuK9
         lBU+ctCBX3rKeG+gKrAF6Ays97CvofdPXsxo25aWZk94kbdvTE+BON6+5yNn5c3LAZcu
         G5htdFDWGIKU6+yZaNt3gHFB98phdzspT/6WPIKidEf5D93crRHF6+WZwyXZA/1yuaZD
         TD2QGSAg41j0m86aDUP2J2RwwdhfzB9O2lHE16PKJcH+Cz2YP3QdEsqdeT8+hhRjGrPw
         vUxzaui+f2Dddsgkue6Ve2wHnQ+Adp+ImdYlLOTUTXBVtSwD59jaut9f+OXkzNsRt+6s
         KlGQ==
X-Gm-Message-State: AOAM530/9KmXCMBjksc+EcIdE9prhmxbHJIJIVmNqQG6x8arUZ5Zm1PG
        DhIRMJLw6/J5LrOOLDOR4NA=
X-Google-Smtp-Source: ABdhPJwrX2a5F+ZmkSpCOvkrrHKeOxLk/zvf5us+qM2mCgFPbjPh3WskH8eaDhUALyHJJ0K9EjQcfA==
X-Received: by 2002:a5d:6d06:: with SMTP id e6mr3240576wrq.425.1612957776913;
        Wed, 10 Feb 2021 03:49:36 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id j11sm2811145wrt.26.2021.02.10.03.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 03:49:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org,
        syzbot+695b03d82fa8e4901b06@syzkaller.appspotmail.com
Subject: [PATCH 2/2] io_uring; fix files cancel hangs
Date:   Wed, 10 Feb 2021 11:45:42 +0000
Message-Id: <6602e3cf30c58d351a26b117628b599f1fb8a0a1.1612957420.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612957420.git.asml.silence@gmail.com>
References: <cover.1612957420.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We park SQPOLL task before going into io_uring_cancel_files(), so the
task won't run task_works including those that might be important for
the cancellation passes. In this case it's io_poll_remove_one(), which
frees requests via io_put_req_deferred().

Unpark it for while waiting, it's ok as we disable submissions
beforehand, so no new will be generated.

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
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6b73e38aa1a9..1e803a9afc8e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9056,11 +9056,16 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
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

