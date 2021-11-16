Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5E8451FC8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351299AbhKPApY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:45:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343673AbhKOTVf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5E9A63377;
        Mon, 15 Nov 2021 18:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001847;
        bh=GganmfV0uo6fP8d0ZH8qrfE+nIhZ9B5adOSt+VQ9KOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=trNryrfB9hmGFUczYF825wAxL67L+BAyhk9Z0vW6aTJEZDnso3xmXaSRGazW1qYyO
         GSRjLbSFfKHbZR/ckEIojPBm+EKsVUy8vN6XpeucGN+F3GVccgdEY3BvPfRWO85lyV
         GTqEmidlm4GRD9Hrx/5wY61IPZYBeJLc+qD2abQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 309/917] inet: remove races in inet{6}_getname()
Date:   Mon, 15 Nov 2021 17:56:44 +0100
Message-Id: <20211115165439.232650333@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9dfc685e0262d4c5e44e13302f89841fa75173ca ]

syzbot reported data-races in inet_getname() multiple times,
it is time we fix this instead of pretending applications
should not trigger them.

getsockname() and getpeername() are not really considered fast path.

v2: added the missing BPF_CGROUP_RUN_SA_PROG() declaration
    needed when CONFIG_CGROUP_BPF=n, as reported by
    kernel test robot <lkp@intel.com>

syzbot typical report:

BUG: KCSAN: data-race in __inet_hash_connect / inet_getname

write to 0xffff888136d66cf8 of 2 bytes by task 14374 on cpu 1:
 __inet_hash_connect+0x7ec/0x950 net/ipv4/inet_hashtables.c:831
 inet_hash_connect+0x85/0x90 net/ipv4/inet_hashtables.c:853
 tcp_v4_connect+0x782/0xbb0 net/ipv4/tcp_ipv4.c:275
 __inet_stream_connect+0x156/0x6e0 net/ipv4/af_inet.c:664
 inet_stream_connect+0x44/0x70 net/ipv4/af_inet.c:728
 __sys_connect_file net/socket.c:1896 [inline]
 __sys_connect+0x254/0x290 net/socket.c:1913
 __do_sys_connect net/socket.c:1923 [inline]
 __se_sys_connect net/socket.c:1920 [inline]
 __x64_sys_connect+0x3d/0x50 net/socket.c:1920
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xa0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff888136d66cf8 of 2 bytes by task 14408 on cpu 0:
 inet_getname+0x11f/0x170 net/ipv4/af_inet.c:790
 __sys_getsockname+0x11d/0x1b0 net/socket.c:1946
 __do_sys_getsockname net/socket.c:1961 [inline]
 __se_sys_getsockname net/socket.c:1958 [inline]
 __x64_sys_getsockname+0x3e/0x50 net/socket.c:1958
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xa0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x0000 -> 0xdee0

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 14408 Comm: syz-executor.3 Not tainted 5.15.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20211026213014.3026708-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf-cgroup.h |  1 +
 net/ipv4/af_inet.c         | 16 +++++++++-------
 net/ipv6/af_inet6.c        | 21 +++++++++++----------
 3 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 2746fd8042162..3536ab432b30c 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -517,6 +517,7 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 
 #define cgroup_bpf_enabled(atype) (0)
 #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, atype, t_ctx) ({ 0; })
+#define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, atype) ({ 0; })
 #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (0)
 #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk,skb) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET_EGRESS(sk,skb) ({ 0; })
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 1d816a5fd3eb9..64062b7ce61df 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -773,26 +773,28 @@ int inet_getname(struct socket *sock, struct sockaddr *uaddr,
 	DECLARE_SOCKADDR(struct sockaddr_in *, sin, uaddr);
 
 	sin->sin_family = AF_INET;
+	lock_sock(sk);
 	if (peer) {
 		if (!inet->inet_dport ||
 		    (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_SYN_SENT)) &&
-		     peer == 1))
+		     peer == 1)) {
+			release_sock(sk);
 			return -ENOTCONN;
+		}
 		sin->sin_port = inet->inet_dport;
 		sin->sin_addr.s_addr = inet->inet_daddr;
-		BPF_CGROUP_RUN_SA_PROG_LOCK(sk, (struct sockaddr *)sin,
-					    CGROUP_INET4_GETPEERNAME,
-					    NULL);
+		BPF_CGROUP_RUN_SA_PROG(sk, (struct sockaddr *)sin,
+				       CGROUP_INET4_GETPEERNAME);
 	} else {
 		__be32 addr = inet->inet_rcv_saddr;
 		if (!addr)
 			addr = inet->inet_saddr;
 		sin->sin_port = inet->inet_sport;
 		sin->sin_addr.s_addr = addr;
-		BPF_CGROUP_RUN_SA_PROG_LOCK(sk, (struct sockaddr *)sin,
-					    CGROUP_INET4_GETSOCKNAME,
-					    NULL);
+		BPF_CGROUP_RUN_SA_PROG(sk, (struct sockaddr *)sin,
+				       CGROUP_INET4_GETSOCKNAME);
 	}
+	release_sock(sk);
 	memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
 	return sizeof(*sin);
 }
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index b5878bb8e419d..0c4da163535ad 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -521,31 +521,32 @@ int inet6_getname(struct socket *sock, struct sockaddr *uaddr,
 	sin->sin6_family = AF_INET6;
 	sin->sin6_flowinfo = 0;
 	sin->sin6_scope_id = 0;
+	lock_sock(sk);
 	if (peer) {
-		if (!inet->inet_dport)
-			return -ENOTCONN;
-		if (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_SYN_SENT)) &&
-		    peer == 1)
+		if (!inet->inet_dport ||
+		    (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_SYN_SENT)) &&
+		    peer == 1)) {
+			release_sock(sk);
 			return -ENOTCONN;
+		}
 		sin->sin6_port = inet->inet_dport;
 		sin->sin6_addr = sk->sk_v6_daddr;
 		if (np->sndflow)
 			sin->sin6_flowinfo = np->flow_label;
-		BPF_CGROUP_RUN_SA_PROG_LOCK(sk, (struct sockaddr *)sin,
-					    CGROUP_INET6_GETPEERNAME,
-					    NULL);
+		BPF_CGROUP_RUN_SA_PROG(sk, (struct sockaddr *)sin,
+				       CGROUP_INET6_GETPEERNAME);
 	} else {
 		if (ipv6_addr_any(&sk->sk_v6_rcv_saddr))
 			sin->sin6_addr = np->saddr;
 		else
 			sin->sin6_addr = sk->sk_v6_rcv_saddr;
 		sin->sin6_port = inet->inet_sport;
-		BPF_CGROUP_RUN_SA_PROG_LOCK(sk, (struct sockaddr *)sin,
-					    CGROUP_INET6_GETSOCKNAME,
-					    NULL);
+		BPF_CGROUP_RUN_SA_PROG(sk, (struct sockaddr *)sin,
+				       CGROUP_INET6_GETSOCKNAME);
 	}
 	sin->sin6_scope_id = ipv6_iface_scope_id(&sin->sin6_addr,
 						 sk->sk_bound_dev_if);
+	release_sock(sk);
 	return sizeof(*sin);
 }
 EXPORT_SYMBOL(inet6_getname);
-- 
2.33.0



