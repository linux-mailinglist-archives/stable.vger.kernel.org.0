Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9FC3FDBE9
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344726AbhIAMpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345280AbhIAMmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A24AA610F7;
        Wed,  1 Sep 2021 12:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499884;
        bh=qaVj7Tfy7kwr369CTRjzIxDtcj0W6lQgyKp/Xj7Ow14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oNZz3C6lgFotNOUqXYTfKjvR+MUJawWmIFVB8eErCnbkbngPm4UGB+44GTH/LNtj+
         6Kyfo/loN57qQvLU6tJBiKyl9+sbpz8ZbTAfkUxAqZwpihmYmbEfPhuG+4Z68Wi5U1
         eGbumgUo5kPmp8raWfjzmqTY5ikmifvCL9+ynYJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.13 020/113] Revert "btrfs: compression: dont try to compress if we dont have enough pages"
Date:   Wed,  1 Sep 2021 14:27:35 +0200
Message-Id: <20210901122302.657184917@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
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
@@ -603,7 +603,7 @@ again:
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (nr_pages > 1 && inode_need_compress(BTRFS_I(inode), start, end)) {
+	if (inode_need_compress(BTRFS_I(inode), start, end)) {
 		WARN_ON(pages);
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {


