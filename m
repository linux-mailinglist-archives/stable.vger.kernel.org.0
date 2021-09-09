Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91EBF404CE1
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344065AbhIIL6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243567AbhIIL4b (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:56:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BD61613BD;
        Thu,  9 Sep 2021 11:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187915;
        bh=oFbCu/3eod+iO96miKqTRD02KMMKf++LKX7oyMo4u3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MXLDFRtoU7f3+Ab0uMcWf83zOY4fidKpNcdz4gSKYAVGFl6eIaGIUuKmf36c8l7Aj
         /vshe7kWkOc0DcOEBJCFCE9/Ixx0HAX0UjsRE9hpSuLhkAdmNjVBcOFwnXU1iV+598
         PA5IGuw56cPb10cszMwdF/PKTA7LzkwLDvOmPWluQEBM4rYk1hFMH+Yxt7zGQvB4ZM
         U97++g5FDu+uOR48IsAosD3H2iDQ3TqBUKMFxOaC2vscpE63UPXGE+2GZQpO2pD0p+
         nZ+LTvRrdKnzgrJB0Pg8CC3XT9BjdtAnfZHwAUOHZ3ZqvSdM8VBI3Z3WhFE9i3MKJE
         x6F0OS0lhmBjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 191/252] btrfs: reset this_bio_flag to avoid inheriting old flags
Date:   Thu,  9 Sep 2021 07:40:05 -0400
Message-Id: <20210909114106.141462-191-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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
index 9e81d25dea70..907cb88fb30b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3488,7 +3488,6 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 	size_t pg_offset = 0;
 	size_t iosize;
 	size_t blocksize = inode->i_sb->s_blocksize;
-	unsigned long this_bio_flag = 0;
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 
 	ret = set_page_extent_mapped(page);
@@ -3519,6 +3518,7 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 	}
 	begin_page_read(fs_info, page);
 	while (cur <= end) {
+		unsigned long this_bio_flag = 0;
 		bool force_bio_submit = false;
 		u64 disk_bytenr;
 
-- 
2.30.2

