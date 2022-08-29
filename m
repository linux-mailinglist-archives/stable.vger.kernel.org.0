Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444055A4E3B
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 15:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiH2Nej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 09:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiH2Neh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 09:34:37 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6E587099
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:36 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id i188-20020a1c3bc5000000b003a7b6ae4eb2so3216696wma.4
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=y0KqtAyxw62tK5rbVbBSUvQMua6N4CVId2RIgTQHIKs=;
        b=oeImzI2bxz7efcwsKJ2NubFOOIyT5eHIWVqvoraUvGckuFa+QWkJxItfjLAWVULeMu
         o9XeGx6odvJy1YtfRFg2JKrh1OjemoESB8arWtN7AZm19sHKnMfXEDApCDg//Mrueheq
         jCC3g7cJyMmQx224xepTzGhaZqe4+74UI/UlAXsRqpscVNqlz8VcE6yloiXckH6jsoFq
         liOE3PLiE11412ygSwyCw+rfCFnQLT1K/bOTF0+KglSmZ2xgZDzpzQCzRWKtQdOaTEgj
         XouqO1kI5eo/n3VjA9gEQHIQwQFGfkbZPAh5VGJXQqy3HOQ00eHtkaRswTpZ45xpNz3r
         SQXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=y0KqtAyxw62tK5rbVbBSUvQMua6N4CVId2RIgTQHIKs=;
        b=uVZaFTXC0k8H0peAnny11a4b8+dVwjLZteJVtnWoVZbIGvYnoEqX0i0xGKgT8WiO50
         hRrtZp/FzgyIxDa99eA36wdDBZiz8yno/DtA1S/UViAaP7bKcVjddPMqA5+WTN8yuMjn
         iS7q+pf+xGkKCLUY0ImBtRCXgeU2m0ZS2k3GbJA4egtTlCqp0Pg8MMei67iEkyKv+bjv
         4557iTPAv6ejztgWkjBe7t6HbQkStYf+Xl/r+znOEh1OfffDwVUTDQUlWvF1ni/KKhdS
         +QiN7bN6ToRSI8TQl4Wt3zmnBjQ9eov/ptQfle0xymLKoZZK5B0JPXNDDbEQNO4Hw9th
         Ou9w==
X-Gm-Message-State: ACgBeo3G0zpqD1MKXCScelb+IgYe+OBTcxVcqNW6m3XqGLfA3Tcpf/Jo
        vx7+NvSOVWP7O14Yh6eUfBCESBtbHJo=
X-Google-Smtp-Source: AA6agR52twUDYlbmW6ZPd23WvRbKZzfiubsw/Nbvn0y7pXsiKSGkgIYzclVoLKH78FKNFoHa7q6HuA==
X-Received: by 2002:a05:600c:4fcd:b0:3a6:2694:e3ba with SMTP id o13-20020a05600c4fcd00b003a62694e3bamr7145312wmq.160.1661780074399;
        Mon, 29 Aug 2022 06:34:34 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id bn6-20020a056000060600b00222ed7ea203sm4897361wrb.100.2022.08.29.06.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 06:34:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Eric Biggers <ebiggers@google.com>,
        syzbot+5426c7ed6868c705ca14@syzkaller.appspotmail.com
Subject: [PATCH stable-5.15 13/13] io_uring: fix UAF due to missing POLLFREE handling
Date:   Mon, 29 Aug 2022 14:30:24 +0100
Message-Id: <23cf800d9e5e1ec5d7d3776cf57b4db87e5758dc.1661594698.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1661594698.git.asml.silence@gmail.com>
References: <cover.1661594698.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ upstream commmit 791f3465c4afde02d7f16cf7424ca87070b69396 ]

Fixes a problem described in 50252e4b5e989
("aio: fix use-after-free due to missing POLLFREE handling")
and copies the approach used there.

In short, we have to forcibly eject a poll entry when we meet POLLFREE.
We can't rely on io_poll_get_ownership() as can't wait for potentially
running tw handlers, so we use the fact that wqs are RCU freed. See
Eric's patch and comments for more details.

Reported-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20211209010455.42744-6-ebiggers@kernel.org
Reported-and-tested-by: syzbot+5426c7ed6868c705ca14@syzkaller.appspotmail.com
Fixes: 221c5eb233823 ("io_uring: add support for IORING_OP_POLL")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/4ed56b6f548f7ea337603a82315750449412748a.1642161259.git.asml.silence@gmail.com
[axboe: drop non-functional change from patch]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 58 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6bcc3798591e..e586b0e6d725 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5363,12 +5363,14 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
 
 static inline void io_poll_remove_entry(struct io_poll_iocb *poll)
 {
-	struct wait_queue_head *head = poll->head;
+	struct wait_queue_head *head = smp_load_acquire(&poll->head);
 
-	spin_lock_irq(&head->lock);
-	list_del_init(&poll->wait.entry);
-	poll->head = NULL;
-	spin_unlock_irq(&head->lock);
+	if (head) {
+		spin_lock_irq(&head->lock);
+		list_del_init(&poll->wait.entry);
+		poll->head = NULL;
+		spin_unlock_irq(&head->lock);
+	}
 }
 
 static void io_poll_remove_entries(struct io_kiocb *req)
@@ -5376,10 +5378,26 @@ static void io_poll_remove_entries(struct io_kiocb *req)
 	struct io_poll_iocb *poll = io_poll_get_single(req);
 	struct io_poll_iocb *poll_double = io_poll_get_double(req);
 
-	if (poll->head)
-		io_poll_remove_entry(poll);
-	if (poll_double && poll_double->head)
+	/*
+	 * While we hold the waitqueue lock and the waitqueue is nonempty,
+	 * wake_up_pollfree() will wait for us.  However, taking the waitqueue
+	 * lock in the first place can race with the waitqueue being freed.
+	 *
+	 * We solve this as eventpoll does: by taking advantage of the fact that
+	 * all users of wake_up_pollfree() will RCU-delay the actual free.  If
+	 * we enter rcu_read_lock() and see that the pointer to the queue is
+	 * non-NULL, we can then lock it without the memory being freed out from
+	 * under us.
+	 *
+	 * Keep holding rcu_read_lock() as long as we hold the queue lock, in
+	 * case the caller deletes the entry from the queue, leaving it empty.
+	 * In that case, only RCU prevents the queue memory from being freed.
+	 */
+	rcu_read_lock();
+	io_poll_remove_entry(poll);
+	if (poll_double)
 		io_poll_remove_entry(poll_double);
+	rcu_read_unlock();
 }
 
 /*
@@ -5517,6 +5535,30 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 						 wait);
 	__poll_t mask = key_to_poll(key);
 
+	if (unlikely(mask & POLLFREE)) {
+		io_poll_mark_cancelled(req);
+		/* we have to kick tw in case it's not already */
+		io_poll_execute(req, 0);
+
+		/*
+		 * If the waitqueue is being freed early but someone is already
+		 * holds ownership over it, we have to tear down the request as
+		 * best we can. That means immediately removing the request from
+		 * its waitqueue and preventing all further accesses to the
+		 * waitqueue via the request.
+		 */
+		list_del_init(&poll->wait.entry);
+
+		/*
+		 * Careful: this *must* be the last step, since as soon
+		 * as req->head is NULL'ed out, the request can be
+		 * completed and freed, since aio_poll_complete_work()
+		 * will no longer need to take the waitqueue lock.
+		 */
+		smp_store_release(&poll->head, NULL);
+		return 1;
+	}
+
 	/* for instances that support it check for an event match first */
 	if (mask && !(mask & poll->events))
 		return 0;
-- 
2.37.2

