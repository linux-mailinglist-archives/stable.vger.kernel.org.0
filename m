Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804975138D9
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 17:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349499AbiD1PqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 11:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349525AbiD1PqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 11:46:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44650B822D;
        Thu, 28 Apr 2022 08:43:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4A6B61F94;
        Thu, 28 Apr 2022 15:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE76C385A9;
        Thu, 28 Apr 2022 15:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651160584;
        bh=Fq4knAc0N9RbSq3BiSeCJKGfs+zsd8UULSsA9idnt9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhFQEvAacfymIR2uipsYpNI/NEVaKi8nVS6P/l+bb4PqbYXvAdJUr9PY1JhRBcBFE
         Y/PqMCMGkskzKia+1sInvGmkTYEl2Gu+M6fkEdiyAsqFXZ+6JQb0OM3RSBYvic3msl
         3aSFfsGCmxJG5iLjgOk6ifzmhYFOYbgy7fMFrpjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Eric Dumazet <edumazet@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@kernel.org>, Wei Xu <weixugc@google.com>,
        Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH AUTOSEL 08/14] mm/page_alloc: check high-order pages for corruption during PCP operations
Date:   Thu, 28 Apr 2022 17:42:16 +0200
Message-Id: <20220428154222.1230793-8-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
References: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4241; i=gregkh@linuxfoundation.org; h=from:subject; bh=RipHcCeR+SVHuWApuTUzNGeBcEpnHJuOJblMoYeKjOw=; b=owGbwMvMwCRo6H6F97bub03G02pJDElZW+8q9Hv/Ovfr6sfZApFxL36u2yT0d/P0So5UNZuaY+5m FT0SHbEsDIJMDLJiiixftvEc3V9xSNHL0PY0zBxWJpAhDFycAjCRuVMY5kcdXiNlVL3pw5F/xu/sp1 cl/Qm6pM0wTyXn0wkuVpGzbSfEPRo+HDPMjNRtBAA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>

commit 77fe7f136a7312954b1b8b7eeb4bc91fc3c14a3f upstream.

Eric Dumazet pointed out that commit 44042b449872 ("mm/page_alloc: allow
high-order pages to be stored on the per-cpu lists") only checks the
head page during PCP refill and allocation operations.  This was an
oversight and all pages should be checked.  This will incur a small
performance penalty but it's necessary for correctness.

Link: https://lkml.kernel.org/r/20220310092456.GJ15701@techsingularity.net
Fixes: 44042b449872 ("mm/page_alloc: allow high-order pages to be stored on the per-cpu lists")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Eric Dumazet <edumazet@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b2ef0e75fd29..adceee44adf6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2342,23 +2342,36 @@ static inline int check_new_page(struct page *page)
 	return 1;
 }
 
+static bool check_new_pages(struct page *page, unsigned int order)
+{
+	int i;
+	for (i = 0; i < (1 << order); i++) {
+		struct page *p = page + i;
+
+		if (unlikely(check_new_page(p)))
+			return true;
+	}
+
+	return false;
+}
+
 #ifdef CONFIG_DEBUG_VM
 /*
  * With DEBUG_VM enabled, order-0 pages are checked for expected state when
  * being allocated from pcp lists. With debug_pagealloc also enabled, they are
  * also checked when pcp lists are refilled from the free lists.
  */
-static inline bool check_pcp_refill(struct page *page)
+static inline bool check_pcp_refill(struct page *page, unsigned int order)
 {
 	if (debug_pagealloc_enabled_static())
-		return check_new_page(page);
+		return check_new_pages(page, order);
 	else
 		return false;
 }
 
-static inline bool check_new_pcp(struct page *page)
+static inline bool check_new_pcp(struct page *page, unsigned int order)
 {
-	return check_new_page(page);
+	return check_new_pages(page, order);
 }
 #else
 /*
@@ -2366,32 +2379,19 @@ static inline bool check_new_pcp(struct page *page)
  * when pcp lists are being refilled from the free lists. With debug_pagealloc
  * enabled, they are also checked when being allocated from the pcp lists.
  */
-static inline bool check_pcp_refill(struct page *page)
+static inline bool check_pcp_refill(struct page *page, unsigned int order)
 {
-	return check_new_page(page);
+	return check_new_pages(page, order);
 }
-static inline bool check_new_pcp(struct page *page)
+static inline bool check_new_pcp(struct page *page, unsigned int order)
 {
 	if (debug_pagealloc_enabled_static())
-		return check_new_page(page);
+		return check_new_pages(page, order);
 	else
 		return false;
 }
 #endif /* CONFIG_DEBUG_VM */
 
-static bool check_new_pages(struct page *page, unsigned int order)
-{
-	int i;
-	for (i = 0; i < (1 << order); i++) {
-		struct page *p = page + i;
-
-		if (unlikely(check_new_page(p)))
-			return true;
-	}
-
-	return false;
-}
-
 inline void post_alloc_hook(struct page *page, unsigned int order,
 				gfp_t gfp_flags)
 {
@@ -3037,7 +3037,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 		if (unlikely(page == NULL))
 			break;
 
-		if (unlikely(check_pcp_refill(page)))
+		if (unlikely(check_pcp_refill(page, order)))
 			continue;
 
 		/*
@@ -3641,7 +3641,7 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 		page = list_first_entry(list, struct page, lru);
 		list_del(&page->lru);
 		pcp->count -= 1 << order;
-	} while (check_new_pcp(page));
+	} while (check_new_pcp(page, order));
 
 	return page;
 }
-- 
2.36.0

