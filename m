Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE0A40533E
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350090AbhIIMus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:50:48 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:43318 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245671AbhIIMse (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 08:48:34 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4CC17222ED;
        Thu,  9 Sep 2021 12:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631191644; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=HEXL1eIlARZ7rhgQ1Exsy7EoATiiUWbEPg2N4xiuepU=;
        b=QY5uvBvgewfEcSLewsAIBmqgfTko+U9pOOrDFk5hMFlmGQt6YWlgHZnRJfAvQ6bM1/06tl
        lk5kdY/7ldzG2JdacI40JApTX0jc716e+LzfoqW4BbZ3eBOPigcJjeh2L8PbK6A832PlqT
        OZMEIAJMeOx3u5XepXXLLsbUUIG00NE=
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 4713BA3F05;
        Thu,  9 Sep 2021 12:47:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3C93DDA7A9; Thu,  9 Sep 2021 14:47:19 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     stable@vger.kernel.org
Cc:     dsterba@suse.com
Subject: [PATCH stable 4.9, 4.4] Revert "btrfs: compression: don't try to compress if we don't have enough pages"
Date:   Thu,  9 Sep 2021 14:47:19 +0200
Message-Id: <20210909124719.28974-1-dsterba@suse.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
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
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b744e7d33d87..26866785e1c7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -484,7 +484,7 @@ static noinline void compress_file_range(struct inode *inode,
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (nr_pages > 1 && inode_need_compress(inode)) {
+	if (inode_need_compress(inode)) {
 		WARN_ON(pages);
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {
-- 
2.33.0

