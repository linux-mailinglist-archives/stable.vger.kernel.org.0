Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E0E157BB8
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgBJNb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:31:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbgBJMf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:56 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D56520863;
        Mon, 10 Feb 2020 12:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338155;
        bh=4KXAlEUprwiRHITH1OVqudzMd7YQXD6DXCaRbJRCIao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nuLzgBd4JiC9Ua9m1YZH1/T7T3h+BsHKV0P6kCtViI7vgEPtLSTao28MjVkfZyvVY
         p9kaVZpWvM3l4NMzLYLaAZHl2rhOV5K2jagC5VqFjyepwVPR+QI0RzNoX+mPh1nJA2
         CDr7aiTu4GrdgjtXw3BbsORrhmSpjR9bZwF1VxXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 122/195] aio: prevent potential eventfd recursion on poll
Date:   Mon, 10 Feb 2020 04:33:00 -0800
Message-Id: <20200210122317.328504019@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 01d7a356872eec22ef34a33a5f9cfa917d145468 upstream.

If we have nested or circular eventfd wakeups, then we can deadlock if
we run them inline from our poll waitqueue wakeup handler. It's also
possible to have very long chains of notifications, to the extent where
we could risk blowing the stack.

Check the eventfd recursion count before calling eventfd_signal(). If
it's non-zero, then punt the signaling to async context. This is always
safe, as it takes us out-of-line in terms of stack and locking context.

Cc: stable@vger.kernel.org # 4.19+
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1600,6 +1600,14 @@ static int aio_fsync(struct fsync_iocb *
 	return 0;
 }
 
+static void aio_poll_put_work(struct work_struct *work)
+{
+	struct poll_iocb *req = container_of(work, struct poll_iocb, work);
+	struct aio_kiocb *iocb = container_of(req, struct aio_kiocb, poll);
+
+	iocb_put(iocb);
+}
+
 static void aio_poll_complete_work(struct work_struct *work)
 {
 	struct poll_iocb *req = container_of(work, struct poll_iocb, work);
@@ -1664,6 +1672,8 @@ static int aio_poll_wake(struct wait_que
 	list_del_init(&req->wait.entry);
 
 	if (mask && spin_trylock_irqsave(&iocb->ki_ctx->ctx_lock, flags)) {
+		struct kioctx *ctx = iocb->ki_ctx;
+
 		/*
 		 * Try to complete the iocb inline if we can. Use
 		 * irqsave/irqrestore because not all filesystems (e.g. fuse)
@@ -1673,8 +1683,14 @@ static int aio_poll_wake(struct wait_que
 		list_del(&iocb->ki_list);
 		iocb->ki_res.res = mangle_poll(mask);
 		req->done = true;
-		spin_unlock_irqrestore(&iocb->ki_ctx->ctx_lock, flags);
-		iocb_put(iocb);
+		if (iocb->ki_eventfd && eventfd_signal_count()) {
+			iocb = NULL;
+			INIT_WORK(&req->work, aio_poll_put_work);
+			schedule_work(&req->work);
+		}
+		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+		if (iocb)
+			iocb_put(iocb);
 	} else {
 		schedule_work(&req->work);
 	}


