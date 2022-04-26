Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B1250F88F
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbiDZJIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347613AbiDZJF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:05:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5036B1D4;
        Tue, 26 Apr 2022 01:45:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D2F361344;
        Tue, 26 Apr 2022 08:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B066C385AE;
        Tue, 26 Apr 2022 08:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962706;
        bh=lGc0mAUhfpdffiH5zcTjJhech/QCb4kZ9Ct3XGwOF3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhbE+lgqd1vwCT9Fmd4AZtTVeUjOOvtA3p4wonW6eUSu+ZrHVJdQ9JGmMjIXUTen5
         I7axb67AD0tm/D+I1gVuuRJsKlZo5GUJwutTHzv3DzK8FWkew+6RNzZDvFjFDjDyE+
         pP+Cfa50pOd8YiZtd2iwZgBsNap9u0XwY1WZ6ChA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 022/146] esp: limit skb_page_frag_refill use to a single page
Date:   Tue, 26 Apr 2022 10:20:17 +0200
Message-Id: <20220426081750.689360960@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 5bd8baab087dff657e05387aee802e70304cc813 ]

Commit ebe48d368e97 ("esp: Fix possible buffer overflow in ESP
transformation") tried to fix skb_page_frag_refill usage in ESP by
capping allocsize to 32k, but that doesn't completely solve the issue,
as skb_page_frag_refill may return a single page. If that happens, we
will write out of bounds, despite the check introduced in the previous
patch.

This patch forces COW in cases where we would end up calling
skb_page_frag_refill with a size larger than a page (first in
esp_output_head with tailen, then in esp_output_tail with
skb->data_len).

Fixes: cac2661c53f3 ("esp4: Avoid skb_cow_data whenever possible")
Fixes: 03e2a30f6a27 ("esp6: Avoid skb_cow_data whenever possible")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/esp.h | 2 --
 net/ipv4/esp4.c   | 5 ++---
 net/ipv6/esp6.c   | 5 ++---
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/net/esp.h b/include/net/esp.h
index 90cd02ff77ef..9c5637d41d95 100644
--- a/include/net/esp.h
+++ b/include/net/esp.h
@@ -4,8 +4,6 @@
 
 #include <linux/skbuff.h>
 
-#define ESP_SKB_FRAG_MAXSIZE (PAGE_SIZE << SKB_FRAG_PAGE_ORDER)
-
 struct ip_esp_hdr;
 
 static inline struct ip_esp_hdr *ip_esp_hdr(const struct sk_buff *skb)
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 70e6c87fbe3d..d747166bb291 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -446,7 +446,6 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
-	unsigned int allocsz;
 
 	/* this is non-NULL only with TCP/UDP Encapsulation */
 	if (x->encap) {
@@ -456,8 +455,8 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 			return err;
 	}
 
-	allocsz = ALIGN(skb->data_len + tailen, L1_CACHE_BYTES);
-	if (allocsz > ESP_SKB_FRAG_MAXSIZE)
+	if (ALIGN(tailen, L1_CACHE_BYTES) > PAGE_SIZE ||
+	    ALIGN(skb->data_len, L1_CACHE_BYTES) > PAGE_SIZE)
 		goto cow;
 
 	if (!skb_cloned(skb)) {
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 55d604c9b3b3..f2120e92caf1 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -482,7 +482,6 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
-	unsigned int allocsz;
 
 	if (x->encap) {
 		int err = esp6_output_encap(x, skb, esp);
@@ -491,8 +490,8 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 			return err;
 	}
 
-	allocsz = ALIGN(skb->data_len + tailen, L1_CACHE_BYTES);
-	if (allocsz > ESP_SKB_FRAG_MAXSIZE)
+	if (ALIGN(tailen, L1_CACHE_BYTES) > PAGE_SIZE ||
+	    ALIGN(skb->data_len, L1_CACHE_BYTES) > PAGE_SIZE)
 		goto cow;
 
 	if (!skb_cloned(skb)) {
-- 
2.35.1



