Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE103FDB10
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343504AbhIAMhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:37:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343566AbhIAMgC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:36:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F033661090;
        Wed,  1 Sep 2021 12:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499604;
        bh=LpVbVT5UPCEoz8bnrnxcToj1FZ2Pxvrd8UXF5JNzSio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q4GxxdDCgSlw/sLGo5zwbS+nq4engvp9oDcrSFMPk4ByDKVAevm8lQTBP8MW/vy94
         khXgu5DUpdakq9F5bAxD2+l7+KLfF1HL4b0HPlHqadOUmGp1+ybN7hBXddaQpCQjy2
         nzGc6JqDLzLrQPgbbW5R/m0iz26XITsiMxF3Ravg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 015/103] Revert "btrfs: compression: dont try to compress if we dont have enough pages"
Date:   Wed,  1 Sep 2021 14:27:25 +0200
Message-Id: <20210901122301.043928981@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 4e9655763b82a91e4c341835bb504a2b1590f984 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -547,7 +547,7 @@ again:
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (nr_pages > 1 && inode_need_compress(BTRFS_I(inode), start, end)) {
+	if (inode_need_compress(BTRFS_I(inode), start, end)) {
 		WARN_ON(pages);
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {


