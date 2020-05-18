Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77BA1D84EA
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732310AbgERSAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732305AbgERSAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:00:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D27920715;
        Mon, 18 May 2020 18:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824836;
        bh=IqtOVMO1xQL9N6HB5WccWUYFi1WqsW1w9Q+1cmdET8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nb4/HnKbDwOQ+M34VgItPRH/pWxWAlPrxgbC+AWtX/NqNv7CyFmFHIb3w1B5Lu4nX
         5Fj1I70do0HuAHYv5A79yW5ShIAx2Tq3dQ0lK/JNg35UmAB2lvqvGtsNQUoYMqxhZw
         McgpBnuQAWOfqd6AcHeL1P6QOH7pZmhq4mLa/IgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 023/194] net_sched: fix tcm_parent in tc filter dump
Date:   Mon, 18 May 2020 19:35:13 +0200
Message-Id: <20200518173533.457904478@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit a7df4870d79b00742da6cc93ca2f336a71db77f7 ]

When we tell kernel to dump filters from root (ffff:ffff),
those filters on ingress (ffff:0000) are matched, but their
true parents must be dumped as they are. However, kernel
dumps just whatever we tell it, that is either ffff:ffff
or ffff:0000:

 $ nl-cls-list --dev=dummy0 --parent=root
 cls basic dev dummy0 id none parent root prio 49152 protocol ip match-all
 cls basic dev dummy0 id :1 parent root prio 49152 protocol ip match-all
 $ nl-cls-list --dev=dummy0 --parent=ffff:
 cls basic dev dummy0 id none parent ffff: prio 49152 protocol ip match-all
 cls basic dev dummy0 id :1 parent ffff: prio 49152 protocol ip match-all

This is confusing and misleading, more importantly this is
a regression since 4.15, so the old behavior must be restored.

And, when tc filters are installed on a tc class, the parent
should be the classid, rather than the qdisc handle. Commit
edf6711c9840 ("net: sched: remove classid and q fields from tcf_proto")
removed the classid we save for filters, we can just restore
this classid in tcf_block.

Steps to reproduce this:
 ip li set dev dummy0 up
 tc qd add dev dummy0 ingress
 tc filter add dev dummy0 parent ffff: protocol arp basic action pass
 tc filter show dev dummy0 root

Before this patch:
 filter protocol arp pref 49152 basic
 filter protocol arp pref 49152 basic handle 0x1
	action order 1: gact action pass
	 random type none pass val 0
	 index 1 ref 1 bind 1

After this patch:
 filter parent ffff: protocol arp pref 49152 basic
 filter parent ffff: protocol arp pref 49152 basic handle 0x1
 	action order 1: gact action pass
 	 random type none pass val 0
	 index 1 ref 1 bind 1

Fixes: a10fa20101ae ("net: sched: propagate q and parent from caller down to tcf_fill_node")
Fixes: edf6711c9840 ("net: sched: remove classid and q fields from tcf_proto")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h | 1 +
 net/sched/cls_api.c       | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index c30f914867e64..f1f8acb14b674 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -407,6 +407,7 @@ struct tcf_block {
 	struct mutex lock;
 	struct list_head chain_list;
 	u32 index; /* block index for shared blocks */
+	u32 classid; /* which class this block belongs to */
 	refcount_t refcnt;
 	struct net *net;
 	struct Qdisc *q;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index c2cdd0fc2e709..68c8fc6f535c7 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2005,6 +2005,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 		err = PTR_ERR(block);
 		goto errout;
 	}
+	block->classid = parent;
 
 	chain_index = tca[TCA_CHAIN] ? nla_get_u32(tca[TCA_CHAIN]) : 0;
 	if (chain_index > TC_ACT_EXT_VAL_MASK) {
@@ -2547,12 +2548,10 @@ static int tc_dump_tfilter(struct sk_buff *skb, struct netlink_callback *cb)
 			return skb->len;
 
 		parent = tcm->tcm_parent;
-		if (!parent) {
+		if (!parent)
 			q = dev->qdisc;
-			parent = q->handle;
-		} else {
+		else
 			q = qdisc_lookup(dev, TC_H_MAJ(tcm->tcm_parent));
-		}
 		if (!q)
 			goto out;
 		cops = q->ops->cl_ops;
@@ -2568,6 +2567,7 @@ static int tc_dump_tfilter(struct sk_buff *skb, struct netlink_callback *cb)
 		block = cops->tcf_block(q, cl, NULL);
 		if (!block)
 			goto out;
+		parent = block->classid;
 		if (tcf_block_shared(block))
 			q = NULL;
 	}
-- 
2.20.1



