Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5F2111FB1
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfLCWh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:37:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727707AbfLCWh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:37:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C94542073C;
        Tue,  3 Dec 2019 22:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412648;
        bh=zz6hc1y0Nrg95ijcrAaoxy8ZdAJ8NK04RKA1Ad7Z17U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEfrvOLat8pydAhjY45f543XpwjBcunsigAN5EgfqMdAxrxSnnTGWubTLEhgCl43g
         g6mAahtscXPvh8lbKh25pGbtwkq8aylvbQBHiH3bIWeyjgnZwmyB3q6QEWyo5Hp+At
         b5i+nfgXoXIxvLiCDZbRsmSNHczSbxSdcTYkH858=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/46] net: disallow ancillary data for __sys_{send,recv}msg_file()
Date:   Tue,  3 Dec 2019 23:35:23 +0100
Message-Id: <20191203212711.946829051@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203212705.175425505@linuxfoundation.org>
References: <20191203212705.175425505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit d69e07793f891524c6bbf1e75b9ae69db4450953 ]

Only io_uring uses (and added) these, and we want to disallow the
use of sendmsg/recvmsg for anything but regular data transfers.
Use the newly added prep helper to split the msghdr copy out from
the core function, to check for msg_control and msg_controllen
settings. If either is set, we return -EINVAL.

Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/socket.c | 43 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index fbe08d7df7732..d7a106028f0e0 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2357,12 +2357,27 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 /*
  *	BSD sendmsg interface
  */
-long __sys_sendmsg_sock(struct socket *sock, struct user_msghdr __user *msg,
+long __sys_sendmsg_sock(struct socket *sock, struct user_msghdr __user *umsg,
 			unsigned int flags)
 {
-	struct msghdr msg_sys;
+	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
+	struct sockaddr_storage address;
+	struct msghdr msg = { .msg_name = &address };
+	ssize_t err;
+
+	err = sendmsg_copy_msghdr(&msg, umsg, flags, &iov);
+	if (err)
+		return err;
+	/* disallow ancillary data requests from this path */
+	if (msg.msg_control || msg.msg_controllen) {
+		err = -EINVAL;
+		goto out;
+	}
 
-	return ___sys_sendmsg(sock, msg, &msg_sys, flags, NULL, 0);
+	err = ____sys_sendmsg(sock, &msg, flags, NULL, 0);
+out:
+	kfree(iov);
+	return err;
 }
 
 long __sys_sendmsg(int fd, struct user_msghdr __user *msg, unsigned int flags,
@@ -2561,12 +2576,28 @@ static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
  *	BSD recvmsg interface
  */
 
-long __sys_recvmsg_sock(struct socket *sock, struct user_msghdr __user *msg,
+long __sys_recvmsg_sock(struct socket *sock, struct user_msghdr __user *umsg,
 			unsigned int flags)
 {
-	struct msghdr msg_sys;
+	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
+	struct sockaddr_storage address;
+	struct msghdr msg = { .msg_name = &address };
+	struct sockaddr __user *uaddr;
+	ssize_t err;
 
-	return ___sys_recvmsg(sock, msg, &msg_sys, flags, 0);
+	err = recvmsg_copy_msghdr(&msg, umsg, flags, &uaddr, &iov);
+	if (err)
+		return err;
+	/* disallow ancillary data requests from this path */
+	if (msg.msg_control || msg.msg_controllen) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = ____sys_recvmsg(sock, &msg, umsg, uaddr, flags, 0);
+out:
+	kfree(iov);
+	return err;
 }
 
 long __sys_recvmsg(int fd, struct user_msghdr __user *msg, unsigned int flags,
-- 
2.20.1



