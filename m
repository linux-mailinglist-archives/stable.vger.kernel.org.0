Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B507A232CE3
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgG3IEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:04:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728758AbgG3IEp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:04:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5424220672;
        Thu, 30 Jul 2020 08:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096284;
        bh=J0aiOgOPd7YyHG270Ucn4MF+tgtyqZRPTCZ+qXdcNc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jxv+bdAcMAuEMMnfTmTarYiEDeho4dTFbz/NxpK+PGWRoGtLuOys2ozE9T7oH8O/W
         xoggPX9c0IThyvqS2M0KjMfWZgQneycwi9pd0OaxNLQ+3xE94lQyBA2TWunxrcXg7E
         jmxOSlpvmi37kUfmShnAvnHq+Q+1j3Cvox3tfwCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 11/20] rxrpc: Fix sendmsg() returning EPIPE due to recvmsg() returning ENODATA
Date:   Thu, 30 Jul 2020 10:04:01 +0200
Message-Id: <20200730074421.071850083@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.533211699@linuxfoundation.org>
References: <20200730074420.533211699@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 639f181f0ee20d3249dbc55f740f0167267180f0 ]

rxrpc_sendmsg() returns EPIPE if there's an outstanding error, such as if
rxrpc_recvmsg() indicating ENODATA if there's nothing for it to read.

Change rxrpc_recvmsg() to return EAGAIN instead if there's nothing to read
as this particular error doesn't get stored in ->sk_err by the networking
core.

Also change rxrpc_sendmsg() so that it doesn't fail with delayed receive
errors (there's no way for it to report which call, if any, the error was
caused by).

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/recvmsg.c |    2 +-
 net/rxrpc/sendmsg.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -464,7 +464,7 @@ try_again:
 	    list_empty(&rx->recvmsg_q) &&
 	    rx->sk.sk_state != RXRPC_SERVER_LISTENING) {
 		release_sock(&rx->sk);
-		return -ENODATA;
+		return -EAGAIN;
 	}
 
 	if (list_empty(&rx->recvmsg_q)) {
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -306,7 +306,7 @@ static int rxrpc_send_data(struct rxrpc_
 	/* this should be in poll */
 	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
 
-	if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN))
+	if (sk->sk_shutdown & SEND_SHUTDOWN)
 		return -EPIPE;
 
 	more = msg->msg_flags & MSG_MORE;


