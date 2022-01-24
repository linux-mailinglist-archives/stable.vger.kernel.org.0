Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1D749818C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237605AbiAXN7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237526AbiAXN7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:59:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A7EC06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 05:59:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98D96612F3
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC65C340E1;
        Mon, 24 Jan 2022 13:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643032759;
        bh=3m6LlE/4yqlOZl9WkCcdoNp08bf86xDLdgrIQU+GrFo=;
        h=Subject:To:Cc:From:Date:From;
        b=WPX8DLCYAOiN64xVYGp5Z/xjMnNF2Il29BeQCtUXdJwoKnx3CK7h4XRQ1nz02ufkZ
         wbcFJLLOFoLXTo5156EenxrCHFNNHHHI8gG6XnpNv0gI2RjxVlS/rdnApT6XM9cmdV
         F1ycfNIs37DA2UDnDJwGgXh2Ol4L1IED3be6cPzY=
Subject: FAILED: patch "[PATCH] net: mscc: ocelot: don't dereference NULL pointers with" failed to apply to 5.15-stable tree
To:     vladimir.oltean@nxp.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 14:57:16 +0100
Message-ID: <1643032636199208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 80f15f3bef9e9c2cc29888a6773df44de0a0c65f Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Fri, 14 Jan 2022 15:36:37 +0200
Subject: [PATCH] net: mscc: ocelot: don't dereference NULL pointers with
 shared tc filters

The following command sequence:

tc qdisc del dev swp0 clsact
tc qdisc add dev swp0 ingress_block 1 clsact
tc qdisc add dev swp1 ingress_block 1 clsact
tc filter add block 1 flower action drop
tc qdisc del dev swp0 clsact

produces the following NPD:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000014
pc : vcap_entry_set+0x14/0x70
lr : ocelot_vcap_filter_del+0x198/0x234
Call trace:
 vcap_entry_set+0x14/0x70
 ocelot_vcap_filter_del+0x198/0x234
 ocelot_cls_flower_destroy+0x94/0xe4
 felix_cls_flower_del+0x70/0x84
 dsa_slave_setup_tc_block_cb+0x13c/0x60c
 dsa_slave_setup_tc_block_cb_ig+0x20/0x30
 tc_setup_cb_reoffload+0x44/0x120
 fl_reoffload+0x280/0x320
 tcf_block_playback_offloads+0x6c/0x184
 tcf_block_unbind+0x80/0xe0
 tcf_block_setup+0x174/0x214
 tcf_block_offload_cmd.isra.0+0x100/0x13c
 tcf_block_offload_unbind+0x5c/0xa0
 __tcf_block_put+0x54/0x174
 tcf_block_put_ext+0x5c/0x74
 clsact_destroy+0x40/0x60
 qdisc_destroy+0x4c/0x150
 qdisc_put+0x70/0x90
 qdisc_graft+0x3f0/0x4c0
 tc_get_qdisc+0x1cc/0x364
 rtnetlink_rcv_msg+0x124/0x340

The reason is that the driver isn't prepared to receive two tc filters
with the same cookie. It unconditionally creates a new struct
ocelot_vcap_filter for each tc filter, and it adds all filters with the
same identifier (cookie) to the ocelot_vcap_block.

The problem is here, in ocelot_vcap_filter_del():

	/* Gets index of the filter */
	index = ocelot_vcap_block_get_filter_index(block, filter);
	if (index < 0)
		return index;

	/* Delete filter */
	ocelot_vcap_block_remove_filter(ocelot, block, filter);

	/* Move up all the blocks over the deleted filter */
	for (i = index; i < block->count; i++) {
		struct ocelot_vcap_filter *tmp;

		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
		vcap_entry_set(ocelot, i, tmp);
	}

what will happen is ocelot_vcap_block_get_filter_index() will return the
index (@index) of the first filter found with that cookie. This is _not_
the index of _this_ filter, but the other one with the same cookie,
because ocelot_vcap_filter_equal() gets fooled.

Then later, ocelot_vcap_block_remove_filter() is coded to remove all
filters that are ocelot_vcap_filter_equal() with the passed @filter.
So unexpectedly, both filters get deleted from the list.

Then ocelot_vcap_filter_del() will attempt to move all the other filters
up, again finding them by index (@i). The block count is 2, @index was 0,
so it will attempt to move up filter @i=0 and @i=1. It assigns tmp =
ocelot_vcap_block_find_filter_by_index(block, i), which is now a NULL
pointer because ocelot_vcap_block_remove_filter() has removed more than
one filter.

As far as I can see, this problem has been there since the introduction
of tc offload support, however I cannot test beyond the blamed commit
due to hardware availability. In any case, any fix cannot be backported
that far, due to lots of changes to the code base.

Therefore, let's go for the correct solution, which is to not call
ocelot_vcap_filter_add() and ocelot_vcap_filter_del(), unless the filter
is actually unique and not shared. For the shared filters, we should
just modify the ingress port mask and call ocelot_vcap_filter_replace(),
a function introduced by commit 95706be13b9f ("net: mscc: ocelot: create
a function that replaces an existing VCAP filter"). This way,
block->rules will only contain filters with unique cookies, by design.

Fixes: 07d985eef073 ("net: dsa: felix: Wire up the ocelot cls_flower methods")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index beb9379424c0..4a0fda22d343 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -805,13 +805,34 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct ocelot_vcap_filter *filter;
 	int chain = f->common.chain_index;
-	int ret;
+	int block_id, ret;
 
 	if (chain && !ocelot_find_vcap_filter_that_points_at(ocelot, chain)) {
 		NL_SET_ERR_MSG_MOD(extack, "No default GOTO action points to this chain");
 		return -EOPNOTSUPP;
 	}
 
+	block_id = ocelot_chain_to_block(chain, ingress);
+	if (block_id < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload to this chain");
+		return -EOPNOTSUPP;
+	}
+
+	filter = ocelot_vcap_block_find_filter_by_id(&ocelot->block[block_id],
+						     f->cookie, true);
+	if (filter) {
+		/* Filter already exists on other ports */
+		if (!ingress) {
+			NL_SET_ERR_MSG_MOD(extack, "VCAP ES0 does not support shared filters");
+			return -EOPNOTSUPP;
+		}
+
+		filter->ingress_port_mask |= BIT(port);
+
+		return ocelot_vcap_filter_replace(ocelot, filter);
+	}
+
+	/* Filter didn't exist, create it now */
 	filter = ocelot_vcap_filter_create(ocelot, port, ingress, f);
 	if (!filter)
 		return -ENOMEM;
@@ -874,6 +895,12 @@ int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
 	if (filter->type == OCELOT_VCAP_FILTER_DUMMY)
 		return ocelot_vcap_dummy_filter_del(ocelot, filter);
 
+	if (ingress) {
+		filter->ingress_port_mask &= ~BIT(port);
+		if (filter->ingress_port_mask)
+			return ocelot_vcap_filter_replace(ocelot, filter);
+	}
+
 	return ocelot_vcap_filter_del(ocelot, filter);
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_destroy);

