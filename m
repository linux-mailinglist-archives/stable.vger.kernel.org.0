Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE45335BD39
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237703AbhDLIs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:48:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237802AbhDLIrO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:47:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70DBF61243;
        Mon, 12 Apr 2021 08:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217216;
        bh=RZ591xyVWAepXgekhNb08Ivsk/HCGGu428Z6NHr4/AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z72NHnad3HUJCUtuwVvmMhzoVQibXj3JD0JevxX0sCnoTGpv7+D44sRxFLXHdL2Fk
         uMk9DlqHCveGPPQhoYtvlVVG2OO0G+EqqPq+9C0TzxlPQNH34/h4aNqSgYlE0T2ql6
         SwD9Jkr3V0Vt+M1rxTu+2IZco5WSteYBHg3jiKUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eyal Birger <eyal.birger@gmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/111] xfrm: interface: fix ipv4 pmtu check to honor ip header df
Date:   Mon, 12 Apr 2021 10:40:23 +0200
Message-Id: <20210412084005.750325722@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eyal Birger <eyal.birger@gmail.com>

[ Upstream commit 8fc0e3b6a8666d656923d214e4dc791e9a17164a ]

Frag needed should only be sent if the header enables DF.

This fix allows packets larger than MTU to pass the xfrm interface
and be fragmented after encapsulation, aligning behavior with
non-interface xfrm.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_interface.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 01c65f96d283..74e90d78c3b4 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -302,6 +302,8 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 
 			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 		} else {
+			if (!(ip_hdr(skb)->frag_off & htons(IP_DF)))
+				goto xmit;
 			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 				      htonl(mtu));
 		}
@@ -310,6 +312,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 		return -EMSGSIZE;
 	}
 
+xmit:
 	xfrmi_scrub_packet(skb, !net_eq(xi->net, dev_net(dev)));
 	skb_dst_set(skb, dst);
 	skb->dev = tdev;
-- 
2.30.2



