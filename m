Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56D4816705F
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgBUHoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:44:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:39416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728031AbgBUHoh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:44:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D818207FD;
        Fri, 21 Feb 2020 07:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271076;
        bh=FRua610wSp+hISmJPGLxav2876D6fNeZkA358A2HiMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1MWXMF8NLd4Z56ogJV6H+IPNJflmORdXODmnADkfzVLhRNPbv/1+q7zQR2BCL8sI6
         tXqojAYaYWsATqH62lZq7Em51gy69c2cbZT6pFZiHISJOWh5KGjKIJQIJUZ1728iCg
         JA2PqJAWqRegjQLENEGPzDjyCbY905c69haGgnBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Ursula Braun <ubraun@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 003/399] net/smc: fix leak of kernel memory to user space
Date:   Fri, 21 Feb 2020 08:35:28 +0100
Message-Id: <20200221072402.667012935@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 457fed775c97ac2c0cd1672aaf2ff2c8a6235e87 ]

As nlmsg_put() does not clear the memory that is reserved,
it this the caller responsability to make sure all of this
memory will be written, in order to not reveal prior content.

While we are at it, we can provide the socket cookie even
if clsock is not set.

syzbot reported :

BUG: KMSAN: uninit-value in __arch_swab32 arch/x86/include/uapi/asm/swab.h:10 [inline]
BUG: KMSAN: uninit-value in __fswab32 include/uapi/linux/swab.h:59 [inline]
BUG: KMSAN: uninit-value in __swab32p include/uapi/linux/swab.h:179 [inline]
BUG: KMSAN: uninit-value in __be32_to_cpup include/uapi/linux/byteorder/little_endian.h:82 [inline]
BUG: KMSAN: uninit-value in get_unaligned_be32 include/linux/unaligned/access_ok.h:30 [inline]
BUG: KMSAN: uninit-value in ____bpf_skb_load_helper_32 net/core/filter.c:240 [inline]
BUG: KMSAN: uninit-value in ____bpf_skb_load_helper_32_no_cache net/core/filter.c:255 [inline]
BUG: KMSAN: uninit-value in bpf_skb_load_helper_32_no_cache+0x14a/0x390 net/core/filter.c:252
CPU: 1 PID: 5262 Comm: syz-executor.5 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 __arch_swab32 arch/x86/include/uapi/asm/swab.h:10 [inline]
 __fswab32 include/uapi/linux/swab.h:59 [inline]
 __swab32p include/uapi/linux/swab.h:179 [inline]
 __be32_to_cpup include/uapi/linux/byteorder/little_endian.h:82 [inline]
 get_unaligned_be32 include/linux/unaligned/access_ok.h:30 [inline]
 ____bpf_skb_load_helper_32 net/core/filter.c:240 [inline]
 ____bpf_skb_load_helper_32_no_cache net/core/filter.c:255 [inline]
 bpf_skb_load_helper_32_no_cache+0x14a/0x390 net/core/filter.c:252

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_kmalloc_large+0x73/0xc0 mm/kmsan/kmsan_hooks.c:128
 kmalloc_large_node_hook mm/slub.c:1406 [inline]
 kmalloc_large_node+0x282/0x2c0 mm/slub.c:3841
 __kmalloc_node_track_caller+0x44b/0x1200 mm/slub.c:4368
 __kmalloc_reserve net/core/skbuff.c:141 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:209
 alloc_skb include/linux/skbuff.h:1049 [inline]
 netlink_dump+0x44b/0x1ab0 net/netlink/af_netlink.c:2224
 __netlink_dump_start+0xbb2/0xcf0 net/netlink/af_netlink.c:2352
 netlink_dump_start include/linux/netlink.h:233 [inline]
 smc_diag_handler_dump+0x2ba/0x300 net/smc/smc_diag.c:242
 sock_diag_rcv_msg+0x211/0x610 net/core/sock_diag.c:256
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2477
 sock_diag_rcv+0x63/0x80 net/core/sock_diag.c:275
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x1248/0x14d0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 kernel_sendmsg+0x433/0x440 net/socket.c:679
 sock_no_sendpage+0x235/0x300 net/core/sock.c:2740
 kernel_sendpage net/socket.c:3776 [inline]
 sock_sendpage+0x1e1/0x2c0 net/socket.c:937
 pipe_to_sendpage+0x38c/0x4c0 fs/splice.c:458
 splice_from_pipe_feed fs/splice.c:512 [inline]
 __splice_from_pipe+0x539/0xed0 fs/splice.c:636
 splice_from_pipe fs/splice.c:671 [inline]
 generic_splice_sendpage+0x1d5/0x2d0 fs/splice.c:844
 do_splice_from fs/splice.c:863 [inline]
 do_splice fs/splice.c:1170 [inline]
 __do_sys_splice fs/splice.c:1447 [inline]
 __se_sys_splice+0x2380/0x3350 fs/splice.c:1427
 __x64_sys_splice+0x6e/0x90 fs/splice.c:1427
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Ursula Braun <ubraun@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_diag.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -39,16 +39,15 @@ static void smc_diag_msg_common_fill(str
 {
 	struct smc_sock *smc = smc_sk(sk);
 
+	memset(r, 0, sizeof(*r));
 	r->diag_family = sk->sk_family;
+	sock_diag_save_cookie(sk, r->id.idiag_cookie);
 	if (!smc->clcsock)
 		return;
 	r->id.idiag_sport = htons(smc->clcsock->sk->sk_num);
 	r->id.idiag_dport = smc->clcsock->sk->sk_dport;
 	r->id.idiag_if = smc->clcsock->sk->sk_bound_dev_if;
-	sock_diag_save_cookie(sk, r->id.idiag_cookie);
 	if (sk->sk_protocol == SMCPROTO_SMC) {
-		memset(&r->id.idiag_src, 0, sizeof(r->id.idiag_src));
-		memset(&r->id.idiag_dst, 0, sizeof(r->id.idiag_dst));
 		r->id.idiag_src[0] = smc->clcsock->sk->sk_rcv_saddr;
 		r->id.idiag_dst[0] = smc->clcsock->sk->sk_daddr;
 #if IS_ENABLED(CONFIG_IPV6)


