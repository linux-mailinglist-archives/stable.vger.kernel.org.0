Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C2D56F9EA
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiGKJKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGKJKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9095A2497E;
        Mon, 11 Jul 2022 02:08:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17A04B80D2C;
        Mon, 11 Jul 2022 09:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F499C34115;
        Mon, 11 Jul 2022 09:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530505;
        bh=0RjhcLcxu9Futdxg62ZkXoHAwn52IC1X/M2zy7OHxxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I76k/CxbotFKzSQYmH62pHMdwEJ1ynqkMSerNFrgjJ9k2g+IxNHWuI9SzBhsH9JQg
         LgMClDWswOwpmCytPSStTCL93/l7UQiBUV1Snlwwn7DSiW/A7WmNdYc/9fxoFEE+il
         i8NVc2nyIIL7mJnFRxCa+NuoS2Xsws7C0iZ1q30I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.19 01/31] esp: limit skb_page_frag_refill use to a single page
Date:   Mon, 11 Jul 2022 11:06:40 +0200
Message-Id: <20220711090537.888206828@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090537.841305347@linuxfoundation.org>
References: <20220711090537.841305347@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

commit 5bd8baab087dff657e05387aee802e70304cc813 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/esp.h |    2 --
 net/ipv4/esp4.c   |    5 ++---
 net/ipv6/esp6.c   |    5 ++---
 3 files changed, 4 insertions(+), 8 deletions(-)

--- a/include/net/esp.h
+++ b/include/net/esp.h
@@ -4,8 +4,6 @@
 
 #include <linux/skbuff.h>
 
-#define ESP_SKB_FRAG_MAXSIZE (PAGE_SIZE << SKB_FRAG_PAGE_ORDER)
-
 struct ip_esp_hdr;
 
 static inline struct ip_esp_hdr *ip_esp_hdr(const struct sk_buff *skb)
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -275,7 +275,6 @@ int esp_output_head(struct xfrm_state *x
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
-	unsigned int allocsz;
 
 	/* this is non-NULL only with UDP Encapsulation */
 	if (x->encap) {
@@ -285,8 +284,8 @@ int esp_output_head(struct xfrm_state *x
 			return err;
 	}
 
-	allocsz = ALIGN(skb->data_len + tailen, L1_CACHE_BYTES);
-	if (allocsz > ESP_SKB_FRAG_MAXSIZE)
+	if (ALIGN(tailen, L1_CACHE_BYTES) > PAGE_SIZE ||
+	    ALIGN(skb->data_len, L1_CACHE_BYTES) > PAGE_SIZE)
 		goto cow;
 
 	if (!skb_cloned(skb)) {
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -241,10 +241,9 @@ int esp6_output_head(struct xfrm_state *
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
-	unsigned int allocsz;
 
-	allocsz = ALIGN(skb->data_len + tailen, L1_CACHE_BYTES);
-	if (allocsz > ESP_SKB_FRAG_MAXSIZE)
+	if (ALIGN(tailen, L1_CACHE_BYTES) > PAGE_SIZE ||
+	    ALIGN(skb->data_len, L1_CACHE_BYTES) > PAGE_SIZE)
 		goto cow;
 
 	if (!skb_cloned(skb)) {


