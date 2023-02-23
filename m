Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC84C6A0A3A
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbjBWNNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbjBWNNi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:13:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2336354A06
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:13:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDA72B81A28
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5369C4339B;
        Thu, 23 Feb 2023 13:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157951;
        bh=nvcHPHr9w25CVTrPFOru55RcOtCCXS9RSZu/xDDfq4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A9QhEb0wJoXeEF/1pOUHXaJ/lWThVNdMoQXmcyaD20brsqXt9yGZDPnYHD5Qa8wI9
         Ze+sU7CcOxIvql7my83FuIMIwA4p0gENTraKFLfhaVJckupcaMi997SgIidaQDk3Qk
         h8KWR+UH1bSmdkPMFVXJxy5HDQJC5VaqxDEMD1TM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 36/36] Revert "net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs"
Date:   Thu, 23 Feb 2023 14:07:12 +0100
Message-Id: <20230223130430.712130165@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit af7b29b1deaac6da3bb7637f0e263dfab7bfc7a3 upstream.

taprio_attach() has this logic at the end, which should have been
removed with the blamed patch (which is now being reverted):

	/* access to the child qdiscs is not needed in offload mode */
	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
		kfree(q->qdiscs);
		q->qdiscs = NULL;
	}

because otherwise, we make use of q->qdiscs[] even after this array was
deallocated, namely in taprio_leaf(). Therefore, whenever one would try
to attach a valid child qdisc to a fully offloaded taprio root, one
would immediately dereference a NULL pointer.

$ tc qdisc replace dev eno0 handle 8001: parent root taprio \
	num_tc 8 \
	map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
	max-sdu 0 0 0 0 0 200 0 0 \
	base-time 200 \
	sched-entry S 80 20000 \
	sched-entry S a0 20000 \
	sched-entry S 5f 60000 \
	flags 2
$ max_frame_size=1500
$ data_rate_kbps=20000
$ port_transmit_rate_kbps=1000000
$ idleslope=$data_rate_kbps
$ sendslope=$(($idleslope - $port_transmit_rate_kbps))
$ locredit=$(($max_frame_size * $sendslope / $port_transmit_rate_kbps))
$ hicredit=$(($max_frame_size * $idleslope / $port_transmit_rate_kbps))
$ tc qdisc replace dev eno0 parent 8001:7 cbs \
	idleslope $idleslope \
	sendslope $sendslope \
	hicredit $hicredit \
	locredit $locredit \
	offload 0

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000030
pc : taprio_leaf+0x28/0x40
lr : qdisc_leaf+0x3c/0x60
Call trace:
 taprio_leaf+0x28/0x40
 tc_modify_qdisc+0xf0/0x72c
 rtnetlink_rcv_msg+0x12c/0x390
 netlink_rcv_skb+0x5c/0x130
 rtnetlink_rcv+0x1c/0x2c

The solution is not as obvious as the problem. The code which deallocates
q->qdiscs[] is in fact copied and pasted from mqprio, which also
deallocates the array in mqprio_attach() and never uses it afterwards.

Therefore, the identical cleanup logic of priv->qdiscs[] that
mqprio_destroy() has is deceptive because it will never take place at
qdisc_destroy() time, but just at raw ops->destroy() time (otherwise
said, priv->qdiscs[] do not last for the entire lifetime of the mqprio
root), but rather, this is just the twisted way in which the Qdisc API
understands error path cleanup should be done (Qdisc_ops :: destroy() is
called even when Qdisc_ops :: init() never succeeded).

Side note, in fact this is also what the comment in mqprio_init() says:

	/* pre-allocate qdisc, attachment can't fail */

Or reworded, mqprio's priv->qdiscs[] scheme is only meant to serve as
data passing between Qdisc_ops :: init() and Qdisc_ops :: attach().

[ this comment was also copied and pasted into the initial taprio
  commit, even though taprio_attach() came way later ]

The problem is that taprio also makes extensive use of the q->qdiscs[]
array in the software fast path (taprio_enqueue() and taprio_dequeue()),
but it does not keep a reference of its own on q->qdiscs[i] (you'd think
that since it creates these Qdiscs, it holds the reference, but nope,
this is not completely true).

