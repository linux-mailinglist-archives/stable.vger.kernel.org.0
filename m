Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDAF45760D
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237205AbhKSRpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:45:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237215AbhKSRnI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:43:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 946906113A;
        Fri, 19 Nov 2021 17:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343606;
        bh=hCVeozaWi7LaVIcQlvv+XJFTayV6Vu9xbqHZ/DUY8Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YglLw4KGl4rprfK5KX/CuD6U/rLfuGPYODqGF4KMGuYLQHqUcsEqCTfVu9KWTabcR
         w02+qK3OU85SW3ojBZRVnDBm+YOSFeRpHpJs13MxH/WzS8OvNan+ErlwwQGb9vBI+a
         bjYtY6KeExOJVp8ss4P2D5xgFVyk+tCfgiCysllw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 07/20] btrfs: zoned: only allow one process to add pages to a relocation inode
Date:   Fri, 19 Nov 2021 18:39:25 +0100
Message-Id: <20211119171444.893229128@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
References: <20211119171444.640508836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 35156d852762b58855f513b4f8bb7f32d69dc9c5 upstream

Don't allow more than one process to add pages to a relocation inode on
a zoned filesystem, otherwise we cannot guarantee the sequential write
rule once we're filling preallocated extents on a zoned filesystem.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5120,6 +5120,9 @@ int extent_write_locked_range(struct ino
 int extent_writepages(struct address_space *mapping,
 		      struct writeback_control *wbc)
 {
+	struct inode *inode = mapping->host;
+	const bool data_reloc = btrfs_is_data_reloc_root(BTRFS_I(inode)->root);
+	const bool zoned = btrfs_is_zoned(BTRFS_I(inode)->root->fs_info);
 	int ret = 0;
 	struct extent_page_data epd = {
 		.bio_ctrl = { 0 },
@@ -5127,7 +5130,15 @@ int extent_writepages(struct address_spa
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


