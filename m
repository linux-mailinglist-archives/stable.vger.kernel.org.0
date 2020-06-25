Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CAD20A6DE
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 22:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407157AbgFYUhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 16:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407168AbgFYUhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 16:37:09 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06ECC08C5DC
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 13:37:09 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id cm23so3866996pjb.5
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 13:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zH4NCz4WUaJ18HzpAMLRB8JzZlzE4XmxaFkgad5236Q=;
        b=RBKdveDB6/6TryZmoNNALhVnkzSsz2R1ULWjvCpcvukqeMwo0hJIk9HrScRw9ugson
         xp2VUC3/+oZibhV2ktrPBevQZ01heoCGaHB/q3pX2tYDKAkzMDAnS509Kjmw6py7sBnO
         iDJiP31nLw90dXJS/kd9DdxoeZQKV42Tk6wmQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zH4NCz4WUaJ18HzpAMLRB8JzZlzE4XmxaFkgad5236Q=;
        b=TwWmUi7QY1fSXs8QCITkKro94cHUB6RZYE92Bv+xYIL+v8J9uJm9WnrzylW1aj72JB
         4FYU3KtKoLubnX7bvVno06GF8HOHuhqtxB/4uEdKEbroNFRKqZ+d+3ute7w5F1bEh04t
         9wv8SK3lbBpoqPpdt/8djylPKKZX73PVorIpnj5p02tHfH1q+8xVhzvI7tZne4Jwmziu
         s6WrdEz/d87Q4863Q44cz6Ah11pdaDIPcgu0IKHD6mR7o/25BPJwFVRCoQaISYOEAxAE
         KjHLW/ugdE21xtbRYquVL34Alf6KF2gvw4mUzRwBOJs3ABtzl3LjkMNSyoMuQDx6pqUi
         vcFg==
X-Gm-Message-State: AOAM530+TEKdXljXAOM4gIxBAobzln2b7HgdYlcJvAQ7/Ae6YgqW2GcL
        EbtnBlsCHl5XQHdvj4j3fjTn3w==
X-Google-Smtp-Source: ABdhPJz2pFPgByh8wHP5gvDAbO6WFvVcu96QLX6WXAcgHZxo44RtCOOw8GvDsRRsJb/3q0x6ZUOY1w==
X-Received: by 2002:a17:902:dc86:: with SMTP id n6mr35678275pld.82.1593117429438;
        Thu, 25 Jun 2020 13:37:09 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id cm13sm9447469pjb.5.2020.06.25.13.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 13:37:07 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Prasad Sodagudi <psodagud@codeaurora.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH drivers/misc v2 2/4] lkdtm/heap: Avoid edge and middle of slabs
Date:   Thu, 25 Jun 2020 13:37:02 -0700
Message-Id: <20200625203704.317097-3-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200625203704.317097-1-keescook@chromium.org>
References: <20200625203704.317097-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Har har, after I moved the slab freelist pointer into the middle of the
slab, now it looks like the contents are getting poisoned. Adjust the
test to avoid the freelist pointer again.

Fixes: 3202fa62fb43 ("slub: relocate freelist pointer to middle of object")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm/heap.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/lkdtm/heap.c b/drivers/misc/lkdtm/heap.c
index 3c5cec85edce..1323bc16f113 100644
--- a/drivers/misc/lkdtm/heap.c
+++ b/drivers/misc/lkdtm/heap.c
@@ -58,11 +58,12 @@ void lkdtm_READ_AFTER_FREE(void)
 	int *base, *val, saw;
 	size_t len = 1024;
 	/*
-	 * The slub allocator uses the first word to store the free
-	 * pointer in some configurations. Use the middle of the
-	 * allocation to avoid running into the freelist
+	 * The slub allocator will use the either the first word or
+	 * the middle of the allocation to store the free pointer,
+	 * depending on configurations. Store in the second word to
+	 * avoid running into the freelist.
 	 */
-	size_t offset = (len / sizeof(*base)) / 2;
+	size_t offset = sizeof(*base);
 
 	base = kmalloc(len, GFP_KERNEL);
 	if (!base) {
-- 
2.25.1

