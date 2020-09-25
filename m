Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92405278E38
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgIYQUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728861AbgIYQUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74E7C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:15 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d15so3190629ybk.0
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=tBPoyS6dqdyGc6bNgsXRT7AFAD0R9myTdEMTp1duOnc=;
        b=o+T+A7Ei3kHkyYxC1HxUlmv8myWpAO50ervXKXjhD2oVydHgBRQjWtQZMYjrrzYaJn
         C/vYSLNVehZmVFyGEqWbBkRuAkFBaXdN+p5U4we719e0aSJxv9Y5b6LLkMNlcjztDijQ
         UzUHRqH1L0ICQDtuGCr298y4UsLk36fxSfCOAgAXP+hNusFDbYhBIsR+HHwYA7GNuRri
         ovv2TkZ0g6TJwCnBcAWXZcsCFYmUmDvk+uxHZDrVHAI4GEmFz5bDdDI4AzuVRtrPO7Xh
         TYQsEiJMOMUXYeCJAx2Gm+g3uypnCM0q5BFxE0gSA9+APreDaWJ5KyPUIMow/klkG387
         UCDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tBPoyS6dqdyGc6bNgsXRT7AFAD0R9myTdEMTp1duOnc=;
        b=HdFPWt49Ovgf1LTSLtMg1rjLTc8B2w+/Kro3I24+57C+5BISXdgqF5nQaSgLco7gm6
         lgnhmjpz5G537f/RlQWbyOfeiFqkHJZuE+E1dsctFP79km9EaF++s9M69sRfl10FOsd+
         UbIsCcbcBhVsZXKLebkxao46B5JMXgIiJ+u1+BoPSw86h/r00lnDkZ9ModauZaQYYYJa
         qCHBjeRm3ZtWKOx6WMwijtTnlr3BvQOyaggs0t3bdsPWmeJFNkX9Wp02XUorAoGTWwZX
         94a8GAdVkoOkLlrQptcJQRURVTwU+wAZAvD1ji32VuX9vSGX/WnaKLnXBcVijQlUmSDd
         6Bhw==
X-Gm-Message-State: AOAM533768hwmH0eBJQ04FT0/O7d8zRhi9xrEn8RZg5i/lOyaLLmEO7c
        5ZL2WeXh2F30osCkoofh2Nl0HDevsqDabp6Q7S+Kc67hzUiS9MVEzFG4O3P/sIF9PIXaCF/oRjO
        4AZUw8cM452MKe6z3YdqNrOtOqnWV/muBC1n6I3ZuuSB2ZN3deqPnu/PeT9+qrg==
X-Google-Smtp-Source: ABdhPJyBjcCbLksk+IYd0hbsdkJQsQNayWTLcHc3gpkfsEonIgMuDf1ohdbkV8WHQ0ggdNhqFkEkPQ5eZXQ=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a25:4002:: with SMTP id n2mr6578778yba.513.1601050815044;
 Fri, 25 Sep 2020 09:20:15 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:19:00 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-15-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 14/30 for 5.4] dma-pool: decouple DMA_REMAP from DMA_COHERENT_POOL
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Alex Xu <alex_y_xu@yahoo.ca>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Rientjes <rientjes@google.com>

upstream dbed452a078d56bc7f1abecc3edd6a75e8e4484e commit.

DMA_REMAP is an unnecessary requirement for AMD SEV, which requires
DMA_COHERENT_POOL, so avoid selecting it when it is otherwise unnecessary.

The only other requirement for DMA coherent pools is DMA_DIRECT_REMAP, so
ensure that properly selects the config option when needed.

Fixes: 82fef0ad811f ("x86/mm: unencrypted non-blocking DMA allocations use coherent pools")
Reported-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
Signed-off-by: David Rientjes <rientjes@google.com>
Tested-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/Kconfig | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/dma/Kconfig b/kernel/dma/Kconfig
index d006668c0027..a0ce3c1494fd 100644
--- a/kernel/dma/Kconfig
+++ b/kernel/dma/Kconfig
@@ -73,18 +73,18 @@ config SWIOTLB
 config DMA_NONCOHERENT_MMAP
 	bool
 
+config DMA_COHERENT_POOL
+	bool
+
 config DMA_REMAP
+	bool
 	depends on MMU
 	select GENERIC_ALLOCATOR
 	select DMA_NONCOHERENT_MMAP
-	bool
-
-config DMA_COHERENT_POOL
-	bool
-	select DMA_REMAP
 
 config DMA_DIRECT_REMAP
 	bool
+	select DMA_REMAP
 	select DMA_COHERENT_POOL
 
 config DMA_CMA
-- 
2.28.0.618.gf4bc123cb7-goog

