Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5164D1CAEB6
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgEHMqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:46:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729032AbgEHMqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFC112495D;
        Fri,  8 May 2020 12:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941981;
        bh=fINJ4RS1aGd8Oraqq6uFAhTIVFDtSTV451XO1mZblEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wAcMC8LsL6PQQhGhxpeOBI1eZReEq9WIHw5PoJZiZPJSEpObMYkHsxCls80RJXz5i
         5nHzyaQ2zotMVDRfA0zj6IZun83p/ORYcvDYp6Db6xEXEN5fM7FnIRQS+AsFbOzxXd
         S/ptakfhLt3j62vmIkkzgNpprxumiSJeBxWn5arE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pravin Shelar <pshelar@nicira.com>,
        Simon Horman <simon.horman@netronome.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 249/312] openvswitch: update checksum in {push,pop}_mpls
Date:   Fri,  8 May 2020 14:34:00 +0200
Message-Id: <20200508123141.932214918@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Horman <simon.horman@netronome.com>

commit bc7cc5999fd392cc799630d7e375b2f4e29cc398 upstream.

In the case of CHECKSUM_COMPLETE the skb checksum should be updated in
{push,pop}_mpls() as they the type in the ethernet header.

As suggested by Pravin Shelar.

Cc: Pravin Shelar <pshelar@nicira.com>
Fixes: 25cd9ba0abc0 ("openvswitch: Add basic MPLS support to kernel")
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/openvswitch/actions.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -137,11 +137,23 @@ static bool is_flow_key_valid(const stru
 	return !!key->eth.type;
 }
 
+static void update_ethertype(struct sk_buff *skb, struct ethhdr *hdr,
+			     __be16 ethertype)
+{
+	if (skb->ip_summed == CHECKSUM_COMPLETE) {
+		__be16 diff[] = { ~(hdr->h_proto), ethertype };
+
+		skb->csum = ~csum_partial((char *)diff, sizeof(diff),
+					~skb->csum);
+	}
+
+	hdr->h_proto = ethertype;
+}
+
 static int push_mpls(struct sk_buff *skb, struct sw_flow_key *key,
 		     const struct ovs_action_push_mpls *mpls)
 {
 	__be32 *new_mpls_lse;
-	struct ethhdr *hdr;
 
 	/* Networking stack do not allow simultaneous Tunnel and MPLS GSO. */
 	if (skb->encapsulation)
@@ -160,9 +172,7 @@ static int push_mpls(struct sk_buff *skb
 
 	skb_postpush_rcsum(skb, new_mpls_lse, MPLS_HLEN);
 
-	hdr = eth_hdr(skb);
-	hdr->h_proto = mpls->mpls_ethertype;
-
+	update_ethertype(skb, eth_hdr(skb), mpls->mpls_ethertype);
 	if (!skb->inner_protocol)
 		skb_set_inner_protocol(skb, skb->protocol);
 	skb->protocol = mpls->mpls_ethertype;
@@ -193,7 +203,7 @@ static int pop_mpls(struct sk_buff *skb,
 	 * field correctly in the presence of VLAN tags.
 	 */
 	hdr = (struct ethhdr *)(skb_mpls_header(skb) - ETH_HLEN);
-	hdr->h_proto = ethertype;
+	update_ethertype(skb, hdr, ethertype);
 	if (eth_p_mpls(skb->protocol))
 		skb->protocol = ethertype;
 


