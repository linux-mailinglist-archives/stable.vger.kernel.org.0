Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1592576DE5
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbfGZPZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728508AbfGZPZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:25:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC3AB22CB8;
        Fri, 26 Jul 2019 15:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154749;
        bh=JbLY78NHtun1l2hrXb1d5IX/OCdO4x3sSMEKJIDV+d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o1MMBW1t0uVEzvTcN2XXONoIwprQBsAc6YdlsNKPsP4pAts4rhT4VRvS0pYCIoga4
         4yNbEVQg2JASO1C/3TWRJDU1QmvLDLsH2SX3Thp7rwVA7elB2x8lJxtNFnsLxxVcdM
         D9kQTQ2h60RZG73rRtqaT19PE0p0NXQvIJiqvEBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 14/66] net_sched: unset TCQ_F_CAN_BYPASS when adding filters
Date:   Fri, 26 Jul 2019 17:24:13 +0200
Message-Id: <20190726152303.389623216@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 3f05e6886a595c9a29a309c52f45326be917823c ]

For qdisc's that support TC filters and set TCQ_F_CAN_BYPASS,
notably fq_codel, it makes no sense to let packets bypass the TC
filters we setup in any scenario, otherwise our packets steering
policy could not be enforced.

This can be reproduced easily with the following script:

 ip li add dev dummy0 type dummy
 ifconfig dummy0 up
 tc qd add dev dummy0 root fq_codel
 tc filter add dev dummy0 parent 8001: protocol arp basic action mirred egress redirect dev lo
 tc filter add dev dummy0 parent 8001: protocol ip basic action mirred egress redirect dev lo
 ping -I dummy0 192.168.112.1

Without this patch, packets are sent directly to dummy0 without
hitting any of the filters. With this patch, packets are redirected
to loopback as expected.

This fix is not perfect, it only unsets the flag but does not set it back
because we have to save the information somewhere in the qdisc if we
really want that. Note, both fq_codel and sfq clear this flag in their
->bind_tcf() but this is clearly not sufficient when we don't use any
class ID.

Fixes: 23624935e0c4 ("net_sched: TCQ_F_CAN_BYPASS generalization")
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_api.c      |    1 +
 net/sched/sch_fq_codel.c |    2 --
 net/sched/sch_sfq.c      |    2 --
 3 files changed, 1 insertion(+), 4 deletions(-)

--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2160,6 +2160,7 @@ replay:
 		tfilter_notify(net, skb, n, tp, block, q, parent, fh,
 			       RTM_NEWTFILTER, false, rtnl_held);
 		tfilter_put(tp, fh);
+		q->flags &= ~TCQ_F_CAN_BYPASS;
 	}
 
 errout:
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -596,8 +596,6 @@ static unsigned long fq_codel_find(struc
 static unsigned long fq_codel_bind(struct Qdisc *sch, unsigned long parent,
 			      u32 classid)
 {
-	/* we cannot bypass queue discipline anymore */
-	sch->flags &= ~TCQ_F_CAN_BYPASS;
 	return 0;
 }
 
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -824,8 +824,6 @@ static unsigned long sfq_find(struct Qdi
 static unsigned long sfq_bind(struct Qdisc *sch, unsigned long parent,
 			      u32 classid)
 {
-	/* we cannot bypass queue discipline anymore */
-	sch->flags &= ~TCQ_F_CAN_BYPASS;
 	return 0;
 }
 


