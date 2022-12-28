Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C5F657E6E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbiL1Pxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233089AbiL1Pxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:53:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5BE186AE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:53:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3950C6155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B160C433EF;
        Wed, 28 Dec 2022 15:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242809;
        bh=EFWRYaa315ZcgWkEslmF75YPQc+EnqURzZtIM6eliqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLpXiL+rxqOZ359KQ7+F6YIdvD4djuP3kk6JrqQj9VOl+7gDmoDpaE7b0UtbXc9Ga
         hSIFiNmNv/h6ljMK9FwlK+QKSFQnpLx9s+FY/KU6XbLze+XzV2imF+tzZXkaB6sxke
         bpuhNc7q0q5VBETu5BXO+L3Udz5Ix+X1ckM/+g34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0457/1073] hsr: Avoid double remove of a node.
Date:   Wed, 28 Dec 2022 15:34:05 +0100
Message-Id: <20221228144340.452351875@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 0c74d9f79ec4299365bbe803baa736ae0068179e ]

Due to the hashed-MAC optimisation one problem become visible:
hsr_handle_sup_frame() walks over the list of available nodes and merges
two node entries into one if based on the information in the supervision
both MAC addresses belong to one node. The list-walk happens on a RCU
protected list and delete operation happens under a lock.

If the supervision arrives on both slave interfaces at the same time
then this delete operation can occur simultaneously on two CPUs. The
result is the first-CPU deletes the from the list and the second CPUs
BUGs while attempting to dereference a poisoned list-entry. This happens
more likely with the optimisation because a new node for the mac_B entry
is created once a packet has been received and removed (merged) once the
supervision frame has been received.

Avoid removing/ cleaning up a hsr_node twice by adding a `removed' field
which is set to true after the removal and checked before the removal.

Fixes: f266a683a4804 ("net/hsr: Better frame dispatch")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_framereg.c | 16 +++++++++++-----
 net/hsr/hsr_framereg.h |  1 +
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 9b8eaebce254..f2dd846ff903 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -366,9 +366,12 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 	node_real->addr_B_port = port_rcv->type;
 
 	spin_lock_bh(&hsr->list_lock);
-	list_del_rcu(&node_curr->mac_list);
+	if (!node_curr->removed) {
+		list_del_rcu(&node_curr->mac_list);
+		node_curr->removed = true;
+		kfree_rcu(node_curr, rcu_head);
+	}
 	spin_unlock_bh(&hsr->list_lock);
-	kfree_rcu(node_curr, rcu_head);
 
 done:
 	/* Push back here */
@@ -539,9 +542,12 @@ void hsr_prune_nodes(struct timer_list *t)
 		if (time_is_before_jiffies(timestamp +
 				msecs_to_jiffies(HSR_NODE_FORGET_TIME))) {
 			hsr_nl_nodedown(hsr, node->macaddress_A);
-			list_del_rcu(&node->mac_list);
-			/* Note that we need to free this entry later: */
-			kfree_rcu(node, rcu_head);
+			if (!node->removed) {
+				list_del_rcu(&node->mac_list);
+				node->removed = true;
+				/* Note that we need to free this entry later: */
+				kfree_rcu(node, rcu_head);
+			}
 		}
 	}
 	spin_unlock_bh(&hsr->list_lock);
diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
index bdbb8c822ba1..b5f902397bf1 100644
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -80,6 +80,7 @@ struct hsr_node {
 	bool			san_a;
 	bool			san_b;
 	u16			seq_out[HSR_PT_PORTS];
+	bool			removed;
 	struct rcu_head		rcu_head;
 };
 
-- 
2.35.1



