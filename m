Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FEE303B81
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 12:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392364AbhAZLX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 06:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392340AbhAZLW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 06:22:56 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658ADC06178B
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:07 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id w1so22361437ejf.11
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b62UQnLTv6+nYld9hSZxRvsaLNtFsASEvgTrPG6d828=;
        b=O9guSWsKduHr7hx4bRqcF3hwxeAP+h7NFcoYeCVc+Cc+JM9ocJQ5Re+mSq4lYAKW6M
         NyL/tsMDb2aVpHGN37BWmWLFNNf/twb7lru8KlrHnDv9Yu8mGAWs6OchDJHdK/rLfNfP
         bNANIJ4AnxjG6ag7d89K4YRFQnM7Bfx+MKTUgdo0Itq9f+Wr4nXNx3qcARxNK6eVxrxv
         5TNcN3lD5FEiqTDwLrVHEF3r31lsh90QlmTn3+N3H3mFaUWM57Pe8VJ5QL2zQfb9akCH
         02hxP8jSO7L0oSdvwz/sL5AnnVzm/cfUKsKr93uE7IOFLUF+vLcsh+sFpuzPs6rZEAR7
         WDPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b62UQnLTv6+nYld9hSZxRvsaLNtFsASEvgTrPG6d828=;
        b=V2YBvc8KeD+6+WM6fO21MIFCh2ilPUCWqk6iQfLwBrabTksjkkZDQX8SBIMvAWX6Sf
         SDZpBGXElah4WBlUbn1I6JcjVOrIIOxACo70xW+KUlr6YZIyJ/9F/oYOXzaUS3Re/YTy
         x2xRg4ZrwDb4qJNTOF89qLlTVZjnAYGcOJth856nVwy71yRgFfvBKfUMatdI1joIm9R1
         CrYIiN3hxj/2ZgPvSLIti9BXo7r3QVX00AkVKGJ/vDe1z9yk6od2ldncpuNW8xI7MLX5
         S5wCBaCQKRW1S57ObP0Sn3tsMsV3wf+tykwgw+F8rtXafvnaaJjs1XqRB8CqVVntijxH
         5u1A==
X-Gm-Message-State: AOAM530uNAke+NA91E9VWCXA9IC60sKJat+20TO+VlKPCo9vpFzsbnrs
        gUqh5Z+bFK8eCfqMGh2kdRVXYftAeAQF4A==
X-Google-Smtp-Source: ABdhPJy92NyAiiWgaw12rKLE1fQXN7h99NqGBiohKryl6vCWqsdl/BUmJ8BpFsuZjI4rHYKi5VPZTA==
X-Received: by 2002:a17:906:6407:: with SMTP id d7mr1950702ejm.133.1611660065951;
        Tue, 26 Jan 2021 03:21:05 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id o17sm12167128edr.17.2021.01.26.03.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 03:21:05 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+a32b546d58dde07875a1@syzkaller.appspotmail.com
Subject: [PATCH stable 08/11] io_uring: fix uring_flush in exit_files() warning
Date:   Tue, 26 Jan 2021 11:17:07 +0000
Message-Id: <0e32dce528dd20f3539b624e52b2f60d47e067fa.1611659564.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611659564.git.asml.silence@gmail.com>
References: <cover.1611659564.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4325cb498cb743dacaa3edbec398c5255f476ef6 ]

WARNING: CPU: 1 PID: 11100 at fs/io_uring.c:9096
	io_uring_flush+0x326/0x3a0 fs/io_uring.c:9096
RIP: 0010:io_uring_flush+0x326/0x3a0 fs/io_uring.c:9096
Call Trace:
 filp_close+0xb4/0x170 fs/open.c:1280
 close_files fs/file.c:401 [inline]
 put_files_struct fs/file.c:416 [inline]
 put_files_struct+0x1cc/0x350 fs/file.c:413
 exit_files+0x7e/0xa0 fs/file.c:433
 do_exit+0xc22/0x2ae0 kernel/exit.c:820
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x3e9/0x20a0 kernel/signal.c:2770
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

An SQPOLL ring creator task may have gotten rid of its file note during
exit and called io_disable_sqo_submit(), but the io_uring is still left
referenced through fdtable, which will be put during close_files() and
cause a false positive warning.

First split the warning into two for more clarity when is hit, and the
add sqo_dead check to handle the described case.

Cc: stable@vger.kernel.org # 5.5+
Reported-by: syzbot+a32b546d58dde07875a1@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e8d0bea702a3..12fa5e09cefa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8931,7 +8931,10 @@ static int io_uring_flush(struct file *file, void *data)
 
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		/* there is only one file note, which is owned by sqo_task */
-		WARN_ON_ONCE((ctx->sqo_task == current) ==
+		WARN_ON_ONCE(ctx->sqo_task != current &&
+			     xa_load(&tctx->xa, (unsigned long)file));
+		/* sqo_dead check is for when this happens after cancellation */
+		WARN_ON_ONCE(ctx->sqo_task == current && !ctx->sqo_dead &&
 			     !xa_load(&tctx->xa, (unsigned long)file));
 
 		io_disable_sqo_submit(ctx);
-- 
2.24.0

