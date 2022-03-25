Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F45D4E75E7
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359611AbiCYPI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359575AbiCYPIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:08:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5A1D9EAC;
        Fri, 25 Mar 2022 08:07:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6FAD61C1E;
        Fri, 25 Mar 2022 15:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18DBC340F1;
        Fri, 25 Mar 2022 15:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220824;
        bh=EWu8tlVUvY2P/Q7rfy1gpf/qZdKlhBmhU443XVaCSWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3fQx/2lBwxk6z34xmFJWW3Q5k5CIgN2jAZw1KuZovm22ekDx2W5yQlIgzKFQi+mu
         eHrYTaOdEfZo6XgrJ0MS72I7/130OOpVyS1/ENS5peUpLEcAFJuzJTfPOIkCnScr5j
         bwMMa1HqVuE6VkvtChvLn1epYY7zZrhzPO9PLJ6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, valis <sec@valis.email>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Vaibhav Rustagi <vaibhavrustagi@google.com>
Subject: [PATCH 4.19 03/20] esp: Fix possible buffer overflow in ESP transformation
Date:   Fri, 25 Mar 2022 16:04:41 +0100
Message-Id: <20220325150417.110405983@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150417.010265747@linuxfoundation.org>
References: <20220325150417.010265747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

commit ebe48d368e97d007bfeb76fcb065d6cfc4c96645 upstream.

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
Signed-off-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/esp.h  |    2 ++
 include/net/sock.h |    3 +++
 net/core/sock.c    |    3 ---
 net/ipv4/esp4.c    |    5 +++++
 net/ipv6/esp6.c    |    5 +++++
 5 files changed, 15 insertions(+), 3 deletions(-)

--- a/include/net/esp.h
+++ b/include/net/esp.h
@@ -4,6 +4,8 @@
 
 #include <linux/skbuff.h>
 
+#define ESP_SKB_FRAG_MAXSIZE (PAGE_SIZE << SKB_FRAG_PAGE_ORDER)
+
 struct ip_esp_hdr;
 
 static inline struct ip_esp_hdr *ip_esp_hdr(const struct sk_buff *skb)
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2518,6 +2518,9 @@ extern int sysctl_optmem_max;
 extern __u32 sysctl_wmem_default;
 extern __u32 sysctl_rmem_default;
 
+/* On 32bit arches, an skb frag is limited to 2^15 */
+#define SKB_FRAG_PAGE_ORDER	get_order(32768)
+
 static inline int sk_get_wmem0(const struct sock *sk, const struct proto *proto)
 {
 	/* Does this proto have per netns sysctl_wmem ? */
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2207,9 +2207,6 @@ static void sk_leave_memory_pressure(str
 	}
 }
 
-/* On 32bit arches, an skb frag is limited to 2^15 */
-#define SKB_FRAG_PAGE_ORDER	get_order(32768)
-
 /**
  * skb_page_frag_refill - check that a page_frag contains enough room
  * @sz: minimum size of the fragment we want to get
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -275,6 +275,7 @@ int esp_output_head(struct xfrm_state *x
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
+	unsigned int allocsz;
 
 	/* this is non-NULL only with UDP Encapsulation */
 	if (x->encap) {
@@ -284,6 +285,10 @@ int esp_output_head(struct xfrm_state *x
 			return err;
 	}
 
+	allocsz = ALIGN(skb->data_len + tailen, L1_CACHE_BYTES);
+	if (allocsz > ESP_SKB_FRAG_MAXSIZE)
+		goto cow;
+
 	if (!skb_cloned(skb)) {
 		if (tailen <= skb_tailroom(skb)) {
 			nfrags = 1;
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -241,6 +241,11 @@ int esp6_output_head(struct xfrm_state *
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
+	unsigned int allocsz;
+
+	allocsz = ALIGN(skb->data_len + tailen, L1_CACHE_BYTES);
+	if (allocsz > ESP_SKB_FRAG_MAXSIZE)
+		goto cow;
 
 	if (!skb_cloned(skb)) {
 		if (tailen <= skb_tailroom(skb)) {


