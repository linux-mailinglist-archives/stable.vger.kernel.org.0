Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE8974DCB9B
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 17:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbiCQQnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 12:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236618AbiCQQne (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 12:43:34 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EC2204CA3
        for <stable@vger.kernel.org>; Thu, 17 Mar 2022 09:42:18 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id q13so4890630plk.12
        for <stable@vger.kernel.org>; Thu, 17 Mar 2022 09:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=or2gBdqiYvWxrvYeEoW2F03iBQdb5hmDz2yVMN1LieU=;
        b=qhs8UWmCsuEvvAo4Qa7r8A7GKjqXBf+wtzX3LvUApXJ8GSX52TYdDhIZSnON4cCg+U
         aAAv+N+n1JRUoGIqqIR81CAiweeJc6DTtrk9FYe2Ur4zQcElTwQSx+C6pPjwPL0fFMKW
         sqTjcv+cUe+fOJQ4gPivZK7GySRItdsDz4MUS0J2eBqKYXwMCZGL7bwWwGcTCGVVA4hh
         JRm8gsOE28QgqObQKxlITiHNsyC8jeGC19/4kHc6GXo80RQT19QnKB4maYIGpIWddltG
         TYaCWICaXPMorBqVMnaGwVxnlhoTMaom3WcCtAkB+hIL7BqKcum/pBjqpf5D7DSClBd3
         qdMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=or2gBdqiYvWxrvYeEoW2F03iBQdb5hmDz2yVMN1LieU=;
        b=fN8q1TP66I6qCAiAXvnv19B7FJ4RIXP7FswJ51LTSPiyfaWYKsT4Tg95yS/ujnCMOw
         06z0DFUEnQUvfxaPTGUQ7s7HEdRDZVDg97Av00XatkR0UV9VXYfPM3x5xZazNnAAb86D
         +RU8zqjoDHNx0nf0sZisAZ3KEW2AQ0gnzmbfXkm7BWT9kLOf3zxMiJN/qWfbXy/ym4P9
         Rxz8TPkgnxpOqimNWQe6BC7YtKr7zMh4JYlBzm3CW/GNZ2JA6bwzCeEKXEvxMvzDhvr7
         aLvNLQd/K5WykChGP/fkUhLzRHj22D9drFfcEzPE/Lml11SguQFOUIuISurJQPKiLJJy
         7QLA==
X-Gm-Message-State: AOAM530pqbijkkxRUCGDQD+CTC9OGv56I1HYYurPTiWGW2OdXfIFXvll
        RHfDwtSpNE9YeIVyk4U2nnDd+A==
X-Google-Smtp-Source: ABdhPJwoePC7Jx62aULhhc0lS4ZijMFm/Xyw3cDvkSpMf6TIlo40vk/7l3U67/+uH6xhq/2Y8JbdFg==
X-Received: by 2002:a17:90b:1d0d:b0:1bf:6efa:3fed with SMTP id on13-20020a17090b1d0d00b001bf6efa3fedmr16898992pjb.150.1647535337711;
        Thu, 17 Mar 2022 09:42:17 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id s30-20020a056a001c5e00b004f73f27aa40sm7025940pfw.161.2022.03.17.09.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 09:42:17 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     sec@valis.email, stable@vger.kernel.org,
        steffen.klassert@secunet.com,
        syzbot+93ab2623dcb5c73eda9f@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH 5.10] esp: Fix possible buffer overflow in ESP transformation
Date:   Thu, 17 Mar 2022 09:41:59 -0700
Message-Id: <20220317164159.1916929-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <164724987520346@kroah.com>
References: <164724987520346@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

Plese apply this on 5.10.y stable as well as it fixes the following
syzbot issues:

LINK: https://syzkaller.appspot.com/bug?id=517fa734b92b7db404c409b924cf5c997640e324
LINK: https://syzkaller.appspot.com/bug?id=57375340ab81a369df5da5eb16cfcd4aef9dfb9d

Here is a working patch.
---8<---

The maximum message size that can be send is bigger than
the  maximum site that skb_page_frag_refill can allocate.
So it is possible to write beyond the allocated buffer.

Fix this by doing a fallback to COW in that case.

Fixes: cac2661c53f3 ("esp4: Avoid skb_cow_data whenever possible")
Fixes: 03e2a30f6a27 ("esp6: Avoid skb_cow_data whenever possible")
Reported-by: valis <sec@valis.email>
Reported-by: <syzbot+93ab2623dcb5c73eda9f@syzkaller.appspotmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 include/net/esp.h  | 2 ++
 include/net/sock.h | 1 +
 net/ipv4/esp4.c    | 5 +++++
 net/ipv6/esp6.c    | 5 +++++
 4 files changed, 13 insertions(+)

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
diff --git a/include/net/sock.h b/include/net/sock.h
index d50823df426c..865e0ff20a81 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2688,6 +2688,7 @@ extern int sysctl_optmem_max;
 extern __u32 sysctl_wmem_default;
 extern __u32 sysctl_rmem_default;
 
+#define SKB_FRAG_PAGE_ORDER	get_order(32768)
 DECLARE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
 
 static inline int sk_get_wmem0(const struct sock *sk, const struct proto *proto)
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 61dfb64e7256..b23b2bedca7a 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -448,6 +448,7 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
+	unsigned int allocsz;
 
 	/* this is non-NULL only with TCP/UDP Encapsulation */
 	if (x->encap) {
@@ -457,6 +458,10 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
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
index cb708fbb1c17..ffcc30484c8d 100644
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
2.35.1

