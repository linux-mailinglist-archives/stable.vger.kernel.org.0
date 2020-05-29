Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59DC1E8876
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 22:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgE2UEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 16:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbgE2UD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 16:03:57 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E8EC08C5CB
        for <stable@vger.kernel.org>; Fri, 29 May 2020 13:03:57 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id p21so422379pgm.13
        for <stable@vger.kernel.org>; Fri, 29 May 2020 13:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zH4NCz4WUaJ18HzpAMLRB8JzZlzE4XmxaFkgad5236Q=;
        b=HjzFMoyGUyktwlVN5FORoAWqwNgHvmexB7iDIOcfLKLW/T9yqbrFjWx1NKmPw+bwy/
         2prka+MqpOVB8+46qAcUJD0B8qL0wd/LrW8r+/GIajBa+p2Dg54XkajVIaC7iDqBuA06
         GG4T6Lz8zrHhgzmDYePSUxL691mFdV0oWo8ZI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zH4NCz4WUaJ18HzpAMLRB8JzZlzE4XmxaFkgad5236Q=;
        b=i3PSDrU6eSg7kYg/BsXJ9gYR8qS/62BXA2xEEQnoB+ojxg07pq1UmhRCIhyEq6d+fe
         tlnGVNCmiGlwqoxwIt9S5XYpUBoKxMAlWei3AyoaFc5roc5IIKZiSg/MMXbpxr/zfRWo
         dYzoWsaugLxenxqD78Bls4Hf3S12pvvmJuhwsXpOdlg0tX8mQuz4r/0H0LCaKfG+Ams+
         kCLrZXDWLH0W96JTjFoQzQbb8ZkOqFub9naMC7lMvO+TazTHzGABHy42X71FqpMqu4yy
         UH2IFbk7cvPlvwzwBLCx5tvE7prw7SWewZOxtPTD8vg4KcwgbEGbrhiHbnDfqWuhcxIz
         dTkA==
X-Gm-Message-State: AOAM530NeC5FI/0K5s9yLPpmIH7+PK7GlPZDerNedPvI6AXQO8gZXhxR
        vHxr+s5GHqxvs8i7ysyjBlvaxw==
X-Google-Smtp-Source: ABdhPJylwnFPmKnKBrVZK7qSGFJ3fxjbUGwRsA0TE8f9s0GojXSpLE3VBHMUm6+6aD6Upxf869jrvw==
X-Received: by 2002:a62:e419:: with SMTP id r25mr10194795pfh.82.1590782637067;
        Fri, 29 May 2020 13:03:57 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o14sm8055147pfp.89.2020.05.29.13.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 13:03:54 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Prasad Sodagudi <psodagud@codeaurora.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] lkdtm/heap: Avoid edge and middle of slabs
Date:   Fri, 29 May 2020 13:03:45 -0700
Message-Id: <20200529200347.2464284-3-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200529200347.2464284-1-keescook@chromium.org>
References: <20200529200347.2464284-1-keescook@chromium.org>
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

