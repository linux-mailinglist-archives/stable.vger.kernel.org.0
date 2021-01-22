Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A37E300545
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbhAVOYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:24:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:40014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728623AbhAVOXg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D2DF23B83;
        Fri, 22 Jan 2021 14:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325071;
        bh=W8/1ggZ/RTjMxiMDdKObgvwI7zkkrqnLBJDBnr2wTUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F8foH6NN5XbXJhu3Tf73jEjeV06LgBx3mCdGJC9nBAuWwmNcNaHgjXH6VoYNM87/n
         QWJ7N3UO5AosYFf+ogD2kZDYSbj5aXUyWj2ZkC6qLkJfdV1hF4fIfBmwKbq+TGYOGd
         CG3yqHJcCkuvSt6HH+7IMXxLKgW749j44V5CfVdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 21/33] esp: avoid unneeded kmap_atomic call
Date:   Fri, 22 Jan 2021 15:12:37 +0100
Message-Id: <20210122135734.441605268@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135733.565501039@linuxfoundation.org>
References: <20210122135733.565501039@linuxfoundation.org>
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
@@ -272,7 +272,6 @@ static int esp_output_udp_encap(struct x
 int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
 {
 	u8 *tail;
-	u8 *vaddr;
 	int nfrags;
 	int esph_offset;
 	struct page *page;
@@ -314,14 +313,10 @@ int esp_output_head(struct xfrm_state *x
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
@@ -226,7 +226,6 @@ static void esp_output_fill_trailer(u8 *
 int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
 {
 	u8 *tail;
-	u8 *vaddr;
 	int nfrags;
 	struct page *page;
 	struct sk_buff *trailer;
@@ -259,14 +258,10 @@ int esp6_output_head(struct xfrm_state *
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


