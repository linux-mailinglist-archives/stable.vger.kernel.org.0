Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2968D240A1B
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbgHJPZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728431AbgHJPZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:25:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0813420855;
        Mon, 10 Aug 2020 15:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073137;
        bh=Y7wmMwDeYET/Juzo4G/3OZOixAly9URCHID3PK/qwFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPlI3uSIgBag5XVRGSIGyJ7QwW73WW8rm08Uw9LVJmxvAUdd5pKGlv2cxUSWaaZYH
         UCVfwRCWUzPPM3pE0fnd1yYTE0e2aF4aFfNuRWyOP2hGx/XwABNXbYsYx27ufy5Ok7
         bRFnjygrogPB2sLwY0jivLKLGShJM3fE9gQXtJH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 70/79] net/sched: act_ct: fix miss set mru for ovs after defrag in act_ct
Date:   Mon, 10 Aug 2020 17:21:29 +0200
Message-Id: <20200810151815.687796652@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

[ Upstream commit 038ebb1a713d114d54dbf14868a73181c0c92758 ]

When openvswitch conntrack offload with act_ct action. Fragment packets
defrag in the ingress tc act_ct action and miss the next chain. Then the
packet pass to the openvswitch datapath without the mru. The over
mtu packet will be dropped in output action in openvswitch for over mtu.

"kernel: net2: dropped over-mtu packet: 1528 > 1500"

This patch add mru in the tc_skb_ext for adefrag and miss next chain
situation. And also add mru in the qdisc_skb_cb. The act_ct set the mru
to the qdisc_skb_cb when the packet defrag. And When the chain miss,
The mru is set to tc_skb_ext which can be got by ovs datapath.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h    |    1 +
 include/net/sch_generic.h |    3 ++-
 net/openvswitch/flow.c    |    1 +
 net/sched/act_ct.c        |    8 ++++++--
 net/sched/cls_api.c       |    1 +
 5 files changed, 11 insertions(+), 3 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -283,6 +283,7 @@ struct nf_bridge_info {
  */
 struct tc_skb_ext {
 	__u32 chain;
+	__u16 mru;
 };
 #endif
 
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -380,6 +380,7 @@ struct qdisc_skb_cb {
 	};
 #define QDISC_CB_PRIV_LEN 20
 	unsigned char		data[QDISC_CB_PRIV_LEN];
+	u16			mru;
 };
 
 typedef void tcf_chain_head_change_t(struct tcf_proto *tp_head, void *priv);
@@ -459,7 +460,7 @@ static inline void qdisc_cb_private_vali
 {
 	struct qdisc_skb_cb *qcb;
 
-	BUILD_BUG_ON(sizeof(skb->cb) < offsetof(struct qdisc_skb_cb, data) + sz);
+	BUILD_BUG_ON(sizeof(skb->cb) < sizeof(*qcb));
 	BUILD_BUG_ON(sizeof(qcb->data) < sz);
 }
 
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -890,6 +890,7 @@ int ovs_flow_key_extract(const struct ip
 	if (static_branch_unlikely(&tc_recirc_sharing_support)) {
 		tc_ext = skb_ext_find(skb, TC_SKB_EXT);
 		key->recirc_id = tc_ext ? tc_ext->chain : 0;
+		OVS_CB(skb)->mru = tc_ext ? tc_ext->mru : 0;
 	} else {
 		key->recirc_id = 0;
 	}
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -704,8 +704,10 @@ static int tcf_ct_handle_fragments(struc
 		if (err && err != -EINPROGRESS)
 			goto out_free;
 
-		if (!err)
+		if (!err) {
 			*defrag = true;
+			cb.mru = IPCB(skb)->frag_max_size;
+		}
 	} else { /* NFPROTO_IPV6 */
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 		enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;
@@ -715,8 +717,10 @@ static int tcf_ct_handle_fragments(struc
 		if (err && err != -EINPROGRESS)
 			goto out_free;
 
-		if (!err)
+		if (!err) {
 			*defrag = true;
+			cb.mru = IP6CB(skb)->frag_max_size;
+		}
 #else
 		err = -EOPNOTSUPP;
 		goto out_free;
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1679,6 +1679,7 @@ int tcf_classify_ingress(struct sk_buff
 		if (WARN_ON_ONCE(!ext))
 			return TC_ACT_SHOT;
 		ext->chain = last_executed_chain;
+		ext->mru = qdisc_skb_cb(skb)->mru;
 	}
 
 	return ret;


