Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0A776DC0
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389207AbfGZPbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389202AbfGZPbH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:31:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19DC6205F4;
        Fri, 26 Jul 2019 15:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155066;
        bh=EwLZ7RAFxEhQHU1QRp5g3dde1FFcgFjpZQ5iIiesAKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QhyOWVeiHGffjqb/dEB6KaP9tJOMNfkAudFK//QogkZcztWp1VjwhlmIfGffRcDsP
         BDEyKF4eCuzBtAuvLD5SEXh8PkcncttHPxfimtE+1SVBGHYkgeQDGHoAmXj8JUuWv/
         EgQjousETUN4X9+SaJA7UgUWsyTpgTQ379WBoDpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7966f2a0b2c7da8939b4@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 19/62] rxrpc: Fix send on a connected, but unbound socket
Date:   Fri, 26 Jul 2019 17:24:31 +0200
Message-Id: <20190726152303.726590457@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit e835ada07091f40dcfb1bc735082bd0a7c005e59 ]

If sendmsg() or sendmmsg() is called on a connected socket that hasn't had
bind() called on it, then an oops will occur when the kernel tries to
connect the call because no local endpoint has been allocated.

Fix this by implicitly binding the socket if it is in the
RXRPC_CLIENT_UNBOUND state, just like it does for the RXRPC_UNBOUND state.

Further, the state should be transitioned to RXRPC_CLIENT_BOUND after this
to prevent further attempts to bind it.

This can be tested with:

	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <sys/socket.h>
	#include <arpa/inet.h>
	#include <linux/rxrpc.h>
	static const unsigned char inet6_addr[16] = {
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0xac, 0x14, 0x14, 0xaa
	};
	int main(void)
	{
		struct sockaddr_rxrpc srx;
		struct cmsghdr *cm;
		struct msghdr msg;
		unsigned char control[16];
		int fd;
		memset(&srx, 0, sizeof(srx));
		srx.srx_family = 0x21;
		srx.srx_service = 0;
		srx.transport_type = AF_INET;
		srx.transport_len = 0x1c;
		srx.transport.sin6.sin6_family = AF_INET6;
		srx.transport.sin6.sin6_port = htons(0x4e22);
		srx.transport.sin6.sin6_flowinfo = htons(0x4e22);
		srx.transport.sin6.sin6_scope_id = htons(0xaa3b);
		memcpy(&srx.transport.sin6.sin6_addr, inet6_addr, 16);
		cm = (struct cmsghdr *)control;
		cm->cmsg_len	= CMSG_LEN(sizeof(unsigned long));
		cm->cmsg_level	= SOL_RXRPC;
		cm->cmsg_type	= RXRPC_USER_CALL_ID;
		*(unsigned long *)CMSG_DATA(cm) = 0;
		msg.msg_name = NULL;
		msg.msg_namelen = 0;
		msg.msg_iov = NULL;
		msg.msg_iovlen = 0;
		msg.msg_control = control;
		msg.msg_controllen = cm->cmsg_len;
		msg.msg_flags = 0;
		fd = socket(AF_RXRPC, SOCK_DGRAM, AF_INET);
		connect(fd, (struct sockaddr *)&srx, sizeof(srx));
		sendmsg(fd, &msg, 0);
		return 0;
	}

Leading to the following oops:

	BUG: kernel NULL pointer dereference, address: 0000000000000018
	#PF: supervisor read access in kernel mode
	#PF: error_code(0x0000) - not-present page
	...
	RIP: 0010:rxrpc_connect_call+0x42/0xa01
	...
	Call Trace:
	 ? mark_held_locks+0x47/0x59
	 ? __local_bh_enable_ip+0xb6/0xba
	 rxrpc_new_client_call+0x3b1/0x762
	 ? rxrpc_do_sendmsg+0x3c0/0x92e
	 rxrpc_do_sendmsg+0x3c0/0x92e
	 rxrpc_sendmsg+0x16b/0x1b5
	 sock_sendmsg+0x2d/0x39
	 ___sys_sendmsg+0x1a4/0x22a
	 ? release_sock+0x19/0x9e
	 ? reacquire_held_locks+0x136/0x160
	 ? release_sock+0x19/0x9e
	 ? find_held_lock+0x2b/0x6e
	 ? __lock_acquire+0x268/0xf73
	 ? rxrpc_connect+0xdd/0xe4
	 ? __local_bh_enable_ip+0xb6/0xba
	 __sys_sendmsg+0x5e/0x94
	 do_syscall_64+0x7d/0x1bf
	 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: 2341e0775747 ("rxrpc: Simplify connect() implementation and simplify sendmsg() op")
Reported-by: syzbot+7966f2a0b2c7da8939b4@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/af_rxrpc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -521,6 +521,7 @@ static int rxrpc_sendmsg(struct socket *
 
 	switch (rx->sk.sk_state) {
 	case RXRPC_UNBOUND:
+	case RXRPC_CLIENT_UNBOUND:
 		rx->srx.srx_family = AF_RXRPC;
 		rx->srx.srx_service = 0;
 		rx->srx.transport_type = SOCK_DGRAM;
@@ -545,10 +546,9 @@ static int rxrpc_sendmsg(struct socket *
 		}
 
 		rx->local = local;
-		rx->sk.sk_state = RXRPC_CLIENT_UNBOUND;
+		rx->sk.sk_state = RXRPC_CLIENT_BOUND;
 		/* Fall through */
 
-	case RXRPC_CLIENT_UNBOUND:
 	case RXRPC_CLIENT_BOUND:
 		if (!m->msg_name &&
 		    test_bit(RXRPC_SOCK_CONNECTED, &rx->flags)) {


