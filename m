Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4AB40886D
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 11:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238764AbhIMJj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 05:39:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238771AbhIMJjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 05:39:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFD3C6101A;
        Mon, 13 Sep 2021 09:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631525918;
        bh=OJxoqk/q+j4zzKPbeanM+i2/WL1TaPyaKi9QtSxiuoA=;
        h=Subject:To:Cc:From:Date:From;
        b=eHv4RJgFlSlKBwSc9s1fdyLIj0d1/O9AGmvKs7OgZ3PugWuBmm2gADq7TJmWcbH/N
         NmFnvSdt15Kr9cJBRCwB77wqO+4/2Ci7bRWaJe341UrT9Zj5EbSVyjPQhsWoDjFCYi
         YeAPKfQSa4n0csaSXd7PPhXbaDMO39vX04yx4BCU=
Subject: FAILED: patch "[PATCH] io_uring: fail links of cancelled timeouts" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Sep 2021 11:38:36 +0200
Message-ID: <1631525916166157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2ae2eb9dde18979b40629dd413b9adbd6c894cdf Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Thu, 9 Sep 2021 13:56:27 +0100
Subject: [PATCH] io_uring: fail links of cancelled timeouts

When we cancel a timeout we should mark it with REQ_F_FAIL, so
linked requests are cancelled as well, but not queued for further
execution.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/fff625b44eeced3a5cae79f60e6acf3fbdf8f990.1631192135.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b21a423a4de8..ffd91844b2e5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1482,6 +1482,8 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 	struct io_timeout_data *io = req->async_data;
 
 	if (hrtimer_try_to_cancel(&io->timer) != -1) {
+		if (status)
+			req_set_fail(req);
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);

