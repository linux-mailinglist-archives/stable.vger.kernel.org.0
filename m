Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFC2226B6A
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbgGTPpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729996AbgGTPpe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:45:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19F6B22CAF;
        Mon, 20 Jul 2020 15:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259933;
        bh=kgH0OGVXZHiy4IKHFztjkPe4ZUEKGKQvWlgThSsU97Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YgEO95EyFKeftCOwPOeHnyRv3+iu4uSR7gHH7bU9LyXCXNJXvZjN6icdnocRpGjJp
         lPZjG2Q9/cLZ9XUCjYc9UuIrnnlSalIJX3kI8uAkDVS0t0TaUQDoNePRF3JtZIOGZn
         dPN97V1iOo4GDRUP/0R2DZl6CsHq3mbmVnhdXpF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Varghese <martin.varghese@nokia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 045/125] net: Added pointer check for dst->ops->neigh_lookup in dst_neigh_lookup_skb
Date:   Mon, 20 Jul 2020 17:36:24 +0200
Message-Id: <20200720152805.184499915@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

[ Upstream commit 394de110a73395de2ca4516b0de435e91b11b604 ]

The packets from tunnel devices (eg bareudp) may have only
metadata in the dst pointer of skb. Hence a pointer check of
neigh_lookup is needed in dst_neigh_lookup_skb

Kernel crashes when packets from bareudp device is processed in
the kernel neighbour subsytem.

