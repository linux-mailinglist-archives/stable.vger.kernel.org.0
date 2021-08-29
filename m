Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9273FA997
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 08:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbhH2GzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 02:55:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhH2GzX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Aug 2021 02:55:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D4C860F36;
        Sun, 29 Aug 2021 06:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630220071;
        bh=0rgzU4Yya4In6V2QOSlu05rPJVWfZM16F1z7SSnCRh0=;
        h=Subject:To:Cc:From:Date:From;
        b=WxPiOxzEYO+1U+R5yWOlpj2nehELyiOm1PyM1YQ0N33L1kgPrWx6njCkE15iYDOvk
         erLlQtLsNVzUUWKAJFA76A6RrjIQACS8FvjJVOzN9Fn/aXJS2on6VnKc0JdnJq98n0
         q6FZNJeio7UUopfw32gfU3Lmu25Rc+w3vrDJ1HPc=
Subject: FAILED: patch "[PATCH] Revert "btrfs: compression: don't try to compress if we don't" failed to apply to 4.14-stable tree
To:     wqu@suse.com, ce3g8jdj@umail.furryterror.org, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Aug 2021 08:54:07 +0200
Message-ID: <16302200473261@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4e9655763b82a91e4c341835bb504a2b1590f984 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Wed, 25 Aug 2021 13:41:42 +0800
Subject: [PATCH] Revert "btrfs: compression: don't try to compress if we don't
 have enough pages"

This reverts commit f2165627319ffd33a6217275e5690b1ab5c45763.

[BUG]
It's no longer possible to create compressed inline extent after commit
f2165627319f ("btrfs: compression: don't try to compress if we don't
have enough pages").

[CAUSE]
For compression code, there are several possible reasons we have a range
that needs to be compressed while it's no more than one page.

- Compressed inline write
  The data is always smaller than one sector and the test lacks the
  condition to properly recognize a non-inline extent.

- Compressed subpage write
  For the incoming subpage compressed write support, we require page
  alignment of the delalloc range.
  And for 64K page size, we can compress just one page into smaller
  sectors.

For those reasons, the requirement for the data to be more than one page
is not correct, and is already causing regression for compressed inline
data writeback.  The idea of skipping one page to avoid wasting CPU time
could be revisited in the future.

[FIX]
Fix it by reverting the offending commit.

Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Link: https://lore.kernel.org/linux-btrfs/afa2742.c084f5d6.17b6b08dffc@tnonline.net
Fixes: f2165627319f ("btrfs: compression: don't try to compress if we don't have enough pages")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 06f9f167222b..bd5689fa290e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -629,7 +629,7 @@ static noinline int compress_file_range(struct async_chunk *async_chunk)
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (nr_pages > 1 && inode_need_compress(BTRFS_I(inode), start, end)) {
+	if (inode_need_compress(BTRFS_I(inode), start, end)) {
 		WARN_ON(pages);
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {

