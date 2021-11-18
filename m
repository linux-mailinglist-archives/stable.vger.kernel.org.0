Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E545455782
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244926AbhKRJBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 04:01:37 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:44972 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244876AbhKRJBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 04:01:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637225911; x=1668761911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WHh1r8k5Jz7DDZe8TDskDHhXcZyN863quRTci8bgnPY=;
  b=V7JeI4pxdW3/wAqjFSeW5GxwrTA+vXAabRUjBRG7euK+kNFZSSL1wkAD
   j3QABwaDAluMJLSjqbrkEFlTzdZdA05/O+hD+lcv/0puvNEmkL7Mj7suX
   5N2gqbYb991NLGnQMvueinRns+OoO8iVxPlUHpMQKuXuUmgPTW/afXL0n
   PhxOottQN2J7IiP7McDAnun+lpoJqMFKohJq5iFMVdt/EL5FvcrC/EYso
   5xcJrnIzC2PvTjbNBshEOuAXNWIHsLQV6mIQ4msxYtFKgn0uB94D7bYGx
   DVQkNLjcEGcB+cFGonxNFDU7Sx+zN9bm/IoJiT+iOR2q8ctxTaJ22fjeE
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,244,1631548800"; 
   d="scan'208";a="185939017"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2021 16:58:29 +0800
IronPort-SDR: MccmnFJvMRUkMhrrQsQqUJP0ojxeQnfkSa65lhFBTuRJt2E5Ti0sPdU8wSSvdKsk2m4SuFgwxC
 QHXknO+GEHKbaY4Xol8zandLJ4HY53SpWYlrt4bqLiywrWVlsxC0csxGPmR7/T7oiZYrAfJ6xf
 qA9ykXsXtsNNy+qBMMWqmAGYkLO7wuaTD/pEHzSfOOiMlSryUH6p0FYXpm5801pDYHhNwOzowq
 7aDl+y7xPJy3oKRao0Lef4joj6eio4FdTPIvhKqL/veX3l+/HRgkDrJzi2HDTG+zcu+pt4eq9+
 pjtHZ1SKIOYCZs7qISYhqve6
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 00:33:30 -0800
IronPort-SDR: hAfTts7uAoFAjp0Nk/5qiO/I/0O41ZAol3r4IarHc1XwMFeuC3nezYPI7CRXqo8dL637/Ax2++
 QjmjX/xcbXHz8z/mNSbnX2TuPBFw+LvKryLGUYRWUKRFltMuMdBqEpWFuCPJ/p/F6g4LUKDHNA
 xx1EZSMA1IE/y3lwPy8V3R0HDjQp00r7J9pSjwysaS8jjyltobwYoK3sEh3JQDudUV/1wPcwZE
 FdmrzA5QeXZIGR7mDaW7BKBXOZK4F0WGHgSzc0kORA69QkRoN4rWpftEajNOauMcadDzNZmdVG
 hxs=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip01.wdc.com with ESMTP; 18 Nov 2021 00:58:28 -0800
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH for-5.15.x 3/6] btrfs: zoned: only allow one process to add pages to a relocation inode
Date:   Thu, 18 Nov 2021 17:58:15 +0900
Message-Id: <c2c15d9992727dc6473d3dedb3d863874a3d3222.1637225333.git.johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1637225333.git.johannes.thumshirn@wdc.com>
References: <cover.1637225333.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 35156d852762b58855f513b4f8bb7f32d69dc9c5 upstream

Don't allow more than one process to add pages to a relocation inode on
a zoned filesystem, otherwise we cannot guarantee the sequential write
rule once we're filling preallocated extents on a zoned filesystem.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/extent_io.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index aaddd7225348..a40fb9c74dda 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5120,6 +5120,9 @@ int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
 int extent_writepages(struct address_space *mapping,
 		      struct writeback_control *wbc)
 {
+	struct inode *inode = mapping->host;
+	const bool data_reloc = btrfs_is_data_reloc_root(BTRFS_I(inode)->root);
+	const bool zoned = btrfs_is_zoned(BTRFS_I(inode)->root->fs_info);
 	int ret = 0;
 	struct extent_page_data epd = {
 		.bio_ctrl = { 0 },
@@ -5127,7 +5130,15 @@ int extent_writepages(struct address_space *mapping,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
 	};
 
+	/*
+	 * Allow only a single thread to do the reloc work in zoned mode to
+	 * protect the write pointer updates.
+	 */
+	if (data_reloc && zoned)
+		btrfs_inode_lock(inode, 0);
 	ret = extent_write_cache_pages(mapping, wbc, &epd);
+	if (data_reloc && zoned)
+		btrfs_inode_unlock(inode, 0);
 	ASSERT(ret <= 0);
 	if (ret < 0) {
 		end_write_bio(&epd, ret);
-- 
2.32.0

