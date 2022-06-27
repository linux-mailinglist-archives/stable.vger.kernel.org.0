Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73CD455C4D9
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238211AbiF0Lub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238579AbiF0Lsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCBFD48;
        Mon, 27 Jun 2022 04:42:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CBE7611AE;
        Mon, 27 Jun 2022 11:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248BAC3411D;
        Mon, 27 Jun 2022 11:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330150;
        bh=47pZZTtzNUS+oJyyrvsilCS55bonXuaxLoQSfMbjg9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AafEcPSDyIylJbRDnswf7mrsaErMr6OZi4SqqaC2KXoIw7R6mdiCo7FGHVNXfRkDa
         bMCBvyoyfh36jzQxew3Mc+ZEPa6B361mDKNIt2fhoswu8D6bir+C8egsS5s7DmFqhK
         ZKExiqGSRSrJJ3JRxfR4NDGUHmsc8tptrE13qJAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alistair Popple <apopple@nvidia.com>,
        Jan Kara <jack@suse.cz>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 102/181] filemap: Fix serialization adding transparent huge pages to page cache
Date:   Mon, 27 Jun 2022 13:21:15 +0200
Message-Id: <20220627111947.655795167@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alistair Popple <apopple@nvidia.com>

[ Upstream commit 00fa15e0d56482e32d8ca1f51d76b0ee00afb16b ]

Commit 793917d997df ("mm/readahead: Add large folio readahead")
introduced support for using large folios for filebacked pages if the
filesystem supports it.

page_cache_ra_order() was introduced to allocate and add these large
folios to the page cache. However adding pages to the page cache should
be serialized against truncation and hole punching by taking
invalidate_lock. Not doing so can lead to data races resulting in stale
data getting added to the page cache and marked up-to-date. See commit
730633f0b7f9 ("mm: Protect operations adding pages to page cache with
invalidate_lock") for more details.

This issue was found by inspection but a testcase revealed it was
possible to observe in practice on XFS. Fix this by taking
invalidate_lock in page_cache_ra_order(), to mirror what is done for the
non-thp case in page_cache_ra_unbounded().

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/readahead.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/readahead.c b/mm/readahead.c
index 4a60cdb64262..38635af5bab7 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -508,6 +508,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 			new_order--;
 	}
 
+	filemap_invalidate_lock_shared(mapping);
 	while (index <= limit) {
 		unsigned int order = new_order;
 
@@ -534,6 +535,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 	}
 
 	read_pages(ractl);
+	filemap_invalidate_unlock_shared(mapping);
 
 	/*
 	 * If there were already pages in the page cache, then we may have
-- 
2.35.1



