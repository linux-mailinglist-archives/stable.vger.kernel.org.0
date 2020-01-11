Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8394A137D79
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgAKJ6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:58:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728825AbgAKJ6I (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:58:08 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12EE92077C;
        Sat, 11 Jan 2020 09:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736687;
        bh=TcSIPZkTH4ZoWBKp9aOL7sVs7tTvgf3WAimogN6bRno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJF4AKX63TJms5M2UgV7KToaZKH/xNFomu4nKJnvmzV/ZVc7/WH17Xkn5v8yVTm9i
         6iUODAuwhucarTYSui6e+PLlqPuQ3OqQSnrlYlMuZ6gu/8Ve0WsUthF5aQVO1X/l4A
         M1zFM3G9UiPu3zOcRRxif84/u5iX346v94hixReM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 56/59] vxlan: fix tos value before xmit
Date:   Sat, 11 Jan 2020 10:50:05 +0100
Message-Id: <20200111094852.836466070@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
References: <20200111094835.417654274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 71130f29979c7c7956b040673e6b9d5643003176 ]

Before ip_tunnel_ecn_encap() and udp_tunnel_xmit_skb() we should filter
tos value by RT_TOS() instead of using config tos directly.

vxlan_get_route() would filter the tos to fl4.flowi4_tos but we didn't
return it back, as geneve_get_v4_rt() did. So we have to use RT_TOS()
directly in function ip_tunnel_ecn_encap().

Fixes: 206aaafcd279 ("VXLAN: Use IP Tunnels tunnel ENC encap API")
Fixes: 1400615d64cf ("vxlan: allow setting ipv6 traffic class")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2068,7 +2068,7 @@ static void vxlan_xmit_one(struct sk_buf
 			return;
 		}
 
-		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
+		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
 		ttl = ttl ? : ip4_dst_hoplimit(&rt->dst);
 		err = vxlan_xmit_skb(rt, sk, skb, fl4.saddr,
 				     dst->sin.sin_addr.s_addr, tos, ttl, df,


