Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3DF3B61A9
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbhF1Oha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:37:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235388AbhF1Of2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:35:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D31F61C9C;
        Mon, 28 Jun 2021 14:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890631;
        bh=lE0OWfzJly5dznmrqite8kzpnOQYGVrYMWV9Ps09TTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ciCa7BtXVK3JBriWLBFBURrb06n7klAe3RLUD/g9o6pVN8P4qU7p+Wf2Z0fKZQLgw
         FSmP7ZPh371VbI8Z9C0GxdiLLccD0yTeVFAEEhOpBpF/eYj2SkuxFb6I83T4YWkVo5
         Qz1QsaqNa2OfoXQOlUOQrYQr8Py1egCM+cD1547k+CPXhrSvFJFQxwvgPkicoBDmdH
         lFL5AtN+IIb8kIJs0AEtMtc7Jeulj82IUMu33bZEcL7Qo2P+QDFVnpd8EzQ9viMEBI
         aEAGr+obaf/vbY6O0X7z5nksDfd4S3Pfe+rpLggZJ3eay8Nl3pItwcD9Nuxs5TuPH8
         T/dlXGe0rEqmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/71] net/packet: annotate accesses to po->ifindex
Date:   Mon, 28 Jun 2021 10:29:22 -0400
Message-Id: <20210628143004.32596-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e032f7c9c7cefffcfb79b9fc16c53011d2d9d11f ]

Like prior patch, we need to annotate lockless accesses to po->ifindex
For instance, packet_getname() is reading po->ifindex (twice) while
another thread is able to change po->ifindex.

KCSAN reported:

BUG: KCSAN: data-race in packet_do_bind / packet_getname

write to 0xffff888143ce3cbc of 4 bytes by task 25573 on cpu 1:
 packet_do_bind+0x420/0x7e0 net/packet/af_packet.c:3191
 packet_bind+0xc3/0xd0 net/packet/af_packet.c:3255
 __sys_bind+0x200/0x290 net/socket.c:1637
 __do_sys_bind net/socket.c:1648 [inline]
 __se_sys_bind net/socket.c:1646 [inline]
 __x64_sys_bind+0x3d/0x50 net/socket.c:1646
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff888143ce3cbc of 4 bytes by task 25578 on cpu 0:
 packet_getname+0x5b/0x1a0 net/packet/af_packet.c:3525
 __sys_getsockname+0x10e/0x1a0 net/socket.c:1887
 __do_sys_getsockname net/socket.c:1902 [inline]
 __se_sys_getsockname net/socket.c:1899 [inline]
 __x64_sys_getsockname+0x3e/0x50 net/socket.c:1899
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00000000 -> 0x00000001

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 25578 Comm: syz-executor.5 Not tainted 5.13.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index e582799d4e85..0ffbf3d17911 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3157,11 +3157,11 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 		if (unlikely(unlisted)) {
 			dev_put(dev);
 			po->prot_hook.dev = NULL;
-			po->ifindex = -1;
+			WRITE_ONCE(po->ifindex, -1);
 			packet_cached_dev_reset(po);
 		} else {
 			po->prot_hook.dev = dev;
-			po->ifindex = dev ? dev->ifindex : 0;
+			WRITE_ONCE(po->ifindex, dev ? dev->ifindex : 0);
 			packet_cached_dev_assign(po, dev);
 		}
 	}
@@ -3475,7 +3475,7 @@ static int packet_getname_spkt(struct socket *sock, struct sockaddr *uaddr,
 	uaddr->sa_family = AF_PACKET;
 	memset(uaddr->sa_data, 0, sizeof(uaddr->sa_data));
 	rcu_read_lock();
-	dev = dev_get_by_index_rcu(sock_net(sk), pkt_sk(sk)->ifindex);
+	dev = dev_get_by_index_rcu(sock_net(sk), READ_ONCE(pkt_sk(sk)->ifindex));
 	if (dev)
 		strlcpy(uaddr->sa_data, dev->name, sizeof(uaddr->sa_data));
 	rcu_read_unlock();
@@ -3490,16 +3490,18 @@ static int packet_getname(struct socket *sock, struct sockaddr *uaddr,
 	struct sock *sk = sock->sk;
 	struct packet_sock *po = pkt_sk(sk);
 	DECLARE_SOCKADDR(struct sockaddr_ll *, sll, uaddr);
+	int ifindex;
 
 	if (peer)
 		return -EOPNOTSUPP;
 
+	ifindex = READ_ONCE(po->ifindex);
 	sll->sll_family = AF_PACKET;
-	sll->sll_ifindex = po->ifindex;
+	sll->sll_ifindex = ifindex;
 	sll->sll_protocol = READ_ONCE(po->num);
 	sll->sll_pkttype = 0;
 	rcu_read_lock();
-	dev = dev_get_by_index_rcu(sock_net(sk), po->ifindex);
+	dev = dev_get_by_index_rcu(sock_net(sk), ifindex);
 	if (dev) {
 		sll->sll_hatype = dev->type;
 		sll->sll_halen = dev->addr_len;
@@ -4099,7 +4101,7 @@ static int packet_notifier(struct notifier_block *this,
 				}
 				if (msg == NETDEV_UNREGISTER) {
 					packet_cached_dev_reset(po);
-					po->ifindex = -1;
+					WRITE_ONCE(po->ifindex, -1);
 					if (po->prot_hook.dev)
 						dev_put(po->prot_hook.dev);
 					po->prot_hook.dev = NULL;
@@ -4614,7 +4616,7 @@ static int packet_seq_show(struct seq_file *seq, void *v)
 			   refcount_read(&s->sk_refcnt),
 			   s->sk_type,
 			   ntohs(READ_ONCE(po->num)),
-			   po->ifindex,
+			   READ_ONCE(po->ifindex),
 			   po->running,
 			   atomic_read(&s->sk_rmem_alloc),
 			   from_kuid_munged(seq_user_ns(seq), sock_i_uid(s)),
-- 
2.30.2

