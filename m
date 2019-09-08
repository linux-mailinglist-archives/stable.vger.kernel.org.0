Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD9C7ACE06
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731646AbfIHMto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731594AbfIHMtn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:49:43 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D836218AC;
        Sun,  8 Sep 2019 12:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946982;
        bh=LP2tWWU6SNcc0eaVpBGE6cJjoSO6JWYhOXJUvaUUgV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfS0boKZm0gbsCgEjmWv604AMJosNj/0czasfci8Ri4WS2j7JC9Whbi2/NTs4JJ+g
         YPGxhEEPTWEB+Bg+7Sks4GbRhADNgtnXbjV2Yeb7JYUVl+ZILm0OTMLZXb2tsCNxb0
         jg2wv0SWThNW5TI6rEOLMVAHM4NTDpuPnrH5w7uE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Li Shuang <shuali@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 17/94] net/sched: pfifo_fast: fix wrong dereference in pfifo_fast_enqueue
Date:   Sun,  8 Sep 2019 13:41:13 +0100
Message-Id: <20190908121150.925637761@linuxfoundation.org>
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

[ Upstream commit 092e22e586236bba106a82113826a68080a03506 ]

Now that 'TCQ_F_CPUSTATS' bit can be cleared, depending on the value of
'TCQ_F_NOLOCK' bit in the parent qdisc, we can't assume anymore that
per-cpu counters are there in the error path of skb_array_produce().
Otherwise, the following splat can be seen:

 Unable to handle kernel paging request at virtual address 0000600dea430008
 Mem abort info:
   ESR = 0x96000005
   Exception class = DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
 Data abort info:
   ISV = 0, ISS = 0x00000005
   CM = 0, WnR = 0
 user pgtable: 64k pages, 48-bit VAs, pgdp = 000000007b97530e
 [0000600dea430008] pgd=0000000000000000, pud=0000000000000000
 Internal error: Oops: 96000005 [#1] SMP
[...]
 pstate: 10000005 (nzcV daif -PAN -UAO)
 pc : pfifo_fast_enqueue+0x524/0x6e8
 lr : pfifo_fast_enqueue+0x46c/0x6e8
 sp : ffff800d39376fe0
 x29: ffff800d39376fe0 x28: 1ffff001a07d1e40
 x27: ffff800d03e8f188 x26: ffff800d03e8f200
 x25: 0000000000000062 x24: ffff800d393772f0
 x23: 0000000000000000 x22: 0000000000000403
 x21: ffff800cca569a00 x20: ffff800d03e8ee00
 x19: ffff800cca569a10 x18: 00000000000000bf
 x17: 0000000000000000 x16: 0000000000000000
 x15: 0000000000000000 x14: ffff1001a726edd0
 x13: 1fffe4000276a9a4 x12: 0000000000000000
 x11: dfff200000000000 x10: ffff800d03e8f1a0
 x9 : 0000000000000003 x8 : 0000000000000000
 x7 : 00000000f1f1f1f1 x6 : ffff1001a726edea
 x5 : ffff800cca56a53c x4 : 1ffff001bf9a8003
 x3 : 1ffff001bf9a8003 x2 : 1ffff001a07d1dcb
 x1 : 0000600dea430000 x0 : 0000600dea430008
 Process ping (pid: 6067, stack limit = 0x00000000dc0aa557)
 Call trace:
  pfifo_fast_enqueue+0x524/0x6e8
  htb_enqueue+0x660/0x10e0 [sch_htb]
  __dev_queue_xmit+0x123c/0x2de0
  dev_queue_xmit+0x24/0x30
  ip_finish_output2+0xc48/0x1720
  ip_finish_output+0x548/0x9d8
  ip_output+0x334/0x788
  ip_local_out+0x90/0x138
  ip_send_skb+0x44/0x1d0
  ip_push_pending_frames+0x5c/0x78
  raw_sendmsg+0xed8/0x28d0
  inet_sendmsg+0xc4/0x5c0
  sock_sendmsg+0xac/0x108
  __sys_sendto+0x1ac/0x2a0
  __arm64_sys_sendto+0xc4/0x138
  el0_svc_handler+0x13c/0x298
  el0_svc+0x8/0xc
 Code: f9402e80 d538d081 91002000 8b010000 (885f7c03)

Fix this by testing the value of 'TCQ_F_CPUSTATS' bit in 'qdisc->flags',
before dereferencing 'qdisc->cpu_qstats'.

Fixes: 8a53e616de29 ("net: sched: when clearing NOLOCK, clear TCQ_F_CPUSTATS, too")
CC: Paolo Abeni <pabeni@redhat.com>
CC: Stefano Brivio <sbrivio@redhat.com>
Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_generic.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -624,8 +624,12 @@ static int pfifo_fast_enqueue(struct sk_
 
 	err = skb_array_produce(q, skb);
 
-	if (unlikely(err))
-		return qdisc_drop_cpu(skb, qdisc, to_free);
+	if (unlikely(err)) {
+		if (qdisc_is_percpu_stats(qdisc))
+			return qdisc_drop_cpu(skb, qdisc, to_free);
+		else
+			return qdisc_drop(skb, qdisc, to_free);
+	}
 
 	qdisc_update_stats_at_enqueue(qdisc, pkt_len);
 	return NET_XMIT_SUCCESS;


