Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA340300C37
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 20:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbhAVSlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:41:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728510AbhAVOVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:21:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3E6E23B26;
        Fri, 22 Jan 2021 14:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324919;
        bh=YBUaJS27ThLeex0B9oiSRGpkoFV5SK9mrYm406vRGTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToYFBkZDRcEW3HUaIOh7uyKjWzvsE9P3cp+xkiIc2VEDcHvoqWIp/vF9FBtQRnoyM
         oqN2wHfzRXB67BiRsOq0fubtt0CUeABWVqBAm3B/eNOfHNzbtrOhZuqA3rcj3Jnh9J
         LtxlIZ4+2N2qLg507z7czLrPG7f+TFO1v7s7ibVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 38/50] esp: avoid unneeded kmap_atomic call
Date:   Fri, 22 Jan 2021 15:12:19 +0100
Message-Id: <20210122135736.734491512@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
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
@@ -252,7 +252,6 @@ static int esp_output_udp_encap(struct x
 int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
 {
 	u8 *tail;
-	u8 *vaddr;
 	int nfrags;
 	int esph_offset;
 	struct page *page;
@@ -294,14 +293,10 @@ int esp_output_head(struct xfrm_state *x
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
@@ -219,7 +219,6 @@ static void esp_output_fill_trailer(u8 *
 int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
 {
 	u8 *tail;
-	u8 *vaddr;
 	int nfrags;
 	struct page *page;
 	struct sk_buff *trailer;
@@ -252,14 +251,10 @@ int esp6_output_head(struct xfrm_state *
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


