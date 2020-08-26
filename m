Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3447252DC7
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 14:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbgHZMGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 08:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729534AbgHZMDf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 08:03:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E200D208E4;
        Wed, 26 Aug 2020 12:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598443413;
        bh=b5EO4+AmusjhpfSUxjeTLp5l8RBm10R97KGtkUSvOuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUpYACMQV1b1SSK7FoIJIDMYeGNqnXgCedExN2NJg8AszvM6sKeHp80dBPjH4JhjF
         55Q9W5iDIN0QjZSjkzVqujz0YdSIPiz9xxnx1/tRrIayt8RkemRvwIOMwmO4xT3i/b
         KmIlQxJkbIRTzMxs4vun4T4heImzg0x3vqLLuLeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Roman Gershman <romange@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.8 15/16] io_uring: fix missing ->mm on exit
Date:   Wed, 26 Aug 2020 14:02:52 +0200
Message-Id: <20200826114911.967258227@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826114911.216745274@linuxfoundation.org>
References: <20200826114911.216745274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

Upstream commits:

8eb06d7e8dd85 ("io_uring: fix missing ->mm on exit")
cbcf72148da4a ("io_uring: return locked and pinned page accounting")

do_exit() first drops current->mm and then runs task_work, from where
io_sq_thread_acquire_mm() would try to set mm for a user dying process.

[  208.004249] WARNING: CPU: 2 PID: 1854 at
	kernel/kthread.c:1238 kthread_use_mm+0x244/0x270
[  208.004287]  kthread_use_mm+0x244/0x270
[  208.004288]  io_sq_thread_acquire_mm.part.0+0x54/0x80
[  208.004290]  io_async_task_func+0x258/0x2ac
[  208.004291]  task_work_run+0xc8/0x210
[  208.004294]  do_exit+0x1b8/0x430
[  208.004295]  do_group_exit+0x44/0xac
[  208.004296]  get_signal+0x164/0x69c
[  208.004298]  do_signal+0x94/0x1d0
[  208.004299]  do_notify_resume+0x18c/0x340
[  208.004300]  work_pending+0x8/0x3d4

Reported-by: Roman Gershman <romange@gmail.com>
Tested-by: Roman Gershman <romange@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4363,7 +4363,8 @@ static int io_sq_thread_acquire_mm(struc
 				   struct io_kiocb *req)
 {
 	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
-		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
+		if (unlikely(!(ctx->flags & IORING_SETUP_SQPOLL) ||
+			     !mmget_not_zero(ctx->sqo_mm)))
 			return -EFAULT;
 		kthread_use_mm(ctx->sqo_mm);
 	}


