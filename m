Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0187E33B7DB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbhCOOBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232468AbhCON7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DF5D64F2F;
        Mon, 15 Mar 2021 13:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816769;
        bh=DWkUTZJPYEwdrYvkqTCumpJfYkrmCHUOc9flC5P+QQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bm+PdGW23dQGkv6ZWYiEOuJukYM3b/vXVxJUVu7bsxSeriYWm90NAOLhQvrDpeTTV
         50qtjk41wUTx3Y/rNJ7bwzErCNboR0cLonAvOu2jMGfB0NGj4vycjc7q4W2LUE656k
         pY//qRZpVZxja407+xE/gXwLB4tatqhNDOVu4wKI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.4 097/168] arm64: kasan: fix page_alloc tagging with DEBUG_VIRTUAL
Date:   Mon, 15 Mar 2021 14:55:29 +0100
Message-Id: <20210315135553.559811335@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Andrey Konovalov <andreyknvl@google.com>

commit 86c83365ab76e4b43cedd3ce07a07d32a4dc79ba upstream.

When CONFIG_DEBUG_VIRTUAL is enabled, the default page_to_virt() macro
implementation from include/linux/mm.h is used. That definition doesn't
account for KASAN tags, which leads to no tags on page_alloc allocations.

Provide an arm64-specific definition for page_to_virt() when
CONFIG_DEBUG_VIRTUAL is enabled that takes care of KASAN tags.

Fixes: 2813b9c02962 ("kasan, mm, arm64: tag non slab memory allocated via pagealloc")
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/4b55b35202706223d3118230701c6a59749d9b72.1615219501.git.andreyknvl@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/memory.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -315,6 +315,11 @@ static inline void *phys_to_virt(phys_ad
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


