Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A05E25CB3B
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbfGBIIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:08:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728074AbfGBII3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:08:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D90721851;
        Tue,  2 Jul 2019 08:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054908;
        bh=pZuPC87F7Ez7v8MKlVnZCC8cf5cYx8wCtINfbQZCZWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dlYrJDKBdTGGurdGLVPpigEsWQbsVIREKYlRSxT0zy3dcgOlaUZJcuDvNMD8UszFQ
         uHqf3WVsDp6xdNIxciaJ++OjHMfoRHJHsKJisK4B7J05RH53AozWdwX9fQK6Th5ZGK
         v032E/I8w0a3OEmsBWQq2euiLjz8E58S91g3QrCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Herbert <tom@herbertland.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.19 66/72] bpf: udp: Avoid calling reuseports bpf_prog from udp_gro
Date:   Tue,  2 Jul 2019 10:02:07 +0200
Message-Id: <20190702080128.065178436@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin KaFai Lau <kafai@fb.com>

commit 257a525fe2e49584842c504a92c27097407f778f upstream.

When the commit a6024562ffd7 ("udp: Add GRO functions to UDP socket")
added udp[46]_lib_lookup_skb to the udp_gro code path, it broke
the reuseport_select_sock() assumption that skb->data is pointing
to the transport header.

This patch follows an earlier __udp6_lib_err() fix by
passing a NULL skb to avoid calling the reuseport's bpf_prog.

Fixes: a6024562ffd7 ("udp: Add GRO functions to UDP socket")
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/udp.c |    6 +++++-
 net/ipv6/udp.c |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -542,7 +542,11 @@ static inline struct sock *__udp4_lib_lo
 struct sock *udp4_lib_lookup_skb(struct sk_buff *skb,
 				 __be16 sport, __be16 dport)
 {
-	return __udp4_lib_lookup_skb(skb, sport, dport, &udp_table);
+	const struct iphdr *iph = ip_hdr(skb);
+
+	return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
+				 iph->daddr, dport, inet_iif(skb),
+				 inet_sdif(skb), &udp_table, NULL);
 }
 EXPORT_SYMBOL_GPL(udp4_lib_lookup_skb);
 
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -282,7 +282,7 @@ struct sock *udp6_lib_lookup_skb(struct
 
 	return __udp6_lib_lookup(dev_net(skb->dev), &iph->saddr, sport,
 				 &iph->daddr, dport, inet6_iif(skb),
-				 inet6_sdif(skb), &udp_table, skb);
+				 inet6_sdif(skb), &udp_table, NULL);
 }
 EXPORT_SYMBOL_GPL(udp6_lib_lookup_skb);
 


