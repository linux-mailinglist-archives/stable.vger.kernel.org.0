Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC55F22638D
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgGTPiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:38:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729076AbgGTPiI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:38:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56EE122CB2;
        Mon, 20 Jul 2020 15:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259487;
        bh=uTypaYNpDvhD/WQgHpjQn5uDImVBBqB+Zmg+rdbuEVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1np7rqd0DlrwRFU9NyzMQt1UOlKIusKO35mapZHRCF4oWgN7n3lcnmAnBXcH1Zrgs
         TBPkx9hh8zw/FWR9Rdo1R/SdIHUFPcfZI62Y8rtDoEIj7/NR/85Xbvdb7GCNh0mC4G
         9lS5KwIQb5azFfFyLpBl6LO+2xj4Wx6XZ+fkqnHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Christoph Paasch <cpaasch@apple.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 25/58] tcp: make sure listeners dont initialize congestion-control state
Date:   Mon, 20 Jul 2020 17:36:41 +0200
Message-Id: <20200720152748.406908111@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
References: <20200720152747.127988571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Paasch <cpaasch@apple.com>

[ Upstream commit ce69e563b325f620863830c246a8698ccea52048 ]

syzkaller found its way into setsockopt with TCP_CONGESTION "cdg".
tcp_cdg_init() does a kcalloc to store the gradients. As sk_clone_lock
just copies all the memory, the allocated pointer will be copied as
well, if the app called setsockopt(..., TCP_CONGESTION) on the listener.
If now the socket will be destroyed before the congestion-control
has properly been initialized (through a call to tcp_init_transfer), we
will end up freeing memory that does not belong to that particular
socket, opening the door to a double-free:

