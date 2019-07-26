Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA3B76DBF
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388329AbfGZPbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:31:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389239AbfGZPbO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:31:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA2B322BF5;
        Fri, 26 Jul 2019 15:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155073;
        bh=bkKa09Bt3oXV8Y6UPtyVRlX3kevz220qWhxojHD+jwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3sOkzUAhhkdso1/Os02fsmHzCTZcrqCCT0dufEoTXkLDcau1rkzblsuGuTIUvA+w
         XdlnZWHuxHgANkmXUP6XYUxsFoU3Ica+nkP2mXIYyhGblfWTRgg5xY9apnNTyakI2H
         YYPreE+hCsmTgv799z4PMjn6XzImc7p5SjTdmKkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+079bf326b38072f849d9@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 21/62] sctp: not bind the socket in sctp_connect
Date:   Fri, 26 Jul 2019 17:24:33 +0200
Message-Id: <20190726152303.922789380@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
References: <20190726152301.720139286@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 9b6c08878e23adb7cc84bdca94d8a944b03f099e ]

Now when sctp_connect() is called with a wrong sa_family, it binds
to a port but doesn't set bp->port, then sctp_get_af_specific will
return NULL and sctp_connect() returns -EINVAL.

Then if sctp_bind() is called to bind to another port, the last
port it has bound will leak due to bp->port is NULL by then.

sctp_connect() doesn't need to bind ports, as later __sctp_connect
will do it if bp->port is NULL. So remove it from sctp_connect().
While at it, remove the unnecessary sockaddr.sa_family len check
as it's already done in sctp_inet_connect.

Fixes: 644fbdeacf1d ("sctp: fix the issue that flags are ignored when using kernel_connect")
Reported-by: syzbot+079bf326b38072f849d9@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |   24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4828,35 +4828,17 @@ out_nounlock:
 static int sctp_connect(struct sock *sk, struct sockaddr *addr,
 			int addr_len, int flags)
 {
-	struct inet_sock *inet = inet_sk(sk);
 	struct sctp_af *af;
-	int err = 0;
+	int err = -EINVAL;
 
 	lock_sock(sk);
-
 	pr_debug("%s: sk:%p, sockaddr:%p, addr_len:%d\n", __func__, sk,
 		 addr, addr_len);
 
-	/* We may need to bind the socket. */
-	if (!inet->inet_num) {
-		if (sk->sk_prot->get_port(sk, 0)) {
-			release_sock(sk);
-			return -EAGAIN;
-		}
-		inet->inet_sport = htons(inet->inet_num);
-	}
-
 	/* Validate addr_len before calling common connect/connectx routine. */
-	af = addr_len < offsetofend(struct sockaddr, sa_family) ? NULL :
-		sctp_get_af_specific(addr->sa_family);
-	if (!af || addr_len < af->sockaddr_len) {
-		err = -EINVAL;
-	} else {
-		/* Pass correct addr len to common routine (so it knows there
-		 * is only one address being passed.
-		 */
+	af = sctp_get_af_specific(addr->sa_family);
+	if (af && addr_len >= af->sockaddr_len)
 		err = __sctp_connect(sk, addr, af->sockaddr_len, flags, NULL);
-	}
 
 	release_sock(sk);
 	return err;


