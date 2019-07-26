Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFED76D63
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389633AbfGZPdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389628AbfGZPdW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:33:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A051218D4;
        Fri, 26 Jul 2019 15:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155201;
        bh=I8lIdewyWN4WEkd5GZx92YtQgBlT9zMW79sYzkF9Ko0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQEqnH/4pT/9rASHrYe7ihDSdrMuBiP2c0zbpugh/eWQ79IFvAwFsU530lKU+E1Kz
         uF3YIahBrzGEIKkcX1spNLHYVECzCMerFdim675xVw40fJiWA5SjJPP1d3H9Eul4Jx
         xOcu8NGkS2uWFZyMc140dvZtK+B7cUSU/j7S2mOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 29/50] net_sched: unset TCQ_F_CAN_BYPASS when adding filters
Date:   Fri, 26 Jul 2019 17:25:04 +0200
Message-Id: <20190726152303.612362667@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152300.760439618@linuxfoundation.org>
References: <20190726152300.760439618@linuxfoundation.org>
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
@@ -1325,6 +1325,7 @@ replay:
 			tcf_chain_tp_insert(chain, &chain_info, tp);
 		tfilter_notify(net, skb, n, tp, block, q, parent, fh,
 			       RTM_NEWTFILTER, false);
+		q->flags &= ~TCQ_F_CAN_BYPASS;
 	} else {
 		if (tp_created)
 			tcf_proto_destroy(tp, NULL);
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -600,8 +600,6 @@ static unsigned long fq_codel_find(struc
 static unsigned long fq_codel_bind(struct Qdisc *sch, unsigned long parent,
 			      u32 classid)
 {
-	/* we cannot bypass queue discipline anymore */
-	sch->flags &= ~TCQ_F_CAN_BYPASS;
 	return 0;
 }
 
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -828,8 +828,6 @@ static unsigned long sfq_find(struct Qdi
 static unsigned long sfq_bind(struct Qdisc *sch, unsigned long parent,
 			      u32 classid)
 {
-	/* we cannot bypass queue discipline anymore */
-	sch->flags &= ~TCQ_F_CAN_BYPASS;
 	return 0;
 }
 


