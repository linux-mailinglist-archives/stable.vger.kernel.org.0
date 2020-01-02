Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6520512F0F8
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgABWRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:17:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbgABWRS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:17:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CBCF227BF;
        Thu,  2 Jan 2020 22:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003437;
        bh=vGEiSPzPvuEHzZI+F9IqVYZ3YL+4aIjczUHdbVUGx8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsxLaqif0RXDmT0zzCDGZbaLch1dkaPMDkrwAfZpcmpiuAcMznMoRlxhbnVltqDda
         ALIRhQ9d7fM23GEKl5ltZtm6LI9CWESOl56aEaYUbwmfSbdIGmyxJyKd/MLBm3nrdQ
         pYEB9dzQ5/o9g3CqrnA58CG4c8UNJP1a6o+YQjvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+0341f6a4d729d4e0acf1@syzkaller.appspotmail.com>,
        James Morris <jmorris@namei.org>
Subject: [PATCH 5.4 143/191] tomoyo: Dont use nifty names on sockets.
Date:   Thu,  2 Jan 2020 23:07:05 +0100
Message-Id: <20200102215844.863867281@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 6f7c41374b62fd80bbd8aae3536c43688c54d95e upstream.

syzbot is reporting that use of SOCKET_I()->sk from open() can result in
use after free problem [1], for socket's inode is still reachable via
/proc/pid/fd/n despite destruction of SOCKET_I()->sk already completed.

At first I thought that this race condition applies to only open/getattr
permission checks. But James Morris has pointed out that there are more
permission checks where this race condition applies to. Thus, get rid of
tomoyo_get_socket_name() instead of conditionally bypassing permission
checks on sockets. As a side effect of this patch,
"socket:[family=\$:type=\$:protocol=\$]" in the policy files has to be
rewritten to "socket:[\$]".

[1] https://syzkaller.appspot.com/bug?id=73d590010454403d55164cca23bd0565b1eb3b74

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot <syzbot+0341f6a4d729d4e0acf1@syzkaller.appspotmail.com>
Reported-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/tomoyo/realpath.c |   32 +-------------------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

--- a/security/tomoyo/realpath.c
+++ b/security/tomoyo/realpath.c
@@ -218,31 +218,6 @@ out:
 }
 
 /**
- * tomoyo_get_socket_name - Get the name of a socket.
- *
- * @path:   Pointer to "struct path".
- * @buffer: Pointer to buffer to return value in.
- * @buflen: Sizeof @buffer.
- *
- * Returns the buffer.
- */
-static char *tomoyo_get_socket_name(const struct path *path, char * const buffer,
-				    const int buflen)
-{
-	struct inode *inode = d_backing_inode(path->dentry);
-	struct socket *sock = inode ? SOCKET_I(inode) : NULL;
-	struct sock *sk = sock ? sock->sk : NULL;
-
-	if (sk) {
-		snprintf(buffer, buflen, "socket:[family=%u:type=%u:protocol=%u]",
-			 sk->sk_family, sk->sk_type, sk->sk_protocol);
-	} else {
-		snprintf(buffer, buflen, "socket:[unknown]");
-	}
-	return buffer;
-}
-
-/**
  * tomoyo_realpath_from_path - Returns realpath(3) of the given pathname but ignores chroot'ed root.
  *
  * @path: Pointer to "struct path".
@@ -279,12 +254,7 @@ char *tomoyo_realpath_from_path(const st
 			break;
 		/* To make sure that pos is '\0' terminated. */
 		buf[buf_len - 1] = '\0';
-		/* Get better name for socket. */
-		if (sb->s_magic == SOCKFS_MAGIC) {
-			pos = tomoyo_get_socket_name(path, buf, buf_len - 1);
-			goto encode;
-		}
-		/* For "pipe:[\$]". */
+		/* For "pipe:[\$]" and "socket:[\$]". */
 		if (dentry->d_op && dentry->d_op->d_dname) {
 			pos = dentry->d_op->d_dname(dentry, buf, buf_len - 1);
 			goto encode;


