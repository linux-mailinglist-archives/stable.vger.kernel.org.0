Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C814249FE
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 00:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbhJFWpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 18:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbhJFWpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 18:45:16 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE2FC061755
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 15:43:23 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id z19-20020a631913000000b00252ede336caso2331708pgl.4
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 15:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=z8o3vrToRPXWpRi6lUNzwoCXQctar2zORy+Anm1eJ7s=;
        b=koUNHiD2fX5IdRRbeJRVnwxhK+fiF8SCJcIrdhTPcmwTE/+lX/sElhXCQtgWL+I4PW
         Um3VSGs9mp8qE1/uddpgjmdEHAsxh8tuQDPxidy7bcvmiqZu9ga/Zkxk8yAmRKRSof0H
         zAQ05iP0/y6Iz4Xo0OAvdDxHvzIBq3mWu9qclnffgIzxqfBsRg/sMOXEXN31rQobQsA6
         EdslA1Z1aWFV+rN1suUq6p8xCzAEk8a73SITies9JZ64i/GzOWzJ5hnIrNGSA8HIcRKO
         3SZAS8RxpqRhFSdmVgRMQv4LV3wpoPhkV/FQ+sKb8urrXB73DY5Hj0/B+3FuM6+TyrPF
         46gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=z8o3vrToRPXWpRi6lUNzwoCXQctar2zORy+Anm1eJ7s=;
        b=dQzJ8WJw44hkjd74NZSn7J8KpQqYn1i9tXq6bDrOg8BtNnJHVtZFyp766gikz0kT56
         1VGe30D5qHWhE4wOtEgwCYnf/dI7ohHDn1BRv5e0MBmOppz2Qntkim1H9k3Y3Y1gkix0
         9vgHzgPNksAx2nXKqeB7YktalzSSg8rdgF11QWwy9WGzvQqFeUioKg94WeBdNwZAj2i8
         XoCmwBVgkD1cXK0olCLZGMkgXJgx6ARha8yOpioAa7JR/mDIjTKTfhKyZnR/pOPV/6Zl
         K+z6l1T42yH4mpBhcYpxfWEvIQxjV0KTkbfu0UBmnZztbWEuZLoewZ2SZ2TLDXQnNLwU
         Z6WQ==
X-Gm-Message-State: AOAM533+ieHvnYJFCr2wGgO88+ZNZYX5Sqx93DUUptHsM2HFylTbCOh2
        nUKo/Qxq8cF2/nHX1sz3mTbqEx54sNrZ6Mc=
X-Google-Smtp-Source: ABdhPJwVGe+1bLx183esn1tSE35Cx+805z+jCcD8uYscQXuimnkjC9yrHjkUqUylSF401n9nQD39HTr/JGUaAqU=
X-Received: from ramjiyani.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2edd])
 (user=ramjiyani job=sendgmr) by 2002:a17:902:b18b:b0:13a:354a:3e9d with SMTP
 id s11-20020a170902b18b00b0013a354a3e9dmr651747plr.36.1633560202905; Wed, 06
 Oct 2021 15:43:22 -0700 (PDT)