[   11.413102] ==================================================================
[   11.414181] BUG: KASAN: double-free or invalid-free in tcp_cleanup_congestion_control+0x58/0xd0
[   11.415329]
[   11.415560] CPU: 3 PID: 4884 Comm: syz-executor.5 Not tainted 5.8.0-rc2 #80
[   11.416544] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[   11.418148] Call Trace:
[   11.418534]  <IRQ>
[   11.418834]  dump_stack+0x7d/0xb0
[   11.419297]  print_address_description.constprop.0+0x1a/0x210
[   11.422079]  kasan_report_invalid_free+0x51/0x80
[   11.423433]  __kasan_slab_free+0x15e/0x170
[   11.424761]  kfree+0x8c/0x230
[   11.425157]  tcp_cleanup_congestion_control+0x58/0xd0
[   11.425872]  tcp_v4_destroy_sock+0x57/0x5a0
[   11.426493]  inet_csk_destroy_sock+0x153/0x2c0
[   11.427093]  tcp_v4_syn_recv_sock+0xb29/0x1100
[   11.427731]  tcp_get_cookie_sock+0xc3/0x4a0
[   11.429457]  cookie_v4_check+0x13d0/0x2500
[   11.433189]  tcp_v4_do_rcv+0x60e/0x780
[   11.433727]  tcp_v4_rcv+0x2869/0x2e10
[   11.437143]  ip_protocol_deliver_rcu+0x23/0x190
[   11.437810]  ip_local_deliver+0x294/0x350
[   11.439566]  __netif_receive_skb_one_core+0x15d/0x1a0
[   11.441995]  process_backlog+0x1b1/0x6b0
[   11.443148]  net_rx_action+0x37e/0xc40
[   11.445361]  __do_softirq+0x18c/0x61a
[   11.445881]  asm_call_on_stack+0x12/0x20
[   11.446409]  </IRQ>
[   11.446716]  do_softirq_own_stack+0x34/0x40
[   11.447259]  do_softirq.part.0+0x26/0x30
[   11.447827]  __local_bh_enable_ip+0x46/0x50
[   11.448406]  ip_finish_output2+0x60f/0x1bc0
[   11.450109]  __ip_queue_xmit+0x71c/0x1b60
[   11.451861]  __tcp_transmit_skb+0x1727/0x3bb0
[   11.453789]  tcp_rcv_state_process+0x3070/0x4d3a
[   11.456810]  tcp_v4_do_rcv+0x2ad/0x780
[   11.457995]  __release_sock+0x14b/0x2c0
[   11.458529]  release_sock+0x4a/0x170
[   11.459005]  __inet_stream_connect+0x467/0xc80
[   11.461435]  inet_stream_connect+0x4e/0xa0
[   11.462043]  __sys_connect+0x204/0x270
[   11.465515]  __x64_sys_connect+0x6a/0xb0
[   11.466088]  do_syscall_64+0x3e/0x70
[   11.466617]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   11.467341] RIP: 0033:0x7f56046dc469
[   11.467844] Code: Bad RIP value.
[   11.468282] RSP: 002b:00007f5604dccdd8 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
[   11.469326] RAX: ffffffffffffffda RBX: 000000000068bf00 RCX: 00007f56046dc469
[   11.470379] RDX: 0000000000000010 RSI: 0000000020000000 RDI: 0000000000000004
[   11.471311] RBP: 00000000ffffffff R08: 0000000000000000 R09: 0000000000000000
[   11.472286] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[   11.473341] R13: 000000000041427c R14: 00007f5604dcd5c0 R15: 0000000000000003
[   11.474321]
[   11.474527] Allocated by task 4884:
[   11.475031]  save_stack+0x1b/0x40
[   11.475548]  __kasan_kmalloc.constprop.0+0xc2/0xd0
[   11.476182]  tcp_cdg_init+0xf0/0x150
[   11.476744]  tcp_init_congestion_control+0x9b/0x3a0
[   11.477435]  tcp_set_congestion_control+0x270/0x32f
[   11.478088]  do_tcp_setsockopt.isra.0+0x521/0x1a00
[   11.478744]  __sys_setsockopt+0xff/0x1e0
[   11.479259]  __x64_sys_setsockopt+0xb5/0x150
[   11.479895]  do_syscall_64+0x3e/0x70
[   11.480395]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   11.481097]
[   11.481321] Freed by task 4872:
[   11.481783]  save_stack+0x1b/0x40
[   11.482230]  __kasan_slab_free+0x12c/0x170
[   11.482839]  kfree+0x8c/0x230
[   11.483240]  tcp_cleanup_congestion_control+0x58/0xd0
[   11.483948]  tcp_v4_destroy_sock+0x57/0x5a0
[   11.484502]  inet_csk_destroy_sock+0x153/0x2c0
[   11.485144]  tcp_close+0x932/0xfe0
[   11.485642]  inet_release+0xc1/0x1c0
[   11.486131]  __sock_release+0xc0/0x270
[   11.486697]  sock_close+0xc/0x10
[   11.487145]  __fput+0x277/0x780
[   11.487632]  task_work_run+0xeb/0x180
[   11.488118]  __prepare_exit_to_usermode+0x15a/0x160
[   11.488834]  do_syscall_64+0x4a/0x70
[   11.489326]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Wei Wang fixed a part of these CDG-malloc issues with commit c12014440750
("tcp: memset ca_priv data to 0 properly").

This patch here fixes the listener-scenario: We make sure that listeners
setting the congestion-control through setsockopt won't initialize it
(thus CDG never allocates on listeners). For those who use AF_UNSPEC to
reuse a socket, tcp_disconnect() is changed to cleanup afterwards.

(The issue can be reproduced at least down to v4.4.x.)

Cc: Wei Wang <weiwan@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Fixes: 2b0a8c9eee81 ("tcp: add CDG congestion control")
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c      |    3 +++
 net/ipv4/tcp_cong.c |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2259,6 +2259,9 @@ int tcp_disconnect(struct sock *sk, int
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
 	tp->snd_cwnd_cnt = 0;
 	tp->window_clamp = 0;
+	if (icsk->icsk_ca_ops->release)
+		icsk->icsk_ca_ops->release(sk);
+	memset(icsk->icsk_ca_priv, 0, sizeof(icsk->icsk_ca_priv));
 	tcp_set_ca_state(sk, TCP_CA_Open);
 	tcp_clear_retrans(tp);
 	tp->total_retrans = 0;
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -201,7 +201,7 @@ static void tcp_reinit_congestion_contro
 	icsk->icsk_ca_ops = ca;
 	icsk->icsk_ca_setsockopt = 1;
 
-	if (sk->sk_state != TCP_CLOSE)
+	if (!((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
 		tcp_init_congestion_control(sk);
 }
 


