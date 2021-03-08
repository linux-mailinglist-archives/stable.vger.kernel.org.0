Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09F9331306
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 17:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhCHQKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 11:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhCHQKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 11:10:31 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DDBC06175F
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 08:10:30 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id i1so8015781qvu.12
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 08:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=oHoXOsuCgC7xf9AhbyLfG6oKwbjtqz3UKDIdpKdyom4=;
        b=f9G5VYb61NRmKnzQ+kJ/qIpehGxvh6Tl91nXblnBclVVfILnCqa4K859ACPoRgJlB8
         BoM3WccpS5s0XNN/J9e7i1yxAqR54D7Q8KhM6bWU3bfToS0R9THLQiJSiN2y/7s0jDhG
         IQx8aMiHoG9fuvf6Jb5LTJ40gTRJ52IIZR37dYZPfL4l2oaPXd+1MIEd3LWw9fihHBKV
         IwJ7AwEc1xgXPB8PeOlXUPLcQT8OBnuAt4C0L/Xl5l2sDfLhXTDapGBbAgZL+eaOOTif
         0v7C7icnv33OwwWvsffPMTXY8frYoUw0gygqncQxcPFTxHvyLA3bQ/l9yoACAqebGhzx
         Omhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=oHoXOsuCgC7xf9AhbyLfG6oKwbjtqz3UKDIdpKdyom4=;
        b=rZPO5cpW1nbtnBp2hv3plSSOqkysqVlBwTJLTC/2/wcNnc0ZiPSS8cPg8HGbRo5Cgk
         Hyzerd9VwBY1YwOWR3qqcrezKS1JdyhLTP3jptHvWOWXKBHmRWhtiKRJcka1m4Lpu4Xa
         26fWLXMudQQkrYtTadh353Hp01KC89yHxBc1dxfOkFT/c8KHiNdFWLGGMts9skNxGbbx
         VNjXb9tx2hKmZfGx1IgeWPQjUM1bgmBahtb8OS0e2xsmwhsZBX53bRWqHDUs2kiHjK7W
         0nPNf0CPG3EVrUuJ7Z8TAFsr/l5II0UWpO239HRn4r0tN+fAaof6eo/rUbhJzHu3DBf4
         PXvA==
X-Gm-Message-State: AOAM5319HhQYKRtp7psvQRqp6ZP47tiogl8hATY2+SyT5ZuTDDPNsnWF
        meqIxrVa7LuJ7p1jVrAkgodxGk3Qec+Y30o8
X-Google-Smtp-Source: ABdhPJzK8pae1qjyFps8+oVppA/0pZjgQL3oiraxl7iLzIThic5NbHNq9hzZeXogGGytNeUHqmd0t1gVKDVN4Mck
Sender: "andreyknvl via sendgmr" <andreyknvl@andreyknvl3.muc.corp.google.com>
X-Received: from andreyknvl3.muc.corp.google.com ([2a00:79e0:15:13:85fb:aac9:69ed:e574])
 (user=andreyknvl job=sendgmr) by 2002:a0c:f890:: with SMTP id
 u16mr21837557qvn.21.1615219829599; Mon, 08 Mar 2021 08:10:29 -0800 (PST)
Date:   Mon,  8 Mar 2021 17:10:23 +0100
Message-Id: <4b55b35202706223d3118230701c6a59749d9b72.1615219501.git.andreyknvl@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH] arm64: kasan: fix page_alloc tagging with DEBUG_VIRTUAL
From:   Andrey Konovalov <andreyknvl@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Branislav Rankov <Branislav.Rankov@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrey Konovalov <andreyknvl@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When CONFIG_DEBUG_VIRTUAL is enabled, the default page_to_virt() macro
implementation from include/linux/mm.h is used. That definition doesn't
account for KASAN tags, which leads to no tags on page_alloc allocations.

Provide an arm64-specific definition for page_to_virt() when
CONFIG_DEBUG_VIRTUAL is enabled that takes care of KASAN tags.

Fixes: 2813b9c02962 ("kasan, mm, arm64: tag non slab memory allocated via pagealloc")
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 arch/arm64/include/asm/memory.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index c759faf7a1ff..0aabc3be9a75 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -328,6 +328,11 @@ static inline void *phys_to_virt(phys_addr_t x)
 #define ARCH_PFN_OFFSET		((unsigned long)PHYS_PFN_OFFSET)
 
 #if !defined(CONFIG_SPARSEMEM_VMEMMAP) || defined(CONFIG_DEBUG_VIRTUAL)
+#define page_to_virt(x)	({						\
+	__typeof__(x) __page = x;					\
+	void *__addr = __va(page_to_phys(__page));			\
+	(void *)__tag_set((const void *)__addr, page_kasan_tag(__page));\
+})
 #define virt_to_page(x)		pfn_to_page(virt_to_pfn(x))
 #else
 #define page_to_virt(x)	({						\
-- 
2.30.1.766.gb4fecdf3b7-goog

