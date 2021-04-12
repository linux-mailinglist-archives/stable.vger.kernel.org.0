Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7081635C049
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238332AbhDLJMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239418AbhDLJHQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:07:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBFF961247;
        Mon, 12 Apr 2021 09:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218234;
        bh=rl4LpxZtedlhqxqusSSH0Q7lNK3NXt4/3wKqUUwWjNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgWpOWPN9MCp2onS+9TGookcrL1C4XdLMBopVAKbIUZBkcXRh29dq1jy/TNc+XdyS
         zNEoZpAkyQu3Sch/CMR6H2T4SNu3yJEUpxNs+SLFgKybHAc4ilIL9yp3nO/KjAeJgo
         w5jyYr+8kBIV0es7o5cNSbZg2hVmHJpeH7hfrO4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eelco Chaudron <echaudro@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 120/210] vxlan: do not modify the shared tunnel info when PMTU triggers an ICMP reply
Date:   Mon, 12 Apr 2021 10:40:25 +0200
Message-Id: <20210412084020.000103461@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 30a93d2b7d5a7cbb53ac19c9364a256d1aa6c08a ]

When the interface is part of a bridge or an Open vSwitch port and a
packet exceed a PMTU estimate, an ICMP reply is sent to the sender. When
using the external mode (collect metadata) the source and destination
addresses are reversed, so that Open vSwitch can match the packet
against an existing (reverse) flow.

But inverting the source and destination addresses in the shared
ip_tunnel_info will make following packets of the flow to use a wrong
destination address (packets will be tunnelled to itself), if the flow
isn't updated. Which happens with Open vSwitch, until the flow times
out.

Fixes this by uncloning the skb's ip_tunnel_info before inverting its
source and destination addresses, so that the modification will only be
made for the PTMU packet, not the following ones.

Fixes: fc68c99577cc ("vxlan: Support for PMTU discovery on directly bridged links")
Tested-by: Eelco Chaudron <echaudro@redhat.com>
Reviewed-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 0842371eca3d..4adfa6a01198 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2725,12 +2725,17 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			goto tx_error;
 		} else if (err) {
 			if (info) {
+				struct ip_tunnel_info *unclone;
 				struct in_addr src, dst;
 
+				unclone = skb_tunnel_info_unclone(skb);
+				if (unlikely(!unclone))
+					goto tx_error;
+
 				src = remote_ip.sin.sin_addr;
 				dst = local_ip.sin.sin_addr;
-				info->key.u.ipv4.src = src.s_addr;
-				info->key.u.ipv4.dst = dst.s_addr;
+				unclone->key.u.ipv4.src = src.s_addr;
+				unclone->key.u.ipv4.dst = dst.s_addr;
 			}
 			vxlan_encap_bypass(skb, vxlan, vxlan, vni, false);
 			dst_release(ndst);
@@ -2781,12 +2786,17 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			goto tx_error;
 		} else if (err) {
 			if (info) {
+				struct ip_tunnel_info *unclone;
 				struct in6_addr src, dst;
 
+				unclone = skb_tunnel_info_unclone(skb);
+				if (unlikely(!unclone))
+					goto tx_error;
+
 				src = remote_ip.sin6.sin6_addr;
 				dst = local_ip.sin6.sin6_addr;
-				info->key.u.ipv6.src = src;
-				info->key.u.ipv6.dst = dst;
+				unclone->key.u.ipv6.src = src;
+				unclone->key.u.ipv6.dst = dst;
 			}
 
 			vxlan_encap_bypass(skb, vxlan, vxlan, vni, false);
-- 
2.30.2



