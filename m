Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A9F5EA0F3
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbiIZKnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236267AbiIZKmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:42:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B5DE90;
        Mon, 26 Sep 2022 03:24:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F37CA609D1;
        Mon, 26 Sep 2022 10:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1066FC433C1;
        Mon, 26 Sep 2022 10:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187857;
        bh=d2DtQtDp4JJPnrVB+mtoUIdTvXbw37ugwgs7rrKXT/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LF9/m3n6QtPtK9m3nGe9HLw9C08nSx6hTmlaL0E5LTLSlTot+Z696uARV5SORNG98
         iCr24ory/9HDn/zSvOuznee1pLntXiLotwE45O2TB80pPwY8aZr4/fodYrUf567U/s
         icjRuAjejXQqe/Nwj2lEF/ycnSmyvmipTn/ocr8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/120] net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs
Date:   Mon, 26 Sep 2022 12:11:56 +0200
Message-Id: <20220926100754.089287316@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 1461d212ab277d8bba1a753d33e9afe03d81f9d4 ]

taprio can only operate as root qdisc, and to that end, there exists the
following check in taprio_init(), just as in mqprio:

	if (sch->parent != TC_H_ROOT)
		return -EOPNOTSUPP;

And indeed, when we try to attach taprio to an mqprio child, it fails as
expected:

$ tc qdisc add dev swp0 root handle 1: mqprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0
$ tc qdisc replace dev swp0 parent 1:2 taprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
	base-time 0 sched-entry S 0x7f 990000 sched-entry S 0x80 100000 \
	flags 0x0 clockid CLOCK_TAI
Error: sch_taprio: Can only be attached as root qdisc.

(extack message added by me)

But when we try to attach a taprio child to a taprio root qdisc,
surprisingly it doesn't fail:

$ tc qdisc replace dev swp0 root handle 1: taprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
	base-time 0 sched-entry S 0x7f 990000 sched-entry S 0x80 100000 \
	flags 0x0 clockid CLOCK_TAI
$ tc qdisc replace dev swp0 parent 1:2 taprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
	base-time 0 sched-entry S 0x7f 990000 sched-entry S 0x80 100000 \
	flags 0x0 clockid CLOCK_TAI

This is because tc_modify_qdisc() behaves differently when mqprio is
root, vs when taprio is root.

In the mqprio case, it finds the parent qdisc through
p = qdisc_lookup(dev, TC_H_MAJ(clid)), and then the child qdisc through
q = qdisc_leaf(p, clid). This leaf qdisc q has handle 0, so it is
ignored according to the comment right below ("It may be default qdisc,
ignore it"). As a result, tc_modify_qdisc() goes through the
qdisc_create() code path, and this gives taprio_init() a chance to check
for sch_parent != TC_H_ROOT and error out.

Whereas in the taprio case, the returned q = qdisc_leaf(p, clid) is
different. It is not the default qdisc created for each netdev queue
(both taprio and mqprio call qdisc_create_dflt() and keep them in
a private q->qdiscs[], or priv->qdiscs[], respectively). Instead, taprio
makes qdisc_leaf() return the _root_ qdisc, aka itself.

When taprio does that, tc_modify_qdisc() goes through the qdisc_change()
code path, because the qdisc layer never finds out about the child qdisc
of the root. And through the ->change() ops, taprio has no reason to
check whether its parent is root or not, just through ->init(), which is
not called.

The problem is the taprio_leaf() implementation. Even though code wise,
it does the exact same thing as mqprio_leaf() which it is copied from,
it works with different input data. This is because mqprio does not
attach itself (the root) to each device TX queue, but one of the default
qdiscs from its private array.

In fact, since commit 13511704f8d7 ("net: taprio offload: enforce qdisc
to netdev queue mapping"), taprio does this too, but just for the full
offload case. So if we tried to attach a taprio child to a fully
offloaded taprio root qdisc, it would properly fail too; just not to a
software root taprio.

To fix the problem, stop looking at the Qdisc that's attached to the TX
queue, and instead, always return the default qdiscs that we've
allocated (and to which we privately enqueue and dequeue, in software
scheduling mode).

Since Qdisc_class_ops :: leaf  is only called from tc_modify_qdisc(),
the risk of unforeseen side effects introduced by this change is
minimal.

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 842ccdcc0db2..506ebae1f72c 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1906,12 +1906,14 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 
 static struct Qdisc *taprio_leaf(struct Qdisc *sch, unsigned long cl)
 {
-	struct netdev_queue *dev_queue = taprio_queue_get(sch, cl);
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	unsigned int ntx = cl - 1;
 
-	if (!dev_queue)
+	if (ntx >= dev->num_tx_queues)
 		return NULL;
 
-	return dev_queue->qdisc_sleeping;
+	return q->qdiscs[ntx];
 }
 
 static unsigned long taprio_find(struct Qdisc *sch, u32 classid)
-- 
2.35.1



