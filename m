Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6DAE4E2982
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344361AbiCUOFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348565AbiCUOCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:02:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F5CA27D3;
        Mon, 21 Mar 2022 06:59:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B386B61325;
        Mon, 21 Mar 2022 13:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9938C340ED;
        Mon, 21 Mar 2022 13:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871168;
        bh=WbAXIMIpSRb7OSyInJWIlEk1e63sTaThqozBnDrl2dY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u02wL1SW39FzXRYbI6Wr4VNYBTOOjMJFXrUt23gT3ZDI3RVepUxUI0zW1Vxq2u+Lm
         u9fiQmv0GVCry/THldhali7hCktgIj+LbIgy1fxP66cCfjMSu2/Wdy8BQCGxo61Zv4
         nr47/p4qZH5xVxu65ls4I8Ud48tMpB8Qezomftx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, valis <sec@valis.email>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH 5.10 29/30] esp: Fix possible buffer overflow in ESP transformation
Date:   Mon, 21 Mar 2022 14:52:59 +0100
Message-Id: <20220321133220.490047170@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133219.643490199@linuxfoundation.org>
References: <20220321133219.643490199@linuxfoundation.org>
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
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/esp.h  |    2 ++
 include/net/sock.h |    1 +
 net/ipv4/esp4.c    |    5 +++++
 net/ipv6/esp6.c    |    5 +++++
 4 files changed, 13 insertions(+)

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
@@ -2670,6 +2670,7 @@ extern int sysctl_optmem_max;
 extern __u32 sysctl_wmem_default;
 extern __u32 sysctl_rmem_default;
 
+#define SKB_FRAG_PAGE_ORDER	get_order(32768)
 DECLARE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
 
 static inline int sk_get_wmem0(const struct sock *sk, const struct proto *proto)
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -448,6 +448,7 @@ int esp_output_head(struct xfrm_state *x
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
+	unsigned int allocsz;
 
 	/* this is non-NULL only with TCP/UDP Encapsulation */
 	if (x->encap) {
@@ -457,6 +458,10 @@ int esp_output_head(struct xfrm_state *x
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
@@ -483,6 +483,7 @@ int esp6_output_head(struct xfrm_state *
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
+	unsigned int allocsz;
 
 	if (x->encap) {
 		int err = esp6_output_encap(x, skb, esp);
@@ -491,6 +492,10 @@ int esp6_output_head(struct xfrm_state *
 			return err;
 	}
 
+	allocsz = ALIGN(skb->data_len + tailen, L1_CACHE_BYTES);
+	if (allocsz > ESP_SKB_FRAG_MAXSIZE)
+		goto cow;
+
 	if (!skb_cloned(skb)) {
 		if (tailen <= skb_tailroom(skb)) {
 			nfrags = 1;


