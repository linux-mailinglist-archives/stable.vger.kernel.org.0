Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1712F3D624B
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236409AbhGZPf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237459AbhGZPei (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:34:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 772B960240;
        Mon, 26 Jul 2021 16:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316105;
        bh=6BPvIUoAdC+WTyOiM7S32GO6WYWIOb+eZXyLlb41Vwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vZnUVKzjGCohL+uIHQYyc9xQlMlKRq/70lZ5TM62uWLoahLzRZP7DKLvZ1zvstkuY
         Cu81gEv0lagIJV7gyL1nUjJyuKicpYQUZ7KjEusgMwQv1WsN0K33uXQhtVteNkN9tB
         WvOBn1+8oP2L9g4UcCHuwUPyNT+mnaSQbARMVAew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 144/223] io_uring: Fix race condition when sqp thread goes to sleep
Date:   Mon, 26 Jul 2021 17:38:56 +0200
Message-Id: <20210726153850.944924889@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Langlois <olivier@trillion01.com>

commit 997135017716c33f3405e86cca5da9567b40a08e upstream.

If an asynchronous completion happens before the task is preparing
itself to wait and set its state to TASK_INTERRUPTIBLE, the completion
will not wake up the sqp thread.

Cc: stable@vger.kernel.org
Signed-off-by: Olivier Langlois <olivier@trillion01.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/d1419dc32ec6a97b453bee34dc03fa6a02797142.1624473200.git.olivier@trillion01.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6876,7 +6876,8 @@ static int io_sq_thread(void *data)
 		}
 
 		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
-		if (!test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state)) {
+		if (!test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state) &&
+		    !io_run_task_work()) {
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_set_wakeup_flag(ctx);
 


