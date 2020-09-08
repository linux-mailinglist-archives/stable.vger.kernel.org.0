Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30ED3261C64
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731846AbgIHTSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:18:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731135AbgIHQCw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:02:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B317D23C82;
        Tue,  8 Sep 2020 15:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579384;
        bh=Wb3AnQ9pG/xstfYsiyL5oDmyvAT5F572N3TLlAoyC78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CIXEDxxvO+GtAvqo4J1yjP7izlydAAUZ9v0cPqeIcZ1pm+IqL8p3X/4sQl57d+RCy
         Yv6wun2mVRS3xx2QIMglJbd5UBubawH1d2QDfdTrwVDazQWuS5wakJIpu8uAmK6yhp
         sJio01hi4ifQZoF3dwLR8t3DugXhXb+YnsOeCqL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 056/186] netfilter: nf_tables: fix destination register zeroing
Date:   Tue,  8 Sep 2020 17:23:18 +0200
Message-Id: <20200908152244.385822435@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 1e105e6afa6c3d32bfb52c00ffa393894a525c27 ]

Following bug was reported via irc:
nft list ruleset
   set knock_candidates_ipv4 {
      type ipv4_addr . inet_service
      size 65535
      elements = { 127.0.0.1 . 123,
                   127.0.0.1 . 123 }
      }
 ..
   udp dport 123 add @knock_candidates_ipv4 { ip saddr . 123 }
   udp dport 123 add @knock_candidates_ipv4 { ip saddr . udp dport }

It should not have been possible to add a duplicate set entry.

After some debugging it turned out that the problem is the immediate
value (123) in the second-to-last rule.

Concatenations use 32bit registers, i.e. the elements are 8 bytes each,
not 6 and it turns out the kernel inserted

inet firewall @knock_candidates_ipv4
        element 0100007f ffff7b00  : 0 [end]
        element 0100007f 00007b00  : 0 [end]

Note the non-zero upper bits of the first element.  It turns out that
nft_immediate doesn't zero the destination register, but this is needed
when the length isn't a multiple of 4.

Furthermore, the zeroing in nft_payload is broken.  We can't use
[len / 4] = 0 -- if len is a multiple of 4, index is off by one.

Skip zeroing in this case and use a conditional instead of (len -1) / 4.

Fixes: 49499c3e6e18 ("netfilter: nf_tables: switch registers to 32 bit addressing")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h | 2 ++
 net/netfilter/nft_payload.c       | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 6f0f6fca9ac3e..ec2cbfab71f35 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -143,6 +143,8 @@ static inline u64 nft_reg_load64(const u32 *sreg)
 static inline void nft_data_copy(u32 *dst, const struct nft_data *src,
 				 unsigned int len)
 {
+	if (len % NFT_REG32_SIZE)
+		dst[len / NFT_REG32_SIZE] = 0;
 	memcpy(dst, src, len);
 }
 
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index a7de3a58f553d..67ce866a446d9 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -87,7 +87,9 @@ void nft_payload_eval(const struct nft_expr *expr,
 	u32 *dest = &regs->data[priv->dreg];
 	int offset;
 
-	dest[priv->len / NFT_REG32_SIZE] = 0;
+	if (priv->len % NFT_REG32_SIZE)
+		dest[priv->len / NFT_REG32_SIZE] = 0;
+
 	switch (priv->base) {
 	case NFT_PAYLOAD_LL_HEADER:
 		if (!skb_mac_header_was_set(skb))
-- 
2.25.1



