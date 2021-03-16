Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B78C33D7AA
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 16:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238095AbhCPPe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 11:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238197AbhCPPeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 11:34:12 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16EBFC061756;
        Tue, 16 Mar 2021 08:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=W1/Pd1fvF7xVVbyikJTI1oYMQfnsxA1s6oxtgxnl93c=; b=DRKaJ5dRE2FUA56+oec4MKmW3d
        AqGU6kn2AdGMcjjs6qtTj7N1JrCOoPMfAaor0BYi6EYW0xLcyxmpO3QfEXBcCJ27gEEPout2C4Z7D
        vq68Sv1tQfj6okIDTVlZUeQLdA7h0SQnsYBlE7S4WQ9Ki1ulp4DZRWxDB+XX4mob/JyDjw5uzlkx4
        8JLtyeG74IzwBYAS9M17lIMh37XUkubKKnyGZy40N9pPMEDZfe2l0FJIP6X5u2Rf8OT/LX8t0Rb0B
        jQbJ+l13dpCxwDxk0Dvwo4bRr/cQnrEx8ZKXDlRMCMCihIoeuNwHzGz6GyUoxBjYrzzpARPEcfXSZ
        9snZaZN8Dh2GWADRBodBb34hJNC/+Hxqw8nt+/mf3M3lErTJwuuc0qD/+32O+CJCtmwHhhYO+Hfnr
        IPv6OcSmhvnPIExcs+aPb4ACSEG2GKJpbEW8cp6j5jloiMSE+wMvgB0/xOHc3LyMLUrvnRsy4L5zn
        fM3yKSpOiWy7jVJ47LZDuSAd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lMBho-0000k2-MA; Tue, 16 Mar 2021 15:34:00 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>, stable@vger.kernel.org
Subject: [PATCH 2/2] io_uring: imply MSG_NOSIGNAL for send[msg]()/recv[msg]() calls
Date:   Tue, 16 Mar 2021 16:33:27 +0100
Message-Id: <38961085c3ec49fd21550c7788f214d1ff02d2d4.1615908477.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1615908477.git.metze@samba.org>
References: <cover.1615908477.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We never want to generate any SIGPIPE, -EPIPE only is much better.

cc: stable@vger.kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f8a6a629e4db..54105c5cf9e8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4369,7 +4369,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		kmsg = &iomsg;
 	}
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (issue_flags & IO_URING_F_NONBLOCK)
@@ -4416,7 +4416,7 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (issue_flags & IO_URING_F_NONBLOCK)
@@ -4607,7 +4607,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 				1, req->sr_msg.len);
 	}
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
@@ -4669,7 +4669,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_iocb = NULL;
 	msg.msg_flags = 0;
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
-- 
2.25.1

