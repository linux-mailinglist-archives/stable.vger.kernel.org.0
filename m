Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625D3548098
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 09:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239119AbiFMH2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 03:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239130AbiFMH2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 03:28:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B91193E1
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 00:28:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E033B80D76
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82296C3411C;
        Mon, 13 Jun 2022 07:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655105289;
        bh=ttiaMSskNWsOBAnTcAA1Jd5cs9KiMBogJ/A2bv+mGrU=;
        h=Subject:To:Cc:From:Date:From;
        b=btb/BXmV0FPiAS1YEYAxYQG3fee9w6ODJOEo+MkgusiH4ijHUYd5/YQvJ716CeYj0
         ci/USXcJhnFezLmg8O3P4eSIQRXQ06Cx8QG2Zosdps5LjsqovZtJC4cH+0GjA9BDfd
         Ahh1cOc3+suPFyyYLr7D83/OLMnTqKdmMc1xThZc=
Subject: FAILED: patch "[PATCH] net: openvswitch: fix misuse of the cached connection on" failed to apply to 4.14-stable tree
To:     i.maximets@ovn.org, frode.nordahl@canonical.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 09:27:58 +0200
Message-ID: <165510527821382@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2061ecfdf2350994e5b61c43e50e98a7a70e95ee Mon Sep 17 00:00:00 2001
From: Ilya Maximets <i.maximets@ovn.org>
Date: Tue, 7 Jun 2022 00:11:40 +0200
Subject: [PATCH] net: openvswitch: fix misuse of the cached connection on
 tuple changes

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

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 1b5d73079dc9..868db4669a29 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -373,6 +373,7 @@ static void set_ip_addr(struct sk_buff *skb, struct iphdr *nh,
 	update_ip_l4_checksum(skb, nh, *addr, new_addr);
 	csum_replace4(&nh->check, *addr, new_addr);
 	skb_clear_hash(skb);
+	ovs_ct_clear(skb, NULL);
 	*addr = new_addr;
 }
 
@@ -420,6 +421,7 @@ static void set_ipv6_addr(struct sk_buff *skb, u8 l4_proto,
 		update_ipv6_checksum(skb, l4_proto, addr, new_addr);
 
 	skb_clear_hash(skb);
+	ovs_ct_clear(skb, NULL);
 	memcpy(addr, new_addr, sizeof(__be32[4]));
 }
 
@@ -660,6 +662,7 @@ static int set_nsh(struct sk_buff *skb, struct sw_flow_key *flow_key,
 static void set_tp_port(struct sk_buff *skb, __be16 *port,
 			__be16 new_port, __sum16 *check)
 {
+	ovs_ct_clear(skb, NULL);
 	inet_proto_csum_replace2(check, skb, *port, new_port, false);
 	*port = new_port;
 }
@@ -699,6 +702,7 @@ static int set_udp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 		uh->dest = dst;
 		flow_key->tp.src = src;
 		flow_key->tp.dst = dst;
+		ovs_ct_clear(skb, NULL);
 	}
 
 	skb_clear_hash(skb);
@@ -761,6 +765,8 @@ static int set_sctp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	sh->checksum = old_csum ^ old_correct_csum ^ new_csum;
 
 	skb_clear_hash(skb);
+	ovs_ct_clear(skb, NULL);
+
 	flow_key->tp.src = sh->source;
 	flow_key->tp.dst = sh->dest;
 
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 4a947c13c813..4e70df91d0f2 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1342,7 +1342,9 @@ int ovs_ct_clear(struct sk_buff *skb, struct sw_flow_key *key)
 
 	nf_ct_put(ct);
 	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
-	ovs_ct_fill_key(skb, key, false);
+
+	if (key)
+		ovs_ct_fill_key(skb, key, false);
 
 	return 0;
 }

