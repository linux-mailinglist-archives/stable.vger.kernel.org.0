Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96288411A86
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244445AbhITQuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243890AbhITQso (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:48:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8976461211;
        Mon, 20 Sep 2021 16:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156437;
        bh=mQG8IH/HJSkH6P8c5RlulqNS25ErDLDkcMn184/RKjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWCQH+LSqMaptYpjCFotb2m8XvvJgxuJ2l/I/X+OhuPiZdeplYKUnKx90byaMFhOG
         WC4zi6ZkJfacU10pAyzS9PkWg+H3KrwXWliAasW0UiR+Vbw6uf7rAsE1XklAzAFYkK
         pFqkJz2n+36w0e3tyTADd9+87dQuZzs1gXswNuSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 4.4 026/133] Revert "btrfs: compression: dont try to compress if we dont have enough pages"
Date:   Mon, 20 Sep 2021 18:41:44 +0200
Message-Id: <20210920163913.469248773@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
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
@@ -476,7 +476,7 @@ again:
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (nr_pages > 1 && inode_need_compress(inode)) {
+	if (inode_need_compress(inode)) {
 		WARN_ON(pages);
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {


