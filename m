Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1943BB358
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhGDXRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:17:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhGDXPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:15:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F9B4611ED;
        Sun,  4 Jul 2021 23:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440339;
        bh=KHxbqFoMu3+2Bu4dk7hHwaTzsqsvbd+hIAH1CHJxe9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZlDhvzUPrhHuC9+5f65Mwith8RvYMc5QhSmtaf8fS+5UKpVDIDxGovNi32mKryRuJ
         YKn0yxB5N9QcetJMhEUameSDjgO4h4O2VvhBT8quLIBkhORgMCQ7upP8bqOvrIu9pA
         u90ajjJ1sfac0ih93PuF8oYyKU02+OUrsbly+8yACiCeMesNDtln2xzZC7XKizcYEF
         shhzysqGlt281/wWa84Z0cxSqAfWg4YTkNiNTduPSsku54OVNU3a/l4muTxbEXsRJ8
         GWIjlf64SCNMCrWZ7AL2PmnYtd7Yvg9X7ek17Q0Z49AnyIIvgpkgKNA5v0M4GJ7qaZ
         uSp5k84LOgmIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 18/20] btrfs: make Private2 lifespan more consistent
Date:   Sun,  4 Jul 2021 19:11:53 -0400
Message-Id: <20210704231155.1491795-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231155.1491795-1-sashal@kernel.org>
References: <20210704231155.1491795-1-sashal@kernel.org>
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
index 4b671e5c33ce..ac9d8f2e3f01 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2149,7 +2149,7 @@ static int btrfs_writepage_start_hook(struct page *page, u64 start, u64 end)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
 	/* this page is properly in the ordered list */
-	if (TestClearPagePrivate2(page))
+	if (PagePrivate2(page))
 		return 0;
 
 	if (PageChecked(page))
-- 
2.30.2

