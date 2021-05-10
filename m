Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394223788F0
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbhEJLZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235751AbhEJLNo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:13:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C6276101B;
        Mon, 10 May 2021 11:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645027;
        bh=so06xh22x+eOvI3lB5XXERypi5HW9pgp260kwFsvtCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5qiTtX+V3Z+S+FWFSlAi94GHMe6DHmf+dYoKE0YH8LNIhphuX5HJQaWCaHzVaa5G
         lWuJx1ptJ8mzmZ8DcICYZ1dXD+drEeMBw5KW9e5LML7U+gMJAzIvqXzBtTLDLcsBr0
         lT1WfpNsbf4D7yUcSM0nBy3vurMbV+hCWJI6dshI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 321/384] mm: page_alloc: ignore init_on_free=1 for debug_pagealloc=1
Date:   Mon, 10 May 2021 12:21:50 +0200
Message-Id: <20210510102025.378166191@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>

commit 9df65f522536719682bccd24245ff94db956256c upstream.

On !ARCH_SUPPORTS_DEBUG_PAGEALLOC (like ia64) debug_pagealloc=1 implies
page_poison=on:

    if (page_poisoning_enabled() ||
         (!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) &&
          debug_pagealloc_enabled()))
            static_branch_enable(&_page_poisoning_enabled);

page_poison=on needs to override init_on_free=1.

Before the change it did not work as expected for the following case:
- have PAGE_POISONING=y
- have page_poison unset
- have !ARCH_SUPPORTS_DEBUG_PAGEALLOC arch (like ia64)
- have init_on_free=1
- have debug_pagealloc=1

That way we get both keys enabled:
- static_branch_enable(&init_on_free);
- static_branch_enable(&_page_poisoning_enabled);

which leads to poisoned pages returned for __GFP_ZERO pages.

After the change we execute only:
- static_branch_enable(&_page_poisoning_enabled);
  and ignore init_on_free=1.

Link: https://lkml.kernel.org/r/20210329222555.3077928-1-slyfox@gentoo.org
Link: https://lkml.org/lkml/2021/3/26/443
Fixes: 8db26a3d4735 ("mm, page_poison: use static key more efficiently")
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -764,32 +764,36 @@ static inline void clear_page_guard(stru
  */
 void init_mem_debugging_and_hardening(void)
 {
+	bool page_poisoning_requested = false;
+
+#ifdef CONFIG_PAGE_POISONING
+	/*
+	 * Page poisoning is debug page alloc for some arches. If
+	 * either of those options are enabled, enable poisoning.
+	 */
+	if (page_poisoning_enabled() ||
+	     (!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) &&
+	      debug_pagealloc_enabled())) {
+		static_branch_enable(&_page_poisoning_enabled);
+		page_poisoning_requested = true;
+	}
+#endif
+
 	if (_init_on_alloc_enabled_early) {
-		if (page_poisoning_enabled())
+		if (page_poisoning_requested)
 			pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
 				"will take precedence over init_on_alloc\n");
 		else
 			static_branch_enable(&init_on_alloc);
 	}
 	if (_init_on_free_enabled_early) {
-		if (page_poisoning_enabled())
+		if (page_poisoning_requested)
 			pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
 				"will take precedence over init_on_free\n");
 		else
 			static_branch_enable(&init_on_free);
 	}
 
-#ifdef CONFIG_PAGE_POISONING
-	/*
-	 * Page poisoning is debug page alloc for some arches. If
-	 * either of those options are enabled, enable poisoning.
-	 */
-	if (page_poisoning_enabled() ||
-	     (!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) &&
-	      debug_pagealloc_enabled()))
-		static_branch_enable(&_page_poisoning_enabled);
-#endif
-
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	if (!debug_pagealloc_enabled())
 		return;


