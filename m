Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687E32C0BE6
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgKWNcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:32:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:37024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729680AbgKWM1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:27:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A5C620728;
        Mon, 23 Nov 2020 12:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134428;
        bh=00yX7xkfYt4iLxj6ny5HpIFTko9DeQ7JDkK1wweJn7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5X77ExawcSjEr8TGaByEw2qB8c+78YX2sspnJs/UmroBHKsYskUK/NVBclYvJSTn
         Htm+PImcLq+U9+badi4lr+S/qjOdG+pcvVaDo0r5ap15aS0MhK9WDdSWar/kpLHGmA
         iPwgncgJPOWdPVTbR42xWMZWjkw7VQgxOgsl9/aE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 16/60] sctp: change to hold/put transport for proto_unreach_timer
Date:   Mon, 23 Nov 2020 13:21:58 +0100
Message-Id: <20201123121805.817403622@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.028396732@linuxfoundation.org>
References: <20201123121805.028396732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 057a10fa1f73d745c8e69aa54ab147715f5630ae ]

A call trace was found in Hangbin's Codenomicon testing with debug kernel:

  [ 2615.981988] ODEBUG: free active (active state 0) object type: timer_list hint: sctp_generate_proto_unreach_event+0x0/0x3a0 [sctp]
  [ 2615.995050] WARNING: CPU: 17 PID: 0 at lib/debugobjects.c:328 debug_print_object+0x199/0x2b0
  [ 2616.095934] RIP: 0010:debug_print_object+0x199/0x2b0
  [ 2616.191533] Call Trace:
  [ 2616.194265]  <IRQ>
  [ 2616.202068]  debug_check_no_obj_freed+0x25e/0x3f0
  [ 2616.207336]  slab_free_freelist_hook+0xeb/0x140
  [ 2616.220971]  kfree+0xd6/0x2c0
  [ 2616.224293]  rcu_do_batch+0x3bd/0xc70
  [ 2616.243096]  rcu_core+0x8b9/0xd00
  [ 2616.256065]  __do_softirq+0x23d/0xacd
  [ 2616.260166]  irq_exit+0x236/0x2a0
  [ 2616.263879]  smp_apic_timer_interrupt+0x18d/0x620
  [ 2616.269138]  apic_timer_interrupt+0xf/0x20
  [ 2616.273711]  </IRQ>

This is because it holds asoc when transport->proto_unreach_timer starts
and puts asoc when the timer stops, and without holding transport the
transport could be freed when the timer is still running.

So fix it by holding/putting transport instead for proto_unreach_timer
in transport, just like other timers in transport.

v1->v2:
  - Also use sctp_transport_put() for the "out_unlock:" path in
    sctp_generate_proto_unreach_event(), as Marcelo noticed.

Fixes: 50b5d6ad6382 ("sctp: Fix a race between ICMP protocol unreachable and connect()")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://lore.kernel.org/r/102788809b554958b13b95d33440f5448113b8d6.1605331373.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/input.c         |    4 ++--
 net/sctp/sm_sideeffect.c |    4 ++--
 net/sctp/transport.c     |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -453,7 +453,7 @@ void sctp_icmp_proto_unreachable(struct
 		else {
 			if (!mod_timer(&t->proto_unreach_timer,
 						jiffies + (HZ/20)))
-				sctp_association_hold(asoc);
+				sctp_transport_hold(t);
 		}
 	} else {
 		struct net *net = sock_net(sk);
@@ -462,7 +462,7 @@ void sctp_icmp_proto_unreachable(struct
 			 "encountered!\n", __func__);
 
 		if (del_timer(&t->proto_unreach_timer))
-			sctp_association_put(asoc);
+			sctp_transport_put(t);
 
 		sctp_do_sm(net, SCTP_EVENT_T_OTHER,
 			   SCTP_ST_OTHER(SCTP_EVENT_ICMP_PROTO_UNREACH),
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -418,7 +418,7 @@ void sctp_generate_proto_unreach_event(u
 		/* Try again later.  */
 		if (!mod_timer(&transport->proto_unreach_timer,
 				jiffies + (HZ/20)))
-			sctp_association_hold(asoc);
+			sctp_transport_hold(transport);
 		goto out_unlock;
 	}
 
@@ -434,7 +434,7 @@ void sctp_generate_proto_unreach_event(u
 
 out_unlock:
 	bh_unlock_sock(sk);
-	sctp_association_put(asoc);
+	sctp_transport_put(transport);
 }
 
  /* Handle the timeout of the RE-CONFIG timer. */
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -151,7 +151,7 @@ void sctp_transport_free(struct sctp_tra
 
 	/* Delete the ICMP proto unreachable timer if it's active. */
 	if (del_timer(&transport->proto_unreach_timer))
-		sctp_association_put(transport->asoc);
+		sctp_transport_put(transport);
 
 	sctp_transport_put(transport);
 }


