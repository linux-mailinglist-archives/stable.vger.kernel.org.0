Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92A331236A6
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbfLQUKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:10:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728438AbfLQUKn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:10:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC80A206D7;
        Tue, 17 Dec 2019 20:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613442;
        bh=Eb4V9O8crp96OIJnkru18gVTM5Mk2hQoIWDTp90FGv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v6WYD9LmCD0QcBeqNiehOO4zJxZ4pfIADNb1WX8JzO7Hi3B9bW05N7lFKrJ45FWTa
         u2dT/bcIBkHSjYmtZQsTJTsAjLbk5mGQyLIiJgwFQWHLRB2fpUJ2vA+piKZy5iRvT0
         BKWnvYxLT4rWy0AcH0iPYEihmNiM/ZrxKoCVoRbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 22/37] cls_flower: Fix the behavior using port ranges with hw-offload
Date:   Tue, 17 Dec 2019 21:09:43 +0100
Message-Id: <20191217200728.852887941@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200721.741054904@linuxfoundation.org>
References: <20191217200721.741054904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshiki Komachi <komachi.yoshiki@gmail.com>

[ Upstream commit 8ffb055beae58574d3e77b4bf9d4d15eace1ca27 ]

The recent commit 5c72299fba9d ("net: sched: cls_flower: Classify
packets using port ranges") had added filtering based on port ranges
to tc flower. However the commit missed necessary changes in hw-offload
code, so the feature gave rise to generating incorrect offloaded flow
keys in NIC.

One more detailed example is below:

$ tc qdisc add dev eth0 ingress
$ tc filter add dev eth0 ingress protocol ip flower ip_proto tcp \
  dst_port 100-200 action drop

With the setup above, an exact match filter with dst_port == 0 will be
installed in NIC by hw-offload. IOW, the NIC will have a rule which is
equivalent to the following one.

$ tc qdisc add dev eth0 ingress
$ tc filter add dev eth0 ingress protocol ip flower ip_proto tcp \
  dst_port 0 action drop

The behavior was caused by the flow dissector which extracts packet
data into the flow key in the tc flower. More specifically, regardless
of exact match or specified port ranges, fl_init_dissector() set the
FLOW_DISSECTOR_KEY_PORTS flag in struct flow_dissector to extract port
numbers from skb in skb_flow_dissect() called by fl_classify(). Note
that device drivers received the same struct flow_dissector object as
used in skb_flow_dissect(). Thus, offloaded drivers could not identify
which of these is used because the FLOW_DISSECTOR_KEY_PORTS flag was
set to struct flow_dissector in either case.

This patch adds the new FLOW_DISSECTOR_KEY_PORTS_RANGE flag and the new
tp_range field in struct fl_flow_key to recognize which filters are applied
to offloaded drivers. At this point, when filters based on port ranges
passed to drivers, drivers return the EOPNOTSUPP error because they do
not support the feature (the newly created FLOW_DISSECTOR_KEY_PORTS_RANGE
flag).

Fixes: 5c72299fba9d ("net: sched: cls_flower: Classify packets using port ranges")
Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/flow_dissector.h |    1 
 net/core/flow_dissector.c    |   37 ++++++++++---
 net/sched/cls_flower.c       |  118 ++++++++++++++++++++++++-------------------
 3 files changed, 95 insertions(+), 61 deletions(-)

--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -229,6 +229,7 @@ enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_IPV4_ADDRS, /* struct flow_dissector_key_ipv4_addrs */
 	FLOW_DISSECTOR_KEY_IPV6_ADDRS, /* struct flow_dissector_key_ipv6_addrs */
 	FLOW_DISSECTOR_KEY_PORTS, /* struct flow_dissector_key_ports */
+	FLOW_DISSECTOR_KEY_PORTS_RANGE, /* struct flow_dissector_key_ports */
 	FLOW_DISSECTOR_KEY_ICMP, /* struct flow_dissector_key_icmp */
 	FLOW_DISSECTOR_KEY_ETH_ADDRS, /* struct flow_dissector_key_eth_addrs */
 	FLOW_DISSECTOR_KEY_TIPC, /* struct flow_dissector_key_tipc */
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -684,6 +684,31 @@ __skb_flow_dissect_tcp(const struct sk_b
 }
 
 static void
+__skb_flow_dissect_ports(const struct sk_buff *skb,
+			 struct flow_dissector *flow_dissector,
+			 void *target_container, void *data, int nhoff,
+			 u8 ip_proto, int hlen)
+{
+	enum flow_dissector_key_id dissector_ports = FLOW_DISSECTOR_KEY_MAX;
+	struct flow_dissector_key_ports *key_ports;
+
+	if (dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_PORTS))
+		dissector_ports = FLOW_DISSECTOR_KEY_PORTS;
+	else if (dissector_uses_key(flow_dissector,
+				    FLOW_DISSECTOR_KEY_PORTS_RANGE))
+		dissector_ports = FLOW_DISSECTOR_KEY_PORTS_RANGE;
+
+	if (dissector_ports == FLOW_DISSECTOR_KEY_MAX)
+		return;
+
+	key_ports = skb_flow_dissector_target(flow_dissector,
+					      dissector_ports,
+					      target_container);
+	key_ports->ports = __skb_flow_get_ports(skb, nhoff, ip_proto,
+						data, hlen);
+}
+
+static void
 __skb_flow_dissect_ipv4(const struct sk_buff *skb,
 			struct flow_dissector *flow_dissector,
 			void *target_container, void *data, const struct iphdr *iph)
