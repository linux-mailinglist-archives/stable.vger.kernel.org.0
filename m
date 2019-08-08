Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA5886A69
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404197AbfHHTGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404196AbfHHTGH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:06:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 352012184E;
        Thu,  8 Aug 2019 19:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291166;
        bh=WLBYh0GoRhp9dzJDdv30zfp8sCdMj1MIp8GArBRONlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kUSCDxGxn1EOFzUfm/HXow9Mf6GDPoJjzwk8FfaQMPfd+JN/oBoGC81B9MbfNZXqC
         1EABAV/S5wRVYDIbaWAybs5H45prZe4ecaisPAyiL+JQGk006c3NPxGKunJITbhBfl
         kTTTWhQrKVyFfUA+6IJpjYk+aw3Z/uNmXtTmY4VQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, William Tu <u9012063@gmail.com>,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 12/56] ip6_gre: reload ipv6h in prepare_ip6gre_xmit_ipv6
Date:   Thu,  8 Aug 2019 21:04:38 +0200
Message-Id: <20190808190453.354245914@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
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
@@ -660,12 +660,13 @@ static int prepare_ip6gre_xmit_ipv6(stru
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


