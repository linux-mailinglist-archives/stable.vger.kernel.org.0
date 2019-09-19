Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A795FB866B
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389807AbfISW3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:29:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406530AbfISWRw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:17:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D68702196E;
        Thu, 19 Sep 2019 22:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931471;
        bh=xm2I17chUjyy5gfS9Dzee/XgBwcBHHyXL+dh19MEKrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mtn0efHKazNigiysasTApGFrLtaSAQAQlcFv9jeN8phzeZpC5+Pa8ByoyCp6E0sFb
         mkUthZ15DTioSNO2fWaz3F/sK97dQruEPNddtWMXGTBnx5LK1B+ZhADlljaXgIM0MY
         bYE/mOqaUq26+jw6XE9FjUlLcjNdfZTGkd8aiMno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Vladimir Rutsky <rutsky@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH 4.14 58/59] tcp: Dont dequeue SYN/FIN-segments from write-queue
Date:   Fri, 20 Sep 2019 00:04:13 +0200
Message-Id: <20190919214808.429159608@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
References: <20190919214755.852282682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Paasch <cpaasch@apple.com>

If a SYN/FIN-segment is on the write-queue, skb->len is 0, but the
segment actually has been transmitted. end_seq and seq of the tcp_skb_cb
in that case will indicate this difference.

We should not remove such segments from the write-queue as we might be
in SYN_SENT-state and a retransmission-timer is running. When that one
fires, packets_out will be 1, but the write-queue would be empty,
resulting in:

[   61.280214] ------------[ cut here ]------------
[   61.281307] WARNING: CPU: 0 PID: 0 at net/ipv4/tcp_timer.c:429 tcp_retransmit_timer+0x18f9/0x2660
[   61.283498] Modules linked in:
[   61.284084] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.14.142 #58
[   61.285214] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.5.1 01/01/2011
[   61.286644] task: ffffffff8401e1c0 task.stack: ffffffff84000000
[   61.287758] RIP: 0010:tcp_retransmit_timer+0x18f9/0x2660
[   61.288715] RSP: 0018:ffff88806ce07cb8 EFLAGS: 00010206
[   61.289669] RAX: ffffffff8401e1c0 RBX: ffff88805c998b00 RCX: 0000000000000006
[   61.290968] RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffff88805c9994d8
[   61.292314] RBP: ffff88805c99919a R08: ffff88807fff901c R09: ffff88807fff9008
[   61.293547] R10: ffff88807fff9017 R11: ffff88807fff9010 R12: ffff88805c998b30
[   61.294834] R13: ffffffff844b9380 R14: 0000000000000000 R15: ffff88805c99930c
[   61.296086] FS:  0000000000000000(0000) GS:ffff88806ce00000(0000) knlGS:0000000000000000
[   61.297523] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   61.298646] CR2: 00007f721da50ff8 CR3: 0000000004014002 CR4: 00000000001606f0
[   61.299944] Call Trace:
[   61.300403]  <IRQ>
[   61.300806]  ? kvm_sched_clock_read+0x21/0x30
[   61.301689]  ? sched_clock+0x5/0x10
[   61.302433]  ? sched_clock_cpu+0x18/0x170
[   61.303173]  tcp_write_timer_handler+0x2c1/0x7a0
[   61.304038]  tcp_write_timer+0x13e/0x160
[   61.304794]  call_timer_fn+0x14a/0x5f0
[   61.305480]  ? tcp_write_timer_handler+0x7a0/0x7a0
[   61.306364]  ? __next_timer_interrupt+0x140/0x140
[   61.307229]  ? _raw_spin_unlock_irq+0x24/0x40
[   61.308033]  ? tcp_write_timer_handler+0x7a0/0x7a0
[   61.308887]  ? tcp_write_timer_handler+0x7a0/0x7a0
[   61.309760]  run_timer_softirq+0xc41/0x1080
[   61.310539]  ? trigger_dyntick_cpu.isra.33+0x180/0x180
[   61.311506]  ? ktime_get+0x13f/0x1c0
[   61.312232]  ? clockevents_program_event+0x10d/0x2f0
[   61.313158]  __do_softirq+0x20b/0x96b
[   61.313889]  irq_exit+0x1a7/0x1e0
[   61.314513]  smp_apic_timer_interrupt+0xfc/0x4d0
[   61.315386]  apic_timer_interrupt+0x8f/0xa0
[   61.316129]  </IRQ>

Followed by a panic.

So, before removing an skb with skb->len == 0, let's make sure that the
skb is really empty by checking the end_seq and seq.

This patch needs to be backported only to 4.14 and older (among those
that applied the backport of fdfc5c8594c2).

Fixes: fdfc5c8594c2 ("tcp: remove empty skb from write queue in error cases")
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Vladimir Rutsky <rutsky@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -922,7 +922,8 @@ static int tcp_send_mss(struct sock *sk,
  */
 static void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
 {
-	if (skb && !skb->len) {
+	if (skb && !skb->len &&
+	    TCP_SKB_CB(skb)->end_seq == TCP_SKB_CB(skb)->seq) {
 		tcp_unlink_write_queue(skb, sk);
 		tcp_check_send_head(sk, skb);
 		sk_wmem_free_skb(sk, skb);