Date:   Wed,  6 Oct 2021 22:43:11 +0000
Message-Id: <20211006224311.26662-1-ramjiyani@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v3] aio: Add support for the POLLFREE
From:   Ramji Jiyani <ramjiyani@google.com>
To:     arnd@arndb.de, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     hch@lst.de, kernel-team@android.com, linux-aio@kvack.org,
        linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, oleg@redhat.com, ebiggers@kernel.org,
        Ramji Jiyani <ramjiyani@google.com>,
        Jeff Moyer <jmoyer@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit f5cb779ba163 ("ANDROID: binder: remove waitqueue when thread
exits.") fixed the use-after-free in eventpoll but aio still has the
same issue because it doesn't honor the POLLFREE flag.

Add support for the POLLFREE flag to force complete iocb inline in
aio_poll_wake(). A thread may use it to signal it's exit and/or request
to cleanup while pending poll request. In this case, aio_poll_wake()
needs to make sure it doesn't keep any reference to the queue entry
before returning from wake to avoid possible use after free via
poll_cancel() path.

The POLLFREE flag is no more exclusive to the epoll and is being
shared with the aio. Remove comment from poll.h to avoid confusion.

This fixes a use after free issue between binder thread and aio
interactions in certain sequence of events [1].

[1] https://lore.kernel.org/all/CAKUd0B_TCXRY4h1hTztfwWbNSFQqsudDLn2S_28csgWZmZAG3Q@mail.gmail.com/

Fixes: f5cb779ba163 ("ANDROID: binder: remove waitqueue when thread exits.")
Signed-off-by: Ramji Jiyani <ramjiyani@google.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Cc: stable@vger.kernel.org # 4.19+
---
Changes since v1:
- Removed parenthesis around POLLFREE macro definition as per review.
- Updated description to refer UAF issue discussion this patch fixes.
- Updated description to remove reference to parenthesis change.
- Added Reviewed-by

Changes since v2:
- Added Fixes tag.
- Added stable tag for backporting on 4.19+ LTS releases
---
 fs/aio.c                        | 45 ++++++++++++++++++---------------
 include/uapi/asm-generic/poll.h |  2 +-
 2 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 51b08ab01dff..5d539c05df42 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1674,6 +1674,7 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 {
 	struct poll_iocb *req = container_of(wait, struct poll_iocb, wait);
 	struct aio_kiocb *iocb = container_of(req, struct aio_kiocb, poll);
+	struct kioctx *ctx = iocb->ki_ctx;
 	__poll_t mask = key_to_poll(key);
 	unsigned long flags;
 
@@ -1683,29 +1684,33 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 
 	list_del_init(&req->wait.entry);
 
-	if (mask && spin_trylock_irqsave(&iocb->ki_ctx->ctx_lock, flags)) {
-		struct kioctx *ctx = iocb->ki_ctx;
+	/*
+	 * Use irqsave/irqrestore because not all filesystems (e.g. fuse)
+	 * call this function with IRQs disabled and because IRQs have to
+	 * be disabled before ctx_lock is obtained.
+	 */
+	if (mask & POLLFREE) {
+		/* Force complete iocb inline to remove refs to deleted entry */
+		spin_lock_irqsave(&ctx->ctx_lock, flags);
+	} else if (!(mask && spin_trylock_irqsave(&ctx->ctx_lock, flags))) {
+		/* Can't complete iocb inline; schedule for later */
+		schedule_work(&req->work);
+		return 1;
+	}
 
-		/*
-		 * Try to complete the iocb inline if we can. Use
-		 * irqsave/irqrestore because not all filesystems (e.g. fuse)
-		 * call this function with IRQs disabled and because IRQs
-		 * have to be disabled before ctx_lock is obtained.
-		 */
-		list_del(&iocb->ki_list);
-		iocb->ki_res.res = mangle_poll(mask);
-		req->done = true;
-		if (iocb->ki_eventfd && eventfd_signal_allowed()) {
-			iocb = NULL;
-			INIT_WORK(&req->work, aio_poll_put_work);
-			schedule_work(&req->work);
-		}
-		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
-		if (iocb)
-			iocb_put(iocb);
-	} else {
+	/* complete iocb inline */
+	list_del(&iocb->ki_list);
+	iocb->ki_res.res = mangle_poll(mask);
+	req->done = true;
+	if (iocb->ki_eventfd && eventfd_signal_allowed()) {
+		iocb = NULL;
+		INIT_WORK(&req->work, aio_poll_put_work);
 		schedule_work(&req->work);
 	}
+	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+	if (iocb)
+		iocb_put(iocb);
+
 	return 1;
 }
 
diff --git a/include/uapi/asm-generic/poll.h b/include/uapi/asm-generic/poll.h
index 41b509f410bf..f9c520ce4bf4 100644
--- a/include/uapi/asm-generic/poll.h
+++ b/include/uapi/asm-generic/poll.h
@@ -29,7 +29,7 @@
 #define POLLRDHUP       0x2000
 #endif
 
-#define POLLFREE	(__force __poll_t)0x4000	/* currently only for epoll */
+#define POLLFREE	(__force __poll_t)0x4000
 
 #define POLL_BUSY_LOOP	(__force __poll_t)0x8000
 
-- 
2.33.0.800.g4c38ced690-goog

