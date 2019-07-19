Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A246E6DDB5
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732652AbfGSEJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:09:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387551AbfGSEJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:09:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54D322189E;
        Fri, 19 Jul 2019 04:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509364;
        bh=bmTFn2nUfqtn9lYCa79Sidrp3U1/aWjv5+bzonW2H6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PV36iSu7F4NEZm28i4ue5LMDmNxsAJaLE8/A5y7NOh5uu563MqFWN3Szz4l8+oA5b
         ZeQJ6eGoHu08XoRG8TEPudiZhPzhwWMN4Stwjk4/0PVqOJJag4xtd7wgjS9vyKLKuY
         kUJVPKlNa/P2KjepsK8a73KLBHlLzxXmWPhvw8cY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Dan Williams <dan.j.williams@intel.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.19 055/101] mm/swap: fix release_pages() when releasing devmap pages
Date:   Fri, 19 Jul 2019 00:06:46 -0400
Message-Id: <20190719040732.17285-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040732.17285-1-sashal@kernel.org>
References: <20190719040732.17285-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

[ Upstream commit c5d6c45e90c49150670346967971e14576afd7f1 ]

release_pages() is an optimized version of a loop around put_page().
Unfortunately for devmap pages the logic is not entirely correct in
release_pages().  This is because device pages can be more than type
MEMORY_DEVICE_PUBLIC.  There are in fact 4 types, private, public, FS DAX,
and PCI P2PDMA.  Some of these have specific needs to "put" the page while
others do not.

This logic to handle any special needs is contained in
put_devmap_managed_page().  Therefore all devmap pages should be processed
by this function where we can contain the correct logic for a page put.

Handle all device type pages within release_pages() by calling
put_devmap_managed_page() on all devmap pages.  If
put_devmap_managed_page() returns true the page has been put and we
continue with the next page.  A false return of put_devmap_managed_page()
means the page did not require special processing and should fall to
"normal" processing.

This was found via code inspection while determining if release_pages()
and the new put_user_pages() could be interchangeable.[1]

[1] https://lkml.kernel.org/r/20190523172852.GA27175@iweiny-DESK2.sc.intel.com

Link: https://lkml.kernel.org/r/20190605214922.17684-1-ira.weiny@intel.com
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/swap.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index a3fc028e338e..45fdbfb6b2a6 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -740,15 +740,20 @@ void release_pages(struct page **pages, int nr)
 		if (is_huge_zero_page(page))
 			continue;
 
-		/* Device public page can not be huge page */
-		if (is_device_public_page(page)) {
+		if (is_zone_device_page(page)) {
 			if (locked_pgdat) {
 				spin_unlock_irqrestore(&locked_pgdat->lru_lock,
 						       flags);
 				locked_pgdat = NULL;
 			}
-			put_devmap_managed_page(page);
-			continue;
+			/*
+			 * ZONE_DEVICE pages that return 'false' from
+			 * put_devmap_managed_page() do not require special
+			 * processing, and instead, expect a call to
+			 * put_page_testzero().
+			 */
+			if (put_devmap_managed_page(page))
+				continue;
 		}
 
 		page = compound_head(page);
-- 
2.20.1

