Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7D72409A5
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbgHJPeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:34:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbgHJP3L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:29:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E94722B47;
        Mon, 10 Aug 2020 15:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073350;
        bh=97QJhoJYDeam/oMbkKOnP6nfbKvfx2kmikgCEsZvy+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I2uaY/TNxG6OG8ANyr/RtlWOq4kVZJvLW21n6/7Tt3xWSUhq+qdZwILMNPOtaUdph
         RYFRne439P5Y8w/wn+YXnsT9Tvihp98MO9i/KpSxOdUarjYkxFDym7mpniEWO0gFMn
         i02rZj7HJ30iK+7mGwDI0ZjWnccU+UMnW8B3Eosc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 62/67] openvswitch: Prevent kernel-infoleak in ovs_ct_put_key()
Date:   Mon, 10 Aug 2020 17:21:49 +0200
Message-Id: <20200810151812.564468225@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

[ Upstream commit 9aba6c5b49254d5bee927d81593ed4429e91d4ae ]

ovs_ct_put_key() is potentially copying uninitialized kernel stack memory
into socket buffers, since the compiler may leave a 3-byte hole at the end
of `struct ovs_key_ct_tuple_ipv4` and `struct ovs_key_ct_tuple_ipv6`. Fix
it by initializing `orig` with memset().

Fixes: 9dd7f8907c37 ("openvswitch: Add original direction conntrack tuple to sw_flow_key.")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/conntrack.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -276,10 +276,6 @@ void ovs_ct_fill_key(const struct sk_buf
 	ovs_ct_update_key(skb, NULL, key, false, false);
 }
 
-#define IN6_ADDR_INITIALIZER(ADDR) \
-	{ (ADDR).s6_addr32[0], (ADDR).s6_addr32[1], \
-	  (ADDR).s6_addr32[2], (ADDR).s6_addr32[3] }
-
 int ovs_ct_put_key(const struct sw_flow_key *swkey,
 		   const struct sw_flow_key *output, struct sk_buff *skb)
 {
@@ -301,24 +297,30 @@ int ovs_ct_put_key(const struct sw_flow_
 
 	if (swkey->ct_orig_proto) {
 		if (swkey->eth.type == htons(ETH_P_IP)) {
-			struct ovs_key_ct_tuple_ipv4 orig = {
-				output->ipv4.ct_orig.src,
-				output->ipv4.ct_orig.dst,
-				output->ct.orig_tp.src,
-				output->ct.orig_tp.dst,
-				output->ct_orig_proto,
-			};
+			struct ovs_key_ct_tuple_ipv4 orig;
+
+			memset(&orig, 0, sizeof(orig));
+			orig.ipv4_src = output->ipv4.ct_orig.src;
+			orig.ipv4_dst = output->ipv4.ct_orig.dst;
+			orig.src_port = output->ct.orig_tp.src;
+			orig.dst_port = output->ct.orig_tp.dst;
+			orig.ipv4_proto = output->ct_orig_proto;
+
 			if (nla_put(skb, OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4,
 				    sizeof(orig), &orig))
 				return -EMSGSIZE;
 		} else if (swkey->eth.type == htons(ETH_P_IPV6)) {
-			struct ovs_key_ct_tuple_ipv6 orig = {
-				IN6_ADDR_INITIALIZER(output->ipv6.ct_orig.src),
-				IN6_ADDR_INITIALIZER(output->ipv6.ct_orig.dst),
-				output->ct.orig_tp.src,
-				output->ct.orig_tp.dst,
-				output->ct_orig_proto,
-			};
+			struct ovs_key_ct_tuple_ipv6 orig;
+
+			memset(&orig, 0, sizeof(orig));
+			memcpy(orig.ipv6_src, output->ipv6.ct_orig.src.s6_addr32,
+			       sizeof(orig.ipv6_src));
+			memcpy(orig.ipv6_dst, output->ipv6.ct_orig.dst.s6_addr32,
+			       sizeof(orig.ipv6_dst));
+			orig.src_port = output->ct.orig_tp.src;
+			orig.dst_port = output->ct.orig_tp.dst;
+			orig.ipv6_proto = output->ct_orig_proto;
+
 			if (nla_put(skb, OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6,
 				    sizeof(orig), &orig))
 				return -EMSGSIZE;


