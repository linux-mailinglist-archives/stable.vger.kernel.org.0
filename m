Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBFB353F43
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239457AbhDEJKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239005AbhDEJJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:09:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CADC61002;
        Mon,  5 Apr 2021 09:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613754;
        bh=Y3S6eeb8eYVNAZ5ChJGQfPD85uV+E1rxwfP7NXbAR4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mgM0M3w7k3Sy0uYyr74mZw6jEwipjF8IT1p0Hy8RrWNyVtnu/IhsTqRdYLef0Pe8w
         TaQoNRwc+14zA8bobJuo9e63xdJi35v6Do+P4aafCZQRX9osQpHZM1SGT7J2Jk4ZSj
         xIoPviCOKjsR3smEq3jtLmwQNCmMfYJt/peTkO5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/126] io_uring: imply MSG_NOSIGNAL for send[msg]()/recv[msg]() calls
Date:   Mon,  5 Apr 2021 10:53:15 +0200
Message-Id: <20210405085032.138005885@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 76cd979f4f38a27df22efb5773a0d567181a9392 ]

We never want to generate any SIGPIPE, -EPIPE only is much better.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
Link: https://lore.kernel.org/r/38961085c3ec49fd21550c7788f214d1ff02d2d4.1615908477.git.metze@samba.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4e53445db73f..fe2dfdab0acd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4421,7 +4421,7 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 		kmsg = &iomsg;
 	}
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
@@ -4465,7 +4465,7 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
@@ -4659,7 +4659,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 				1, req->sr_msg.len);
 	}
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
@@ -4717,7 +4717,7 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 	msg.msg_iocb = NULL;
 	msg.msg_flags = 0;
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
-- 
2.30.1



