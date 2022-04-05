Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D104F3C37
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243710AbiDEMG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358267AbiDEK2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:28:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E80810FE0;
        Tue,  5 Apr 2022 03:17:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C3CEB81B18;
        Tue,  5 Apr 2022 10:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA3FC385A0;
        Tue,  5 Apr 2022 10:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153863;
        bh=uKH24HtaFBqLmO+xSRD692UsORjzvXc4qTmIGqH7/4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHHGXp/0nX0yfXRdFUSdYju79Sr4xc1WEFOcIgchwn8HDuzlilzyogHrKUVdH0X/W
         NqbbodQ5ev7Hx3IB1ZIJwv4Kk0rVkKgSbY/1ID1RavJGvbndulTMXKVMvRHzBQxhiP
         LZln7WG+Ho64is92utOw/U0zv7+3+JuDCfsP70O8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dumitru Ceara <dceara@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Aaron Conole <aconole@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 375/599] openvswitch: always update flow key after nat
Date:   Tue,  5 Apr 2022 09:31:09 +0200
Message-Id: <20220405070309.989261762@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Conole <aconole@redhat.com>

[ Upstream commit 60b44ca6bd7518dd38fa2719bc9240378b6172c3 ]

During NAT, a tuple collision may occur.  When this happens, openvswitch
will make a second pass through NAT which will perform additional packet
modification.  This will update the skb data, but not the flow key that
OVS uses.  This means that future flow lookups, and packet matches will
have incorrect data.  This has been supported since
5d50aa83e2c8 ("openvswitch: support asymmetric conntrack").

That commit failed to properly update the sw_flow_key attributes, since
it only called the ovs_ct_nat_update_key once, rather than each time
ovs_ct_nat_execute was called.  As these two operations are linked, the
ovs_ct_nat_execute() function should always make sure that the
sw_flow_key is updated after a successful call through NAT infrastructure.

Fixes: 5d50aa83e2c8 ("openvswitch: support asymmetric conntrack")
Cc: Dumitru Ceara <dceara@redhat.com>
Cc: Numan Siddique <nusiddiq@redhat.com>
Signed-off-by: Aaron Conole <aconole@redhat.com>
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Link: https://lore.kernel.org/r/20220318124319.3056455-1-aconole@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/conntrack.c | 118 ++++++++++++++++++------------------
 1 file changed, 59 insertions(+), 59 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index a11b558813c1..7ff98d39ec94 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -730,6 +730,57 @@ static bool skb_nfct_cached(struct net *net,
 }
 
 #if IS_ENABLED(CONFIG_NF_NAT)
+static void ovs_nat_update_key(struct sw_flow_key *key,
+			       const struct sk_buff *skb,
+			       enum nf_nat_manip_type maniptype)
+{
+	if (maniptype == NF_NAT_MANIP_SRC) {
+		__be16 src;
+
+		key->ct_state |= OVS_CS_F_SRC_NAT;
+		if (key->eth.type == htons(ETH_P_IP))
+			key->ipv4.addr.src = ip_hdr(skb)->saddr;
+		else if (key->eth.type == htons(ETH_P_IPV6))
+			memcpy(&key->ipv6.addr.src, &ipv6_hdr(skb)->saddr,
+			       sizeof(key->ipv6.addr.src));
+		else
+			return;
+
+		if (key->ip.proto == IPPROTO_UDP)
+			src = udp_hdr(skb)->source;
+		else if (key->ip.proto == IPPROTO_TCP)
+			src = tcp_hdr(skb)->source;
+		else if (key->ip.proto == IPPROTO_SCTP)
+			src = sctp_hdr(skb)->source;
+		else
+			return;
+
+		key->tp.src = src;
+	} else {
+		__be16 dst;
+
+		key->ct_state |= OVS_CS_F_DST_NAT;
+		if (key->eth.type == htons(ETH_P_IP))
+			key->ipv4.addr.dst = ip_hdr(skb)->daddr;
+		else if (key->eth.type == htons(ETH_P_IPV6))
+			memcpy(&key->ipv6.addr.dst, &ipv6_hdr(skb)->daddr,
+			       sizeof(key->ipv6.addr.dst));
+		else
+			return;
+
+		if (key->ip.proto == IPPROTO_UDP)
+			dst = udp_hdr(skb)->dest;
+		else if (key->ip.proto == IPPROTO_TCP)
+			dst = tcp_hdr(skb)->dest;
+		else if (key->ip.proto == IPPROTO_SCTP)
+			dst = sctp_hdr(skb)->dest;
+		else
+			return;
+
+		key->tp.dst = dst;
+	}
+}
+
 /* Modelled after nf_nat_ipv[46]_fn().
  * range is only used for new, uninitialized NAT state.
  * Returns either NF_ACCEPT or NF_DROP.
@@ -737,7 +788,7 @@ static bool skb_nfct_cached(struct net *net,
 static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 			      enum ip_conntrack_info ctinfo,
 			      const struct nf_nat_range2 *range,
-			      enum nf_nat_manip_type maniptype)
+			      enum nf_nat_manip_type maniptype, struct sw_flow_key *key)
 {
 	int hooknum, nh_off, err = NF_ACCEPT;
 
@@ -810,58 +861,11 @@ static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 	skb_push(skb, nh_off);
 	skb_postpush_rcsum(skb, skb->data, nh_off);
 
-	return err;
-}
-
-static void ovs_nat_update_key(struct sw_flow_key *key,
-			       const struct sk_buff *skb,
-			       enum nf_nat_manip_type maniptype)
-{
-	if (maniptype == NF_NAT_MANIP_SRC) {
-		__be16 src;
-
-		key->ct_state |= OVS_CS_F_SRC_NAT;
-		if (key->eth.type == htons(ETH_P_IP))
-			key->ipv4.addr.src = ip_hdr(skb)->saddr;
-		else if (key->eth.type == htons(ETH_P_IPV6))
-			memcpy(&key->ipv6.addr.src, &ipv6_hdr(skb)->saddr,
-			       sizeof(key->ipv6.addr.src));
-		else
-			return;
-
-		if (key->ip.proto == IPPROTO_UDP)
-			src = udp_hdr(skb)->source;
-		else if (key->ip.proto == IPPROTO_TCP)
-			src = tcp_hdr(skb)->source;
-		else if (key->ip.proto == IPPROTO_SCTP)
-			src = sctp_hdr(skb)->source;
-		else
-			return;
-
-		key->tp.src = src;
-	} else {
-		__be16 dst;
-
-		key->ct_state |= OVS_CS_F_DST_NAT;
-		if (key->eth.type == htons(ETH_P_IP))
-			key->ipv4.addr.dst = ip_hdr(skb)->daddr;
-		else if (key->eth.type == htons(ETH_P_IPV6))
-			memcpy(&key->ipv6.addr.dst, &ipv6_hdr(skb)->daddr,
-			       sizeof(key->ipv6.addr.dst));
-		else
-			return;
-
-		if (key->ip.proto == IPPROTO_UDP)
-			dst = udp_hdr(skb)->dest;
-		else if (key->ip.proto == IPPROTO_TCP)
-			dst = tcp_hdr(skb)->dest;
-		else if (key->ip.proto == IPPROTO_SCTP)
-			dst = sctp_hdr(skb)->dest;
-		else
-			return;
+	/* Update the flow key if NAT successful. */
+	if (err == NF_ACCEPT)
+		ovs_nat_update_key(key, skb, maniptype);
 
-		key->tp.dst = dst;
-	}
+	return err;
 }
 
 /* Returns NF_DROP if the packet should be dropped, NF_ACCEPT otherwise. */
@@ -903,7 +907,7 @@ static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 	} else {
 		return NF_ACCEPT; /* Connection is not NATed. */
 	}
-	err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype);
+	err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype, key);
 
 	if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
 		if (ct->status & IPS_SRC_NAT) {
@@ -913,17 +917,13 @@ static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 				maniptype = NF_NAT_MANIP_SRC;
 
 			err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range,
-						 maniptype);
+						 maniptype, key);
 		} else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
 			err = ovs_ct_nat_execute(skb, ct, ctinfo, NULL,
-						 NF_NAT_MANIP_SRC);
+						 NF_NAT_MANIP_SRC, key);
 		}
 	}
 
-	/* Mark NAT done if successful and update the flow key. */
-	if (err == NF_ACCEPT)
-		ovs_nat_update_key(key, skb, maniptype);
-
 	return err;
 }
 #else /* !CONFIG_NF_NAT */
-- 
2.34.1



