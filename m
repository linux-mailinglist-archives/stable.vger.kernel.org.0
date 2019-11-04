Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02642EEF99
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388360AbfKDV4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:56:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:51954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388349AbfKDV4W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:56:22 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1363421D7D;
        Mon,  4 Nov 2019 21:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904581;
        bh=arJ2BRB1IpfGYQd0+0FKKEMEfGuTLFKQTpwb9QW2mZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v4EMo4LAbF34jT0AU1Obbdo9QLR1zq6PxZGY/qxfpQmgO95Dz7FVQruiSIR31vkd0
         vt0JLZIBLNLNr8zAp775jb4flFHCzYG8bGUXAdZHxvBFFgwdYQecCnIlrFWFGIjQB0
         dggk2T+f0dzgvnnQspguHYtj19Q6yhpKqwCEnZqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+079bf326b38072f849d9@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 92/95] sctp: not bind the socket in sctp_connect
Date:   Mon,  4 Nov 2019 22:45:30 +0100
Message-Id: <20191104212124.460000853@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 9b6c08878e23adb7cc84bdca94d8a944b03f099e upstream.

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
 net/sctp/socket.c |   21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4168,34 +4168,17 @@ out_nounlock:
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
 	af = sctp_get_af_specific(addr->sa_family);
-	if (!af || addr_len < af->sockaddr_len) {
-		err = -EINVAL;
-	} else {
-		/* Pass correct addr len to common routine (so it knows there
-		 * is only one address being passed.
-		 */
+	if (af && addr_len >= af->sockaddr_len)
 		err = __sctp_connect(sk, addr, af->sockaddr_len, flags, NULL);
-	}
 
 	release_sock(sk);
 	return err;


