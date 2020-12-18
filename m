Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB052DE329
	for <lists+stable@lfdr.de>; Fri, 18 Dec 2020 14:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgLRNQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Dec 2020 08:16:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLRNQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Dec 2020 08:16:42 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9103BC0617B0;
        Fri, 18 Dec 2020 05:16:01 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id r3so2123690wrt.2;
        Fri, 18 Dec 2020 05:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dL/AuyeUrHnEUUtiBzoq8HJknDkLU9BE5SB7vIR5M88=;
        b=LTWbVkA83xVri9kA9HrLn3WR1O6C6WriKA6xHX9uiKof18y4TxvCqJDNDsdUaRn8c0
         IP7MHYGohE4JhlyXI+Ezd5HS+iG9kVqRG1Zi6DDYJ6zRhh8IWjk9n+L//jh/hNX+G/UM
         5CLIYIcRylRon05ZvAnJ64yTKD4GK3n1Hn3y2bP/OnaYb2+kjTMTTNW8C8CwVKZ4I6K5
         /YgvUgBW4YxMoN7EZiJFU0KDN3JhyoawEum7b/B3sjw0yxHdMTKGNSrIBhvzaDCcC6TC
         eR7K8SuPrxZ3WR393aBfVKzvMPXmu4dRRx1i3vAoKNTIcxBWlS7HkjDBAwp0Gam2M2RB
         G2qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dL/AuyeUrHnEUUtiBzoq8HJknDkLU9BE5SB7vIR5M88=;
        b=TpvVKEyqrzzvn7eWIuOlCF6nxW8fVgpFoL6w8VHfZOoucFJwWPlUDMa1YWRIiwXtwn
         Gjh6DyHBZVFLLgZ7vqMOVmp/hnpO1TGhUh3yj/vvvNlVa3TJcVAIKx7Yn+G9SfenrJTp
         mMKF4kIujRGITq9ELgR8l0JYYpvlBZTgjoFDt9CVPH1J5Ci51emgSUsE3/HLQHobmVA2
         9S3yAi8G2FYhPYk3c0ZXQP1hUNUDFWt6r7oAeVKdyA+o4Zxi8KxkNs/bJSJhL0hlCeBs
         OQHvngvt2PGiVTuFC6Armv56wL1ibno545esoFy+Zvr0N92SFUuGcE+pskKFJNueL3Xj
         oRLA==
X-Gm-Message-State: AOAM530AOsnI2FyNUACBkKXy8xK4/OVDivgOrLifDWDxyEzt+FGisz14
        K260JVuRypSOpvp9rtvQzys=
X-Google-Smtp-Source: ABdhPJzkal/zsfw97AgYHxggEHOuyyMDqzwc7vHzT44iPN/PKW14jdvtXv+QPpwTSUp6sc5FYqwYOQ==
X-Received: by 2002:adf:f6cc:: with SMTP id y12mr4427787wrp.35.1608297360336;
        Fri, 18 Dec 2020 05:16:00 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.120])
        by smtp.gmail.com with ESMTPSA id b9sm12778595wmd.32.2020.12.18.05.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 05:15:59 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/8] io_uring: close a small race gap for files cancel
Date:   Fri, 18 Dec 2020 13:12:21 +0000
Message-Id: <68b267b21b29369fb553eb70c0c3f359c6a119c0.1608296656.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1608296656.git.asml.silence@gmail.com>
References: <cover.1608296656.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The purpose of io_uring_cancel_files() is to wait for all requests
matching ->files to go/be cancelled. We should first drop files of a
request in io_req_drop_files() and only then make it undiscoverable for
io_uring_cancel_files.

First drop, then delete from list. It's ok to leave req->id->files
dangling, because it's not dereferenced by cancellation code, only
compared against. It would potentially go to sleep and be awaken by
following in io_req_drop_files() wake_up().

Fixes: 0f2122045b946 ("io_uring: don't rely on weak ->files references")
Cc: <stable@vger.kernel.org> # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8cf6f22afc5e..b74957856e68 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6098,15 +6098,15 @@ static void io_req_drop_files(struct io_kiocb *req)
 	struct io_uring_task *tctx = req->task->io_uring;
 	unsigned long flags;
 
+	put_files_struct(req->work.identity->files);
+	put_nsproxy(req->work.identity->nsproxy);
 	spin_lock_irqsave(&ctx->inflight_lock, flags);
 	list_del(&req->inflight_entry);
-	if (atomic_read(&tctx->in_idle))
-		wake_up(&tctx->wait);
 	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	req->flags &= ~REQ_F_INFLIGHT;
-	put_files_struct(req->work.identity->files);
-	put_nsproxy(req->work.identity->nsproxy);
 	req->work.flags &= ~IO_WQ_WORK_FILES;
+	if (atomic_read(&tctx->in_idle))
+		wake_up(&tctx->wait);
 }
 
 static void __io_clean_op(struct io_kiocb *req)
-- 
2.24.0

