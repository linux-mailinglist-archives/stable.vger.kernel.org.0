Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540303A68F3
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 16:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbhFNO2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 10:28:22 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:37522 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbhFNO2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 10:28:18 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 2658E1FD33;
        Mon, 14 Jun 2021 14:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1623680775; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Nxl8aEZNO2CkPcdtI84T+kALrOSV0hfyaDn3yG5WeSY=;
        b=e9YGcOrc9hFTzdD8G+AI+w0dusX4SgiGlSKJXvhoOrovnv/Sulsp8R7hmFP/0FuOEOow0r
        q44Wmh3QJkPhPpRI+V+Ktshf9cAnzfHotkRFeG/AS0Y+mLxsybKM0D0PKmI2fLCPDgI8az
        N0tsC5B7DoVrjewio6or2YMZQ6ZgEY8=
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 1FCEAA3BF4;
        Mon, 14 Jun 2021 14:26:15 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 860D0DB228; Mon, 14 Jun 2021 16:23:28 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: compression: don't try to compress if we don't have enough pages
Date:   Mon, 14 Jun 2021 16:23:27 +0200
Message-Id: <20210614142327.30619-1-dsterba@suse.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The early check if we should attempt compression does not take into
account the number of input pages. It can happen that there's only one
page, eg. a tail page after some ranges of the BTRFS_MAX_UNCOMPRESSED
have been processed, or an isolated page that won't be converted to an
inline extent.

The single page would be compressed but a later check would drop it
again because the result size must be at least one block shorter than
the input. That can never work with just one page.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a2494c645681..e6eb20987351 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -629,7 +629,7 @@ static noinline int compress_file_range(struct async_chunk *async_chunk)
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (inode_need_compress(BTRFS_I(inode), start, end)) {
+	if (nr_pages > 1 && inode_need_compress(BTRFS_I(inode), start, end)) {
 		WARN_ON(pages);
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {
-- 
2.31.1

