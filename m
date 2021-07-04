Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10A53BB2E3
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbhGDXQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:16:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233117AbhGDXOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5038661958;
        Sun,  4 Jul 2021 23:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440166;
        bh=fyS2pBw7otVL0+4RHwdOlbDlg7FT1yNzcGUexd630+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6i/R8JkxRvXkDHHQ8kLF4SEaBbGilbjZtDxKDws2RzLWnaT7fJtvLHbGXI5R36Y6
         xpYUFdZrT9Q8FB7n9BSd99rWt7TiEvv5zsY/a9ap+Q7oc0idH8i36WYeptoZ/4MHxA
         kpKOWmrUZoX5/H5yVpMnTzM4IcTafaTcxxuoD5rvdBjcdB9ZI9d4WMW2Zk0hmMGu7z
         nSqERCunG/TUVfS8bn+3S1YCsBKyhaXnBBvxvRYHeaK0u3r4BxTDpnUhLqXt88JYly
         0OsKz40UP9NkctQ3MrsBW4TimY0AGksKNAVGYu2PbV4qwEkdxbE4+QfaKr3/t0O4YP
         hATPuyjPOvVHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 61/70] btrfs: make Private2 lifespan more consistent
Date:   Sun,  4 Jul 2021 19:07:54 -0400
Message-Id: <20210704230804.1490078-61-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 87b4d86baae219a9a79f6b0a1434b2a42fd40d09 ]

Currently we use page Private2 bit to indicate that we have ordered
extent for the page range.

But the lifespan of it is not consistent, during regular writeback path,
there are two locations to clear the same PagePrivate2:

    T ----- Page marked Dirty
    |
    + ----- Page marked Private2, through btrfs_run_dealloc_range()
    |
    + ----- Page cleared Private2, through btrfs_writepage_cow_fixup()
    |       in __extent_writepage_io()
    |       ^^^ Private2 cleared for the first time
    |
    + ----- Page marked Writeback, through btrfs_set_range_writeback()
    |       in __extent_writepage_io().
    |
    + ----- Page cleared Private2, through
    |       btrfs_writepage_endio_finish_ordered()
    |       ^^^ Private2 cleared for the second time.
    |
    + ----- Page cleared Writeback, through
            btrfs_writepage_endio_finish_ordered()

Currently PagePrivate2 is mostly to prevent ordered extent accounting
being executed for both endio and invalidatepage.
Thus only the one who cleared page Private2 is responsible for ordered
extent accounting.

But the fact is, in btrfs_writepage_endio_finish_ordered(), page
Private2 is cleared and ordered extent accounting is executed
unconditionally.

The race prevention only happens through btrfs_invalidatepage(), where
we wait for the page writeback first, before checking the Private2 bit.

This means, Private2 is also protected by Writeback bit, and there is no
need for btrfs_writepage_cow_fixup() to clear Priavte2.

This patch will change btrfs_writepage_cow_fixup() to just check
PagePrivate2, not to clear it.
The clearing will happen in either btrfs_invalidatepage() or
btrfs_writepage_endio_finish_ordered().

This makes the Private2 bit easier to understand, just meaning the page
has unfinished ordered extent attached to it.

And this patch is a hard requirement for the incoming refactoring for
how we finished ordered IO for endio context, as the coming patch will
check Private2 to determine if we need to do the ordered extent
accounting.  Thus this patch is definitely needed or we will hang due to
unfinished ordered extent.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4f26dae63b64..d0f38d2890a0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2474,7 +2474,7 @@ int btrfs_writepage_cow_fixup(struct page *page, u64 start, u64 end)
 	struct btrfs_writepage_fixup *fixup;
 
 	/* this page is properly in the ordered list */
-	if (TestClearPagePrivate2(page))
+	if (PagePrivate2(page))
 		return 0;
 
 	/*
-- 
2.30.2

