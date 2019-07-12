Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF06866E1E
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbfGLMcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729432AbfGLMcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:32:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8133C216FD;
        Fri, 12 Jul 2019 12:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934727;
        bh=ETWyk8gxgCMJRP97idqhRkoOc9kGssNuCg0Y1fLZSAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ebAru49LHM0TI8wWtKWpYXZG0bIlKpdiKe7brzXQjXxl6863hsU0ACgroBw5fQW8q
         aPK1dW+HazAUX2iqjjKrl/Khk0Edl8w+wtPZZxQKPgeGnn3Nt3hNu7XtXwxvNqIW3b
         BduHsM5WmfFx5jVoq4Ynhx34AP6MCPNFFSUbfa2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Valente <paolo.valente@unimore.it>,
        Douglas Anderson <dianders@chromium.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.2 12/61] block, bfq: NULL out the bic when its no longer valid
Date:   Fri, 12 Jul 2019 14:19:25 +0200
Message-Id: <20190712121621.281677748@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit dbc3117d4ca9e17819ac73501e914b8422686750 upstream.

In reboot tests on several devices we were seeing a "use after free"
when slub_debug or KASAN was enabled.  The kernel complained about:

  Unable to handle kernel paging request at virtual address 6b6b6c2b

...which is a classic sign of use after free under slub_debug.  The
stack crawl in kgdb looked like:

 0  test_bit (addr=<optimized out>, nr=<optimized out>)
 1  bfq_bfqq_busy (bfqq=<optimized out>)
 2  bfq_select_queue (bfqd=<optimized out>)
 3  __bfq_dispatch_request (hctx=<optimized out>)
 4  bfq_dispatch_request (hctx=<optimized out>)
 5  0xc056ef00 in blk_mq_do_dispatch_sched (hctx=0xed249440)
 6  0xc056f728 in blk_mq_sched_dispatch_requests (hctx=0xed249440)
 7  0xc0568d24 in __blk_mq_run_hw_queue (hctx=0xed249440)
 8  0xc0568d94 in blk_mq_run_work_fn (work=<optimized out>)
 9  0xc024c5c4 in process_one_work (worker=0xec6d4640, work=0xed249480)
 10 0xc024cff4 in worker_thread (__worker=0xec6d4640)

Digging in kgdb, it could be found that, though bfqq looked fine,
bfqq->bic had been freed.

Through further digging, I postulated that perhaps it is illegal to
access a "bic" (AKA an "icq") after bfq_exit_icq() had been called
because the "bic" can be freed at some point in time after this call
is made.  I confirmed that there certainly were cases where the exact
crashing code path would access the "bic" after bfq_exit_icq() had
been called.  Sspecifically I set the "bfqq->bic" to (void *)0x7 and
saw that the bic was 0x7 at the time of the crash.

To understand a bit more about why this crash was fairly uncommon (I
saw it only once in a few hundred reboots), you can see that much of
the time bfq_exit_icq_fbqq() fully frees the bfqq and thus it can't
access the ->bic anymore.  The only case it doesn't is if
bfq_put_queue() sees a reference still held.

However, even in the case when bfqq isn't freed, the crash is still
rare.  Why?  I tracked what happened to the "bic" after the exit
routine.  It doesn't get freed right away.  Rather,
put_io_context_active() eventually called put_io_context() which
queued up freeing on a workqueue.  The freeing then actually happened
later than that through call_rcu().  Despite all these delays, some
extra debugging showed that all the hoops could be jumped through in
time and the memory could be freed causing the original crash.  Phew!

To make a long story short, assuming it truly is illegal to access an
icq after the "exit_icq" callback is finished, this patch is needed.

Cc: stable@vger.kernel.org
Reviewed-by: Paolo Valente <paolo.valente@unimore.it>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/bfq-iosched.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4584,6 +4584,7 @@ static void bfq_exit_icq_bfqq(struct bfq
 		unsigned long flags;
 
 		spin_lock_irqsave(&bfqd->lock, flags);
+		bfqq->bic = NULL;
 		bfq_exit_bfqq(bfqd, bfqq);
 		bic_set_bfqq(bic, NULL, is_sync);
 		spin_unlock_irqrestore(&bfqd->lock, flags);


