Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E776D551B65
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245360AbiFTNLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343963AbiFTNJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:09:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008651AF26;
        Mon, 20 Jun 2022 06:04:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 020C96159F;
        Mon, 20 Jun 2022 13:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13081C3411B;
        Mon, 20 Jun 2022 13:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730254;
        bh=WJbhDVgho8feozDRu3uCkpb8QYDZn+orPxbdl0Va0vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AOmP2PK5s1+KxNffiU/LXR8J+6wdFr1e74v6AVQS7jI7nWGmqZKdNieU/EtXKh548
         AVvNFtwzHH8sbtISjWG3Aj0F6cRdHz3N2/0d0uSLDUTAV+JdFo8zgm5ahrbvbkQYg+
         yWwDJatF/eYgT4ofRy4E8yoq95ZKhzjM9LMPkTs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Frode Nordahl <frode.nordahl@canonical.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 80/84] net: openvswitch: fix misuse of the cached connection on tuple changes
Date:   Mon, 20 Jun 2022 14:51:43 +0200
Message-Id: <20220620124723.254446622@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Maximets <i.maximets@ovn.org>

commit 2061ecfdf2350994e5b61c43e50e98a7a70e95ee upstream.

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
[Backport to 5.10: minor rebase in ovs_ct_clear function.
 This version also applicable to and tested on 5.4 and 4.19.]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/actions.c   |    6 ++++++
 net/openvswitch/conntrack.c |    3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -372,6 +372,7 @@ static void set_ip_addr(struct sk_buff *
 	update_ip_l4_checksum(skb, nh, *addr, new_addr);
 	csum_replace4(&nh->check, *addr, new_addr);
 	skb_clear_hash(skb);
+	ovs_ct_clear(skb, NULL);
 	*addr = new_addr;
 }
 
@@ -419,6 +420,7 @@ static void set_ipv6_addr(struct sk_buff
 		update_ipv6_checksum(skb, l4_proto, addr, new_addr);
 
 	skb_clear_hash(skb);
+	ovs_ct_clear(skb, NULL);
 	memcpy(addr, new_addr, sizeof(__be32[4]));
 }
 
@@ -659,6 +661,7 @@ static int set_nsh(struct sk_buff *skb,
 static void set_tp_port(struct sk_buff *skb, __be16 *port,
 			__be16 new_port, __sum16 *check)
 {
+	ovs_ct_clear(skb, NULL);
 	inet_proto_csum_replace2(check, skb, *port, new_port, false);
 	*port = new_port;
 }
@@ -698,6 +701,7 @@ static int set_udp(struct sk_buff *skb,
 		uh->dest = dst;
 		flow_key->tp.src = src;
 		flow_key->tp.dst = dst;
+		ovs_ct_clear(skb, NULL);
 	}
 
 	skb_clear_hash(skb);
@@ -760,6 +764,8 @@ static int set_sctp(struct sk_buff *skb,
 	sh->checksum = old_csum ^ old_correct_csum ^ new_csum;
 
 	skb_clear_hash(skb);
+	ovs_ct_clear(skb, NULL);
+
 	flow_key->tp.src = sh->source;
 	flow_key->tp.dst = sh->dest;
 
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1324,7 +1324,8 @@ int ovs_ct_clear(struct sk_buff *skb, st
 	if (skb_nfct(skb)) {
 		nf_conntrack_put(skb_nfct(skb));
 		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
-		ovs_ct_fill_key(skb, key);
+		if (key)
+			ovs_ct_fill_key(skb, key);
 	}
 
 	return 0;


