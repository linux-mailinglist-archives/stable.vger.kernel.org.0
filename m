Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C4D35BE41
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238186AbhDLI5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239013AbhDLIzV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8696D61284;
        Mon, 12 Apr 2021 08:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217689;
        bh=pvuQRS5yNC2F/IfNlFewLUQ5x1zVq6shOC/2QOT+HoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0gcGOj3yg3YsduI1OAQcZGeACpizMN3V2XJwUt5G2QFBaiIj6ne2VL+eTw7XUo41
         8RuZt8X5+zbXaQHCDf1B67zx9wW/P/2lPEzmamsP6oZihWU8e4qquxVVJeR8jlMR/R
         75USu8uKqz28nzHj8f0CIVfKTnGPuL/ghJTUmQ3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eelco Chaudron <echaudro@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/188] vxlan: do not modify the shared tunnel info when PMTU triggers an ICMP reply
Date:   Mon, 12 Apr 2021 10:40:24 +0200
Message-Id: <20210412084017.302398148@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
index 50cb8f045a1e..d3b698d9e2e6 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2724,12 +2724,17 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
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
@@ -2780,12 +2785,17 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
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



