Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F1B5A47DF
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiH2LCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiH2LCG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:02:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26D94332F;
        Mon, 29 Aug 2022 04:02:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E33EB80EF3;
        Mon, 29 Aug 2022 11:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574A9C433C1;
        Mon, 29 Aug 2022 11:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770922;
        bh=/iy+f312kTj5A6TMMgKiWZt1SOjvo8oZVyIccP7xceY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vrqobNOlSPILhgqmK08LKC4zZhw6StAr1vEbUGc6mknvosL/YB+s1ILOHBtb96zv1
         aeys4zBHw196j31LZceNInlbPpvIiwc4ku+q/Uh4/OhYKlg+bbwN4piziRsv6Fg13C
         P8fR4ufATKAnCqqxxT9Qcs7Q6I6yovoAzfbKeapc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/136] btrfs: remove unnecessary parameter delalloc_start for writepage_delalloc()
Date:   Mon, 29 Aug 2022 12:58:10 +0200
Message-Id: <20220829105805.536233187@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit cf3075fb36c6a98ea890f4a50b4419ff2fff9a2f ]

In function __extent_writepage() we always pass page start to
@delalloc_start for writepage_delalloc().

Thus we don't really need @delalloc_start parameter as we can extract it
from @page.

Remove @delalloc_start parameter and make __extent_writepage() to
declare @page_start and @page_end as const.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 41862045b3de3..a72a8d4d4a72e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3780,10 +3780,11 @@ static void update_nr_written(struct writeback_control *wbc,
  */
 static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 		struct page *page, struct writeback_control *wbc,
-		u64 delalloc_start, unsigned long *nr_written)
+		unsigned long *nr_written)
 {
-	u64 page_end = delalloc_start + PAGE_SIZE - 1;
+	u64 page_end = page_offset(page) + PAGE_SIZE - 1;
 	bool found;
+	u64 delalloc_start = page_offset(page);
 	u64 delalloc_to_write = 0;
 	u64 delalloc_end = 0;
 	int ret;
@@ -4068,8 +4069,8 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 			      struct extent_page_data *epd)
 {
 	struct inode *inode = page->mapping->host;
-	u64 start = page_offset(page);
-	u64 page_end = start + PAGE_SIZE - 1;
+	const u64 page_start = page_offset(page);
+	const u64 page_end = page_start + PAGE_SIZE - 1;
 	int ret;
 	int nr = 0;
 	size_t pg_offset;
@@ -4104,8 +4105,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	}
 
 	if (!epd->extent_locked) {
-		ret = writepage_delalloc(BTRFS_I(inode), page, wbc, start,
-					 &nr_written);
+		ret = writepage_delalloc(BTRFS_I(inode), page, wbc, &nr_written);
 		if (ret == 1)
 			return 0;
 		if (ret)
@@ -4155,7 +4155,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	 * capable of that.
 	 */
 	if (PageError(page))
-		end_extent_writepage(page, ret, start, page_end);
+		end_extent_writepage(page, ret, page_start, page_end);
 	unlock_page(page);
 	ASSERT(ret <= 0);
 	return ret;
-- 
2.35.1



