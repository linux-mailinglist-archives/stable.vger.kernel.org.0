Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7B254FAAE
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 17:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383101AbiFQP5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 11:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbiFQP5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 11:57:01 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37DA2F006
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 08:56:59 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 7574C4000F;
        Fri, 17 Jun 2022 15:56:57 +0000 (UTC)
From:   Ilya Maximets <i.maximets@ovn.org>
To:     stable@vger.kernel.org
Cc:     Ilya Maximets <i.maximets@ovn.org>,
        Frode Nordahl <frode.nordahl@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10] net: openvswitch: fix misuse of the cached connection on tuple changes
Date:   Fri, 17 Jun 2022 17:56:49 +0200
Message-Id: <20220617155649.238255-1-i.maximets@ovn.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2061ecfdf2350994e5b61c43e50e98a7a70e95ee upstream

[Backport to 5.10: minor rebase in ovs_ct_clear function.
 This version also applicable to and tested on 5.4 and 4.19.]

If packet headers changed, the cached nfct is no longer relevant
for the packet and attempt to re-use it leads to the incorrect packet
classification.

This issue is causing broken connectivity in OpenStack deployments
with OVS/OVN due to hairpin traffic being unexpectedly dropped.

The setup has datapath flows with several conntrack actions and tuple
changes between them:

  actions:ct(commit,zone=8,mark=0/0x1,nat(src)),
          set(eth(src=00:00:00:00:00:01,dst=00:00:00:00:00:06)),
          set(ipv4(src=172.18.2.10,dst=192.168.100.6,ttl=62)),
          ct(zone=8),recirc(0x4)

After the first ct() action the packet headers are almost fully
re-written.  The next ct() tries to re-use the existing nfct entry
and marks the packet as invalid, so it gets dropped later in the
pipeline.

Clearing the cached conntrack entry whenever packet tuple is changed
to avoid the issue.

The flow key should not be cleared though, because we should still
be able to match on the ct_state if the recirculation happens after
the tuple change but before the next ct() action.

Cc: stable@vger.kernel.org
Fixes: 7f8a436eaa2c ("openvswitch: Add conntrack action")
Reported-by: Frode Nordahl <frode.nordahl@canonical.com>
Link: https://mail.openvswitch.org/pipermail/ovs-discuss/2022-May/051829.html
Link: https://bugs.launchpad.net/ubuntu/+source/ovn/+bug/1967856
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://lore.kernel.org/r/20220606221140.488984-1-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---

The patch was already backported down to 5.15.
This version was adjusted to work on 5.10, 5.4 and 4.19.

 net/openvswitch/actions.c   | 6 ++++++
 net/openvswitch/conntrack.c | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 6d8d70021666..80fee9d118ee 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -372,6 +372,7 @@ static void set_ip_addr(struct sk_buff *skb, struct iphdr *nh,
 	update_ip_l4_checksum(skb, nh, *addr, new_addr);
 	csum_replace4(&nh->check, *addr, new_addr);
 	skb_clear_hash(skb);
+	ovs_ct_clear(skb, NULL);
 	*addr = new_addr;
 }
 
@@ -419,6 +420,7 @@ static void set_ipv6_addr(struct sk_buff *skb, u8 l4_proto,
 		update_ipv6_checksum(skb, l4_proto, addr, new_addr);
 
 	skb_clear_hash(skb);
+	ovs_ct_clear(skb, NULL);
 	memcpy(addr, new_addr, sizeof(__be32[4]));
 }
 
@@ -659,6 +661,7 @@ static int set_nsh(struct sk_buff *skb, struct sw_flow_key *flow_key,
 static void set_tp_port(struct sk_buff *skb, __be16 *port,
 			__be16 new_port, __sum16 *check)
 {
+	ovs_ct_clear(skb, NULL);
 	inet_proto_csum_replace2(check, skb, *port, new_port, false);
 	*port = new_port;
 }
@@ -698,6 +701,7 @@ static int set_udp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 		uh->dest = dst;
 		flow_key->tp.src = src;
 		flow_key->tp.dst = dst;
+		ovs_ct_clear(skb, NULL);
 	}
 
 	skb_clear_hash(skb);
@@ -760,6 +764,8 @@ static int set_sctp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	sh->checksum = old_csum ^ old_correct_csum ^ new_csum;
 
 	skb_clear_hash(skb);
+	ovs_ct_clear(skb, NULL);
+
 	flow_key->tp.src = sh->source;
 	flow_key->tp.dst = sh->dest;
 
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 7ff98d39ec94..41f248895a87 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1324,7 +1324,8 @@ int ovs_ct_clear(struct sk_buff *skb, struct sw_flow_key *key)
 	if (skb_nfct(skb)) {
 		nf_conntrack_put(skb_nfct(skb));
 		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
-		ovs_ct_fill_key(skb, key);
+		if (key)
+			ovs_ct_fill_key(skb, key);
 	}
 
 	return 0;
-- 
2.34.3

