Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A5F307E59
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 19:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhA1SqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 13:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbhA1Sn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 13:43:57 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F78CC0613ED;
        Thu, 28 Jan 2021 10:43:17 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o10so5683085wmc.1;
        Thu, 28 Jan 2021 10:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uKrqSdyJaO/qlYV4J4LsnqnVzOS6dJ7WZMQZFyJyEIM=;
        b=KAbVlfCNrRn8sp03E+YTUXL478zVqtOH9yv9ZkGPmyoqraIJ5j5eU1a7cIk+DbSgFE
         T6HF8qofx0tSRPk+L3Bn1yUgVYlHTxQGbTh9/ENSvXwm5lWekcad4aLXLsaGtMzdTLqN
         6CbJxQ/XPu2r1woKPs0EhDGKJAxzk+BRgrqYE2OIh2x9alJ4RN14qFY09RObCmEvxrtD
         sx87+304uVQyCHF7SdESqj9sjbTfJTU4jOmS37yrtr1U7R7p/ldD0OfcsQrQaapxfBGV
         n2SkhvxrghZe0TfVy4BOqqZ0vVJ2sqlE18jD39ZPd5+nIsFVRYXH0DxpqBSu88bpqEDZ
         TZlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uKrqSdyJaO/qlYV4J4LsnqnVzOS6dJ7WZMQZFyJyEIM=;
        b=mDLsaBu7QM1692zpHlBu9Efd3M/yvBJrw8393aDuzgg48xFNT7rgr3qdTzZPuBRnxm
         BdWEc3j2vHBEOL5O7VA2k8al4zbntL0ZdGiM3QeRlrBvY0oeccTE5lwJZe27dmGRgRkM
         kDq88/eN1T+2bwuWnw2+LPRRkEJNQC9Mag0DKI/7mmQrUH8PyQcku2N+FhxoypK5RW4p
         OCZoVSDHjIWYr+HeQQol7SdVqlgZexU3OBE0YY/kly5srbZnAHKeaP8fQlGOVMhhnqAk
         nvAf9fLaFZjo6jwVCTMzs1iEXwQVoS5YAVjxt7Z7+OrK8AE2Q476DQxcVr3MRLRL6iH7
         CruQ==
X-Gm-Message-State: AOAM531obmzswyb8sVZnpsKeQZqvkcYSzrsjidiHpflD8oHgzXZJvYk1
        UvUukXj9Ova1iDzsE0dZowg5Y61GGxU=
X-Google-Smtp-Source: ABdhPJwvkQII4SJN3SFvGozK9SnIPyzfUoGuZzjfxl3zOWLipFdn1cpTsna8D2jEvg5kcA65xTHkzw==
X-Received: by 2002:a1c:cc14:: with SMTP id h20mr577735wmb.180.1611859396195;
        Thu, 28 Jan 2021 10:43:16 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.131])
        by smtp.gmail.com with ESMTPSA id y18sm7916386wrt.19.2021.01.28.10.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 10:43:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org,
        syzbot+3e3d9bd0c6ce9efbc3ef@syzkaller.appspotmail.com
Subject: [PATCH 2/2] io_uring: fix sqo ownership false positive warning
Date:   Thu, 28 Jan 2021 18:39:25 +0000
Message-Id: <4864e44e886a651f87288ad9a0ffdeea4ac025a7.1611859042.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611859042.git.asml.silence@gmail.com>
References: <cover.1611859042.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 39ae1f821cef..12bf7180c0f1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8967,8 +8967,6 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	struct task_struct *task = current;
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
-		/* for SQPOLL only sqo_task has task notes */
-		WARN_ON_ONCE(ctx->sqo_task != current);
 		io_disable_sqo_submit(ctx);
 		task = ctx->sq_data->thread;
 		atomic_inc(&task->io_uring->in_idle);
-- 
2.24.0

