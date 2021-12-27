Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE2047FDA9
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 14:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhL0Nlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 08:41:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56996 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbhL0Nlc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 08:41:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60DBA60FFB
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 13:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB46C36AE7;
        Mon, 27 Dec 2021 13:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640612491;
        bh=RWNQPoNF8HBUxK3iq4N1LVoYhi1zmD9mY8xPzrkbpIc=;
        h=Subject:To:Cc:From:Date:From;
        b=1wOZHETNPCA9d+R/xN5sWFmo3RmGOXTZogAtb5aObEu6gpn3HF0l/Lwms9PkUYFZb
         VquypywFBeHW9HZh45mcL9n6rlg1qip8Ujoeubhhk/as9c2cZHuNj3ZlliOjaf7XE6
         TG8ofHvf9+9OCGQ+8DOHnejrhCz69fclVAtjs6Mc=
Subject: FAILED: patch "[PATCH] net/sched: flow_dissector: Fix matching on zone id for" failed to apply to 5.15-stable tree
To:     paulb@nvidia.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Dec 2021 14:41:28 +0100
Message-ID: <1640612488166230@kroah.com>
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

From 3849595866166b23bf6a0cb9ff87e06423167f67 Mon Sep 17 00:00:00 2001
From: Paul Blakey <paulb@nvidia.com>
Date: Tue, 14 Dec 2021 19:24:34 +0200
Subject: [PATCH] net/sched: flow_dissector: Fix matching on zone id for
 invalid conns

If ct rejects a flow, it removes the conntrack info from the skb.
act_ct sets the post_ct variable so the dissector will see this case
as an +tracked +invalid state, but the zone id is lost with the
conntrack info.

To restore the zone id on such cases, set the last executed zone,
via the tc control block, when passing ct, and read it back in the
dissector if there is no ct info on the skb (invalid connection).

Fixes: 7baf2429a1a9 ("net/sched: cls_flower add CT_FLAGS_INVALID flag support")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c8cb7e697d47..2ecf8cfd2223 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1380,7 +1380,7 @@ skb_flow_dissect_ct(const struct sk_buff *skb,
 		    struct flow_dissector *flow_dissector,
 		    void *target_container,
 		    u16 *ctinfo_map, size_t mapsize,
-		    bool post_ct);
+		    bool post_ct, u16 zone);
 void
 skb_flow_dissect_tunnel_info(const struct sk_buff *skb,
 			     struct flow_dissector *flow_dissector,
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 05f18e81f3e8..9e71691c491b 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -198,6 +198,7 @@ struct tc_skb_cb {
 
 	u16 mru;
 	bool post_ct;
+	u16 zone; /* Only valid if post_ct = true */
 };
 
 static inline struct tc_skb_cb *tc_skb_cb(const struct sk_buff *skb)
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 3255f57f5131..1b094c481f1d 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -238,7 +238,7 @@ void
 skb_flow_dissect_ct(const struct sk_buff *skb,
 		    struct flow_dissector *flow_dissector,
 		    void *target_container, u16 *ctinfo_map,
-		    size_t mapsize, bool post_ct)
+		    size_t mapsize, bool post_ct, u16 zone)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	struct flow_dissector_key_ct *key;
@@ -260,6 +260,7 @@ skb_flow_dissect_ct(const struct sk_buff *skb,
 	if (!ct) {
 		key->ct_state = TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
 				TCA_FLOWER_KEY_CT_FLAGS_INVALID;
+		key->ct_zone = zone;
 		return;
 	}
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 98e248b9c0b1..ab3591408419 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1049,6 +1049,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	skb_push_rcsum(skb, nh_ofs);
 
 	tc_skb_cb(skb)->post_ct = true;
+	tc_skb_cb(skb)->zone = p->zone;
 out_clear:
 	if (defrag)
 		qdisc_skb_cb(skb)->pkt_len = skb->len;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 9782b93db1b3..ef54ed395874 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -311,6 +311,7 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 {
 	struct cls_fl_head *head = rcu_dereference_bh(tp->root);
 	bool post_ct = tc_skb_cb(skb)->post_ct;
+	u16 zone = tc_skb_cb(skb)->zone;
 	struct fl_flow_key skb_key;
 	struct fl_flow_mask *mask;
 	struct cls_fl_filter *f;
@@ -328,7 +329,7 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		skb_flow_dissect_ct(skb, &mask->dissector, &skb_key,
 				    fl_ct_info_to_flower_map,
 				    ARRAY_SIZE(fl_ct_info_to_flower_map),
-				    post_ct);
+				    post_ct, zone);
 		skb_flow_dissect_hash(skb, &mask->dissector, &skb_key);
 		skb_flow_dissect(skb, &mask->dissector, &skb_key,
 				 FLOW_DISSECTOR_F_STOP_BEFORE_ENCAP);

