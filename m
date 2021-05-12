Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B4A37CA6B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237340AbhELQaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:30:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233297AbhELQWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:22:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 481BC613AA;
        Wed, 12 May 2021 15:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834412;
        bh=Qa5/d6jFxzUndL0oQj5P8wGZxBk0mTmUw2dprZ+lhRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zk0RO9CRARgPo6sYbZ+4P0r7S+c81L3GYn87WzngxJX94OytxOdNlGpKWdM8h+lzg
         ZxA3Es62+8rtyW7Llx7PXfQ2zQ3Iw9PB5wfwJl3YPmFHYEyNYVbeUFbAviQfDVeaY6
         cAaFmaco+RxmAFRbp2gysmSGmfWoewBhIB6ZpBUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 534/601] gro: fix napi_gro_frags() Fast GRO breakage due to IP alignment check
Date:   Wed, 12 May 2021 16:50:11 +0200
Message-Id: <20210512144845.437592945@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

[ Upstream commit 7ad18ff6449cbd6beb26b53128ddf56d2685aa93 ]

Commit 38ec4944b593 ("gro: ensure frag0 meets IP header alignment")
did the right thing, but missed the fact that napi_gro_frags() logics
calls for skb_gro_reset_offset() *before* pulling Ethernet header
to the skb linear space.
That said, the introduced check for frag0 address being aligned to 4
always fails for it as Ethernet header is obviously 14 bytes long,
and in case with NET_IP_ALIGN its start is not aligned to 4.

Fix this by adding @nhoff argument to skb_gro_reset_offset() which
tells if an IP header is placed right at the start of frag0 or not.
This restores Fast GRO for napi_gro_frags() that became very slow
after the mentioned commit, and preserves the introduced check to
avoid silent unaligned accesses.

>From v1 [0]:
 - inline tiny skb_gro_reset_offset() to let the code be optimized
   more efficively (esp. for the !NET_IP_ALIGN case) (Eric);
 - pull in Reviewed-by from Eric.

[0] https://lore.kernel.org/netdev/20210418114200.5839-1-alobakin@pm.me

Fixes: 38ec4944b593 ("gro: ensure frag0 meets IP header alignment")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 3c0d3b6d674d..633c2d6f1a35 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5867,7 +5867,7 @@ static struct list_head *gro_list_prepare(struct napi_struct *napi,
 	return head;
 }
 
-static void skb_gro_reset_offset(struct sk_buff *skb)
+static inline void skb_gro_reset_offset(struct sk_buff *skb, u32 nhoff)
 {
 	const struct skb_shared_info *pinfo = skb_shinfo(skb);
 	const skb_frag_t *frag0 = &pinfo->frags[0];
@@ -5878,7 +5878,7 @@ static void skb_gro_reset_offset(struct sk_buff *skb)
 
 	if (!skb_headlen(skb) && pinfo->nr_frags &&
 	    !PageHighMem(skb_frag_page(frag0)) &&
-	    (!NET_IP_ALIGN || !(skb_frag_off(frag0) & 3))) {
+	    (!NET_IP_ALIGN || !((skb_frag_off(frag0) + nhoff) & 3))) {
 		NAPI_GRO_CB(skb)->frag0 = skb_frag_address(frag0);
 		NAPI_GRO_CB(skb)->frag0_len = min_t(unsigned int,
 						    skb_frag_size(frag0),
@@ -6111,7 +6111,7 @@ gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
 	skb_mark_napi_id(skb, napi);
 	trace_napi_gro_receive_entry(skb);
 
-	skb_gro_reset_offset(skb);
+	skb_gro_reset_offset(skb, 0);
 
 	ret = napi_skb_finish(napi, skb, dev_gro_receive(napi, skb));
 	trace_napi_gro_receive_exit(ret);
@@ -6204,7 +6204,7 @@ static struct sk_buff *napi_frags_skb(struct napi_struct *napi)
 	napi->skb = NULL;
 
 	skb_reset_mac_header(skb);
-	skb_gro_reset_offset(skb);
+	skb_gro_reset_offset(skb, hlen);
 
 	if (unlikely(skb_gro_header_hard(skb, hlen))) {
 		eth = skb_gro_header_slow(skb, hlen, 0);
-- 
2.30.2



