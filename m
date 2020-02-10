Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3991157574
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbgBJMlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:42580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729885AbgBJMlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:06 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAF0320661;
        Mon, 10 Feb 2020 12:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338465;
        bh=u5iY+zUkAwoQvPV4FOjhEXet1A340J2ouQeqEjKVdEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOqjpd2DnEWWwEInlM5wXRhqSHyRkB4uEZHZG9itztrMXL9uiumDDdrALGpolCCbp
         gfZwt71NEHOL9lhM41MepjwsXKjzn1bOF1HvjeBVtNBj9ZZnviFuF8tywreIqXEQ3p
         klz5XU4UL0rqpry5GMbHS9EYnz4XHS/vi//zmVq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.5 226/367] aio: prevent potential eventfd recursion on poll
Date:   Mon, 10 Feb 2020 04:32:19 -0800
Message-Id: <20200210122445.299858467@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
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
@@ -1610,6 +1610,14 @@ static int aio_fsync(struct fsync_iocb *
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
@@ -1674,6 +1682,8 @@ static int aio_poll_wake(struct wait_que
 	list_del_init(&req->wait.entry);
 
 	if (mask && spin_trylock_irqsave(&iocb->ki_ctx->ctx_lock, flags)) {
+		struct kioctx *ctx = iocb->ki_ctx;
+
 		/*
 		 * Try to complete the iocb inline if we can. Use
 		 * irqsave/irqrestore because not all filesystems (e.g. fuse)
@@ -1683,8 +1693,14 @@ static int aio_poll_wake(struct wait_que
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


