Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354CE4C17F5
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 16:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiBWQAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 11:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbiBWQAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 11:00:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518FDC2E4B;
        Wed, 23 Feb 2022 07:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=U1NJLx2hNGzn0cF6hu7XUgutHeB7KzSAS3+ZL8eXD0c=; b=sI/6jm4ANMJu2XxEFZa6wo+hHy
        TuR5xBR9lM5xrobaeW8u9ebzG577X2PORDlb5LJkqggX8lWqoBhEgF0o39ZZMq3znekbvNdLJYxdF
        aLDJ0lR5Q+qaq3N29TO+vZvDmZ8Qb0Uv8aW65L5cHjNCiYxbcKgnlr3I36994zBhTe3DdUOTwAwVl
        7oiGWpcAkw1Az8BiFa5vCHVpuMAsBmoV82WmFaCmcgB0EIszgU6y/PBIqC1A0ylGXnsSQDcd3lnAf
        u090fogA7nsPBAqX6xPvctNvg60gd0j1vy0AA9lxezzKMzHhwAiTd6WeDSxNEgi8KiK3dqPzl0gk0
        L2LAg8Yg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMu3D-003tMu-EB; Wed, 23 Feb 2022 15:59:35 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kirill.shutemov@linux.intel.com,
        Song Liu <songliubraving@fb.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Adam Majer <amajer@suse.com>, Dirk Mueller <dmueller@suse.com>,
        Takashi Iwai <tiwai@suse.de>, Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH] mm/filemap: Fix handling of THPs in generic_file_buffered_read()
Date:   Wed, 23 Feb 2022 15:59:18 +0000
Message-Id: <20220223155918.927140-1-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When a THP is present in the page cache, we can return it several times,
leading to userspace seeing the same data repeatedly if doing a read()
that crosses a 64-page boundary.  This is probably not a security issue
(since the data all comes from the same file), but it can be interpreted
as a transient data corruption issue.  Fortunately, it is very rare as
it can only occur when CONFIG_READ_ONLY_THP_FOR_FS is enabled, and it can
only happen to executables.  We don't often call read() on executables.

This bug is fixed differently in v5.17 by commit 6b24ca4a1a8d
("mm: Use multi-index entries in the page cache").  That commit is
unsuitable for backporting, so fix this in the clearest way.  It
sacrifices a little performance for clarity, but this should never
be a performance path in these kernel versions.

Fixes: cbd59c48ae2b ("mm/filemap: use head pages in generic_file_buffered_read")
Cc: stable@vger.kernel.org # v5.15, v5.16
Link: https://lore.kernel.org/r/df3b5d1c-a36b-2c73-3e27-99e74983de3a@suse.cz/
Analyzed-by: Adam Majer <amajer@suse.com>
Analyzed-by: Dirk Mueller <dmueller@suse.com>
Bisected-by: Takashi Iwai <tiwai@suse.de>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/filemap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 82a17c35eb96..1293c3409e42 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2354,8 +2354,12 @@ static void filemap_get_read_batch(struct address_space *mapping,
 			break;
 		if (PageReadahead(head))
 			break;
-		xas.xa_index = head->index + thp_nr_pages(head) - 1;
-		xas.xa_offset = (xas.xa_index >> xas.xa_shift) & XA_CHUNK_MASK;
+		if (PageHead(head)) {
+			xas_set(&xas, head->index + thp_nr_pages(head));
+			/* Handle wrap correctly */
+			if (xas.xa_index - 1 >= max)
+				break;
+		}
 		continue;
 put_page:
 		put_page(head);
-- 
2.34.1

