Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6214C1CAFDF
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgEHNVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728660AbgEHMk3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7EE021835;
        Fri,  8 May 2020 12:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941628;
        bh=TFNhKuLpw3OQr4b7CKnFUrnR9pkd+mWFol/OPa/GFEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIK+ThjVq19+DbRItrzImuEO/MATno+Eiv0iXjVTZhZsesmaZL95a9RNjaD7U9MZQ
         VIMd5b/81JHRmUXjUy5x0eovmjzsv6R+LUHEbbp23G6/T5/621udL7MyadCd2SGCF9
         d07jpamDbH5CYQXAxiwxtPg2Js1hpJorMQdGnXjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Duyck <aduyck@mirantis.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 068/312] GRE: Disable segmentation offloads w/ CSUM and we are encapsulated via FOU
Date:   Fri,  8 May 2020 14:30:59 +0200
Message-Id: <20200508123129.332155925@linuxfoundation.org>
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

From: Alexander Duyck <aduyck@mirantis.com>

commit a0ca153f98db8cf25298565a09e11fe9d82846ad upstream.

This patch fixes an issue I found in which we were dropping frames if we
had enabled checksums on GRE headers that were encapsulated by either FOU
or GUE.  Without this patch I was barely able to get 1 Gb/s of throughput.
With this patch applied I am now at least getting around 6 Gb/s.

The issue is due to the fact that with FOU or GUE applied we do not provide
a transport offset pointing to the GRE header, nor do we offload it in
software as the GRE header is completely skipped by GSO and treated like a
VXLAN or GENEVE type header.  As such we need to prevent the stack from
generating it and also prevent GRE from generating it via any interface we
create.

Fixes: c3483384ee511 ("gro: Allow tunnel stacking in the case of FOU/GUE")
Signed-off-by: Alexander Duyck <aduyck@mirantis.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/netdevice.h |    5 ++++-
 net/core/dev.c            |    1 +
 net/ipv4/fou.c            |    6 ++++++
 net/ipv4/gre_offload.c    |    8 ++++++++
 net/ipv4/ip_gre.c         |   13 ++++++++++---
 5 files changed, 29 insertions(+), 4 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2013,7 +2013,10 @@ struct napi_gro_cb {
 	/* Number of gro_receive callbacks this packet already went through */
 	u8 recursion_counter:4;
 
-	/* 3 bit hole */
+	/* Used in GRE, set in fou/gue_gro_receive */
+	u8	is_fou:1;
+
+	/* 2 bit hole */
 
 	/* used to support CHECKSUM_COMPLETE for tunneling protocols */
 	__wsum	csum;
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4320,6 +4320,7 @@ static enum gro_result dev_gro_receive(s
 		NAPI_GRO_CB(skb)->free = 0;
 		NAPI_GRO_CB(skb)->encap_mark = 0;
 		NAPI_GRO_CB(skb)->recursion_counter = 0;
+		NAPI_GRO_CB(skb)->is_fou = 0;
 		NAPI_GRO_CB(skb)->gro_remcsum_start = 0;
 
 		/* Setup for GRO checksum validation */
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -205,6 +205,9 @@ static struct sk_buff **fou_gro_receive(
 	 */
 	NAPI_GRO_CB(skb)->encap_mark = 0;
 
+	/* Flag this frame as already having an outer encap header */
+	NAPI_GRO_CB(skb)->is_fou = 1;
+
 	rcu_read_lock();
 	offloads = NAPI_GRO_CB(skb)->is_ipv6 ? inet6_offloads : inet_offloads;
 	ops = rcu_dereference(offloads[proto]);
@@ -372,6 +375,9 @@ static struct sk_buff **gue_gro_receive(
 	 */
 	NAPI_GRO_CB(skb)->encap_mark = 0;
 
+	/* Flag this frame as already having an outer encap header */
+	NAPI_GRO_CB(skb)->is_fou = 1;
+
 	rcu_read_lock();
 	offloads = NAPI_GRO_CB(skb)->is_ipv6 ? inet6_offloads : inet_offloads;
 	ops = rcu_dereference(offloads[guehdr->proto_ctype]);
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -151,6 +151,14 @@ static struct sk_buff **gre_gro_receive(
 	if ((greh->flags & ~(GRE_KEY|GRE_CSUM)) != 0)
 		goto out;
 
+	/* We can only support GRE_CSUM if we can track the location of
+	 * the GRE header.  In the case of FOU/GUE we cannot because the
+	 * outer UDP header displaces the GRE header leaving us in a state
+	 * of limbo.
+	 */
+	if ((greh->flags & GRE_CSUM) && NAPI_GRO_CB(skb)->is_fou)
+		goto out;
+
 	type = greh->protocol;
 
 	rcu_read_lock();
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -851,9 +851,16 @@ static void __gre_tunnel_init(struct net
 	dev->hw_features	|= GRE_FEATURES;
 
 	if (!(tunnel->parms.o_flags & TUNNEL_SEQ)) {
-		/* TCP offload with GRE SEQ is not supported. */
-		dev->features    |= NETIF_F_GSO_SOFTWARE;
-		dev->hw_features |= NETIF_F_GSO_SOFTWARE;
+		/* TCP offload with GRE SEQ is not supported, nor
+		 * can we support 2 levels of outer headers requiring
+		 * an update.
+		 */
+		if (!(tunnel->parms.o_flags & TUNNEL_CSUM) ||
+		    (tunnel->encap.type == TUNNEL_ENCAP_NONE)) {
+			dev->features    |= NETIF_F_GSO_SOFTWARE;
+			dev->hw_features |= NETIF_F_GSO_SOFTWARE;
+		}
+
 		/* Can use a lockless transmit, unless we generate
 		 * output sequences
 		 */


