Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8FE750E0C3
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 14:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241990AbiDYMyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 08:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240183AbiDYMyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 08:54:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587C229C81
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 05:51:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1F9B6148F
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 12:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA432C385A4;
        Mon, 25 Apr 2022 12:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650891060;
        bh=ucynwnVJOssZwC4Qm5ysCy+PMP981+j40mjY7WzwKG8=;
        h=Subject:To:Cc:From:Date:From;
        b=Qmcoe2t8UjzFt9cqIhAhe05NbT3yr+cyhzKSqnY9k/xZMEmyy5mBjdPgR0yDsdSRB
         WORrZpD4rmXPqsW0Q4J2euVwHc4YFMVsg0g61Ub75u33qM4ZBfQSXPKJvUPyXwYsgi
         Oa8rjYXvbxzXE3NFS/4CLdvD8dco24kaTy7hCwhM=
Subject: FAILED: patch "[PATCH] io_uring: fix leaks on IOPOLL and CQE_SKIP" failed to apply to 5.17-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Apr 2022 14:50:57 +0200
Message-ID: <1650891057139245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c0713540f6d55c53dca65baaead55a5a8b20552d Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Sun, 17 Apr 2022 10:10:34 +0100
Subject: [PATCH] io_uring: fix leaks on IOPOLL and CQE_SKIP

If all completed requests in io_do_iopoll() were marked with
REQ_F_CQE_SKIP, we'll not only skip CQE posting but also
io_free_batch_list() leaking memory and resources.

Move @nr_events increment before REQ_F_CQE_SKIP check. We'll potentially
return the value greater than the real one, but iopolling will deal with
it and the userspace will re-iopoll if needed. In anyway, I don't think
there are many use cases for REQ_F_CQE_SKIP + IOPOLL.

Fixes: 83a13a4181b0e ("io_uring: tweak iopoll CQE_SKIP event counting")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/5072fc8693fbfd595f89e5d4305bfcfd5d2f0a64.1650186611.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 24409dd07239..7625b29153b9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2797,11 +2797,10 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
+		nr_events++;
 		if (unlikely(req->flags & REQ_F_CQE_SKIP))
 			continue;
-
 		__io_fill_cqe_req(req, req->result, io_put_kbuf(req, 0));
-		nr_events++;
 	}
 
 	if (unlikely(!nr_events))

