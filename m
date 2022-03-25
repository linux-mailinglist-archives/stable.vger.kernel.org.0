Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FBA4E7631
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376304AbiCYPLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359855AbiCYPLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:11:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CFC5F276;
        Fri, 25 Mar 2022 08:08:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF29A61C12;
        Fri, 25 Mar 2022 15:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E64C340E9;
        Fri, 25 Mar 2022 15:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220900;
        bh=VxRB2LISnDDQcZScuENYf6qsl2GEU/YC1FvIF1AMrFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jNbKg0eZE5lko5jKfHsScKXymn8JH9qwSwUlAORA4ufAuTUiOm0Z38T0AnuIjacAH
         IYV4nPBkF3zNoeoL2tSH3BzpX/G6ZZZSIjMhJSsP6lUsBXt0egET61VBjXeVneSEl0
         /8IYLW8Y9bDm7Ku6UlG5CuHJC7G36poM/erH0Ohk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, valis <sec@valis.email>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Vaibhav Rustagi <vaibhavrustagi@google.com>
Subject: [PATCH 5.4 05/29] esp: Fix possible buffer overflow in ESP transformation
Date:   Fri, 25 Mar 2022 16:04:45 +0100
Message-Id: <20220325150418.741528100@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150418.585286754@linuxfoundation.org>
References: <20220325150418.585286754@linuxfoundation.org>
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
 net/core/sock.c    |    2 --
 net/ipv4/esp4.c    |    5 +++++
 net/ipv6/esp6.c    |    5 +++++
 5 files changed, 15 insertions(+), 2 deletions(-)

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
@@ -2583,6 +2583,9 @@ extern int sysctl_optmem_max;
 extern __u32 sysctl_wmem_default;
 extern __u32 sysctl_rmem_default;
 
+
+/* On 32bit arches, an skb frag is limited to 2^15 */
+#define SKB_FRAG_PAGE_ORDER	get_order(32768)
 DECLARE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
 
 static inline int sk_get_wmem0(const struct sock *sk, const struct proto *proto)
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2355,8 +2355,6 @@ static void sk_leave_memory_pressure(str
 	}
 }
 
-/* On 32bit arches, an skb frag is limited to 2^15 */
-#define SKB_FRAG_PAGE_ORDER	get_order(32768)
 DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
 
 /**
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -277,6 +277,7 @@ int esp_output_head(struct xfrm_state *x
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
+	unsigned int allocsz;
 
 	/* this is non-NULL only with UDP Encapsulation */
 	if (x->encap) {
@@ -286,6 +287,10 @@ int esp_output_head(struct xfrm_state *x
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
@@ -230,6 +230,11 @@ int esp6_output_head(struct xfrm_state *
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


