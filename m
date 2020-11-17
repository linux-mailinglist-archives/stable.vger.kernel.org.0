Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630B42B652A
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732998AbgKQNvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:51:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:38628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731597AbgKQN3r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:29:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2801F20781;
        Tue, 17 Nov 2020 13:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619786;
        bh=QpYELbB2Oh2l4OZ/VvRqHSyhzMNSDAnCHwv1+Za/aa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XhokegserkeH3e4QOy8mlnsiwnwBDujvN9JGSA82RWyg6L6inGFjOyoZPHFq16Xop
         zWBnLzYHz9JlbgJ9s+wm7/JCyVihes6WY8fJ88y7lQs5TaXJumy6duAgkS9xMp4QyZ
         zV8bUOg246kB6a2xC8RMElzw0QO54PVc6rJA1Ias=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 140/151] net: udp: fix UDP header access on Fast/frag0 UDP GRO
Date:   Tue, 17 Nov 2020 14:06:10 +0100
Message-Id: <20201117122128.243375930@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
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
@@ -349,7 +349,7 @@ out:
 static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
 					       struct sk_buff *skb)
 {
-	struct udphdr *uh = udp_hdr(skb);
+	struct udphdr *uh = udp_gro_udphdr(skb);
 	struct sk_buff *pp = NULL;
 	struct udphdr *uh2;
 	struct sk_buff *p;


