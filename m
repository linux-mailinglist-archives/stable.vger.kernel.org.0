Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136972B640B
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732781AbgKQNoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:44:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:54386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733258AbgKQNlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:41:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CE6920729;
        Tue, 17 Nov 2020 13:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620509;
        bh=3FlSneyxjugV8U/0LdRGkzFHyixXJ7CnPmTZNGA6tZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zDPBc1F14i/VCrsJm1vMOS6ocjGDNKUwUOrvpKs7HuHOqMk1mFXU7r36EqlNaVRPD
         jS0vcvqFS5HEO5ZZwMp1k6aL5qqiSWAS7xeh+vhZyqK4LnKvHL5tDWYl08afBAxDT6
         myoQKVY4VknqnpQrbeHpP5cd5df3d0xxnGZhohBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 243/255] net: udp: fix UDP header access on Fast/frag0 UDP GRO
Date:   Tue, 17 Nov 2020 14:06:23 +0100
Message-Id: <20201117122150.763312048@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

[ Upstream commit 4b1a86281cc1d0de46df3ad2cb8c1f86ac07681c ]

UDP GRO uses udp_hdr(skb) in its .gro_receive() callback. While it's
probably OK for non-frag0 paths (when all headers or even the entire
frame are already in skb head), this inline points to junk when
using Fast GRO (napi_gro_frags() or napi_gro_receive() with only
Ethernet header in skb head and all the rest in the frags) and breaks
GRO packet compilation and the packet flow itself.
To support both modes, skb_gro_header_fast() + skb_gro_header_slow()
are typically used. UDP even has an inline helper that makes use of
them, udp_gro_udphdr(). Use that instead of troublemaking udp_hdr()
to get rid of the out-of-order delivers.

Present since the introduction of plain UDP GRO in 5.0-rc1.

Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp_offload.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -366,7 +366,7 @@ out:
 static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
 					       struct sk_buff *skb)
 {
-	struct udphdr *uh = udp_hdr(skb);
+	struct udphdr *uh = udp_gro_udphdr(skb);
 	struct sk_buff *pp = NULL;
 	struct udphdr *uh2;
 	struct sk_buff *p;


