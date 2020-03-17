Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 376BE187EEC
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 11:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgCQK5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726898AbgCQK5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:57:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A6A02073E;
        Tue, 17 Mar 2020 10:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442633;
        bh=Oe3hXxBsoQiN/trHS0kxJHdVpRq9GDRqGxypdn6kNRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+dornV8VtbrMI2Br7S3l33BkyB2t9glEQxgRMAh5hd0HX47oGzKaJIF4kYzNv0T3
         Uqukv/Veg4l27XjW4GqcdnbyuJ7RO76CbPdRbLO07CeFuF1bHc+NzlENiYpwNNmY8T
         O06KPRYPBo0GGEjNZz85oPENyLEWaSZIFT8unlLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 04/89] gre: fix uninit-value in __iptunnel_pull_header
Date:   Tue, 17 Mar 2020 11:54:13 +0100
Message-Id: <20200317103300.308746795@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 17c25cafd4d3e74c83dce56b158843b19c40b414 ]

syzbot found an interesting case of the kernel reading
an uninit-value [1]

Problem is in the handling of ETH_P_WCCP in gre_parse_header()

We look at the byte following GRE options to eventually decide
if the options are four bytes longer.

Use skb_header_pointer() to not pull bytes if we found
that no more bytes were needed.

All callers of gre_parse_header() are properly using pskb_may_pull()
anyway before proceeding to next header.

[1]
BUG: KMSAN: uninit-value in pskb_may_pull include/linux/skbuff.h:2303 [inline]
BUG: KMSAN: uninit-value in __iptunnel_pull_header+0x30c/0xbd0 net/ipv4/ip_tunnel_core.c:94
CPU: 1 PID: 11784 Comm: syz-executor940 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 pskb_may_pull include/linux/skbuff.h:2303 [inline]
 __iptunnel_pull_header+0x30c/0xbd0 net/ipv4/ip_tunnel_core.c:94
 iptunnel_pull_header include/net/ip_tunnels.h:411 [inline]
 gre_rcv+0x15e/0x19c0 net/ipv6/ip6_gre.c:606
 ip6_protocol_deliver_rcu+0x181b/0x22c0 net/ipv6/ip6_input.c:432
 ip6_input_finish net/ipv6/ip6_input.c:473 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ip6_input net/ipv6/ip6_input.c:482 [inline]
 ip6_mc_input+0xdf2/0x1460 net/ipv6/ip6_input.c:576
 dst_input include/net/dst.h:442 [inline]
 ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ipv6_rcv+0x683/0x710 net/ipv6/ip6_input.c:306
 __netif_receive_skb_one_core net/core/dev.c:5198 [inline]
 __netif_receive_skb net/core/dev.c:5312 [inline]
 netif_receive_skb_internal net/core/dev.c:5402 [inline]
 netif_receive_skb+0x66b/0xf20 net/core/dev.c:5461
 tun_rx_batched include/linux/skbuff.h:4321 [inline]
 tun_get_user+0x6aef/0x6f60 drivers/net/tun.c:1997
 tun_chr_write_iter+0x1f2/0x360 drivers/net/tun.c:2026
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:483 [inline]
 __vfs_write+0xa5a/0xca0 fs/read_write.c:496
 vfs_write+0x44a/0x8f0 fs/read_write.c:558
 ksys_write+0x267/0x450 fs/read_write.c:611
 __do_sys_write fs/read_write.c:623 [inline]
 __se_sys_write fs/read_write.c:620 [inline]
 __ia32_sys_write+0xdb/0x120 fs/read_write.c:620
 do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
 do_fast_syscall_32+0x3c7/0x6e0 arch/x86/entry/common.c:410
 entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f62d99
Code: 90 e8 0b 00 00 00 f3 90 0f ae e8 eb f9 8d 74 26 00 89 3c 24 c3 90 90 90 90 90 90 90 90 90 90 90 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000fffedb2c EFLAGS: 00000217 ORIG_RAX: 0000000000000004
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020002580
RDX: 0000000000000fca RSI: 0000000000000036 RDI: 0000000000000004
RBP: 0000000000008914 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:82
 slab_alloc_node mm/slub.c:2793 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4401
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1051 [inline]
 alloc_skb_with_frags+0x18c/0xa70 net/core/skbuff.c:5766
 sock_alloc_send_pskb+0xada/0xc60 net/core/sock.c:2242
 tun_alloc_skb drivers/net/tun.c:1529 [inline]
 tun_get_user+0x10ae/0x6f60 drivers/net/tun.c:1843
 tun_chr_write_iter+0x1f2/0x360 drivers/net/tun.c:2026
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:483 [inline]
 __vfs_write+0xa5a/0xca0 fs/read_write.c:496
 vfs_write+0x44a/0x8f0 fs/read_write.c:558
 ksys_write+0x267/0x450 fs/read_write.c:611
 __do_sys_write fs/read_write.c:623 [inline]
 __se_sys_write fs/read_write.c:620 [inline]
 __ia32_sys_write+0xdb/0x120 fs/read_write.c:620
 do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
 do_fast_syscall_32+0x3c7/0x6e0 arch/x86/entry/common.c:410
 entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139

Fixes: 95f5c64c3c13 ("gre: Move utility functions to common headers")
Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/gre_demux.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/net/ipv4/gre_demux.c
+++ b/net/ipv4/gre_demux.c
@@ -61,7 +61,9 @@ int gre_del_protocol(const struct gre_pr
 }
 EXPORT_SYMBOL_GPL(gre_del_protocol);
 
-/* Fills in tpi and returns header length to be pulled. */
+/* Fills in tpi and returns header length to be pulled.
+ * Note that caller must use pskb_may_pull() before pulling GRE header.
+ */
 int gre_parse_header(struct sk_buff *skb, struct tnl_ptk_info *tpi,
 		     bool *csum_err, __be16 proto, int nhs)
 {
@@ -115,8 +117,14 @@ int gre_parse_header(struct sk_buff *skb
 	 * - When dealing with WCCPv2, Skip extra 4 bytes in GRE header
 	 */
 	if (greh->flags == 0 && tpi->proto == htons(ETH_P_WCCP)) {
+		u8 _val, *val;
+
+		val = skb_header_pointer(skb, nhs + hdr_len,
+					 sizeof(_val), &_val);
+		if (!val)
+			return -EINVAL;
 		tpi->proto = proto;
-		if ((*(u8 *)options & 0xF0) != 0x40)
+		if ((*val & 0xF0) != 0x40)
 			hdr_len += 4;
 	}
 	tpi->hdr_len = hdr_len;


