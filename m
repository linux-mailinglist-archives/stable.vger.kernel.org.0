Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26459300562
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbhAVO14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:27:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728695AbhAVOZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:25:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E75C23B16;
        Fri, 22 Jan 2021 14:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325182;
        bh=aB2RksjgBJHFztiKH7AoN4rPQOthsOqpXEZRfNFUlpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuZ+MiVSZ/YCWbLzKbgcTaV9Jh5+2Zm1eBRkzx837Ag46Kk+8CSwI7SUOpJwtBVaS
         McXoHycX7lpm3h/Lt7BGTjmJg6f20tQTwCTNjLsZ4qujJEP6q8qV2J2LVL1GMk2aDh
         cgZaHrmPAMPYwIO5+HA4wdW6H/EnMLjgmvngF1ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 21/43] esp: avoid unneeded kmap_atomic call
Date:   Fri, 22 Jan 2021 15:12:37 +0100
Message-Id: <20210122135736.521514342@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 9bd6b629c39e3fa9e14243a6d8820492be1a5b2e ]

esp(6)_output_head uses skb_page_frag_refill to allocate a buffer for
the esp trailer.

It accesses the page with kmap_atomic to handle highmem. But
skb_page_frag_refill can return compound pages, of which
kmap_atomic only maps the first underlying page.

skb_page_frag_refill does not return highmem, because flag
__GFP_HIGHMEM is not set. ESP uses it in the same manner as TCP.
That also does not call kmap_atomic, but directly uses page_address,
in skb_copy_to_page_nocache. Do the same for ESP.

This issue has become easier to trigger with recent kmap local
debugging feature CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP.

Fixes: cac2661c53f3 ("esp4: Avoid skb_cow_data whenever possible")
Fixes: 03e2a30f6a27 ("esp6: Avoid skb_cow_data whenever possible")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/esp4.c |    7 +------
 net/ipv6/esp6.c |    7 +------
 2 files changed, 2 insertions(+), 12 deletions(-)

--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -443,7 +443,6 @@ static int esp_output_encap(struct xfrm_
 int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
 {
 	u8 *tail;
-	u8 *vaddr;
 	int nfrags;
 	int esph_offset;
 	struct page *page;
@@ -485,14 +484,10 @@ int esp_output_head(struct xfrm_state *x
 			page = pfrag->page;
 			get_page(page);
 
-			vaddr = kmap_atomic(page);
-
-			tail = vaddr + pfrag->offset;
+			tail = page_address(page) + pfrag->offset;
 
 			esp_output_fill_trailer(tail, esp->tfclen, esp->plen, esp->proto);
 
-			kunmap_atomic(vaddr);
-
 			nfrags = skb_shinfo(skb)->nr_frags;
 
 			__skb_fill_page_desc(skb, nfrags, page, pfrag->offset,
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -478,7 +478,6 @@ static int esp6_output_encap(struct xfrm
 int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
 {
 	u8 *tail;
-	u8 *vaddr;
 	int nfrags;
 	int esph_offset;
 	struct page *page;
@@ -519,14 +518,10 @@ int esp6_output_head(struct xfrm_state *
 			page = pfrag->page;
 			get_page(page);
 
-			vaddr = kmap_atomic(page);
-
-			tail = vaddr + pfrag->offset;
+			tail = page_address(page) + pfrag->offset;
 
 			esp_output_fill_trailer(tail, esp->tfclen, esp->plen, esp->proto);
 
-			kunmap_atomic(vaddr);
-
 			nfrags = skb_shinfo(skb)->nr_frags;
 
 			__skb_fill_page_desc(skb, nfrags, page, pfrag->offset,


