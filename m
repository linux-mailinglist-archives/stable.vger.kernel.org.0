Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7138C150DDA
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgBCQ11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:27:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:38706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729397AbgBCQ10 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:27:26 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB7DA2051A;
        Mon,  3 Feb 2020 16:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747246;
        bh=MTIi2xvUFrgETjS3sxrsfHrN4tB0xrG35zGaFnLhi2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o2NZOTQ+7G5u+Uf1ioN0htvnE0OgUuIsVGNhYzWvKQuACdkjOTQbkPmliBFC2gih2
         Zz6hLiGtw1qERKhw19lMS2mmMnraaYrBiiJpIodgyzhs2D1VpDfJN2UMGcSkGqVU+6
         9ek5BijlneY0/PlGfR1R9ihbV+CUtiSvZkSPArRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 52/68] vti[6]: fix packet tx through bpf_redirect()
Date:   Mon,  3 Feb 2020 16:19:48 +0000
Message-Id: <20200203161913.604139588@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit 95224166a9032ff5d08fca633d37113078ce7d01 ]

With an ebpf program that redirects packets through a vti[6] interface,
the packets are dropped because no dst is attached.

This could also be reproduced with an AF_PACKET socket, with the following
python script (vti1 is an ip_vti interface):

 import socket
 send_s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, 0)
 # scapy
 # p = IP(src='10.100.0.2', dst='10.200.0.1')/ICMP(type='echo-request')
 # raw(p)
 req = b'E\x00\x00\x1c\x00\x01\x00\x00@\x01e\xb2\nd\x00\x02\n\xc8\x00\x01\x08\x00\xf7\xff\x00\x00\x00\x00'
 send_s.sendto(req, ('vti1', 0x800, 0, 0))

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_vti.c  | 13 +++++++++++--
 net/ipv6/ip6_vti.c | 13 +++++++++++--
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 4e39c935e057e..ec417156f388e 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -208,8 +208,17 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 	int mtu;
 
 	if (!dst) {
-		dev->stats.tx_carrier_errors++;
-		goto tx_error_icmp;
+		struct rtable *rt;
+
+		fl->u.ip4.flowi4_oif = dev->ifindex;
+		fl->u.ip4.flowi4_flags |= FLOWI_FLAG_ANYSRC;
+		rt = __ip_route_output_key(dev_net(dev), &fl->u.ip4);
+		if (IS_ERR(rt)) {
+			dev->stats.tx_carrier_errors++;
+			goto tx_error_icmp;
+		}
+		dst = &rt->dst;
+		skb_dst_set(skb, dst);
 	}
 
 	dst_hold(dst);
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index c2b2ee71fc6c3..a266fac084261 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -453,8 +453,17 @@ vti6_xmit(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	int err = -1;
 	int mtu;
 
-	if (!dst)
-		goto tx_err_link_failure;
+	if (!dst) {
+		fl->u.ip6.flowi6_oif = dev->ifindex;
+		fl->u.ip6.flowi6_flags |= FLOWI_FLAG_ANYSRC;
+		dst = ip6_route_output(dev_net(dev), NULL, &fl->u.ip6);
+		if (dst->error) {
+			dst_release(dst);
+			dst = NULL;
+			goto tx_err_link_failure;
+		}
+		skb_dst_set(skb, dst);
+	}
 
 	dst_hold(dst);
 	dst = xfrm_lookup(t->net, dst, fl, NULL, 0);
-- 
2.20.1



