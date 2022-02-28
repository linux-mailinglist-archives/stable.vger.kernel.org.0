Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8B54C74ED
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238827AbiB1RtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239135AbiB1RsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:48:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC3D7F6DC;
        Mon, 28 Feb 2022 09:38:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44E77614CC;
        Mon, 28 Feb 2022 17:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FECC340F4;
        Mon, 28 Feb 2022 17:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069921;
        bh=r0Z4C8eDA3KQUAtoijoXzLcHNx4ACTiR/uJim8ztYUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6tsfBxuzLjZFtugNqnvs9dRex8cVv29QPp2OWs2uhWKNShO/+s89T6xMwAiF0dxn
         OVG+K9ajw5d7mEMGj0WqlHSsMdAGdsJhy66hYKWprdmBFurDYnDZwFAt8Ph5Cgxosr
         lmXXeUqEukSc3iSkMngQbHTN4ZvVslz8qAUU9XBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 061/139] openvswitch: Fix setting ipv6 fields causing hw csum failure
Date:   Mon, 28 Feb 2022 18:23:55 +0100
Message-Id: <20220228172354.110053185@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

commit d9b5ae5c1b241b91480aa30408be12fe91af834a upstream.

Ipv6 ttl, label and tos fields are modified without first
pulling/pushing the ipv6 header, which would have updated
the hw csum (if available). This might cause csum validation
when sending the packet to the stack, as can be seen in
the trace below.

Fix this by updating skb->csum if available.

Trace resulted by ipv6 ttl dec and then sending packet
to conntrack [actions: set(ipv6(hlimit=63)),ct(zone=99)]:
[295241.900063] s_pf0vf2: hw csum failure
[295241.923191] Call Trace:
[295241.925728]  <IRQ>
[295241.927836]  dump_stack+0x5c/0x80
[295241.931240]  __skb_checksum_complete+0xac/0xc0
[295241.935778]  nf_conntrack_tcp_packet+0x398/0xba0 [nf_conntrack]
[295241.953030]  nf_conntrack_in+0x498/0x5e0 [nf_conntrack]
[295241.958344]  __ovs_ct_lookup+0xac/0x860 [openvswitch]
[295241.968532]  ovs_ct_execute+0x4a7/0x7c0 [openvswitch]
[295241.979167]  do_execute_actions+0x54a/0xaa0 [openvswitch]
[295242.001482]  ovs_execute_actions+0x48/0x100 [openvswitch]
[295242.006966]  ovs_dp_process_packet+0x96/0x1d0 [openvswitch]
[295242.012626]  ovs_vport_receive+0x6c/0xc0 [openvswitch]
[295242.028763]  netdev_frame_hook+0xc0/0x180 [openvswitch]
[295242.034074]  __netif_receive_skb_core+0x2ca/0xcb0
[295242.047498]  netif_receive_skb_internal+0x3e/0xc0
[295242.052291]  napi_gro_receive+0xba/0xe0
[295242.056231]  mlx5e_handle_rx_cqe_mpwrq_rep+0x12b/0x250 [mlx5_core]
[295242.062513]  mlx5e_poll_rx_cq+0xa0f/0xa30 [mlx5_core]
[295242.067669]  mlx5e_napi_poll+0xe1/0x6b0 [mlx5_core]
[295242.077958]  net_rx_action+0x149/0x3b0
[295242.086762]  __do_softirq+0xd7/0x2d6
[295242.090427]  irq_exit+0xf7/0x100
[295242.093748]  do_IRQ+0x7f/0xd0
[295242.096806]  common_interrupt+0xf/0xf
[295242.100559]  </IRQ>
[295242.102750] RIP: 0033:0x7f9022e88cbd
[295242.125246] RSP: 002b:00007f9022282b20 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffda
[295242.132900] RAX: 0000000000000005 RBX: 0000000000000010 RCX: 0000000000000000
[295242.140120] RDX: 00007f9022282ba8 RSI: 00007f9022282a30 RDI: 00007f9014005c30
[295242.147337] RBP: 00007f9014014d60 R08: 0000000000000020 R09: 00007f90254a8340
[295242.154557] R10: 00007f9022282a28 R11: 0000000000000246 R12: 0000000000000000
[295242.161775] R13: 00007f902308c000 R14: 000000000000002b R15: 00007f9022b71f40

Fixes: 3fdbd1ce11e5 ("openvswitch: add ipv6 'set' action")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Link: https://lore.kernel.org/r/20220223163416.24096-1-paulb@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/checksum.h    |    5 +++++
 net/openvswitch/actions.c |   46 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 8 deletions(-)

