Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6DFE6798
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732113AbfJ0VWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:22:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732084AbfJ0VWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:22:16 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 820CA2070B;
        Sun, 27 Oct 2019 21:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211335;
        bh=2nEcRshp5xhvza40m8+vlnqa7DtGgn2vAsX0H6M8crY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zXLLOP5ruz6BZZYS91AF4THc0E0f8a/uRqXwSgsR2wyrUhw0oENWGiIjwpL0qjW7e
         KQt14A5BfaNAv+lAAexlL4kf+PfCRoWfNc8Oc7gE5CSCcEeGEfHPajhvlRxkEpaKqw
         p8Nip9kghUTMww/fg4Km4hcy3d7xct2i/2DUhsig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 088/197] net/sched: fix corrupted L2 header with MPLS push and pop actions
Date:   Sun, 27 Oct 2019 22:00:06 +0100
Message-Id: <20191027203356.491152717@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit fa4e0f8855fcba600e0be2575ee29c69166f74bd ]

the following script:

 # tc qdisc add dev eth0 clsact
 # tc filter add dev eth0 egress protocol ip matchall \
 > action mpls push protocol mpls_uc label 0x355aa bos 1

causes corruption of all IP packets transmitted by eth0. On TC egress, we
can't rely on the value of skb->mac_len, because it's 0 and a MPLS 'push'
operation will result in an overwrite of the first 4 octets in the packet
L2 header (e.g. the Destination Address if eth0 is an Ethernet); the same
error pattern is present also in the MPLS 'pop' operation. Fix this error
in act_mpls data plane, computing 'mac_len' as the difference between the
network header and the mac header (when not at TC ingress), and use it in
MPLS 'push'/'pop' core functions.

v2: unbreak 'make htmldocs' because of missing documentation of 'mac_len'
    in skb_mpls_pop(), reported by kbuild test robot

CC: Lorenzo Bianconi <lorenzo@kernel.org>
Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Acked-by: John Hurley <john.hurley@netronome.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h    |    5 +++--
 net/core/skbuff.c         |   19 +++++++++++--------
 net/openvswitch/actions.c |    5 +++--
 net/sched/act_mpls.c      |   12 ++++++++----
 4 files changed, 25 insertions(+), 16 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3465,8 +3465,9 @@ int skb_ensure_writable(struct sk_buff *
 int __skb_vlan_pop(struct sk_buff *skb, u16 *vlan_tci);
 int skb_vlan_pop(struct sk_buff *skb);
 int skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci);
-int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto);
-int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto);
+int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
+		  int mac_len);
+int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len);
 int skb_mpls_update_lse(struct sk_buff *skb, __be32 mpls_lse);
 int skb_mpls_dec_ttl(struct sk_buff *skb);
 struct sk_buff *pskb_extract(struct sk_buff *skb, int off, int to_copy,
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5465,12 +5465,14 @@ static void skb_mod_eth_type(struct sk_b
  * @skb: buffer
  * @mpls_lse: MPLS label stack entry to push
  * @mpls_proto: ethertype of the new MPLS header (expects 0x8847 or 0x8848)
+ * @mac_len: length of the MAC header
  *
  * Expects skb->data at mac header.
  *
  * Returns 0 on success, -errno otherwise.
  */
-int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto)
+int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
+		  int mac_len)
 {
 	struct mpls_shim_hdr *lse;
 	int err;
@@ -5487,15 +5489,15 @@ int skb_mpls_push(struct sk_buff *skb, _
 		return err;
 
 	if (!skb->inner_protocol) {
-		skb_set_inner_network_header(skb, skb->mac_len);
+		skb_set_inner_network_header(skb, mac_len);
 		skb_set_inner_protocol(skb, skb->protocol);
 	}
 
 	skb_push(skb, MPLS_HLEN);
 	memmove(skb_mac_header(skb) - MPLS_HLEN, skb_mac_header(skb),
-		skb->mac_len);
+		mac_len);
 	skb_reset_mac_header(skb);
-	skb_set_network_header(skb, skb->mac_len);
+	skb_set_network_header(skb, mac_len);
 
 	lse = mpls_hdr(skb);
 	lse->label_stack_entry = mpls_lse;
@@ -5514,29 +5516,30 @@ EXPORT_SYMBOL_GPL(skb_mpls_push);
  *
  * @skb: buffer
  * @next_proto: ethertype of header after popped MPLS header
+ * @mac_len: length of the MAC header
  *
  * Expects skb->data at mac header.
  *
  * Returns 0 on success, -errno otherwise.
  */
-int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto)
+int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len)
 {
 	int err;
 
 	if (unlikely(!eth_p_mpls(skb->protocol)))
 		return 0;
 
-	err = skb_ensure_writable(skb, skb->mac_len + MPLS_HLEN);
+	err = skb_ensure_writable(skb, mac_len + MPLS_HLEN);
 	if (unlikely(err))
 		return err;
 
 	skb_postpull_rcsum(skb, mpls_hdr(skb), MPLS_HLEN);
 	memmove(skb_mac_header(skb) + MPLS_HLEN, skb_mac_header(skb),
-		skb->mac_len);
+		mac_len);
 
 	__skb_pull(skb, MPLS_HLEN);
 	skb_reset_mac_header(skb);
