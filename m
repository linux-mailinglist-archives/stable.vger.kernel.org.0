Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6C935C04D
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238509AbhDLJMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239470AbhDLJHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:07:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8390B61241;
        Mon, 12 Apr 2021 09:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218237;
        bh=FHLjFpiq0SA8ILyN79XAVnMCVDMBdcrFZdA0z1g08gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7YkTi6kicZ1IdOQmBeHR6WuRBo+eRlnpkoScXaicvGfYZgBiSgzle0JYjU8MkBsh
         IRqEuy8Fry5yhNOiL7fII6r+0yljjKOUqPjqx9WZVHI2YR48bRSRD7iuS7OR7K9Ji9
         5ySaI3kRAzF0oRuutU5cdPx2upYQqSv2AoNycqVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eelco Chaudron <echaudro@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 121/210] geneve: do not modify the shared tunnel info when PMTU triggers an ICMP reply
Date:   Mon, 12 Apr 2021 10:40:26 +0200
Message-Id: <20210412084020.030784878@linuxfoundation.org>
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

[ Upstream commit 68c1a943ef37bafde5ea2383e8ca224c7169ee31 ]

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

Fixes: c1a800e88dbf ("geneve: Support for PMTU discovery on directly bridged links")
Tested-by: Eelco Chaudron <echaudro@redhat.com>
Reviewed-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 5523f069b9a5..f35b0b83fe85 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -908,8 +908,16 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 
 		info = skb_tunnel_info(skb);
 		if (info) {
-			info->key.u.ipv4.dst = fl4.saddr;
-			info->key.u.ipv4.src = fl4.daddr;
+			struct ip_tunnel_info *unclone;
+
+			unclone = skb_tunnel_info_unclone(skb);
+			if (unlikely(!unclone)) {
+				dst_release(&rt->dst);
+				return -ENOMEM;
+			}
+
+			unclone->key.u.ipv4.dst = fl4.saddr;
+			unclone->key.u.ipv4.src = fl4.daddr;
 		}
 
 		if (!pskb_may_pull(skb, ETH_HLEN)) {
@@ -993,8 +1001,16 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 		struct ip_tunnel_info *info = skb_tunnel_info(skb);
 
 		if (info) {
-			info->key.u.ipv6.dst = fl6.saddr;
-			info->key.u.ipv6.src = fl6.daddr;
+			struct ip_tunnel_info *unclone;
+
+			unclone = skb_tunnel_info_unclone(skb);
+			if (unlikely(!unclone)) {
+				dst_release(dst);
+				return -ENOMEM;
+			}
+
+			unclone->key.u.ipv6.dst = fl6.saddr;
+			unclone->key.u.ipv6.src = fl6.daddr;
 		}
 
 		if (!pskb_may_pull(skb, ETH_HLEN)) {
-- 
2.30.2



