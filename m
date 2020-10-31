Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE532A16D4
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbgJaLkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727442AbgJaLkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:40:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B43220719;
        Sat, 31 Oct 2020 11:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144436;
        bh=3pEmG3AOSznnPgnSo/shb2yrAfKCHH08OSL14uUoVkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BbnDX//eOrx9eI8OxFV7HaHStzLOnfFvgC/gUp8lE2d+pfN9DAQZe/s/g8y90fv8d
         RVv4AYu21u1IU1YYDcN0GNvF0mJw//c/wpgBKMfzMktHfVwV5v4Kw4/6Kb2XzeJ9bb
         1BmZAcgG3sMsQbVwt9Q7pA16snd+KMVYrixcL0HA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 02/70] io_uring: dont run task work on an exiting task
Date:   Sat, 31 Oct 2020 12:35:34 +0100
Message-Id: <20201031113459.607784722@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 6200b0ae4ea28a4bfd8eb434e33e6201b7a6a282 upstream.

This isn't safe, and isn't needed either. We are guaranteed that any
work we queue is on a live task (and will be run), or it goes to
our backup io-wq threads if the task is exiting.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1762,6 +1762,12 @@ static int io_put_kbuf(struct io_kiocb *
 
 static inline bool io_run_task_work(void)
 {
+	/*
+	 * Not safe to run on exiting task, and the task_work handling will
+	 * not add work to such a task.
+	 */
+	if (unlikely(current->flags & PF_EXITING))
+		return false;
 	if (current->task_works) {
 		__set_current_state(TASK_RUNNING);
 		task_work_run();
@@ -7791,6 +7797,8 @@ static void io_uring_cancel_files(struct
 			io_put_req(cancel_req);
 		}
 
+		/* cancellations _may_ trigger task work */
+		io_run_task_work();
 		schedule();
 		finish_wait(&ctx->inflight_wait, &wait);
 	}


