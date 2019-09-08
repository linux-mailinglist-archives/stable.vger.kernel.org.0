Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7F0ACD76
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731701AbfIHMtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:49:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731679AbfIHMtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:49:46 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 015D9218AC;
        Sun,  8 Sep 2019 12:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946985;
        bh=eQlVCz7A4VtsmN4UIi6xwVpu5z5TDNmOHLMxu/wasDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yPFehOyL9TRXpfLVWwRTTgR8e6cDI4YQjm9tktSTgKgYKlNaEB8MbxuT2MMWmLFQ3
         oxx0gCbiuSZ2CY/9pLwqEUyz5AP8agvQIGo23CVfiOJv0abP1qFsynzuUJ+T69tKcI
         y1/ArGsqaU6EvpEdYAYlc/1iqrHc4Vp2Y/oe6mW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Li Shuang <shuali@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 18/94] net/sched: pfifo_fast: fix wrong dereference when qdisc is reset
Date:   Sun,  8 Sep 2019 13:41:14 +0100
Message-Id: <20190908121150.955754187@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 04d37cf46a773910f75fefaa9f9488f42bfe1fe2 ]

Now that 'TCQ_F_CPUSTATS' bit can be cleared, depending on the value of
'TCQ_F_NOLOCK' bit in the parent qdisc, we need to be sure that per-cpu
counters are present when 'reset()' is called for pfifo_fast qdiscs.
Otherwise, the following script:

 # tc q a dev lo handle 1: root htb default 100
 # tc c a dev lo parent 1: classid 1:100 htb \
 > rate 95Mbit ceil 100Mbit burst 64k
 [...]
 # tc f a dev lo parent 1: protocol arp basic classid 1:100
 [...]
 # tc q a dev lo parent 1:100 handle 100: pfifo_fast
 [...]
 # tc q d dev lo root

can generate the following splat:

 Unable to handle kernel paging request at virtual address dfff2c01bd148000
 Mem abort info:
   ESR = 0x96000004
   Exception class = DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
 Data abort info:
   ISV = 0, ISS = 0x00000004
   CM = 0, WnR = 0
 [dfff2c01bd148000] address between user and kernel address ranges
 Internal error: Oops: 96000004 [#1] SMP
 [...]
 pstate: 80000005 (Nzcv daif -PAN -UAO)
 pc : pfifo_fast_reset+0x280/0x4d8
 lr : pfifo_fast_reset+0x21c/0x4d8
 sp : ffff800d09676fa0
 x29: ffff800d09676fa0 x28: ffff200012ee22e4
 x27: dfff200000000000 x26: 0000000000000000
 x25: ffff800ca0799958 x24: ffff1001940f332b
 x23: 0000000000000007 x22: ffff200012ee1ab8
 x21: 0000600de8a40000 x20: 0000000000000000
 x19: ffff800ca0799900 x18: 0000000000000000
 x17: 0000000000000002 x16: 0000000000000000
 x15: 0000000000000000 x14: 0000000000000000
 x13: 0000000000000000 x12: ffff1001b922e6e2
 x11: 1ffff001b922e6e1 x10: 0000000000000000
 x9 : 1ffff001b922e6e1 x8 : dfff200000000000
 x7 : 0000000000000000 x6 : 0000000000000000
 x5 : 1fffe400025dc45c x4 : 1fffe400025dc357
 x3 : 00000c01bd148000 x2 : 0000600de8a40000
 x1 : 0000000000000007 x0 : 0000600de8a40004
 Call trace:
  pfifo_fast_reset+0x280/0x4d8
  qdisc_reset+0x6c/0x370
  htb_reset+0x150/0x3b8 [sch_htb]
  qdisc_reset+0x6c/0x370
  dev_deactivate_queue.constprop.5+0xe0/0x1a8
  dev_deactivate_many+0xd8/0x908
  dev_deactivate+0xe4/0x190
  qdisc_graft+0x88c/0xbd0
  tc_get_qdisc+0x418/0x8a8
  rtnetlink_rcv_msg+0x3a8/0xa78
  netlink_rcv_skb+0x18c/0x328
  rtnetlink_rcv+0x28/0x38
  netlink_unicast+0x3c4/0x538
  netlink_sendmsg+0x538/0x9a0
  sock_sendmsg+0xac/0xf8
  ___sys_sendmsg+0x53c/0x658
  __sys_sendmsg+0xc8/0x140
  __arm64_sys_sendmsg+0x74/0xa8
  el0_svc_handler+0x164/0x468
  el0_svc+0x10/0x14
 Code: 910012a0 92400801 d343fc03 11000c21 (38fb6863)

Fix this by testing the value of 'TCQ_F_CPUSTATS' bit in 'qdisc->flags',
before dereferencing 'qdisc->cpu_qstats'.

Changes since v1:
 - coding style improvements, thanks to Stefano Brivio

Fixes: 8a53e616de29 ("net: sched: when clearing NOLOCK, clear TCQ_F_CPUSTATS, too")
CC: Paolo Abeni <pabeni@redhat.com>
Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_generic.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -692,11 +692,14 @@ static void pfifo_fast_reset(struct Qdis
 			kfree_skb(skb);
 	}
 
-	for_each_possible_cpu(i) {
-		struct gnet_stats_queue *q = per_cpu_ptr(qdisc->cpu_qstats, i);
+	if (qdisc_is_percpu_stats(qdisc)) {
+		for_each_possible_cpu(i) {
+			struct gnet_stats_queue *q;
 
-		q->backlog = 0;
-		q->qlen = 0;
+			q = per_cpu_ptr(qdisc->cpu_qstats, i);
+			q->backlog = 0;
+			q->qlen = 0;
+		}
 	}
 }
 


