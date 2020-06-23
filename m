Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7E22064AA
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390185AbgFWVZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389737AbgFWUS7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:18:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4A2E2064B;
        Tue, 23 Jun 2020 20:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943539;
        bh=lplSbLlZgXLCRBcD3d2RMfbfqyWN56EQwqbbvlCAF0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZY14JFjmmOoRjSdtH3Iay5WVSUl6dU0tes5u/rJ8UZJMjmVzqa0INjaSPZm1Q9Ci
         jfsDnYIJXGJDQiZZbBZ/FdO/iiWZEtkeYlOhIp2ZIbyL14T7fUL426T2M7o0QTHD75
         IDjZ/91eYbS4g/jY8sqPwUzGbjM/1xP3GmFQErpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.7 430/477] io_uring: fix io_kiocb.flags modification race in IOPOLL mode
Date:   Tue, 23 Jun 2020 21:57:07 +0200
Message-Id: <20200623195427.855825618@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

[ Upstream commit 65a6543da386838f935d2f03f452c5c0acff2a68 ]

While testing io_uring in arm, we found sometimes io_sq_thread() keeps
polling io requests even though there are not inflight io requests in
block layer. After some investigations, found a possible race about
io_kiocb.flags, see below race codes:
  1) in the end of io_write() or io_read()
    req->flags &= ~REQ_F_NEED_CLEANUP;
    kfree(iovec);
    return ret;

  2) in io_complete_rw_iopoll()
    if (res != -EAGAIN)
        req->flags |= REQ_F_IOPOLL_COMPLETED;

In IOPOLL mode, io requests still maybe completed by interrupt, then
above codes are not safe, concurrent modifications to req->flags, which
is not protected by lock or is not atomic modifications. I also had
disassemble io_complete_rw_iopoll() in arm:
   req->flags |= REQ_F_IOPOLL_COMPLETED;
   0xffff000008387b18 <+76>:    ldr     w0, [x19,#104]
   0xffff000008387b1c <+80>:    orr     w0, w0, #0x1000
   0xffff000008387b20 <+84>:    str     w0, [x19,#104]

Seems that the "req->flags |= REQ_F_IOPOLL_COMPLETED;" is  load and
modification, two instructions, which obviously is not atomic.

To fix this issue, add a new iopoll_completed in io_kiocb to indicate
whether io request is completed.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -513,7 +513,6 @@ enum {
 	REQ_F_INFLIGHT_BIT,
 	REQ_F_CUR_POS_BIT,
 	REQ_F_NOWAIT_BIT,
-	REQ_F_IOPOLL_COMPLETED_BIT,
 	REQ_F_LINK_TIMEOUT_BIT,
 	REQ_F_TIMEOUT_BIT,
 	REQ_F_ISREG_BIT,
@@ -556,8 +555,6 @@ enum {
 	REQ_F_CUR_POS		= BIT(REQ_F_CUR_POS_BIT),
 	/* must not punt to workers */
 	REQ_F_NOWAIT		= BIT(REQ_F_NOWAIT_BIT),
-	/* polled IO has completed */
-	REQ_F_IOPOLL_COMPLETED	= BIT(REQ_F_IOPOLL_COMPLETED_BIT),
 	/* has linked timeout */
 	REQ_F_LINK_TIMEOUT	= BIT(REQ_F_LINK_TIMEOUT_BIT),
 	/* timeout request */
@@ -618,6 +615,8 @@ struct io_kiocb {
 	int				cflags;
 	bool				needs_fixed_file;
 	u8				opcode;
+	/* polled IO has completed */
+	u8				iopoll_completed;
 
 	u16				buf_index;
 
@@ -1760,7 +1759,7 @@ static int io_do_iopoll(struct io_ring_c
 		 * If we find a request that requires polling, break out
 		 * and complete those lists first, if we have entries there.
 		 */
-		if (req->flags & REQ_F_IOPOLL_COMPLETED) {
+		if (READ_ONCE(req->iopoll_completed)) {
 			list_move_tail(&req->list, &done);
 			continue;
 		}
@@ -1941,7 +1940,7 @@ static void io_complete_rw_iopoll(struct
 		req_set_fail_links(req);
 	req->result = res;
 	if (res != -EAGAIN)
-		req->flags |= REQ_F_IOPOLL_COMPLETED;
+		WRITE_ONCE(req->iopoll_completed, 1);
 }
 
 /*
@@ -1974,7 +1973,7 @@ static void io_iopoll_req_issued(struct
 	 * For fast devices, IO may have already completed. If it has, add
 	 * it to the front so we find it first.
 	 */
-	if (req->flags & REQ_F_IOPOLL_COMPLETED)
+	if (READ_ONCE(req->iopoll_completed))
 		list_add(&req->list, &ctx->poll_list);
 	else
 		list_add_tail(&req->list, &ctx->poll_list);
@@ -2098,6 +2097,7 @@ static int io_prep_rw(struct io_kiocb *r
 		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->result = 0;
+		req->iopoll_completed = 0;
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;


