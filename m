Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87014D843E
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241686AbiCNMX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243004AbiCNMUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:20:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382F652E18;
        Mon, 14 Mar 2022 05:15:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C67D1B80D24;
        Mon, 14 Mar 2022 12:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D6AC340E9;
        Mon, 14 Mar 2022 12:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260110;
        bh=RsFZTWnfjmpT6i3ems5I0UMcIWdeQ2t770YuUzve0og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjcEMa4z9bSWgpdmAiAKGRHch06w4mVvg7VvQIK8inRiDanMUSZr77v/BMeF1DtaR
         2x7u2JPDRNsxlFrT2t96moIUMCQ33C1bm6BMMXi822ybdavaE/JeduVFVUskN1LGF6
         MQikQBBDERkw5A4+3gDfgUmVsIZmSa9VbFxuBr+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, valis <sec@valis.email>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 023/121] esp: Fix possible buffer overflow in ESP transformation
Date:   Mon, 14 Mar 2022 12:53:26 +0100
Message-Id: <20220314112744.776782376@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit ebe48d368e97d007bfeb76fcb065d6cfc4c96645 ]

The maximum message size that can be send is bigger than
the  maximum site that skb_page_frag_refill can allocate.
So it is possible to write beyond the allocated buffer.

Fix this by doing a fallback to COW in that case.

v2:

Avoid get get_order() costs as suggested by Linus Torvalds.

Fixes: cac2661c53f3 ("esp4: Avoid skb_cow_data whenever possible")
Fixes: 03e2a30f6a27 ("esp6: Avoid skb_cow_data whenever possible")
Reported-by: valis <sec@valis.email>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/esp.h | 2 ++
 net/ipv4/esp4.c   | 5 +++++
 net/ipv6/esp6.c   | 5 +++++
 3 files changed, 12 insertions(+)

diff --git a/include/net/esp.h b/include/net/esp.h
index 9c5637d41d95..90cd02ff77ef 100644
--- a/include/net/esp.h
+++ b/include/net/esp.h
@@ -4,6 +4,8 @@
 
 #include <linux/skbuff.h>
 
+#define ESP_SKB_FRAG_MAXSIZE (PAGE_SIZE << SKB_FRAG_PAGE_ORDER)
+
 struct ip_esp_hdr;
 
 static inline struct ip_esp_hdr *ip_esp_hdr(const struct sk_buff *skb)
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index e1b1d080e908..70e6c87fbe3d 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -446,6 +446,7 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
+	unsigned int allocsz;
 
 	/* this is non-NULL only with TCP/UDP Encapsulation */
 	if (x->encap) {
@@ -455,6 +456,10 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 			return err;
 	}
 
+	allocsz = ALIGN(skb->data_len + tailen, L1_CACHE_BYTES);
+	if (allocsz > ESP_SKB_FRAG_MAXSIZE)
+		goto cow;
+
 	if (!skb_cloned(skb)) {
 		if (tailen <= skb_tailroom(skb)) {
 			nfrags = 1;
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 883b53fd7846..b7b573085bd5 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -483,6 +483,7 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
+	unsigned int allocsz;
 
 	if (x->encap) {
 		int err = esp6_output_encap(x, skb, esp);
@@ -491,6 +492,10 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 			return err;
 	}
 
+	allocsz = ALIGN(skb->data_len + tailen, L1_CACHE_BYTES);
+	if (allocsz > ESP_SKB_FRAG_MAXSIZE)
+		goto cow;
+
 	if (!skb_cloned(skb)) {
 		if (tailen <= skb_tailroom(skb)) {
 			nfrags = 1;
-- 
2.34.1



