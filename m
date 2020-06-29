Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B14C20DC87
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730940AbgF2UQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:16:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732817AbgF2TaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EF6C2520C;
        Mon, 29 Jun 2020 15:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444926;
        bh=aFsRrZvPXRU61iA2L2eyJCTnBNZH5fD3c59ryoAjsY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFCSUFHfBfdZU/qY+kxmfWU6CuE9b1zmCOBPFdGUeIM8fUZ0jsse1Z4p78W5VKb14
         cKtzC7/HdhE3Z9l0V+4ofGZzUIIiFbqN7u/XdWqNOLVldyfC0qDFWp4g5Kudt9mfvh
         rGl3VYoUpDi2LARroYIR1pkN/LNiiIBKXDBwZzN0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 023/131] net: increment xmit_recursion level in dev_direct_xmit()
Date:   Mon, 29 Jun 2020 11:33:14 -0400
Message-Id: <20200629153502.2494656-24-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0ad6f6e767ec2f613418cbc7ebe5ec4c35af540c ]

Back in commit f60e5990d9c1 ("ipv6: protect skb->sk accesses
from recursive dereference inside the stack") Hannes added code
so that IPv6 stack would not trust skb->sk for typical cases
where packet goes through 'standard' xmit path (__dev_queue_xmit())

Alas af_packet had a dev_direct_xmit() path that was not
dealing yet with xmit_recursion level.

Also change sk_mc_loop() to dump a stack once only.

Without this patch, syzbot was able to trigger :

[1]
[  153.567378] WARNING: CPU: 7 PID: 11273 at net/core/sock.c:721 sk_mc_loop+0x51/0x70
[  153.567378] Modules linked in: nfnetlink ip6table_raw ip6table_filter iptable_raw iptable_nat nf_nat nf_conntrack nf_defrag_ipv4 nf_defrag_ipv6 iptable_filter macsec macvtap tap macvlan 8021q hsr wireguard libblake2s blake2s_x86_64 libblake2s_generic udp_tunnel ip6_udp_tunnel libchacha20poly1305 poly1305_x86_64 chacha_x86_64 libchacha curve25519_x86_64 libcurve25519_generic netdevsim batman_adv dummy team bridge stp llc w1_therm wire i2c_mux_pca954x i2c_mux cdc_acm ehci_pci ehci_hcd mlx4_en mlx4_ib ib_uverbs ib_core mlx4_core
[  153.567386] CPU: 7 PID: 11273 Comm: b159172088 Not tainted 5.8.0-smp-DEV #273
[  153.567387] RIP: 0010:sk_mc_loop+0x51/0x70
[  153.567388] Code: 66 83 f8 0a 75 24 0f b6 4f 12 b8 01 00 00 00 31 d2 d3 e0 a9 bf ef ff ff 74 07 48 8b 97 f0 02 00 00 0f b6 42 3a 83 e0 01 5d c3 <0f> 0b b8 01 00 00 00 5d c3 0f b6 87 18 03 00 00 5d c0 e8 04 83 e0
[  153.567388] RSP: 0018:ffff95c69bb93990 EFLAGS: 00010212
[  153.567388] RAX: 0000000000000011 RBX: ffff95c6e0ee3e00 RCX: 0000000000000007
[  153.567389] RDX: ffff95c69ae50000 RSI: ffff95c6c30c3000 RDI: ffff95c6c30c3000
[  153.567389] RBP: ffff95c69bb93990 R08: ffff95c69a77f000 R09: 0000000000000008
[  153.567389] R10: 0000000000000040 R11: 00003e0e00026128 R12: ffff95c6c30c3000
[  153.567390] R13: ffff95c6cc4fd500 R14: ffff95c6f84500c0 R15: ffff95c69aa13c00
[  153.567390] FS:  00007fdc3a283700(0000) GS:ffff95c6ff9c0000(0000) knlGS:0000000000000000
[  153.567390] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  153.567391] CR2: 00007ffee758e890 CR3: 0000001f9ba20003 CR4: 00000000001606e0
[  153.567391] Call Trace:
[  153.567391]  ip6_finish_output2+0x34e/0x550
[  153.567391]  __ip6_finish_output+0xe7/0x110
[  153.567391]  ip6_finish_output+0x2d/0xb0
[  153.567392]  ip6_output+0x77/0x120
[  153.567392]  ? __ip6_finish_output+0x110/0x110
[  153.567392]  ip6_local_out+0x3d/0x50
[  153.567392]  ipvlan_queue_xmit+0x56c/0x5e0
[  153.567393]  ? ksize+0x19/0x30
[  153.567393]  ipvlan_start_xmit+0x18/0x50
[  153.567393]  dev_direct_xmit+0xf3/0x1c0
[  153.567393]  packet_direct_xmit+0x69/0xa0
[  153.567394]  packet_sendmsg+0xbf0/0x19b0
[  153.567394]  ? plist_del+0x62/0xb0
[  153.567394]  sock_sendmsg+0x65/0x70
[  153.567394]  sock_write_iter+0x93/0xf0
[  153.567394]  new_sync_write+0x18e/0x1a0
[  153.567395]  __vfs_write+0x29/0x40
[  153.567395]  vfs_write+0xb9/0x1b0
[  153.567395]  ksys_write+0xb1/0xe0
[  153.567395]  __x64_sys_write+0x1a/0x20
[  153.567395]  do_syscall_64+0x43/0x70
[  153.567396]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  153.567396] RIP: 0033:0x453549
[  153.567396] Code: Bad RIP value.
[  153.567396] RSP: 002b:00007fdc3a282cc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  153.567397] RAX: ffffffffffffffda RBX: 00000000004d32d0 RCX: 0000000000453549
[  153.567397] RDX: 0000000000000020 RSI: 0000000020000300 RDI: 0000000000000003
[  153.567398] RBP: 00000000004d32d8 R08: 0000000000000000 R09: 0000000000000000
[  153.567398] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004d32dc
[  153.567398] R13: 00007ffee742260f R14: 00007fdc3a282dc0 R15: 00007fdc3a283700
[  153.567399] ---[ end trace c1d5ae2b1059ec62 ]---

f60e5990d9c1 ("ipv6: protect skb->sk accesses from recursive dereference inside the stack")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c  | 2 ++
 net/core/sock.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8f9a8b009a238..4b1053057ca60 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3899,10 +3899,12 @@ int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
 
 	local_bh_disable();
 
+	dev_xmit_recursion_inc();
 	HARD_TX_LOCK(dev, txq, smp_processor_id());
 	if (!netif_xmit_frozen_or_drv_stopped(txq))
 		ret = netdev_start_xmit(skb, dev, txq, false);
 	HARD_TX_UNLOCK(dev, txq);
+	dev_xmit_recursion_dec();
 
 	local_bh_enable();
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 8abfde0d28ee5..b11d116383dab 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -640,7 +640,7 @@ bool sk_mc_loop(struct sock *sk)
 		return inet6_sk(sk)->mc_loop;
 #endif
 	}
-	WARN_ON(1);
+	WARN_ON_ONCE(1);
 	return true;
 }
 EXPORT_SYMBOL(sk_mc_loop);
-- 
2.25.1

