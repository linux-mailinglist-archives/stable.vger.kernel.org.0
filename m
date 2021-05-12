Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C413C37C24C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbhELPIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:08:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232812AbhELPGd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:06:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB69261492;
        Wed, 12 May 2021 15:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831676;
        bh=M/ITsn40P+MARB6DAzeE/er124OCvqchV5xbpydqlG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Brw/SMaaTxDzvmqBDlUoaTdefSOqSx6Ci6sluPnzZwgJcyxou8LQ+WcW7Uj2m87ky
         ax+jIsSQ4rGhyhTwsmgqhmnkyqETdtzSW9kFZHOb/7nPJYwBn092sWKFkhETi6c0m+
         Br9SUAEETX48bl0H+5mwzlmQJa7qLqysro8isr90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 215/244] gro: fix napi_gro_frags() Fast GRO breakage due to IP alignment check
Date:   Wed, 12 May 2021 16:49:46 +0200
Message-Id: <20210512144749.877573316@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
index 91909e5d6807..a30878346f54 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5395,7 +5395,7 @@ static struct list_head *gro_list_prepare(struct napi_struct *napi,
 	return head;
 }
 
-static void skb_gro_reset_offset(struct sk_buff *skb)
+static inline void skb_gro_reset_offset(struct sk_buff *skb, u32 nhoff)
 {
 	const struct skb_shared_info *pinfo = skb_shinfo(skb);
 	const skb_frag_t *frag0 = &pinfo->frags[0];
@@ -5407,7 +5407,7 @@ static void skb_gro_reset_offset(struct sk_buff *skb)
 	if (skb_mac_header(skb) == skb_tail_pointer(skb) &&
 	    pinfo->nr_frags &&
 	    !PageHighMem(skb_frag_page(frag0)) &&
-	    (!NET_IP_ALIGN || !(skb_frag_off(frag0) & 3))) {
+	    (!NET_IP_ALIGN || !((skb_frag_off(frag0) + nhoff) & 3))) {
 		NAPI_GRO_CB(skb)->frag0 = skb_frag_address(frag0);
 		NAPI_GRO_CB(skb)->frag0_len = min_t(unsigned int,
 						    skb_frag_size(frag0),
@@ -5640,7 +5640,7 @@ gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
 	skb_mark_napi_id(skb, napi);
 	trace_napi_gro_receive_entry(skb);
 
-	skb_gro_reset_offset(skb);
+	skb_gro_reset_offset(skb, 0);
 
 	ret = napi_skb_finish(napi, skb, dev_gro_receive(napi, skb));
 	trace_napi_gro_receive_exit(ret);
@@ -5733,7 +5733,7 @@ static struct sk_buff *napi_frags_skb(struct napi_struct *napi)
 	napi->skb = NULL;
 
 	skb_reset_mac_header(skb);
-	skb_gro_reset_offset(skb);
+	skb_gro_reset_offset(skb, hlen);
 
 	if (unlikely(skb_gro_header_hard(skb, hlen))) {
 		eth = skb_gro_header_slow(skb, hlen, 0);
-- 
2.30.2



