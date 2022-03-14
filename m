Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAA04D7E68
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 10:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237920AbiCNJ0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 05:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237921AbiCNJ0F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 05:26:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC2B2B24F
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 02:24:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CA0C60916
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 09:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793A7C340E9;
        Mon, 14 Mar 2022 09:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647249895;
        bh=PQ+SRj6bt3iPtGCCS55Mf+O6usiG+aMnf7zNDRqsXhs=;
        h=Subject:To:Cc:From:Date:From;
        b=gyQmX1WRPb6SQmsU/rVpvYwI4BvWlH5v0L2pbKFDicZW34kqlkCpo+RZjQLcTrz04
         QaVi38P3biFlpxYPOsy90C8x0PZlb0OQfm0j4gZ8PlJQFcVxGjPDLV7izMiD6gUpT9
         B4PANPK0Vv8VGB4TNt3ZgKeq96MO6omWJauzyRv8=
Subject: FAILED: patch "[PATCH] esp: Fix possible buffer overflow in ESP transformation" failed to apply to 5.10-stable tree
To:     steffen.klassert@secunet.com, sec@valis.email
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Mar 2022 10:24:35 +0100
Message-ID: <164724987520346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ebe48d368e97d007bfeb76fcb065d6cfc4c96645 Mon Sep 17 00:00:00 2001
From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Mon, 7 Mar 2022 13:11:39 +0100
Subject: [PATCH] esp: Fix possible buffer overflow in ESP transformation

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
index 7591160edce1..b0ffbcd5432d 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -482,6 +482,7 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
+	unsigned int allocsz;
 
 	if (x->encap) {
 		int err = esp6_output_encap(x, skb, esp);
@@ -490,6 +491,10 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 			return err;
 	}
 
+	allocsz = ALIGN(skb->data_len + tailen, L1_CACHE_BYTES);
+	if (allocsz > ESP_SKB_FRAG_MAXSIZE)
+		goto cow;
+
 	if (!skb_cloned(skb)) {
 		if (tailen <= skb_tailroom(skb)) {
 			nfrags = 1;

