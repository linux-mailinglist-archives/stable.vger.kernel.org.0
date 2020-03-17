Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A33D188150
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgCQLHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727843AbgCQLHx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:07:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CA1F206EC;
        Tue, 17 Mar 2020 11:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443272;
        bh=HZyQ0SGrjfwxWlJr+71n793Z8r4Ih9BW1zq3GkwkgiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cm4VZI5SRQlWat8vF5F/h9MEoZCafRCWj7mZrIdQ10fQbwzv5PHjnlv2MxhMcEfFl
         mG4lexM9U/1Qgk/OnG4be1K0naVvt0fX5iAOIzNTYNx90TXybe2VJOTqRUmbQIGWxO
         VdFQvehq+pBLaazVjAs8IYvKwPJr39hhmISwAMrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 031/151] slip: make slhc_compress() more robust against malicious packets
Date:   Tue, 17 Mar 2020 11:54:01 +0100
Message-Id: <20200317103328.887144898@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 110a40dfb708fe940a3f3704d470e431c368d256 ]

Before accessing various fields in IPV4 network header
and TCP header, make sure the packet :

- Has IP version 4 (ip->version == 4)
- Has not a silly network length (ip->ihl >= 5)
- Is big enough to hold network and transport headers
- Has not a silly TCP header size (th->doff >= sizeof(struct tcphdr) / 4)

syzbot reported :

BUG: KMSAN: uninit-value in slhc_compress+0x5b9/0x2e60 drivers/net/slip/slhc.c:270
CPU: 0 PID: 11728 Comm: syz-executor231 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 slhc_compress+0x5b9/0x2e60 drivers/net/slip/slhc.c:270
 ppp_send_frame drivers/net/ppp/ppp_generic.c:1637 [inline]
 __ppp_xmit_process+0x1902/0x2970 drivers/net/ppp/ppp_generic.c:1495
 ppp_xmit_process+0x147/0x2f0 drivers/net/ppp/ppp_generic.c:1516
 ppp_write+0x6bb/0x790 drivers/net/ppp/ppp_generic.c:512
 do_loop_readv_writev fs/read_write.c:717 [inline]
 do_iter_write+0x812/0xdc0 fs/read_write.c:1000
 compat_writev+0x2df/0x5a0 fs/read_write.c:1351
 do_compat_pwritev64 fs/read_write.c:1400 [inline]
 __do_compat_sys_pwritev fs/read_write.c:1420 [inline]
 __se_compat_sys_pwritev fs/read_write.c:1414 [inline]
 __ia32_compat_sys_pwritev+0x349/0x3f0 fs/read_write.c:1414
 do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
 do_fast_syscall_32+0x3c7/0x6e0 arch/x86/entry/common.c:410
 entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f7cd99
Code: 90 e8 0b 00 00 00 f3 90 0f ae e8 eb f9 8d 74 26 00 89 3c 24 c3 90 90 90 90 90 90 90 90 90 90 90 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ffdb84ac EFLAGS: 00000217 ORIG_RAX: 000000000000014e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000200001c0
RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000040047459 R08: 0000000000000000 R09: 0000000000000000
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
 ppp_write+0x115/0x790 drivers/net/ppp/ppp_generic.c:500
 do_loop_readv_writev fs/read_write.c:717 [inline]
 do_iter_write+0x812/0xdc0 fs/read_write.c:1000
 compat_writev+0x2df/0x5a0 fs/read_write.c:1351
 do_compat_pwritev64 fs/read_write.c:1400 [inline]
 __do_compat_sys_pwritev fs/read_write.c:1420 [inline]
 __se_compat_sys_pwritev fs/read_write.c:1414 [inline]
 __ia32_compat_sys_pwritev+0x349/0x3f0 fs/read_write.c:1414
 do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
 do_fast_syscall_32+0x3c7/0x6e0 arch/x86/entry/common.c:410
 entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139

Fixes: b5451d783ade ("slip: Move the SLIP drivers")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/slip/slhc.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/net/slip/slhc.c
+++ b/drivers/net/slip/slhc.c
@@ -232,7 +232,7 @@ slhc_compress(struct slcompress *comp, u
 	struct cstate *cs = lcs->next;
 	unsigned long deltaS, deltaA;
 	short changes = 0;
-	int hlen;
+	int nlen, hlen;
 	unsigned char new_seq[16];
 	unsigned char *cp = new_seq;
 	struct iphdr *ip;
@@ -248,6 +248,8 @@ slhc_compress(struct slcompress *comp, u
 		return isize;
 
 	ip = (struct iphdr *) icp;
+	if (ip->version != 4 || ip->ihl < 5)
+		return isize;
 
 	/* Bail if this packet isn't TCP, or is an IP fragment */
 	if (ip->protocol != IPPROTO_TCP || (ntohs(ip->frag_off) & 0x3fff)) {
@@ -258,10 +260,14 @@ slhc_compress(struct slcompress *comp, u
 			comp->sls_o_tcp++;
 		return isize;
 	}
-	/* Extract TCP header */
+	nlen = ip->ihl * 4;
+	if (isize < nlen + sizeof(*th))
+		return isize;
 
-	th = (struct tcphdr *)(((unsigned char *)ip) + ip->ihl*4);
-	hlen = ip->ihl*4 + th->doff*4;
+	th = (struct tcphdr *)(icp + nlen);
+	if (th->doff < sizeof(struct tcphdr) / 4)
+		return isize;
+	hlen = nlen + th->doff * 4;
 
 	/*  Bail if the TCP packet isn't `compressible' (i.e., ACK isn't set or
 	 *  some other control bit is set). Also uncompressible if


