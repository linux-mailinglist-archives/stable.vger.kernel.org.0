Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94272354013
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239390AbhDEJPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:15:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239929AbhDEJO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:14:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D83AB60FE4;
        Mon,  5 Apr 2021 09:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614061;
        bh=ssoKzKFC+66OBKC5z+OK6y19dVXJjX1i3Snn7lGXxfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SnFxbhuUc/TPyL6uxEX1RQ6907lpdLqzfZcp8bO2TzFDtuotKD9MR80m9W5p6IIKf
         HvPNbtYvkQWD/4gqZ2UVk6T2kBvqGHGqze4MsUaY2KDIuqIA1OYRG5mZTawZec4CGL
         mUI+rbO84IIfb2B83Xd6xh4Cp/GnKDxcPI8UObCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 034/152] io_uring: imply MSG_NOSIGNAL for send[msg]()/recv[msg]() calls
Date:   Mon,  5 Apr 2021 10:53:03 +0200
Message-Id: <20210405085035.360327580@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
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
index aaf9b5d49c17..26b4af9831da 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4648,7 +4648,7 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 		kmsg = &iomsg;
 	}
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
@@ -4692,7 +4692,7 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
@@ -4886,7 +4886,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 				1, req->sr_msg.len);
 	}
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
@@ -4944,7 +4944,7 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 	msg.msg_iocb = NULL;
 	msg.msg_flags = 0;
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
-- 
2.30.1



