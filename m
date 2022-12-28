Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66D7657F46
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbiL1QDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbiL1QDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:03:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D811928F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:02:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 441F16156E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FA5C433F0;
        Wed, 28 Dec 2022 16:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243378;
        bh=ynHIJx1I+Jux3bkepZzlnnnuecWyGY1/PIgBQuaKz48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjFDtiQw4sd52wzCHgHVXQczSVUDqAgQQjPjQjC1+72WrFItKgtdhtrmE4apYH8dm
         9MdLL0Lth8i1c4UjnHUApJOi3mhnJUalplESu6T/8rtA0rFFAWdX50qT1OxNWuGArt
         c73OQmIZAI5QSLhHGJ1rxQBFK4kxnelDP6oTEJv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0474/1146] hsr: Synchronize sequence number updates.
Date:   Wed, 28 Dec 2022 15:33:33 +0100
Message-Id: <20221228144343.058821030@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 5c7aa13210c3abdd34fd421f62347665ec6eb551 ]

hsr_register_frame_out() compares new sequence_nr vs the old one
recorded in hsr_node::seq_out and if the new sequence_nr is higher then
it will be written to hsr_node::seq_out as the new value.

This operation isn't locked so it is possible that two frames with the
same sequence number arrive (via the two slave devices) and are fed to
hsr_register_frame_out() at the same time. Both will pass the check and
update the sequence counter later to the same value. As a result the
content of the same packet is fed into the stack twice.

This was noticed by running ping and observing DUP being reported from
time to time.

Instead of using the hsr_priv::seqnr_lock for the whole receive path (as
it is for sending in the master node) add an additional lock that is only
used for sequence number checks and updates.

Add a per-node lock that is used during sequence number reads and
updates.

Fixes: f421436a591d3 ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_framereg.c | 9 ++++++++-
 net/hsr/hsr_framereg.h | 2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index f2dd846ff903..39a6088080e9 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -157,6 +157,7 @@ static struct hsr_node *hsr_add_node(struct hsr_priv *hsr,
 		return NULL;
 
 	ether_addr_copy(new_node->macaddress_A, addr);
+	spin_lock_init(&new_node->seq_out_lock);
 
 	/* We are only interested in time diffs here, so use current jiffies
 	 * as initialization. (0 could trigger an spurious ring error warning).
@@ -353,6 +354,7 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 	}
 
 	ether_addr_copy(node_real->macaddress_B, ethhdr->h_source);
+	spin_lock_bh(&node_real->seq_out_lock);
 	for (i = 0; i < HSR_PT_PORTS; i++) {
 		if (!node_curr->time_in_stale[i] &&
 		    time_after(node_curr->time_in[i], node_real->time_in[i])) {
@@ -363,6 +365,7 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 		if (seq_nr_after(node_curr->seq_out[i], node_real->seq_out[i]))
 			node_real->seq_out[i] = node_curr->seq_out[i];
 	}
+	spin_unlock_bh(&node_real->seq_out_lock);
 	node_real->addr_B_port = port_rcv->type;
 
 	spin_lock_bh(&hsr->list_lock);
@@ -456,13 +459,17 @@ void hsr_register_frame_in(struct hsr_node *node, struct hsr_port *port,
 int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
 			   u16 sequence_nr)
 {
+	spin_lock_bh(&node->seq_out_lock);
 	if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]) &&
 	    time_is_after_jiffies(node->time_out[port->type] +
-	    msecs_to_jiffies(HSR_ENTRY_FORGET_TIME)))
+	    msecs_to_jiffies(HSR_ENTRY_FORGET_TIME))) {
+		spin_unlock_bh(&node->seq_out_lock);
 		return 1;
+	}
 
 	node->time_out[port->type] = jiffies;
 	node->seq_out[port->type] = sequence_nr;
+	spin_unlock_bh(&node->seq_out_lock);
 	return 0;
 }
 
diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
index b5f902397bf1..b23556251d62 100644
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -69,6 +69,8 @@ void prp_update_san_info(struct hsr_node *node, bool is_sup);
 
 struct hsr_node {
 	struct list_head	mac_list;
+	/* Protect R/W access to seq_out */
+	spinlock_t		seq_out_lock;
 	unsigned char		macaddress_A[ETH_ALEN];
 	unsigned char		macaddress_B[ETH_ALEN];
 	/* Local slave through which AddrB frames are received from this node */
-- 
2.35.1



