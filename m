Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C06D278E31
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbgIYQUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729575AbgIYQUK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:10 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2AB1C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:10 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id 205so2332344qkd.2
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=akC9fS9hfa1g5J4aF13FcmNLCU553fW6aB4jLeCPAgo=;
        b=JnoZJeTK9FdxutyNiGss8AJS2y073pDqaM65POu5LWEhZ7wYjMpc7yRHWdTnwGvNTN
         xifVm3Yeo3kJvXEOJqgs0dy6xEsG0MQS8i9DjNkwDe9kzTaE7xaLiejlNudEoHZUyaWy
         mt75Jc65i4OP1dozCX5ZVWU1JN/3SLFRNUFKHLFrw5228cU7B40yHmKDGHAc6ugy9NLy
         gnXO/sOP3Maeio0wFwFVqUiwQ7gMq4P35fkIBCwBwiNCnzaGcde0pG1b55MX/SaHyuun
         xgRDdhHGpYNAYk6D9NZo3ku0cmouIsxW1MT9OkLRqllhbuPOt7MD49vfesPt60AITEL7
         D3oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=akC9fS9hfa1g5J4aF13FcmNLCU553fW6aB4jLeCPAgo=;
        b=hCkN2cj1fxMwlcRWyUoNYfv1qOcwZNyAQX5zZYcKEBU/GkCxXX9GnzAT4PVMe3ahLE
         Y4GZN14w/3SqsA+6kRbLZG6ssP3EWr6nJ7e8pQsL1vBKXgD4wH5aSMusCO1Pxt9OpOV5
         FCirbZ7WbYIRM80w2iGcXugURQT/7w75bKrEh1V6U3yBntDy4x+yRmH91cf9LGMI7wkj
         zKqK3gvDG/tcvMdoXwqy36KW/zqiwDFas5jqx1DIWaPCFLI9/c3bRfTzRn9yn417v8Ml
         HZmaBNOEevv1Usg+UfSmu+x16oeGm21Ill7KNFDO9Jz5mADLlm32QEkJ5jvs+5SgECqu
         YARg==
X-Gm-Message-State: AOAM532c6cX4DcWmF8s13krYn5K5rGb0CX6f+MaUZ3w5M/DRwocApe5E
        XICPaqlj4lLKtBfZYViIq5XF6uDwlbo5Et7s5x6p/OfRrPPMoSDTgrA5KyZ5amYPU39Ye4KtoaG
        rKhLd7rEF++VyOgWF/yWHnfpFszgghGawrZj0XoZIXhbFyxuAsRjYebJ3KcgMzQ==
X-Google-Smtp-Source: ABdhPJxOiQtqUDdD7+sbKkjme5nhzOeiXuYPU+Q9U0mgJYvBVekChAnWS2uEZM1W7PQU4ia9H1u3ErX+da0=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a0c:c446:: with SMTP id t6mr143634qvi.55.1601050809857;
 Fri, 25 Sep 2020 09:20:09 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:18:57 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-12-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 11/30 for 5.4] x86/mm: unencrypted non-blocking DMA
 allocations use coherent pools
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Rientjes <rientjes@google.com>

upstream 82fef0ad811fb5976cf36ccc3d2c3bc0195dfb72 commit.

When CONFIG_AMD_MEM_ENCRYPT is enabled and a device requires unencrypted
DMA, all non-blocking allocations must originate from the atomic DMA
coherent pools.

Select CONFIG_DMA_COHERENT_POOL for CONFIG_AMD_MEM_ENCRYPT.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ef85139553f..be8746e9d864 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1530,6 +1530,7 @@ config X86_CPA_STATISTICS
 config AMD_MEM_ENCRYPT
 	bool "AMD Secure Memory Encryption (SME) support"
 	depends on X86_64 && CPU_SUP_AMD
+	select DMA_COHERENT_POOL
 	select DYNAMIC_PHYSICAL_MASK
 	select ARCH_USE_MEMREMAP_PROT
 	select ARCH_HAS_FORCE_DMA_UNENCRYPTED
-- 
2.28.0.618.gf4bc123cb7-goog