--- a/include/net/checksum.h
+++ b/include/net/checksum.h
@@ -141,6 +141,11 @@ static inline void csum_replace2(__sum16
 	*sum = ~csum16_add(csum16_sub(~(*sum), old), new);
 }
 
+static inline void csum_replace(__wsum *csum, __wsum old, __wsum new)
+{
+	*csum = csum_add(csum_sub(*csum, old), new);
+}
+
 struct sk_buff;
 void inet_proto_csum_replace4(__sum16 *sum, struct sk_buff *skb,
 			      __be32 from, __be32 to, bool pseudohdr);
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -423,12 +423,43 @@ static void set_ipv6_addr(struct sk_buff
 	memcpy(addr, new_addr, sizeof(__be32[4]));
 }
 
-static void set_ipv6_fl(struct ipv6hdr *nh, u32 fl, u32 mask)
+static void set_ipv6_dsfield(struct sk_buff *skb, struct ipv6hdr *nh, u8 ipv6_tclass, u8 mask)
 {
+	u8 old_ipv6_tclass = ipv6_get_dsfield(nh);
+
+	ipv6_tclass = OVS_MASKED(old_ipv6_tclass, ipv6_tclass, mask);
+
+	if (skb->ip_summed == CHECKSUM_COMPLETE)
+		csum_replace(&skb->csum, (__force __wsum)(old_ipv6_tclass << 12),
+			     (__force __wsum)(ipv6_tclass << 12));
+
+	ipv6_change_dsfield(nh, ~mask, ipv6_tclass);
+}
+
+static void set_ipv6_fl(struct sk_buff *skb, struct ipv6hdr *nh, u32 fl, u32 mask)
+{
+	u32 ofl;
+
+	ofl = nh->flow_lbl[0] << 16 |  nh->flow_lbl[1] << 8 |  nh->flow_lbl[2];
+	fl = OVS_MASKED(ofl, fl, mask);
+
 	/* Bits 21-24 are always unmasked, so this retains their values. */
-	OVS_SET_MASKED(nh->flow_lbl[0], (u8)(fl >> 16), (u8)(mask >> 16));
-	OVS_SET_MASKED(nh->flow_lbl[1], (u8)(fl >> 8), (u8)(mask >> 8));
-	OVS_SET_MASKED(nh->flow_lbl[2], (u8)fl, (u8)mask);
+	nh->flow_lbl[0] = (u8)(fl >> 16);
+	nh->flow_lbl[1] = (u8)(fl >> 8);
+	nh->flow_lbl[2] = (u8)fl;
+
+	if (skb->ip_summed == CHECKSUM_COMPLETE)
+		csum_replace(&skb->csum, (__force __wsum)htonl(ofl), (__force __wsum)htonl(fl));
+}
+
+static void set_ipv6_ttl(struct sk_buff *skb, struct ipv6hdr *nh, u8 new_ttl, u8 mask)
+{
+	new_ttl = OVS_MASKED(nh->hop_limit, new_ttl, mask);
+
+	if (skb->ip_summed == CHECKSUM_COMPLETE)
+		csum_replace(&skb->csum, (__force __wsum)(nh->hop_limit << 8),
+			     (__force __wsum)(new_ttl << 8));
+	nh->hop_limit = new_ttl;
 }
 
 static void set_ip_ttl(struct sk_buff *skb, struct iphdr *nh, u8 new_ttl,
@@ -546,18 +577,17 @@ static int set_ipv6(struct sk_buff *skb,
 		}
 	}
 	if (mask->ipv6_tclass) {
-		ipv6_change_dsfield(nh, ~mask->ipv6_tclass, key->ipv6_tclass);
+		set_ipv6_dsfield(skb, nh, key->ipv6_tclass, mask->ipv6_tclass);
 		flow_key->ip.tos = ipv6_get_dsfield(nh);
 	}
 	if (mask->ipv6_label) {
-		set_ipv6_fl(nh, ntohl(key->ipv6_label),
+		set_ipv6_fl(skb, nh, ntohl(key->ipv6_label),
 			    ntohl(mask->ipv6_label));
 		flow_key->ipv6.label =
 		    *(__be32 *)nh & htonl(IPV6_FLOWINFO_FLOWLABEL);
 	}
 	if (mask->ipv6_hlimit) {
-		OVS_SET_MASKED(nh->hop_limit, key->ipv6_hlimit,
-			       mask->ipv6_hlimit);
+		set_ipv6_ttl(skb, nh, key->ipv6_hlimit, mask->ipv6_hlimit);
 		flow_key->ip.ttl = nh->hop_limit;
 	}
 	return 0;


