Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAFA15775D
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgBJM7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:59:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:42530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729880AbgBJMlF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:05 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA1842085B;
        Mon, 10 Feb 2020 12:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338464;
        bh=L+PzT9YJZaZwtj3+DF+bJ0Zd41C5zLO0reoHroKwm3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uH7UnWdaqpEbT4QTvJTFgg+lw7kzFEyj7kKyYWTAdPD7Qn0llTxcwvHPaXS5/ZvFg
         2hcFhEVmM8ox1SOcFNt18qaR26NtwMVuL1qpXz4Hc+9l4g0Ab/AzQIWQ4/+96t3DC5
         zSowwOeW68lUR7TM8Zyer5GsSAWO6Jsma5H9RPGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.5 224/367] io_uring: spin for sq thread to idle on shutdown
Date:   Mon, 10 Feb 2020 04:32:17 -0800
Message-Id: <20200210122444.705287041@linuxfoundation.org>
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

commit df069d80c8e38c19531c392322e9a16617475c44 upstream.

As part of io_uring shutdown, we cancel work that is pending and won't
necessarily complete on its own. That includes requests like poll
commands and timeouts.

If we're using SQPOLL for kernel side submission and we shutdown the
ring immediately after queueing such work, we can race with the sqthread
doing the submission. This means we may miss cancelling some work, which
results in the io_uring shutdown hanging forever.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3902,7 +3902,8 @@ static int io_sq_thread(void *data)
 			 * reap events and wake us up.
 			 */
 			if (inflight ||
-			    (!time_after(jiffies, timeout) && ret != -EBUSY)) {
+			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
+			    !percpu_ref_is_dying(&ctx->refs))) {
 				cond_resched();
 				continue;
 			}
@@ -4983,6 +4984,16 @@ static void io_ring_ctx_wait_and_kill(st
 	percpu_ref_kill(&ctx->refs);
 	mutex_unlock(&ctx->uring_lock);
 
+	/*
+	 * Wait for sq thread to idle, if we have one. It won't spin on new
+	 * work after we've killed the ctx ref above. This is important to do
+	 * before we cancel existing commands, as the thread could otherwise
+	 * be queueing new work post that. If that's work we need to cancel,
+	 * it could cause shutdown to hang.
+	 */
+	while (ctx->sqo_thread && !wq_has_sleeper(&ctx->sqo_wait))
+		cpu_relax();
+
 	io_kill_timeouts(ctx);
 	io_poll_remove_all(ctx);
 


