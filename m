Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E794A424A
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359452AbiAaLLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376504AbiAaLIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:08:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C859BC0619C0;
        Mon, 31 Jan 2022 03:05:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92001B82A5F;
        Mon, 31 Jan 2022 11:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA563C340E8;
        Mon, 31 Jan 2022 11:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627117;
        bh=I0uXQkDbhcrgFlOrWUKs2lEyJYwQN3pii/jlSjzk5Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v4YoXnq0U2NoZGCn/J83NydPWzjXIUpBk7HxFCNFazQZHnR5MOqWrTezbOYQbuO1l
         PMK+shbyDDOGR4JLMQOp5nlPVJUPAX/KN9wTXtFS5eB5F3VPFtcejR7SajtBMrsLrc
         YlOMVIVvPlvVtQVOfbU5lcPDNdxE73QxFPtVmVGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/100] net: ipv4: Move ip_options_fragment() out of loop
Date:   Mon, 31 Jan 2022 11:56:41 +0100
Message-Id: <20220131105223.127439495@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit faf482ca196a5b16007190529b3b2dd32ab3f761 ]

The ip_options_fragment() only called when iter->offset is equal to zero,
so move it out of loop, and inline 'Copy the flags to each fragment.'
As also, remove the unused parameter in ip_frag_ipcb().

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_output.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 10d4cde31c6bf..fb91a466b2d34 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -614,18 +614,6 @@ void ip_fraglist_init(struct sk_buff *skb, struct iphdr *iph,
 }
 EXPORT_SYMBOL(ip_fraglist_init);
 
-static void ip_fraglist_ipcb_prepare(struct sk_buff *skb,
-				     struct ip_fraglist_iter *iter)
-{
-	struct sk_buff *to = iter->frag;
-
-	/* Copy the flags to each fragment. */
-	IPCB(to)->flags = IPCB(skb)->flags;
-
-	if (iter->offset == 0)
-		ip_options_fragment(to);
-}
-
 void ip_fraglist_prepare(struct sk_buff *skb, struct ip_fraglist_iter *iter)
 {
 	unsigned int hlen = iter->hlen;
@@ -671,7 +659,7 @@ void ip_frag_init(struct sk_buff *skb, unsigned int hlen,
 EXPORT_SYMBOL(ip_frag_init);
 
 static void ip_frag_ipcb(struct sk_buff *from, struct sk_buff *to,
-			 bool first_frag, struct ip_frag_state *state)
+			 bool first_frag)
 {
 	/* Copy the flags to each fragment. */
 	IPCB(to)->flags = IPCB(from)->flags;
@@ -845,12 +833,13 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 
 		/* Everything is OK. Generate! */
 		ip_fraglist_init(skb, iph, hlen, &iter);
+		ip_options_fragment(iter.frag);
 
 		for (;;) {
 			/* Prepare header of the next frame,
 			 * before previous one went down. */
 			if (iter.frag) {
-				ip_fraglist_ipcb_prepare(skb, &iter);
+				IPCB(iter.frag)->flags = IPCB(skb)->flags;
 				ip_fraglist_prepare(skb, &iter);
 			}
 
@@ -905,7 +894,7 @@ slow_path:
 			err = PTR_ERR(skb2);
 			goto fail;
 		}
-		ip_frag_ipcb(skb, skb2, first_frag, &state);
+		ip_frag_ipcb(skb, skb2, first_frag);
 
 		/*
 		 *	Put this fragment into the sending queue.
-- 
2.34.1