To understand the difference between taprio_destroy() and mqprio_destroy()
one must look before commit 13511704f8d7 ("net: taprio offload: enforce
qdisc to netdev queue mapping"), because that just muddied the waters.

In the "original" taprio design, taprio always attached itself (the root
Qdisc) to all netdev TX queues, so that dev_qdisc_enqueue() would go
through taprio_enqueue().

It also called qdisc_refcount_inc() on itself for as many times as there
were netdev TX queues, in order to counter-balance what tc_get_qdisc()
does when destroying a Qdisc (simplified for brevity below):

	if (n->nlmsg_type == RTM_DELQDISC)
		err = qdisc_graft(dev, parent=NULL, new=NULL, q, extack);

qdisc_graft(where "new" is NULL so this deletes the Qdisc):

	for (i = 0; i < num_q; i++) {
		struct netdev_queue *dev_queue;

		dev_queue = netdev_get_tx_queue(dev, i);

		old = dev_graft_qdisc(dev_queue, new);
		if (new && i > 0)
			qdisc_refcount_inc(new);

		qdisc_put(old);
		~~~~~~~~~~~~~~
		this decrements taprio's refcount once for each TX queue
	}

	notify_and_destroy(net, skb, n, classid,
			   rtnl_dereference(dev->qdisc), new);
			   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			   and this finally decrements it to zero,
			   making qdisc_put() call qdisc_destroy()

The q->qdiscs[] created using qdisc_create_dflt() (or their
replacements, if taprio_graft() was ever to get called) were then
privately freed by taprio_destroy().

This is still what is happening after commit 13511704f8d7 ("net: taprio
offload: enforce qdisc to netdev queue mapping"), but only for software
mode.

In full offload mode, the per-txq "qdisc_put(old)" calls from
qdisc_graft() now deallocate the child Qdiscs rather than decrement
taprio's refcount. So when notify_and_destroy(taprio) finally calls
taprio_destroy(), the difference is that the child Qdiscs were already
deallocated.

And this is exactly why the taprio_attach() comment "access to the child
qdiscs is not needed in offload mode" is deceptive too. Not only the
q->qdiscs[] array is not needed, but it is also necessary to get rid of
it as soon as possible, because otherwise, we will also call qdisc_put()
on the child Qdiscs in qdisc_destroy() -> taprio_destroy(), and this
will cause a nasty use-after-free/refcount-saturate/whatever.

In short, the problem is that since the blamed commit, taprio_leaf()
needs q->qdiscs[] to not be freed by taprio_attach(), while qdisc_destroy()
-> taprio_destroy() does need q->qdiscs[] to be freed by taprio_attach()
for full offload. Fixing one problem triggers the other.

All of this can be solved by making taprio keep its q->qdiscs[i] with a
refcount elevated at 2 (in offloaded mode where they are attached to the
netdev TX queues), both in taprio_attach() and in taprio_graft(). The
generic qdisc_graft() would just decrement the child qdiscs' refcounts
to 1, and taprio_destroy() would give them the final coup de grace.

However the rabbit hole of changes is getting quite deep, and the
complexity increases. The blamed commit was supposed to be a bug fix in
the first place, and the bug it addressed is not so significant so as to
justify further rework in stable trees. So I'd rather just revert it.
I don't know enough about multi-queue Qdisc design to make a proper
judgement right now regarding what is/isn't idiomatic use of Qdisc
concepts in taprio. I will try to study the problem more and come with a
different solution in net-next.

Fixes: 1461d212ab27 ("net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs")
Reported-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Reported-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://lore.kernel.org/r/20221004220100.1650558-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1950,14 +1950,12 @@ start_error:
 
 static struct Qdisc *taprio_leaf(struct Qdisc *sch, unsigned long cl)
 {
-	struct taprio_sched *q = qdisc_priv(sch);
-	struct net_device *dev = qdisc_dev(sch);
-	unsigned int ntx = cl - 1;
+	struct netdev_queue *dev_queue = taprio_queue_get(sch, cl);
 
-	if (ntx >= dev->num_tx_queues)
+	if (!dev_queue)
 		return NULL;
 
-	return q->qdiscs[ntx];
+	return dev_queue->qdisc_sleeping;
 }
 
 static unsigned long taprio_find(struct Qdisc *sch, u32 classid)