-	skb_set_network_header(skb, skb->mac_len);
+	skb_set_network_header(skb, mac_len);
 
 	if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
 		struct ethhdr *hdr;
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -165,7 +165,8 @@ static int push_mpls(struct sk_buff *skb
 {
 	int err;
 
-	err = skb_mpls_push(skb, mpls->mpls_lse, mpls->mpls_ethertype);
+	err = skb_mpls_push(skb, mpls->mpls_lse, mpls->mpls_ethertype,
+			    skb->mac_len);
 	if (err)
 		return err;
 
@@ -178,7 +179,7 @@ static int pop_mpls(struct sk_buff *skb,
 {
 	int err;
 
-	err = skb_mpls_pop(skb, ethertype);
+	err = skb_mpls_pop(skb, ethertype, skb->mac_len);
 	if (err)
 		return err;
 
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -55,7 +55,7 @@ static int tcf_mpls_act(struct sk_buff *
 	struct tcf_mpls *m = to_mpls(a);
 	struct tcf_mpls_params *p;
 	__be32 new_lse;
-	int ret;
+	int ret, mac_len;
 
 	tcf_lastuse_update(&m->tcf_tm);
 	bstats_cpu_update(this_cpu_ptr(m->common.cpu_bstats), skb);
@@ -63,8 +63,12 @@ static int tcf_mpls_act(struct sk_buff *
 	/* Ensure 'data' points at mac_header prior calling mpls manipulating
 	 * functions.
 	 */
-	if (skb_at_tc_ingress(skb))
+	if (skb_at_tc_ingress(skb)) {
 		skb_push_rcsum(skb, skb->mac_len);
+		mac_len = skb->mac_len;
+	} else {
+		mac_len = skb_network_header(skb) - skb_mac_header(skb);
+	}
 
 	ret = READ_ONCE(m->tcf_action);
 
@@ -72,12 +76,12 @@ static int tcf_mpls_act(struct sk_buff *
 
 	switch (p->tcfm_action) {
 	case TCA_MPLS_ACT_POP:
-		if (skb_mpls_pop(skb, p->tcfm_proto))
+		if (skb_mpls_pop(skb, p->tcfm_proto, mac_len))
 			goto drop;
 		break;
 	case TCA_MPLS_ACT_PUSH:
 		new_lse = tcf_mpls_get_lse(NULL, p, !eth_p_mpls(skb->protocol));
-		if (skb_mpls_push(skb, new_lse, p->tcfm_proto))
+		if (skb_mpls_push(skb, new_lse, p->tcfm_proto, mac_len))
 			goto drop;
 		break;
 	case TCA_MPLS_ACT_MODIFY:


