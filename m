Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9A76AD0CE
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 22:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjCFVua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 16:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjCFVua (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 16:50:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067245D8B2
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 13:50:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A784B80FE3
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 21:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDA1C433EF;
        Mon,  6 Mar 2023 21:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678139426;
        bh=GScdbuM+yBTn6KXH2ANnISgnM4NrrL3yxZ0AjIkzqnI=;
        h=From:To:Cc:Subject:Date:From;
        b=Hzcb5cIYJ3QxEjaBUNlmdUdtfTo2T9r2VTIjFg6iKuTOnJHHvHpFzBcLgB02s4Gmm
         WPCsXidJ2IO+wikQM8LTJzARy3UYIW8VZSJfZp7UgodSYd8GoiXafDVLnZZgB6Lyrj
         TJKgrhMuTcG1TFFsRZ2di2DELWn6dSKS/FQ/Ka57sjkEoMLAg8hyeXqXKC73m0ztGK
         zCm12a4WnVbI4kS0KMjYRu/oGX0wVK28128NR7WjYe/E5hh0TgOj44RIygspiRrmx/
         ihSFxaP2YBSNDcC5jbSFZVnX/Mgwal8zW5BZTYaCDfWagjiMWpUjOUzrczhEmn1APh
         EM22SDYZ2HxGg==
From:   SeongJae Park <sj@kernel.org>
Cc:     "andrew.yang" <andrew.yang@mediatek.com>,
        SeongJae Park <sj@kernel.org>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.{1,2}] mm/damon/paddr: fix missing folio_put()
Date:   Mon,  6 Mar 2023 21:50:12 +0000
Message-Id: <20230306215012.431826-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "andrew.yang" <andrew.yang@mediatek.com>

commit 3f98c9a62c338bbe06a215c9491e6166ea39bf82 upstream.

damon_get_folio() would always increase folio _refcount and
folio_isolate_lru() would increase folio _refcount if the folio's lru flag
is set.

If an unevictable folio isolated successfully, there will be two more
_refcount.  The one from folio_isolate_lru() will be decreased in
folio_puback_lru(), but the other one from damon_get_folio() will be left
behind.  This causes a pin page.

Whatever the case, the _refcount from damon_get_folio() should be
decreased.

Link: https://lkml.kernel.org/r/20230222064223.6735-1-andrew.yang@mediatek.com
Fixes: 57223ac29584 ("mm/damon/paddr: support the pageout scheme")
Signed-off-by: andrew.yang <andrew.yang@mediatek.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.16.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---

This is a backport of the mainline patch for v6.1.y and v6.2.y.

 mm/damon/paddr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index e1a4315c4be6..402d30b37aba 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -219,12 +219,11 @@ static unsigned long damon_pa_pageout(struct damon_region *r)
 			put_page(page);
 			continue;
 		}
-		if (PageUnevictable(page)) {
+		if (PageUnevictable(page))
 			putback_lru_page(page);
-		} else {
+		else
 			list_add(&page->lru, &page_list);
-			put_page(page);
-		}
+		put_page(page);
 	}
 	applied = reclaim_pages(&page_list);
 	cond_resched();
-- 
2.25.1

