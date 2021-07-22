Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F93C3D2821
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhGVPzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:55:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232495AbhGVPyp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:54:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D38A613AE;
        Thu, 22 Jul 2021 16:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971720;
        bh=qpOpOQqwLO1dFYVZmxZ97l5iHgNYBW/kmiXIBJszSrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFRiBg4/nnGmXMtFfspHmKA9NBDKD0XnJODkNNhNS/5hFIKVhPaSxjabK+UMUO4Yz
         BxiuPnPoynhjeoz/6DzedwhCqWhP+1inJ67oQD23tBtn4H9NnDAQhprerNCKRQj78s
         b1Au5SBqZnFAdGjoa7Yt75DJA9tnp5hqtGRj3R+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 71/71] udp: annotate data races around unix_sk(sk)->gso_size
Date:   Thu, 22 Jul 2021 18:31:46 +0200
Message-Id: <20210722155620.285038192@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 18a419bad63b7f68a1979e28459782518e7b6bbe upstream.

Accesses to unix_sk(sk)->gso_size are lockless.
Add READ_ONCE()/WRITE_ONCE() around them.

BUG: KCSAN: data-race in udp_lib_setsockopt / udpv6_sendmsg

write to 0xffff88812d78f47c of 2 bytes by task 10849 on cpu 1:
 udp_lib_setsockopt+0x3b3/0x710 net/ipv4/udp.c:2696
 udpv6_setsockopt+0x63/0x90 net/ipv6/udp.c:1630
 sock_common_setsockopt+0x5d/0x70 net/core/sock.c:3265
 __sys_setsockopt+0x18f/0x200 net/socket.c:2104
 __do_sys_setsockopt net/socket.c:2115 [inline]
 __se_sys_setsockopt net/socket.c:2112 [inline]
 __x64_sys_setsockopt+0x62/0x70 net/socket.c:2112
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff88812d78f47c of 2 bytes by task 10852 on cpu 0:
 udpv6_sendmsg+0x161/0x16b0 net/ipv6/udp.c:1299
 inet6_sendmsg+0x5f/0x80 net/ipv6/af_inet6.c:642
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2337
 ___sys_sendmsg net/socket.c:2391 [inline]
 __sys_sendmmsg+0x315/0x4b0 net/socket.c:2477
 __do_sys_sendmmsg net/socket.c:2506 [inline]
 __se_sys_sendmmsg net/socket.c:2503 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2503
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x0000 -> 0x0005

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 10852 Comm: syz-executor.0 Not tainted 5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp.c |    6 +++---
 net/ipv6/udp.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1043,7 +1043,7 @@ int udp_sendmsg(struct sock *sk, struct
 	}
 
 	ipcm_init_sk(&ipc, inet);
-	ipc.gso_size = up->gso_size;
+	ipc.gso_size = READ_ONCE(up->gso_size);
 
 	if (msg->msg_controllen) {
 		err = udp_cmsg_send(sk, msg, &ipc.gso_size);
@@ -2590,7 +2590,7 @@ int udp_lib_setsockopt(struct sock *sk,
 	case UDP_SEGMENT:
 		if (val < 0 || val > USHRT_MAX)
 			return -EINVAL;
-		up->gso_size = val;
+		WRITE_ONCE(up->gso_size, val);
 		break;
 
 	case UDP_GRO:
@@ -2692,7 +2692,7 @@ int udp_lib_getsockopt(struct sock *sk,
 		break;
 
 	case UDP_SEGMENT:
-		val = up->gso_size;
+		val = READ_ONCE(up->gso_size);
 		break;
 
 	case UDP_GRO:
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1237,7 +1237,7 @@ int udpv6_sendmsg(struct sock *sk, struc
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
 
 	ipcm6_init(&ipc6);
-	ipc6.gso_size = up->gso_size;
+	ipc6.gso_size = READ_ONCE(up->gso_size);
 	ipc6.sockc.tsflags = sk->sk_tsflags;
 	ipc6.sockc.mark = sk->sk_mark;
 


