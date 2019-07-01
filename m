Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17BB3F787
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfD3MAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 08:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730509AbfD3LqK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:46:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2E0C21734;
        Tue, 30 Apr 2019 11:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624769;
        bh=4aT7aPmrz8QpmHBVDf3yOHh3OlMJCOzD8zKtFRyBRZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BE6Z5uolToWBtzzRGLOCxdWbzrQzpjNTiegJM9BDNOiOWQGc8ZXynNVIRKgQXL4NO
         W6gAh1KIzr1m8NiKkKL/qbsTgSZmnlvtgBN1GR40KYwCFkEDlQzHkMrh8UUrSGSfxT
         k+U6T6NJykH6bmFbLRcahzxwCSM+K42mTT+vHxgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 065/100] rxrpc: fix race condition in rxrpc_input_packet()
Date:   Tue, 30 Apr 2019 13:38:34 +0200
Message-Id: <20190430113611.879910212@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 032be5f19a94de51093851757089133dcc1e92aa upstream.

After commit 5271953cad31 ("rxrpc: Use the UDP encap_rcv hook"),
rxrpc_input_packet() is directly called from lockless UDP receive
path, under rcu_read_lock() protection.

It must therefore use RCU rules :

- udp_sk->sk_user_data can be cleared at any point in this function.
  rcu_dereference_sk_user_data() is what we need here.

- Also, since sk_user_data might have been set in rxrpc_open_socket()
  we must observe a proper RCU grace period before kfree(local) in
  rxrpc_lookup_local()

v4: @local can be NULL in xrpc_lookup_local() as reported by kbuild test robot <lkp@intel.com>
        and Julia Lawall <julia.lawall@lip6.fr>, thanks !

v3,v2 : addressed David Howells feedback, thanks !

syzbot reported :

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 19236 Comm: syz-executor703 Not tainted 5.1.0-rc6 #79
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__lock_acquire+0xbef/0x3fb0 kernel/locking/lockdep.c:3573
Code: 00 0f 85 a5 1f 00 00 48 81 c4 10 01 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 <80> 3c 02 00 0f 85 4a 21 00 00 49 81 7d 00 20 54 9c 89 0f 84 cf f4
RSP: 0018:ffff88809d7aef58 EFLAGS: 00010002
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000026 RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff88809d7af090 R08: 0000000000000001 R09: 0000000000000001
R10: ffffed1015d05bc7 R11: ffff888089428600 R12: 0000000000000000
R13: 0000000000000130 R14: 0000000000000001 R15: 0000000000000001
FS:  00007f059044d700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004b6040 CR3: 00000000955ca000 CR4: 00000000001406f0
Call Trace:
 lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4211
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:152
 skb_queue_tail+0x26/0x150 net/core/skbuff.c:2972
 rxrpc_reject_packet net/rxrpc/input.c:1126 [inline]
 rxrpc_input_packet+0x4a0/0x5536 net/rxrpc/input.c:1414
 udp_queue_rcv_one_skb+0xaf2/0x1780 net/ipv4/udp.c:2011
 udp_queue_rcv_skb+0x128/0x730 net/ipv4/udp.c:2085
 udp_unicast_rcv_skb.isra.0+0xb9/0x360 net/ipv4/udp.c:2245
 __udp4_lib_rcv+0x701/0x2ca0 net/ipv4/udp.c:2301
 udp_rcv+0x22/0x30 net/ipv4/udp.c:2482
 ip_protocol_deliver_rcu+0x60/0x8f0 net/ipv4/ip_input.c:208
 ip_local_deliver_finish+0x23b/0x390 net/ipv4/ip_input.c:234
 NF_HOOK include/linux/netfilter.h:289 [inline]
 NF_HOOK include/linux/netfilter.h:283 [inline]
 ip_local_deliver+0x1e9/0x520 net/ipv4/ip_input.c:255
 dst_input include/net/dst.h:450 [inline]
 ip_rcv_finish+0x1e1/0x300 net/ipv4/ip_input.c:413
 NF_HOOK include/linux/netfilter.h:289 [inline]
 NF_HOOK include/linux/netfilter.h:283 [inline]
 ip_rcv+0xe8/0x3f0 net/ipv4/ip_input.c:523
 __netif_receive_skb_one_core+0x115/0x1a0 net/core/dev.c:4987
 __netif_receive_skb+0x2c/0x1c0 net/core/dev.c:5099
 netif_receive_skb_internal+0x117/0x660 net/core/dev.c:5202
 napi_frags_finish net/core/dev.c:5769 [inline]
 napi_gro_frags+0xade/0xd10 net/core/dev.c:5843
 tun_get_user+0x2f24/0x3fb0 drivers/net/tun.c:1981
 tun_chr_write_iter+0xbd/0x156 drivers/net/tun.c:2027
 call_write_iter include/linux/fs.h:1866 [inline]
 do_iter_readv_writev+0x5e1/0x8e0 fs/read_write.c:681
 do_iter_write fs/read_write.c:957 [inline]
 do_iter_write+0x184/0x610 fs/read_write.c:938
 vfs_writev+0x1b3/0x2f0 fs/read_write.c:1002
 do_writev+0x15e/0x370 fs/read_write.c:1037
 __do_sys_writev fs/read_write.c:1110 [inline]
 __se_sys_writev fs/read_write.c:1107 [inline]
 __x64_sys_writev+0x75/0xb0 fs/read_write.c:1107
 do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: 5271953cad31 ("rxrpc: Use the UDP encap_rcv hook")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/rxrpc/input.c        |   12 ++++++++----
 net/rxrpc/local_object.c |    3 ++-
 2 files changed, 10 insertions(+), 5 deletions(-)

--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1155,19 +1155,19 @@ int rxrpc_extract_header(struct rxrpc_sk
  * handle data received on the local endpoint
  * - may be called in interrupt context
  *
- * The socket is locked by the caller and this prevents the socket from being
- * shut down and the local endpoint from going away, thus sk_user_data will not
- * be cleared until this function returns.
+ * [!] Note that as this is called from the encap_rcv hook, the socket is not
+ * held locked by the caller and nothing prevents sk_user_data on the UDP from
+ * being cleared in the middle of processing this function.
  *
  * Called with the RCU read lock held from the IP layer via UDP.
  */
 int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 {
+	struct rxrpc_local *local = rcu_dereference_sk_user_data(udp_sk);
 	struct rxrpc_connection *conn;
 	struct rxrpc_channel *chan;
 	struct rxrpc_call *call = NULL;
 	struct rxrpc_skb_priv *sp;
-	struct rxrpc_local *local = udp_sk->sk_user_data;
 	struct rxrpc_peer *peer = NULL;
 	struct rxrpc_sock *rx = NULL;
 	unsigned int channel;
@@ -1175,6 +1175,10 @@ int rxrpc_input_packet(struct sock *udp_
 
 	_enter("%p", udp_sk);
 
+	if (unlikely(!local)) {
+		kfree_skb(skb);
+		return 0;
+	}
 	if (skb->tstamp == 0)
 		skb->tstamp = ktime_get_real();
 
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -304,7 +304,8 @@ nomem:
 	ret = -ENOMEM;
 sock_error:
 	mutex_unlock(&rxnet->local_mutex);
-	kfree(local);
+	if (local)
+		call_rcu(&local->rcu, rxrpc_local_rcu);
 	_leave(" = %d", ret);
 	return ERR_PTR(ret);
 


