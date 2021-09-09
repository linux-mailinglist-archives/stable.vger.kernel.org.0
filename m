Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79FC840524E
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354279AbhIIMmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:42:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354175AbhIIMg7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:36:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E0E261BA0;
        Thu,  9 Sep 2021 11:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188456;
        bh=1TBie8HWr0fA9alSrUmivfixeYMDJc5oGY/1x1AtOn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBht+PZS6Kh+BTjc9eBGD2Sx6QaMzNdatiFqzmG/dIE+V+yOOcQksT05u4ZCC8IhZ
         QqRRdv/+rjM9YYUcjPZpoBpVwvsLElv4pS4N9VKezdkJDqvUd+TedKNB9orL4MM7f8
         WDXPUqlapBOFT9T9hTTPogIRT4Dt7J9iRt4MGe5YpHmFUVE7UHStQdsvBAWqVLOypB
         SM50xJij5/s1g2MhmQO35niEf60b4EXs03g8hZNOaFue60qBlNSlsLEGzU48lEGrtx
         ufhp4fvxYEpFlwSrgxnR9Pax877ytVyGtU3HtnyUX+pKcD9q4iUi9TSK8A91+lQJGA
         bgomRiK3KVkWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 137/176] btrfs: reset this_bio_flag to avoid inheriting old flags
Date:   Thu,  9 Sep 2021 07:50:39 -0400
Message-Id: <20210909115118.146181-137-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 4c37a7938496756649096a7ec26320eb8b0d90fb ]

In btrfs_do_readpage(), we never reset @this_bio_flag after we hit a
compressed extent.

This is fine, as for PAGE_SIZE == sectorsize case, we can only have one
sector for one page, thus @this_bio_flag will only be set at most once.

But for subpage case, after hitting a compressed extent, @this_bio_flag
will always have EXTENT_BIO_COMPRESSED bit, even we're reading a regular
extent.

This will lead to various read errors, and causing new ASSERT() in
incoming subpage patches, which adds more strict check in
btrfs_submit_compressed_read().

Fix it by declaring @this_bio_flag inside the main loop and reset its
value for each iteration.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 81e98a457130..82873d27d887 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3158,7 +3158,6 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 	size_t iosize;
 	size_t disk_io_size;
 	size_t blocksize = inode->i_sb->s_blocksize;
-	unsigned long this_bio_flag = 0;
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 
 	set_page_extent_mapped(page);
@@ -3184,6 +3183,7 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 		}
 	}
 	while (cur <= end) {
+		unsigned long this_bio_flag = 0;
 		bool force_bio_submit = false;
 		u64 offset;
 
-- 
2.30.2

