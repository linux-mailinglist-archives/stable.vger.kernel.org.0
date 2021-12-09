Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74ECE46EC69
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 17:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239874AbhLIQDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 11:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240722AbhLIQDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 11:03:34 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CBBC061746
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 08:00:01 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id p13so5824691pfw.2
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 08:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0TEf1VCVtrfwRdxN4Rcxnj4FSMmH8bluXlBuJP4JsCU=;
        b=4AoyvvYrx4gjHbKPhjLuClPYMoPSMYpoil1GtY/uJ9zLdc4/TgJYHV6nxnb/2YIV+D
         7kN3G3b7bc0a2Vs9h/+JKhpBpxOjuCd/gBBJ+okcURtYcAoLDfw//Ztobeo5qWRRewVx
         cMeLV34folPppCxCXmAQAT0taBhXn6m+OaTxmfQ072My1Gka0zn9sta7r6JbIrLedFa5
         YSS285RpYkUFqzb7YMVbNBEFyCEE+LSPPmYFbsi3lZcokPsz7Skhn3ZbVTLrCyBQrOHh
         3D8/GVszmpPLpac2CKrMsckXBIIlDVc12OLZsbnGfZgLxJdI9hx7ghkyHUwtpq2/Nkac
         JH3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0TEf1VCVtrfwRdxN4Rcxnj4FSMmH8bluXlBuJP4JsCU=;
        b=rA7cQjrZZOECGTjpBp2xUYR7HgY+yTrQYtvj8qqu9vXOdAUqf+12401Rp6Nm4Pvpb4
         8Pk3maa3rOKeo7jJn53HQRks6AgDioW5/k/8mR/q9AJhKDR+jv9Aq08JAZUsFqBC+P0W
         8+JVBHqp4Xh7evv/7irRuFfDozyY0iY/wB8Anu/NfntJ9Dn+7oAupbne/ivTfIkEbaQR
         mwpEwYmiacV/uXmLuXczffIVaMcHUZ9r3hsC9KpICbzLyrpoEpW9/Ry9f8vWVVVDXxn+
         DjCmQvbVtA77Pz+QN4tb/1QM8//axeCWb0NkImDjDQOUFGYlGHcU71YbyOCcp5fWnclC
         JVbw==
X-Gm-Message-State: AOAM5335KzRW6AABAKytrClIjIV+he5oInjWwp/59vHowSJCneoaVWnN
        xCFbKhrGKS35O1KZu5pKSQFoNQ==
X-Google-Smtp-Source: ABdhPJyLRDH1kZYX7fv6tGqJUAY3+eovh5xwJhSn2Dc/+/SZqVf9eK2Fwnv1RXQtJ7xq4R7j/njKRQ==
X-Received: by 2002:aa7:86c8:0:b0:4b1:7b0:56aa with SMTP id h8-20020aa786c8000000b004b107b056aamr641468pfo.49.1639065600743;
        Thu, 09 Dec 2021 08:00:00 -0800 (PST)
Received: from localhost.localdomain ([66.185.175.30])
        by smtp.gmail.com with ESMTPSA id q17sm146875pfu.117.2021.12.09.07.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 08:00:00 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+21e6887c0be14181206d@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [PATCH 2/2] io_uring: ensure task_work gets run as part of cancelations
Date:   Thu,  9 Dec 2021 08:59:56 -0700
Message-Id: <20211209155956.383317-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211209155956.383317-1-axboe@kernel.dk>
References: <20211209155956.383317-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we successfully cancel a work item but that work item needs to be
processed through task_work, then we can be sleeping uninterruptibly
in io_uring_cancel_generic() and never process it. Hence we don't
make forward progress and we end up with an uninterruptible sleep
warning.

Add the waitqueue earlier to ensure that any wakeups from cancelations
are seen, and switch to using uninterruptible sleep so that postponed
task_work additions get seen and processed.

While in there, correct a comment that should be IFF, not IIF.

Reported-by: syzbot+21e6887c0be14181206d@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b4d5b8d168bf..738076264436 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9826,7 +9826,7 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
 
 /*
  * Find any io_uring ctx that this task has registered or done IO on, and cancel
- * requests. @sqd should be not-null IIF it's an SQPOLL thread cancellation.
+ * requests. @sqd should be not-null IFF it's an SQPOLL thread cancellation.
  */
 static __cold void io_uring_cancel_generic(bool cancel_all,
 					   struct io_sq_data *sqd)
@@ -9851,6 +9851,8 @@ static __cold void io_uring_cancel_generic(bool cancel_all,
 		if (!inflight)
 			break;
 
+		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
+
 		if (!sqd) {
 			struct io_tctx_node *node;
 			unsigned long index;
@@ -9868,8 +9870,9 @@ static __cold void io_uring_cancel_generic(bool cancel_all,
 							     cancel_all);
 		}
 
-		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
+		io_run_task_work();
 		io_uring_drop_tctx_refs(current);
+
 		/*
 		 * If we've seen completions, retry without waiting. This
 		 * avoids a race where a completion comes in before we did
-- 
2.34.1

