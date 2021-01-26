Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51FD303B79
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 12:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392304AbhAZLWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 06:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392303AbhAZLVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 06:21:43 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4612C0613D6
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:02 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id d2so15725162edz.3
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=830NVUoeZpi1YUm0xNN/ayO3qApi6qcIRadh5RBk/94=;
        b=uagH8EqE+e5flLeWpMxEnhMLqgd7P3Zlf6YTIi2AOCTdZxwWfQKQ4deZBwSFZ/tsRh
         RmDtWSptHSMmTXf8K/M1e9oAew+XotppTtmYMPAWFSbB2dhzE12aj9wyTeUsClzuVeoN
         mgtBt1ILOERbh1UwSoJiP8Ka20cJFvDsrheT9wLzwzEWlBG3YriX1rlHoP2z4y9K0e2+
         L8699M0Sny2F8wWXHe0W6GYWnKOFjpQaFekDbX0a184nUumWyKDpFVfLdPAWPtRueHfV
         /mbuUzBmkbWjg+RdexmqfNhxST95Z/yPRTj3a5nz8hT9l15l0a7+eabJcwNFydP+TYWb
         3/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=830NVUoeZpi1YUm0xNN/ayO3qApi6qcIRadh5RBk/94=;
        b=qSNByOYM36UWuR25PtRpOtAtaqSk5AoEoA8DCbzdyoJ2keuTBILOrj7Iy6NvLLIxg7
         6dGxOxbCC9IN4Z2Dg4rY+U4zroYhc8ZnKR0JwFOT1QHJwwq3gmAkYFQSyZfpu15imB4p
         c7XoUzlTs0ogORkTquRjHjKMdHIQ20yCPsLVzvaCYwDwxIl5YrBahvxCrX5RQEzc+qah
         zpaUdjRKaco2a7ryqSFkeMK8tt5OVcjgqd9FVe+MSjIMK74oTwHPDdf47TyKjG/34lOh
         zpq/oaaCIZKBoSGPxLWnkJ8QC63QJ03GX3J5vTw4jcQmujwQWz/or+XmXmvMTzoaRqqZ
         jd1g==
X-Gm-Message-State: AOAM530Az9sq+SGl4oDxJQ07G29uxaBmzejj08phgHhKebOfkXraiE47
        mAd4eGRvF2eDbG4WYOrUIX+C/3/ZXxlS4A==
X-Google-Smtp-Source: ABdhPJzVBvUnQc8Wwm0h35+A/WgT7l2T7u6PKD1qchyKs7MzIuvsXq40xKD/PT9xz/WWyWjOnED6wg==
X-Received: by 2002:a05:6402:34c3:: with SMTP id w3mr4255432edc.3.1611660061275;
        Tue, 26 Jan 2021 03:21:01 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id o17sm12167128edr.17.2021.01.26.03.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 03:21:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH stable 03/11] io_uring: add warn_once for io_uring_flush()
Date:   Tue, 26 Jan 2021 11:17:02 +0000
Message-Id: <1abdd0e576ae991c6ab04bebd20360ea2b3a175b.1611659564.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611659564.git.asml.silence@gmail.com>
References: <cover.1611659564.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6b5733eb638b7068ab7cb34e663b55a1d1892d85]

files_cancel() should cancel all relevant requests and drop file notes,
so we should never have file notes after that, including on-exit fput
and flush. Add a WARN_ONCE to be sure.

Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6c89d38076d0..4dfba3d44a3c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8895,17 +8895,23 @@ void __io_uring_task_cancel(void)
 
 static int io_uring_flush(struct file *file, void *data)
 {
-	if (!current->io_uring)
+	struct io_uring_task *tctx = current->io_uring;
+
+	if (!tctx)
 		return 0;
 
+	/* we should have cancelled and erased it before PF_EXITING */
+	WARN_ON_ONCE((current->flags & PF_EXITING) &&
+		     xa_load(&tctx->xa, (unsigned long)file));
+
 	/*
 	 * fput() is pending, will be 2 if the only other ref is our potential
 	 * task file note. If the task is exiting, drop regardless of count.
 	 */
-	if (fatal_signal_pending(current) || (current->flags & PF_EXITING) ||
-	    atomic_long_read(&file->f_count) == 2)
-		io_uring_del_task_file(file);
+	if (atomic_long_read(&file->f_count) != 2)
+		return 0;
 
+	io_uring_del_task_file(file);
 	return 0;
 }
 
-- 
2.24.0

