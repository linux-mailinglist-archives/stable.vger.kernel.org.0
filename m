Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA3C261AD8
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731416AbgIHSlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731298AbgIHQIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:08:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B37D23F2B;
        Tue,  8 Sep 2020 15:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580081;
        bh=YHqUTJhZOLOWSdR8o8KnGJz51BViWz7q6JqajmtEr1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkfrVBN8g8bBQX6UceqCtuP/Qe1p/j9bjpWSIDpZ8nXsEG9FBZft4YPkxmcgq278L
         pCXYKno0T41p12CgTKcHPX8v8khjarhhqpIQ80dtEkEoBwPw38J7rxjmSL5rp50NKZ
         N0KbQec6OCPwTXv+daHwWVC3uHewKdlQpQGvWTJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/88] netfilter: nf_tables: fix destination register zeroing
Date:   Tue,  8 Sep 2020 17:25:25 +0200
Message-Id: <20200908152222.280473336@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
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
index 024636c31adcf..93253ba1eeac3 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -130,6 +130,8 @@ static inline u8 nft_reg_load8(u32 *sreg)
 static inline void nft_data_copy(u32 *dst, const struct nft_data *src,
 				 unsigned int len)
 {
+	if (len % NFT_REG32_SIZE)
+		dst[len / NFT_REG32_SIZE] = 0;
 	memcpy(dst, src, len);
 }
 
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 19446a89a2a81..b1a9f330a51fe 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -79,7 +79,9 @@ static void nft_payload_eval(const struct nft_expr *expr,
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



