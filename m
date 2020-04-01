Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B06A019B1BE
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389001AbgDAQho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:37:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388995AbgDAQho (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:37:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00EC920BED;
        Wed,  1 Apr 2020 16:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759063;
        bh=+JAAVEF8KYJY+js1qOPD/3WM6MFYxSxtSx/3r8F4uoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qwdm5gIFLzqBO2AGc0QWIfqejEGVY2+LmsTA9HeUE5SPmsFCTkOXmN4smQyN6++nQ
         VqQV/BkVdXHBH8EMp4uHuDuSd3/XdNBjV9RR6UfwIdOUmhh0mgVoLlw+AZPhC33m3m
         Kvjm2ZWZj8ZQ0ynAHUAzftDkYsMvyp5UIn/q2X2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.9 065/102] vti[6]: fix packet tx through bpf_redirect() in XinY cases
Date:   Wed,  1 Apr 2020 18:18:08 +0200
Message-Id: <20200401161543.746725659@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit f1ed10264ed6b66b9cd5e8461cffce69be482356 upstream.

I forgot the 4in6/6in4 cases in my previous patch. Let's fix them.

Fixes: 95224166a903 ("vti[6]: fix packet tx through bpf_redirect()")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/Kconfig   |    1 +
 net/ipv4/ip_vti.c  |   36 +++++++++++++++++++++++++++++-------
 net/ipv6/ip6_vti.c |   32 +++++++++++++++++++++++++-------
 3 files changed, 55 insertions(+), 14 deletions(-)

--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -298,6 +298,7 @@ config SYN_COOKIES
 
 config NET_IPVTI
 	tristate "Virtual (secure) IP: tunneling"
+	depends on IPV6 || IPV6=n
 	select INET_TUNNEL
 	select NET_IP_TUNNEL
 	depends on INET_XFRM_MODE_TUNNEL
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -208,17 +208,39 @@ static netdev_tx_t vti_xmit(struct sk_bu
 	int mtu;
 
 	if (!dst) {
-		struct rtable *rt;
+		switch (skb->protocol) {
+		case htons(ETH_P_IP): {
+			struct rtable *rt;
 
-		fl->u.ip4.flowi4_oif = dev->ifindex;
-		fl->u.ip4.flowi4_flags |= FLOWI_FLAG_ANYSRC;
-		rt = __ip_route_output_key(dev_net(dev), &fl->u.ip4);
-		if (IS_ERR(rt)) {
+			fl->u.ip4.flowi4_oif = dev->ifindex;
+			fl->u.ip4.flowi4_flags |= FLOWI_FLAG_ANYSRC;
+			rt = __ip_route_output_key(dev_net(dev), &fl->u.ip4);
+			if (IS_ERR(rt)) {
+				dev->stats.tx_carrier_errors++;
+				goto tx_error_icmp;
+			}
+			dst = &rt->dst;
+			skb_dst_set(skb, dst);
+			break;
+		}
+#if IS_ENABLED(CONFIG_IPV6)
+		case htons(ETH_P_IPV6):
+			fl->u.ip6.flowi6_oif = dev->ifindex;
+			fl->u.ip6.flowi6_flags |= FLOWI_FLAG_ANYSRC;
+			dst = ip6_route_output(dev_net(dev), NULL, &fl->u.ip6);
+			if (dst->error) {
+				dst_release(dst);
+				dst = NULL;
+				dev->stats.tx_carrier_errors++;
+				goto tx_error_icmp;
+			}
+			skb_dst_set(skb, dst);
+			break;
+#endif
+		default:
 			dev->stats.tx_carrier_errors++;
 			goto tx_error_icmp;
 		}
-		dst = &rt->dst;
-		skb_dst_set(skb, dst);
 	}
 
 	dst_hold(dst);
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -454,15 +454,33 @@ vti6_xmit(struct sk_buff *skb, struct ne
 	int mtu;
 
 	if (!dst) {
-		fl->u.ip6.flowi6_oif = dev->ifindex;
-		fl->u.ip6.flowi6_flags |= FLOWI_FLAG_ANYSRC;
-		dst = ip6_route_output(dev_net(dev), NULL, &fl->u.ip6);
-		if (dst->error) {
-			dst_release(dst);
-			dst = NULL;
+		switch (skb->protocol) {
+		case htons(ETH_P_IP): {
+			struct rtable *rt;
+
+			fl->u.ip4.flowi4_oif = dev->ifindex;
+			fl->u.ip4.flowi4_flags |= FLOWI_FLAG_ANYSRC;
+			rt = __ip_route_output_key(dev_net(dev), &fl->u.ip4);
+			if (IS_ERR(rt))
+				goto tx_err_link_failure;
+			dst = &rt->dst;
+			skb_dst_set(skb, dst);
+			break;
+		}
+		case htons(ETH_P_IPV6):
+			fl->u.ip6.flowi6_oif = dev->ifindex;
+			fl->u.ip6.flowi6_flags |= FLOWI_FLAG_ANYSRC;
+			dst = ip6_route_output(dev_net(dev), NULL, &fl->u.ip6);
+			if (dst->error) {
+				dst_release(dst);
+				dst = NULL;
+				goto tx_err_link_failure;
+			}
+			skb_dst_set(skb, dst);
+			break;
+		default:
 			goto tx_err_link_failure;
 		}
-		skb_dst_set(skb, dst);
 	}
 
 	dst_hold(dst);


