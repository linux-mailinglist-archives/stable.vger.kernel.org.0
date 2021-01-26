Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0C2305107
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 05:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239280AbhA0Eje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 23:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390099AbhA0API (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 19:15:08 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B1CC0698C1;
        Tue, 26 Jan 2021 15:38:59 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id kg20so117813ejc.4;
        Tue, 26 Jan 2021 15:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f6wYZ5gozgmr79/ArNYUttVMN0pjTGFLRYTG3emhLAY=;
        b=EBWlaA0UUJQMFEhsodslv9Qj1+IzpVXbXvUaExI9gt3oxdlKhM7K3oAXyG6zbbTS6x
         mq1a5eZOzeYVGCAqD7SKSL81JOS3XeX4D2+1nwOnGJm0a9YvZKya7JjITZv5bPROrkph
         zftsCZ9gQCv1rH3bdnKuwoU2jQlQMDW9Jp0imPFaHXxZHNL3TG4tbVugg6QBoa1Hycg4
         1mANcFEfg+cwl1uHbHhQiIHYqoFl1ecSF48XrOyjpxnG6V4fOxXhDr1sO5Unhsy77sKN
         OADLEm/pMD2kfZGYSiWPvu7qM0gyndeldc5QqyoKWARt8fpE12OZkXUoRDx+Gx83UXCn
         dCxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f6wYZ5gozgmr79/ArNYUttVMN0pjTGFLRYTG3emhLAY=;
        b=Tq72UetgqWV00NM+jTq88GDyQ8Eitw+pk5S5B9uGwNXJUNpQr2w08/BxkmTwhy/vzy
         QISRdU9QQyeeNvn1yDJCQt+4WSu0Fs0b/Ihm+sdoRLgk+3MNehNk0AGZ4OIYydbM3y7F
         blLBwIeB2/or2LIWWHlejd8YncX8kmtHpjZBP9G8K7IU+fuBQTBbCGJ08me2d/YeLM0e
         zPylbnzzhn59zLbu/K5XEbJ42q4MpUvU5baAz+3s7fiqrhpxc/kO3YurzIYBG0TlH3gJ
         56Y067ReSXMMTVSweTs3oUVgGkrYvWbgukQALmsfI7Ewk7rGX7Y41h2i/J6S5KWI3Npx
         aPtA==
X-Gm-Message-State: AOAM533HI5/+ZS1wFb1jJ+k2uG//vH/xsn2MCvIoTzKVR7SaOIG+W3Gb
        iPjX/JQIKV2h2Rgj/lccDyDq3PqGBvA=
X-Google-Smtp-Source: ABdhPJymKhqSk7Hx9KHpzj4i70ePJ3ElFCuteOSHtgS10XMEOBcKiszosg9NGNVzKU3q9nxUFGZYUQ==
X-Received: by 2002:a17:906:d295:: with SMTP id ay21mr5004144ejb.400.1611704337847;
        Tue, 26 Jan 2021 15:38:57 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id zg24sm54287ejb.120.2021.01.26.15.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 15:38:57 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 5.11] io_uring: fix wqe->lock/completion_lock deadlock
Date:   Tue, 26 Jan 2021 23:35:10 +0000
Message-Id: <9c4f7eb623ae774f3f17afbc1702749480ee19be.1611703952.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Joseph reports following deadlock:

CPU0:
...
io_kill_linked_timeout  // &ctx->completion_lock
io_commit_cqring
__io_queue_deferred
__io_queue_async_work
io_wq_enqueue
io_wqe_enqueue  // &wqe->lock

CPU1:
...
__io_uring_files_cancel
io_wq_cancel_cb
io_wqe_cancel_pending_work  // &wqe->lock
io_cancel_task_cb  // &ctx->completion_lock

Only __io_queue_deferred() calls queue_async_work() while holding
ctx->completion_lock, enqueue drained requests via io_req_task_queue()
instead.

Cc: stable@vger.kernel.org # 5.9+
Reported-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bb0270eeb8cb..c218deaf73a9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1026,6 +1026,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 			     const struct iovec *fast_iov,
 			     struct iov_iter *iter, bool force);
 static void io_req_drop_files(struct io_kiocb *req);
+static void io_req_task_queue(struct io_kiocb *req);
 
 static struct kmem_cache *req_cachep;
 
@@ -1634,18 +1635,11 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
 	do {
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
 						struct io_defer_entry, list);
-		struct io_kiocb *link;
 
 		if (req_need_defer(de->req, de->seq))
 			break;
 		list_del_init(&de->list);
-		/* punt-init is done before queueing for defer */
-		link = __io_queue_async_work(de->req);
-		if (link) {
-			__io_queue_linked_timeout(link);
-			/* drop submission reference */
-			io_put_req_deferred(link, 1);
-		}
+		io_req_task_queue(de->req);
 		kfree(de);
 	} while (!list_empty(&ctx->defer_list));
 }
-- 
2.24.0

