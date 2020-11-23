Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28212C06F8
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731667AbgKWMgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:36:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731628AbgKWMgL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:36:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1588221F1;
        Mon, 23 Nov 2020 12:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134970;
        bh=t6R4CbITu2uIuaeJ1NJEzxNodkHNClQ8mtBqZzLVrng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m1/CgQ3VKu02hCmdwzEQFAxU2v2pwHIbwAXKskKljC1ixPKuGD4S7z0MHzH3hWRxi
         r1znmD5ZJZWgylcZABDpJXTQzEZX02UUO8qT37dhgm6LsHeKieCjDbwCHH0aTAYDXw
         9I1sTTAm3JNQ5EJuSt28IPT7CYWsqPWTkJymnleo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 027/158] sctp: change to hold/put transport for proto_unreach_timer
Date:   Mon, 23 Nov 2020 13:20:55 +0100
Message-Id: <20201123121821.244550383@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
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
@@ -449,7 +449,7 @@ void sctp_icmp_proto_unreachable(struct
 		else {
 			if (!mod_timer(&t->proto_unreach_timer,
 						jiffies + (HZ/20)))
-				sctp_association_hold(asoc);
+				sctp_transport_hold(t);
 		}
 	} else {
 		struct net *net = sock_net(sk);
@@ -458,7 +458,7 @@ void sctp_icmp_proto_unreachable(struct
 			 "encountered!\n", __func__);
 
 		if (del_timer(&t->proto_unreach_timer))
-			sctp_association_put(asoc);
+			sctp_transport_put(t);
 
 		sctp_do_sm(net, SCTP_EVENT_T_OTHER,
 			   SCTP_ST_OTHER(SCTP_EVENT_ICMP_PROTO_UNREACH),
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -419,7 +419,7 @@ void sctp_generate_proto_unreach_event(s
 		/* Try again later.  */
 		if (!mod_timer(&transport->proto_unreach_timer,
 				jiffies + (HZ/20)))
-			sctp_association_hold(asoc);
+			sctp_transport_hold(transport);
 		goto out_unlock;
 	}
 
@@ -435,7 +435,7 @@ void sctp_generate_proto_unreach_event(s
 
 out_unlock:
 	bh_unlock_sock(sk);
-	sctp_association_put(asoc);
+	sctp_transport_put(transport);
 }
 
  /* Handle the timeout of the RE-CONFIG timer. */
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -133,7 +133,7 @@ void sctp_transport_free(struct sctp_tra
 
 	/* Delete the ICMP proto unreachable timer if it's active. */
 	if (del_timer(&transport->proto_unreach_timer))
-		sctp_association_put(transport->asoc);
+		sctp_transport_put(transport);
 
 	sctp_transport_put(transport);
 }


