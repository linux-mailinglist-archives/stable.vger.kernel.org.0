Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A860E132FC5
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 20:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgAGTpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 14:45:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:58374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728358AbgAGTpE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 14:45:04 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81F272187F;
        Tue,  7 Jan 2020 19:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578426303;
        bh=FpRv2zG/ZdnzTOt9JpJJ5h13pS26dnpcp4k0Zucb1mE=;
        h=Date:From:To:Subject:From;
        b=GMwk6K8QKi9tfF7OUOgyTS2JZYmSb4GWedhnQR2LMj61DnX6iDIOeuOgSu0a2S4aH
         wzem7VTngA0XHCc0OfMoj8UoBZVnBh+Qegngaik5Z5f9T5ghmr69d7ubSWz4ZAdzLB
         P3sRu2tP2t3LLpo1na8d5MzHE/lQjKvTwsTbR7mI=
Date:   Tue, 07 Jan 2020 11:45:03 -0800
From:   akpm@linux-foundation.org
To:     chanho.min@lge.com, jjinsuk.choi@lge.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com,
        stable@vger.kernel.org
Subject:  [merged]
 mm-zsmallocc-fix-the-migrated-zspage-statistics.patch removed from -mm tree
Message-ID: <20200107194503.cQNpnBBKY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: fix the migrated zspage statistics.
has been removed from the -mm tree.  Its filename was
     mm-zsmallocc-fix-the-migrated-zspage-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chanho Min <chanho.min@lge.com>
Subject: mm/zsmalloc.c: fix the migrated zspage statistics.

When zspage is migrated to the other zone, the zone page state should be
updated as well, otherwise the NR_ZSPAGE for each zone shows wrong counts
including proc/zoneinfo in practice.

Link: http://lkml.kernel.org/r/1575434841-48009-1-git-send-email-chanho.min@lge.com
Fixes: 91537fee0013 ("mm: add NR_ZSMALLOC to vmstat")
Signed-off-by: Chanho Min <chanho.min@lge.com>
Signed-off-by: Jinsuk Choi <jjinsuk.choi@lge.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>        [4.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/zsmalloc.c~mm-zsmallocc-fix-the-migrated-zspage-statistics
+++ a/mm/zsmalloc.c
@@ -2069,6 +2069,11 @@ static int zs_page_migrate(struct addres
 		zs_pool_dec_isolated(pool);
 	}
 
+	if (page_zone(newpage) != page_zone(page)) {
+		dec_zone_page_state(page, NR_ZSPAGES);
+		inc_zone_page_state(newpage, NR_ZSPAGES);
+	}
+
 	reset_page(page);
 	put_page(page);
 	page = newpage;
_

Patches currently in -mm which might be from chanho.min@lge.com are