@@ -852,7 +877,6 @@ bool __skb_flow_dissect(const struct net
 	struct flow_dissector_key_control *key_control;
 	struct flow_dissector_key_basic *key_basic;
 	struct flow_dissector_key_addrs *key_addrs;
-	struct flow_dissector_key_ports *key_ports;
 	struct flow_dissector_key_icmp *key_icmp;
 	struct flow_dissector_key_tags *key_tags;
 	struct flow_dissector_key_vlan *key_vlan;
@@ -1300,14 +1324,9 @@ ip_proto_again:
 		break;
 	}
 
-	if (dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_PORTS) &&
-	    !(key_control->flags & FLOW_DIS_IS_FRAGMENT)) {
-		key_ports = skb_flow_dissector_target(flow_dissector,
-						      FLOW_DISSECTOR_KEY_PORTS,
-						      target_container);
-		key_ports->ports = __skb_flow_get_ports(skb, nhoff, ip_proto,
-							data, hlen);
-	}
+	if (!(key_control->flags & FLOW_DIS_IS_FRAGMENT))
+		__skb_flow_dissect_ports(skb, flow_dissector, target_container,
+					 data, nhoff, ip_proto, hlen);
 
 	if (dissector_uses_key(flow_dissector,
 			       FLOW_DISSECTOR_KEY_ICMP)) {
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -54,8 +54,13 @@ struct fl_flow_key {
 	struct flow_dissector_key_ip ip;
 	struct flow_dissector_key_ip enc_ip;
 	struct flow_dissector_key_enc_opts enc_opts;
-	struct flow_dissector_key_ports tp_min;
-	struct flow_dissector_key_ports tp_max;
+	union {
+		struct flow_dissector_key_ports tp;
+		struct {
+			struct flow_dissector_key_ports tp_min;
+			struct flow_dissector_key_ports tp_max;
+		};
+	} tp_range;
 	struct flow_dissector_key_ct ct;
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
 
@@ -198,19 +203,19 @@ static bool fl_range_port_dst_cmp(struct
 {
 	__be16 min_mask, max_mask, min_val, max_val;
 
-	min_mask = htons(filter->mask->key.tp_min.dst);
-	max_mask = htons(filter->mask->key.tp_max.dst);
-	min_val = htons(filter->key.tp_min.dst);
-	max_val = htons(filter->key.tp_max.dst);
+	min_mask = htons(filter->mask->key.tp_range.tp_min.dst);
+	max_mask = htons(filter->mask->key.tp_range.tp_max.dst);
+	min_val = htons(filter->key.tp_range.tp_min.dst);
+	max_val = htons(filter->key.tp_range.tp_max.dst);
 
 	if (min_mask && max_mask) {
-		if (htons(key->tp.dst) < min_val ||
-		    htons(key->tp.dst) > max_val)
+		if (htons(key->tp_range.tp.dst) < min_val ||
+		    htons(key->tp_range.tp.dst) > max_val)
 			return false;
 
 		/* skb does not have min and max values */
-		mkey->tp_min.dst = filter->mkey.tp_min.dst;
-		mkey->tp_max.dst = filter->mkey.tp_max.dst;
+		mkey->tp_range.tp_min.dst = filter->mkey.tp_range.tp_min.dst;
+		mkey->tp_range.tp_max.dst = filter->mkey.tp_range.tp_max.dst;
 	}
 	return true;
 }
@@ -221,19 +226,19 @@ static bool fl_range_port_src_cmp(struct
 {
 	__be16 min_mask, max_mask, min_val, max_val;
 
-	min_mask = htons(filter->mask->key.tp_min.src);
-	max_mask = htons(filter->mask->key.tp_max.src);
-	min_val = htons(filter->key.tp_min.src);
-	max_val = htons(filter->key.tp_max.src);
+	min_mask = htons(filter->mask->key.tp_range.tp_min.src);
+	max_mask = htons(filter->mask->key.tp_range.tp_max.src);
+	min_val = htons(filter->key.tp_range.tp_min.src);
+	max_val = htons(filter->key.tp_range.tp_max.src);
 
 	if (min_mask && max_mask) {
-		if (htons(key->tp.src) < min_val ||
-		    htons(key->tp.src) > max_val)
+		if (htons(key->tp_range.tp.src) < min_val ||
+		    htons(key->tp_range.tp.src) > max_val)
 			return false;
 
 		/* skb does not have min and max values */
-		mkey->tp_min.src = filter->mkey.tp_min.src;
-		mkey->tp_max.src = filter->mkey.tp_max.src;
+		mkey->tp_range.tp_min.src = filter->mkey.tp_range.tp_min.src;
+		mkey->tp_range.tp_max.src = filter->mkey.tp_range.tp_max.src;
 	}
 	return true;
 }
@@ -715,23 +720,25 @@ static void fl_set_key_val(struct nlattr
 static int fl_set_key_port_range(struct nlattr **tb, struct fl_flow_key *key,
 				 struct fl_flow_key *mask)
 {
-	fl_set_key_val(tb, &key->tp_min.dst,
-		       TCA_FLOWER_KEY_PORT_DST_MIN, &mask->tp_min.dst,
-		       TCA_FLOWER_UNSPEC, sizeof(key->tp_min.dst));
-	fl_set_key_val(tb, &key->tp_max.dst,
-		       TCA_FLOWER_KEY_PORT_DST_MAX, &mask->tp_max.dst,
-		       TCA_FLOWER_UNSPEC, sizeof(key->tp_max.dst));
-	fl_set_key_val(tb, &key->tp_min.src,
-		       TCA_FLOWER_KEY_PORT_SRC_MIN, &mask->tp_min.src,
-		       TCA_FLOWER_UNSPEC, sizeof(key->tp_min.src));
-	fl_set_key_val(tb, &key->tp_max.src,
-		       TCA_FLOWER_KEY_PORT_SRC_MAX, &mask->tp_max.src,
-		       TCA_FLOWER_UNSPEC, sizeof(key->tp_max.src));
-
-	if ((mask->tp_min.dst && mask->tp_max.dst &&
-	     htons(key->tp_max.dst) <= htons(key->tp_min.dst)) ||
-	     (mask->tp_min.src && mask->tp_max.src &&
-	      htons(key->tp_max.src) <= htons(key->tp_min.src)))
+	fl_set_key_val(tb, &key->tp_range.tp_min.dst,
+		       TCA_FLOWER_KEY_PORT_DST_MIN, &mask->tp_range.tp_min.dst,
+		       TCA_FLOWER_UNSPEC, sizeof(key->tp_range.tp_min.dst));
+	fl_set_key_val(tb, &key->tp_range.tp_max.dst,
+		       TCA_FLOWER_KEY_PORT_DST_MAX, &mask->tp_range.tp_max.dst,
+		       TCA_FLOWER_UNSPEC, sizeof(key->tp_range.tp_max.dst));
+	fl_set_key_val(tb, &key->tp_range.tp_min.src,
+		       TCA_FLOWER_KEY_PORT_SRC_MIN, &mask->tp_range.tp_min.src,
+		       TCA_FLOWER_UNSPEC, sizeof(key->tp_range.tp_min.src));
+	fl_set_key_val(tb, &key->tp_range.tp_max.src,
+		       TCA_FLOWER_KEY_PORT_SRC_MAX, &mask->tp_range.tp_max.src,
+		       TCA_FLOWER_UNSPEC, sizeof(key->tp_range.tp_max.src));
+
+	if ((mask->tp_range.tp_min.dst && mask->tp_range.tp_max.dst &&
+	     htons(key->tp_range.tp_max.dst) <=
+		 htons(key->tp_range.tp_min.dst)) ||
+	    (mask->tp_range.tp_min.src && mask->tp_range.tp_max.src &&
+	     htons(key->tp_range.tp_max.src) <=
+		 htons(key->tp_range.tp_min.src)))
 		return -EINVAL;
 
 	return 0;
@@ -1320,9 +1327,10 @@ static void fl_init_dissector(struct flo
 			     FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
 			     FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6);
-	if (FL_KEY_IS_MASKED(mask, tp) ||
-	    FL_KEY_IS_MASKED(mask, tp_min) || FL_KEY_IS_MASKED(mask, tp_max))
-		FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_PORTS, tp);
+	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_PORTS, tp);
+	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_PORTS_RANGE, tp_range);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
 			     FLOW_DISSECTOR_KEY_IP, ip);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
@@ -1371,8 +1379,10 @@ static struct fl_flow_mask *fl_create_ne
 
 	fl_mask_copy(newmask, mask);
 
-	if ((newmask->key.tp_min.dst && newmask->key.tp_max.dst) ||
-	    (newmask->key.tp_min.src && newmask->key.tp_max.src))
+	if ((newmask->key.tp_range.tp_min.dst &&
+	     newmask->key.tp_range.tp_max.dst) ||
+	    (newmask->key.tp_range.tp_min.src &&
+	     newmask->key.tp_range.tp_max.src))
 		newmask->flags |= TCA_FLOWER_MASK_FLAGS_RANGE;
 
 	err = fl_init_mask_hashtable(newmask);
@@ -1970,18 +1980,22 @@ static int fl_dump_key_val(struct sk_buf
 static int fl_dump_key_port_range(struct sk_buff *skb, struct fl_flow_key *key,
 				  struct fl_flow_key *mask)
 {
-	if (fl_dump_key_val(skb, &key->tp_min.dst, TCA_FLOWER_KEY_PORT_DST_MIN,
-			    &mask->tp_min.dst, TCA_FLOWER_UNSPEC,
-			    sizeof(key->tp_min.dst)) ||
-	    fl_dump_key_val(skb, &key->tp_max.dst, TCA_FLOWER_KEY_PORT_DST_MAX,
-			    &mask->tp_max.dst, TCA_FLOWER_UNSPEC,
-			    sizeof(key->tp_max.dst)) ||
-	    fl_dump_key_val(skb, &key->tp_min.src, TCA_FLOWER_KEY_PORT_SRC_MIN,
-			    &mask->tp_min.src, TCA_FLOWER_UNSPEC,
-			    sizeof(key->tp_min.src)) ||
-	    fl_dump_key_val(skb, &key->tp_max.src, TCA_FLOWER_KEY_PORT_SRC_MAX,
-			    &mask->tp_max.src, TCA_FLOWER_UNSPEC,
-			    sizeof(key->tp_max.src)))
+	if (fl_dump_key_val(skb, &key->tp_range.tp_min.dst,
+			    TCA_FLOWER_KEY_PORT_DST_MIN,
+			    &mask->tp_range.tp_min.dst, TCA_FLOWER_UNSPEC,
+			    sizeof(key->tp_range.tp_min.dst)) ||
+	    fl_dump_key_val(skb, &key->tp_range.tp_max.dst,
+			    TCA_FLOWER_KEY_PORT_DST_MAX,
+			    &mask->tp_range.tp_max.dst, TCA_FLOWER_UNSPEC,
+			    sizeof(key->tp_range.tp_max.dst)) ||
+	    fl_dump_key_val(skb, &key->tp_range.tp_min.src,
+			    TCA_FLOWER_KEY_PORT_SRC_MIN,
+			    &mask->tp_range.tp_min.src, TCA_FLOWER_UNSPEC,
+			    sizeof(key->tp_range.tp_min.src)) ||
+	    fl_dump_key_val(skb, &key->tp_range.tp_max.src,
+			    TCA_FLOWER_KEY_PORT_SRC_MAX,
+			    &mask->tp_range.tp_max.src, TCA_FLOWER_UNSPEC,
+			    sizeof(key->tp_range.tp_max.src)))
 		return -1;
 
 	return 0;


