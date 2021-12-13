Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FE84729B3
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239595AbhLMKX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242369AbhLMKUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:20:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D76EC01388A;
        Mon, 13 Dec 2021 01:58:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 898B2CE0F18;
        Mon, 13 Dec 2021 09:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D713C34600;
        Mon, 13 Dec 2021 09:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389492;
        bh=sUR4msxEilbYVGvj7VU1vHBce5fYvcrIhLnRbNE5VZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bv08L7crYyXOmweVn2/3Q7yruLIxAdtwzkvZ1LkKEdYrUYuZdc9Axe6PGE+ZQ9DGH
         l6KLTKGjPBpjeRZ25APmdMlrRzAaSTekxGGpEz8wKnWpVtnqUu5C1cuWw8QFJgQWNA
         5mXlxaU2H9wSRYolFQEWpwxOC7dkKCqmJda9EY2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        syzbot+21e6887c0be14181206d@syzkaller.appspotmail.com
Subject: [PATCH 5.15 094/171] io_uring: ensure task_work gets run as part of cancelations
Date:   Mon, 13 Dec 2021 10:30:09 +0100
Message-Id: <20211213092948.209020876@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 78a780602075d8b00c98070fa26e389b3b3efa72 upstream.

If we successfully cancel a work item but that work item needs to be
processed through task_work, then we can be sleeping uninterruptibly
in io_uring_cancel_generic() and never process it. Hence we don't
make forward progress and we end up with an uninterruptible sleep
warning.

While in there, correct a comment that should be IFF, not IIF.

Reported-and-tested-by: syzbot+21e6887c0be14181206d@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9775,7 +9775,7 @@ static void io_uring_drop_tctx_refs(stru
 
 /*
  * Find any io_uring ctx that this task has registered or done IO on, and cancel
- * requests. @sqd should be not-null IIF it's an SQPOLL thread cancellation.
+ * requests. @sqd should be not-null IFF it's an SQPOLL thread cancellation.
  */
 static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 {
@@ -9816,8 +9816,10 @@ static void io_uring_cancel_generic(bool
 							     cancel_all);
 		}
 
-		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
+		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
+		io_run_task_work();
 		io_uring_drop_tctx_refs(current);
+
 		/*
 		 * If we've seen completions, retry without waiting. This
 		 * avoids a race where a completion comes in before we did


