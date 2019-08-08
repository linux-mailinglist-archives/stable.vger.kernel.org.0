Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE9F86A32
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404951AbfHHTIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:08:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404518AbfHHTIl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:08:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BDEC2189F;
        Thu,  8 Aug 2019 19:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291320;
        bh=C0vlF4q5TK3PJwaPnm7lOxC5HVy4TewnLNOZ04n5p08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzcI/vczumBRhnMIVjYIh255LikgYgfEZCf4Un8x46OkNeOTwmW35nMLYJqa/ABOa
         wHdBldkHN4gbzv350yfEp7HjWV6o4vQINfuL/YVKSWNV1XP00F5wjYcGXPez+HJy2u
         1f5C+gGPmrVwvQR0qNv6HSegqOXLEN7leeoBO804=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, William Tu <u9012063@gmail.com>,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 15/45] ip6_gre: reload ipv6h in prepare_ip6gre_xmit_ipv6
Date:   Thu,  8 Aug 2019 21:05:01 +0200
Message-Id: <20190808190454.603296704@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

[ Upstream commit 3bc817d665ac6d9de89f59df522ad86f5b5dfc03 ]

Since ip6_tnl_parse_tlv_enc_lim() can call pskb_may_pull()
which may change skb->data, so we need to re-load ipv6h at
the right place.

Fixes: 898b29798e36 ("ip6_gre: Refactor ip6gre xmit codes")
Cc: William Tu <u9012063@gmail.com>
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Acked-by: William Tu <u9012063@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -680,12 +680,13 @@ static int prepare_ip6gre_xmit_ipv6(stru
 				    struct flowi6 *fl6, __u8 *dsfield,
 				    int *encap_limit)
 {
-	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
+	struct ipv6hdr *ipv6h;
 	struct ip6_tnl *t = netdev_priv(dev);
 	__u16 offset;
 
 	offset = ip6_tnl_parse_tlv_enc_lim(skb, skb_network_header(skb));
 	/* ip6_tnl_parse_tlv_enc_lim() might have reallocated skb->head */
+	ipv6h = ipv6_hdr(skb);
 
 	if (offset > 0) {
 		struct ipv6_tlv_tnl_enc_lim *tel;


