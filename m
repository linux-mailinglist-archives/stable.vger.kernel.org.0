Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC9C8A911E
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390304AbfIDSNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:13:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388984AbfIDSNh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:13:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7884E208E4;
        Wed,  4 Sep 2019 18:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620817;
        bh=ynBtC09Evgr3eVUFBLyZhJcRTnkYVtUlu6SMzMg/fKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQDWHfjwGTCiIfRkVQW+AGVIyr4Na0rzeTneufJKX6LQfa+YJW64imj/2AU9+F3Fx
         VOWpx9SItVEeI1MSuIMMhtZdYXWpEkiSCoqAz7O3grLo01VrxzESUguZbstgekMR9/
         0leoVJoHV9PY5ErwXSGNJ3+qBlRZNA/4YqpT1IdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kodanev <alexey.kodanev@oracle.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 055/143] ipv4: mpls: fix mpls_xmit for iptunnel
Date:   Wed,  4 Sep 2019 19:53:18 +0200
Message-Id: <20190904175316.228828422@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kodanev <alexey.kodanev@oracle.com>

[ Upstream commit 803f3e22ae10003a83c781498c0ac34cfe3463ff ]

When using mpls over gre/gre6 setup, rt->rt_gw4 address is not set, the
same for rt->rt_gw_family.  Therefore, when rt->rt_gw_family is checked
in mpls_xmit(), neigh_xmit() call is skipped. As a result, such setup
doesn't work anymore.

This issue was found with LTP mpls03 tests.

Fixes: 1550c171935d ("ipv4: Prepare rtable for IPv6 gateway")
Signed-off-by: Alexey Kodanev <alexey.kodanev@oracle.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mpls/mpls_iptunnel.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/mpls/mpls_iptunnel.c
+++ b/net/mpls/mpls_iptunnel.c
@@ -133,12 +133,12 @@ static int mpls_xmit(struct sk_buff *skb
 	mpls_stats_inc_outucastpkts(out_dev, skb);
 
 	if (rt) {
-		if (rt->rt_gw_family == AF_INET)
-			err = neigh_xmit(NEIGH_ARP_TABLE, out_dev, &rt->rt_gw4,
-					 skb);
-		else if (rt->rt_gw_family == AF_INET6)
+		if (rt->rt_gw_family == AF_INET6)
 			err = neigh_xmit(NEIGH_ND_TABLE, out_dev, &rt->rt_gw6,
 					 skb);
+		else
+			err = neigh_xmit(NEIGH_ARP_TABLE, out_dev, &rt->rt_gw4,
+					 skb);
 	} else if (rt6) {
 		if (ipv6_addr_v4mapped(&rt6->rt6i_gateway)) {
 			/* 6PE (RFC 4798) */


