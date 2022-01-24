Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077B0499AF5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbiAXVsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457508AbiAXVlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:41:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF65C07E330;
        Mon, 24 Jan 2022 12:29:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB164B811FB;
        Mon, 24 Jan 2022 20:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F505C340E5;
        Mon, 24 Jan 2022 20:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056161;
        bh=C3U03kuRJu4rADZf8pbT2hpc6oMwmwLCP7eKl59M+XE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqgdwL6BONa1zn2NKim1FVIQyeCZBkxtMIkShGscmfENpU2OKGcjgWe1D7GkxpO7I
         9b3cE43h2VEmVbtSF03kGzEyMRR+JevEVeOcVEMJK3W996XK0zr3G3qoKYf2EKRx0p
         /oUs8WYaoJ7U1c3ox32SNPtixUCenLdTJlZTVopk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 364/846] net/sched: flow_dissector: Fix matching on zone id for invalid conns
Date:   Mon, 24 Jan 2022 19:38:01 +0100
Message-Id: <20220124184113.493937513@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

[ Upstream commit 3849595866166b23bf6a0cb9ff87e06423167f67 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h    | 2 +-
 include/net/pkt_sched.h   | 1 +
 net/core/flow_dissector.c | 3 ++-
 net/sched/act_ct.c        | 1 +
 net/sched/cls_flower.c    | 3 ++-
 5 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b8c273af2910c..4f31ca71a82a7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1370,7 +1370,7 @@ skb_flow_dissect_ct(const struct sk_buff *skb,
 		    struct flow_dissector *flow_dissector,
 		    void *target_container,
 		    u16 *ctinfo_map, size_t mapsize,
-		    bool post_ct);
+		    bool post_ct, u16 zone);
 void
 skb_flow_dissect_tunnel_info(const struct sk_buff *skb,
 			     struct flow_dissector *flow_dissector,
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 05f18e81f3e87..9e71691c491b7 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -198,6 +198,7 @@ struct tc_skb_cb {
 
 	u16 mru;
 	bool post_ct;
+	u16 zone; /* Only valid if post_ct = true */
 };
 
 static inline struct tc_skb_cb *tc_skb_cb(const struct sk_buff *skb)
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index bac0184cf3de7..edffdaa875f1f 100644
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
index 98e248b9c0b17..ab3591408419f 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1049,6 +1049,7 @@ out_push:
 	skb_push_rcsum(skb, nh_ofs);
 
 	tc_skb_cb(skb)->post_ct = true;
+	tc_skb_cb(skb)->zone = p->zone;
 out_clear:
 	if (defrag)
 		qdisc_skb_cb(skb)->pkt_len = skb->len;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 161bd91c8c6b0..709348262410c 100644
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
 		skb_flow_dissect(skb, &mask->dissector, &skb_key, 0);
 
-- 
2.34.1



