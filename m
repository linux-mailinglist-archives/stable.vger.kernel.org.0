Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C33259326
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbgIAPWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:22:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729314AbgIAPWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:22:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D404A2078B;
        Tue,  1 Sep 2020 15:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973720;
        bh=nk7DUPCQ4LCq491rY6FJmz0IjHemtEpYN9mthPiTfyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LblQs5iNksaa5WozbTFIlvxjOOvt+r30p3kzDd17B3f5LquH7eGhSFvcoqtozZ/oJ
         h8yIsY2ry39n7zsSdY6LO/9NXQfYEdDIzZpS5zmJEMjyd0htNQgUCof5NiL45NF1J/
         iaSryYzWC4jtzIkWFp3e0rmX7Y7Kin8GWI6xoOB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 002/125] gre6: Fix reception with IP6_TNL_F_RCV_DSCP_COPY
Date:   Tue,  1 Sep 2020 17:09:17 +0200
Message-Id: <20200901150934.703341200@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

[ Upstream commit 272502fcb7cda01ab07fc2fcff82d1d2f73d43cc ]

When receiving an IPv4 packet inside an IPv6 GRE packet, and the
IP6_TNL_F_RCV_DSCP_COPY flag is set on the tunnel, the IPv4 header would
get corrupted. This is due to the common ip6_tnl_rcv() function assuming
that the inner header is always IPv6. This patch checks the tunnel
protocol for IPv4 inner packets, but still defaults to IPv6.

Fixes: 308edfdf1563 ("gre6: Cleanup GREv6 receive path, call common GRE functions")
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_tunnel.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -865,7 +865,15 @@ int ip6_tnl_rcv(struct ip6_tnl *t, struc
 		struct metadata_dst *tun_dst,
 		bool log_ecn_err)
 {
-	return __ip6_tnl_rcv(t, skb, tpi, tun_dst, ip6ip6_dscp_ecn_decapsulate,
+	int (*dscp_ecn_decapsulate)(const struct ip6_tnl *t,
+				    const struct ipv6hdr *ipv6h,
+				    struct sk_buff *skb);
+
+	dscp_ecn_decapsulate = ip6ip6_dscp_ecn_decapsulate;
+	if (tpi->proto == htons(ETH_P_IP))
+		dscp_ecn_decapsulate = ip4ip6_dscp_ecn_decapsulate;
+
+	return __ip6_tnl_rcv(t, skb, tpi, tun_dst, dscp_ecn_decapsulate,
 			     log_ecn_err);
 }
 EXPORT_SYMBOL(ip6_tnl_rcv);


