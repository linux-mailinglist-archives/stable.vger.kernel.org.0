Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5FA3147BB
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 05:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhBIEx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 23:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbhBIExL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 23:53:11 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79262C06121D
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 20:52:00 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id y18so21854268edw.13
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 20:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ReT8JKysS12uA3SkyYsIU1Rm9+bIqgsvAOPxre2fpU8=;
        b=AMeHBGCDqdlraHfi2uZfhMsVvPpA8kVveJDbvFJIHk5i9wP0q87lPkJf0OE45HZwxJ
         Q8d2GzNbqgoXlC8MBJm8PNgb8ZCDBMOvNIlsO2cmHiraG2zdHUiVMI7K9DaCvgKqYL1H
         X8dx3IYxmTqVCVyr2SK2hkLMSuaboqkHjkaNWMbwn4kdFm9FVNQCLxzPdijPU7x8a11e
         kTY3IWWygQQvaqeirBEKNoMAjz+zmXTdCyV4q/TlKB96SExgCrIcURTJfVvyKJ/4SrgL
         V2Pdf8qMrCl9/15TmDzd6xlGm83w+OIif8Y05QhHLP1V8rlq7FWFGiP3tamFOWG/j3gZ
         aL6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ReT8JKysS12uA3SkyYsIU1Rm9+bIqgsvAOPxre2fpU8=;
        b=a/4xHYpsCZOuunGnLwP4moBtzfFERx7krVUG4LnU28ndGQMi78hxIdAhtqBz3CPP9C
         dNWqIdTF6xplMhgVVFs+XF8u4pAXud4zFH3+eaI4Zu3B+LTvCNDqlU1c+RsJatylgLp2
         fvMA2GX2RPvLxnBkh/P4J0tiWdOv74X0baaTJET1QtOyKQ7fyCUUYdAAEkgIj1rvw1Oj
         AD8epvKy31HpZcJ9EOwid4kb+HFrDpfi5Kw+t0g4k3b++BzPmWwgYv/o/KJH9HLWzubz
         6ax91a0r0vtlcP3pHzYzz2vFaA3HGMbwcnfWwDjXsgS/Ur1VJE7MDGPzG5zR38vskjLY
         1NPQ==
X-Gm-Message-State: AOAM533ctM3JtFqrWjGPPYvkpvx5w7KoEm0JPX8zgPiwfssLJTnudS4y
        cTgvy16Cp3/7wtA6Z9ZWuzVtAa78j0Y=
X-Google-Smtp-Source: ABdhPJwqNhhNJQOoJpXBDEfxosp/vMcnRYKXULbxDwJApCh40D1AezjvQmpIyy1xA2BbaEjtvZh8Gg==
X-Received: by 2002:a05:6402:1291:: with SMTP id w17mr20910688edv.112.1612846319047;
        Mon, 08 Feb 2021 20:51:59 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id g9sm9973445ejp.55.2021.02.08.20.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 20:51:58 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+3e3d9bd0c6ce9efbc3ef@syzkaller.appspotmail.com
Subject: [PATCH 14/16] io_uring: fix sqo ownership false positive warning
Date:   Tue,  9 Feb 2021 04:47:48 +0000
Message-Id: <624dffd5d4357b851fe6cb482f3a304b409fb722.1612845821.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612845821.git.asml.silence@gmail.com>
References: <cover.1612845821.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 70b2c60d3797bffe182dddb9bb55975b9be5889a ]

WARNING: CPU: 0 PID: 21359 at fs/io_uring.c:9042
    io_uring_cancel_task_requests+0xe55/0x10c0 fs/io_uring.c:9042
Call Trace:
 io_uring_flush+0x47b/0x6e0 fs/io_uring.c:9227
 filp_close+0xb4/0x170 fs/open.c:1295
 close_files fs/file.c:403 [inline]
 put_files_struct fs/file.c:418 [inline]
 put_files_struct+0x1cc/0x350 fs/file.c:415
 exit_files+0x7e/0xa0 fs/file.c:435
 do_exit+0xc22/0x2ae0 kernel/exit.c:820
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x427/0x20f0 kernel/signal.c:2773
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Now io_uring_cancel_task_requests() can be called not through file
notes but directly, remove a WARN_ONCE() there that give us false
positives. That check is not very important and we catch it in other
places.

Fixes: 84965ff8a84f0 ("io_uring: if we see flush on exit, cancel related tasks")
Cc: stable@vger.kernel.org # 5.9+
Reported-by: syzbot+3e3d9bd0c6ce9efbc3ef@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 296b4cb44c7d..0bda8cc25845 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8683,8 +8683,6 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	struct task_struct *task = current;
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
-		/* for SQPOLL only sqo_task has task notes */
-		WARN_ON_ONCE(ctx->sqo_task != current);
 		io_disable_sqo_submit(ctx);
 		task = ctx->sq_data->thread;
 		atomic_inc(&task->io_uring->in_idle);
-- 
2.24.0

