Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D23D4EB58A
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 00:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbiC2WF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 18:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235689AbiC2WF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 18:05:58 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C0D35DCD
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 15:04:14 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id c15-20020a17090a8d0f00b001c9c81d9648so4327631pjo.2
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 15:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ISxNkOfc1BbAsi1yryJcItqT5fA5GDv8BdlpkUwocJ4=;
        b=qBW1RF01ByOBUg0uRUt2D/xJYWKfL2Wye0ZniWA/IECvZ/4x8aEWKnNzrOe6JocSFe
         Wjgs9ognr1FfXUIaWDl1rMhBmUuAK2U0Tl6MYY+/i1r8cTaJExbGwMsSpt8ifJZH8XIH
         El+axebJPTXmgczTEXFgcXO5qK2uGnEFjxcLxdjy6dxv9/KcRj/YsR8DvizaLItIhBfU
         iOElkhcM5F0/bg9qRFgPSAJbYRjJ37vLQWi3KDIu7JnFtxQkrl7RRLcqMF0r1KQkITOw
         8MzGhxvLJrPBrlFxGJY/vF9E7+KHnE2aBhdyUZOKgx0V3MuGFKTQiAajiLqIzVOZ6ZPO
         4DaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ISxNkOfc1BbAsi1yryJcItqT5fA5GDv8BdlpkUwocJ4=;
        b=2K96yk7gTZBGijEW65WoQvMUBB9YTaivfJDb7Llst4q0SQRGTiDc917wcreGHBy0IA
         lU407P+KyzeE7xQtUwMZAQuHFd2cvCFgfv/A5jcMf2xi8OOlH6VkYUtzaama1ui84I2K
         kMdUTNCBwsP5Qz++RXm/XsVFirHqm88mIFUUqPHiWovGU1ruZRf3fpMINcNpEY6QQm2u
         Ys86bhnXXoHDIVRxJbgaQa8MdiIaXGLy3oL7218m1JcLz55orao9Xz+ONPIrM5cPDZKu
         ICSWlWPsq6qoJbhxXIt179ikx7IxgrdyocS5aslIIMwR1/QFeJnn/ugkisQGYm6txT/J
         ny0w==
X-Gm-Message-State: AOAM533UfSIc9RaJkN3uO12GWcvspOUdmsqGt2HxksW3wzNP3BtZT/LW
        JZFULUDAbj1Jboi1DW+XpblJ46riIQfdq8FWKt8=
X-Google-Smtp-Source: ABdhPJwL8DCoDYRxIFi9nWAs9ubIkgxywdK2dMwSORD5INal3rHR6MIAOnillnBE0i9+cJQrpUZ+lA==
X-Received: by 2002:a17:902:b702:b0:156:17a5:5ddb with SMTP id d2-20020a170902b70200b0015617a55ddbmr9636682pls.44.1648591454158;
        Tue, 29 Mar 2022 15:04:14 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id 16-20020a17090a005000b001c7511dc31esm3937452pjb.41.2022.03.29.15.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 15:04:13 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     stable@vger.kernel.org
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 2/2] skbuff: Extract list pointers to silence compiler warnings
Date:   Tue, 29 Mar 2022 15:02:56 -0700
Message-Id: <20220329220256.72283-2-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220329220256.72283-1-tadeusz.struk@linaro.org>
References: <20220329220256.72283-1-tadeusz.struk@linaro.org>
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

Please apply this to stable 5.10.y, and 5.15.y
---8<---

From: Kees Cook <keescook@chromium.org>

Upstream commit: 1a2fb220edca ("skbuff: Extract list pointers to silence compiler warnings")

Under both -Warray-bounds and the object_size sanitizer, the compiler is
upset about accessing prev/next of sk_buff when the object it thinks it
is coming from is sk_buff_head. The warning is a false positive due to
the compiler taking a conservative approach, opting to warn at casting
time rather than access time.

However, in support of enabling -Warray-bounds globally (which has
found many real bugs), arrange things for sk_buff so that the compiler
can unambiguously see that there is no intention to access anything
except prev/next.  Introduce and cast to a separate struct sk_buff_list,
which contains _only_ the first two fields, silencing the warnings:

In file included from ./include/net/net_namespace.h:39,
                 from ./include/linux/netdevice.h:37,
                 from net/core/netpoll.c:17:
net/core/netpoll.c: In function 'refill_skbs':
./include/linux/skbuff.h:2086:9: warning: array subscript 'struct sk_buff[0]' is partly outside array bounds of 'struct sk_buff_head[1]' [-Warray-bounds]
 2086 |         __skb_insert(newsk, next->prev, next, list);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
net/core/netpoll.c:49:28: note: while referencing 'skb_pool'
   49 | static struct sk_buff_head skb_pool;
      |                            ^~~~~~~~

This also upsets UBSAN, which throws a runtime object-size-mismatch
error complaining about skbuff queue helpers, as below, when the kernel
is built with clang and -fsanitize=undefined flag set:

UBSAN: object-size-mismatch in ./include/linux/skbuff.h:2023:28
member access within address ffffc90000cb71c0 with insufficient space
for an object of type 'struct sk_buff'

This change results in no executable instruction differences.

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20211207062758.2324338-1-keescook@chromium.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 include/linux/skbuff.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index acbf1875ad50..b7de22193ec8 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -289,9 +289,11 @@ struct tc_skb_ext {
 #endif
 
 struct sk_buff_head {
+	struct_group_tagged(sk_buff_list, list,
 	/* These two members must be first. */
 	struct sk_buff	*next;
 	struct sk_buff	*prev;
+	);
 
 	__u32		qlen;
 	spinlock_t	lock;
@@ -1906,8 +1908,8 @@ static inline void __skb_insert(struct sk_buff *newsk,
 	 */
 	WRITE_ONCE(newsk->next, next);
 	WRITE_ONCE(newsk->prev, prev);
-	WRITE_ONCE(next->prev, newsk);
-	WRITE_ONCE(prev->next, newsk);
+	WRITE_ONCE(((struct sk_buff_list *)next)->prev, newsk);
+	WRITE_ONCE(((struct sk_buff_list *)prev)->next, newsk);
 	WRITE_ONCE(list->qlen, list->qlen + 1);
 }
 
@@ -2003,7 +2005,7 @@ static inline void __skb_queue_after(struct sk_buff_head *list,
 				     struct sk_buff *prev,
 				     struct sk_buff *newsk)
 {
-	__skb_insert(newsk, prev, prev->next, list);
+	__skb_insert(newsk, prev, ((struct sk_buff_list *)prev)->next, list);
 }
 
 void skb_append(struct sk_buff *old, struct sk_buff *newsk,
@@ -2013,7 +2015,7 @@ static inline void __skb_queue_before(struct sk_buff_head *list,
 				      struct sk_buff *next,
 				      struct sk_buff *newsk)
 {
-	__skb_insert(newsk, next->prev, next, list);
+	__skb_insert(newsk, ((struct sk_buff_list *)next)->prev, next, list);
 }
 
 /**
-- 
2.35.1