[  133.384484] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  133.385240] #PF: supervisor instruction fetch in kernel mode
[  133.385828] #PF: error_code(0x0010) - not-present page
[  133.386603] PGD 0 P4D 0
[  133.386875] Oops: 0010 [#1] SMP PTI
[  133.387275] CPU: 0 PID: 5045 Comm: ping Tainted: G        W         5.8.0-rc2+ #15
[  133.388052] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  133.391076] RIP: 0010:0x0
[  133.392401] Code: Bad RIP value.
[  133.394029] RSP: 0018:ffffb79980003d50 EFLAGS: 00010246
[  133.396656] RAX: 0000000080000102 RBX: ffff9de2fe0d6600 RCX: ffff9de2fe5e9d00
[  133.399018] RDX: 0000000000000000 RSI: ffff9de2fe5e9d00 RDI: ffff9de2fc21b400
[  133.399685] RBP: ffff9de2fe5e9d00 R08: 0000000000000000 R09: 0000000000000000
[  133.400350] R10: ffff9de2fbc6be22 R11: ffff9de2fe0d6600 R12: ffff9de2fc21b400
[  133.401010] R13: ffff9de2fe0d6628 R14: 0000000000000001 R15: 0000000000000003
[  133.401667] FS:  00007fe014918740(0000) GS:ffff9de2fec00000(0000) knlGS:0000000000000000
[  133.402412] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  133.402948] CR2: ffffffffffffffd6 CR3: 000000003bb72000 CR4: 00000000000006f0
[  133.403611] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  133.404270] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  133.404933] Call Trace:
[  133.405169]  <IRQ>
[  133.405367]  __neigh_update+0x5a4/0x8f0
[  133.405734]  arp_process+0x294/0x820
[  133.406076]  ? __netif_receive_skb_core+0x866/0xe70
[  133.406557]  arp_rcv+0x129/0x1c0
[  133.406882]  __netif_receive_skb_one_core+0x95/0xb0
[  133.407340]  process_backlog+0xa7/0x150
[  133.407705]  net_rx_action+0x2af/0x420
[  133.408457]  __do_softirq+0xda/0x2a8
[  133.408813]  asm_call_on_stack+0x12/0x20
[  133.409290]  </IRQ>
[  133.409519]  do_softirq_own_stack+0x39/0x50
[  133.410036]  do_softirq+0x50/0x60
[  133.410401]  __local_bh_enable_ip+0x50/0x60
[  133.410871]  ip_finish_output2+0x195/0x530
[  133.411288]  ip_output+0x72/0xf0
[  133.411673]  ? __ip_finish_output+0x1f0/0x1f0
[  133.412122]  ip_send_skb+0x15/0x40
[  133.412471]  raw_sendmsg+0x853/0xab0
[  133.412855]  ? insert_pfn+0xfe/0x270
[  133.413827]  ? vvar_fault+0xec/0x190
[  133.414772]  sock_sendmsg+0x57/0x80
[  133.415685]  __sys_sendto+0xdc/0x160
[  133.416605]  ? syscall_trace_enter+0x1d4/0x2b0
[  133.417679]  ? __audit_syscall_exit+0x1d9/0x280
[  133.418753]  ? __prepare_exit_to_usermode+0x5d/0x1a0
[  133.419819]  __x64_sys_sendto+0x24/0x30
[  133.420848]  do_syscall_64+0x4d/0x90
[  133.421768]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  133.422833] RIP: 0033:0x7fe013689c03
[  133.423749] Code: Bad RIP value.
[  133.424624] RSP: 002b:00007ffc7288f418 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  133.425940] RAX: ffffffffffffffda RBX: 000056151fc63720 RCX: 00007fe013689c03
[  133.427225] RDX: 0000000000000040 RSI: 000056151fc63720 RDI: 0000000000000003
[  133.428481] RBP: 00007ffc72890b30 R08: 000056151fc60500 R09: 0000000000000010
[  133.429757] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000040
[  133.431041] R13: 000056151fc636e0 R14: 000056151fc616bc R15: 0000000000000080
[  133.432481] Modules linked in: mpls_iptunnel act_mirred act_tunnel_key cls_flower sch_ingress veth mpls_router ip_tunnel bareudp ip6_udp_tunnel udp_tunnel macsec udp_diag inet_diag unix_diag af_packet_diag netlink_diag binfmt_misc xt_MASQUERADE iptable_nat xt_addrtype xt_conntrack nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter bridge stp llc ebtable_filter ebtables overlay ip6table_filter ip6_tables iptable_filter sunrpc ext4 mbcache jbd2 pcspkr i2c_piix4 virtio_balloon joydev ip_tables xfs libcrc32c ata_generic qxl pata_acpi drm_ttm_helper ttm drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm ata_piix libata virtio_net net_failover virtio_console failover virtio_blk i2c_core virtio_pci virtio_ring serio_raw floppy virtio dm_mirror dm_region_hash dm_log dm_mod
[  133.444045] CR2: 0000000000000000
[  133.445082] ---[ end trace f4aeee1958fd1638 ]---
[  133.446236] RIP: 0010:0x0
[  133.447180] Code: Bad RIP value.
[  133.448152] RSP: 0018:ffffb79980003d50 EFLAGS: 00010246
[  133.449363] RAX: 0000000080000102 RBX: ffff9de2fe0d6600 RCX: ffff9de2fe5e9d00
[  133.450835] RDX: 0000000000000000 RSI: ffff9de2fe5e9d00 RDI: ffff9de2fc21b400
[  133.452237] RBP: ffff9de2fe5e9d00 R08: 0000000000000000 R09: 0000000000000000
[  133.453722] R10: ffff9de2fbc6be22 R11: ffff9de2fe0d6600 R12: ffff9de2fc21b400
[  133.455149] R13: ffff9de2fe0d6628 R14: 0000000000000001 R15: 0000000000000003
[  133.456520] FS:  00007fe014918740(0000) GS:ffff9de2fec00000(0000) knlGS:0000000000000000
[  133.458046] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  133.459342] CR2: ffffffffffffffd6 CR3: 000000003bb72000 CR4: 00000000000006f0
[  133.460782] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  133.462240] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  133.463697] Kernel panic - not syncing: Fatal exception in interrupt
[  133.465226] Kernel Offset: 0xfa00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  133.467025] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

Fixes: aaa0c23cb901 ("Fix dst_neigh_lookup/dst_neigh_lookup_skb return value handling bug")
Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -427,7 +427,15 @@ static inline struct neighbour *dst_neig
 static inline struct neighbour *dst_neigh_lookup_skb(const struct dst_entry *dst,
 						     struct sk_buff *skb)
 {
-	struct neighbour *n =  dst->ops->neigh_lookup(dst, skb, NULL);
+	struct neighbour *n = NULL;
+
+	/* The packets from tunnel devices (eg bareudp) may have only
+	 * metadata in the dst pointer of skb. Hence a pointer check of
+	 * neigh_lookup is needed.
+	 */
+	if (dst->ops->neigh_lookup)
+		n = dst->ops->neigh_lookup(dst, skb, NULL);
+
 	return IS_ERR(n) ? NULL : n;
 }
 


