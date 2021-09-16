Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB1840E4F5
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349288AbhIPRGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349362AbhIPREC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:04:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34BCB6187F;
        Thu, 16 Sep 2021 16:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810098;
        bh=CDpKTP9txOGtsEB9oyRmv2jvG7xbiGZyTmeeWnkZ1Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XUNImSZw0cErrd3OQdPVtG5t61SVk5LV/nOxmRCIyXPr+N3VSIVRtDZtu16YUXhgt
         wgDAxldZYJOE4BgLwwvamfYXDcwoJ1wxmRsPN/+dsV4GBHVZ99b9kfunUNwMNMM/tl
         CTYVGscZJeCL1KiAhgB02rTnciNuK3ZFsJMO2X/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.14 017/432] btrfs: zoned: fix double counting of split ordered extent
Date:   Thu, 16 Sep 2021 17:56:06 +0200
Message-Id: <20210916155811.399652864@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit f79645df806565a03abb2847a1d20e6930b25e7e upstream.

btrfs_add_ordered_extent_*() add num_bytes to fs_info->ordered_bytes.
Then, splitting an ordered extent will call btrfs_add_ordered_extent_*()
again for split extents, leading to double counting of the region of
a split extent. These leaked bytes are finally reported at unmount time
as follow:

  BTRFS info (device dm-1): at unmount dio bytes count 364544

Fix the double counting by subtracting split extent's size from
fs_info->ordered_bytes.

Fixes: d22002fd37bd ("btrfs: zoned: split ordered extent when bio is sent")
CC: stable@vger.kernel.org # 5.12+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ordered-data.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -1052,6 +1052,7 @@ static int clone_ordered_extent(struct b
 				u64 len)
 {
 	struct inode *inode = ordered->inode;
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	u64 file_offset = ordered->file_offset + pos;
 	u64 disk_bytenr = ordered->disk_bytenr + pos;
 	u64 num_bytes = len;
@@ -1069,6 +1070,13 @@ static int clone_ordered_extent(struct b
 	else
 		type = __ffs(flags_masked);
 
+	/*
+	 * The splitting extent is already counted and will be added again
+	 * in btrfs_add_ordered_extent_*(). Subtract num_bytes to avoid
+	 * double counting.
+	 */
+	percpu_counter_add_batch(&fs_info->ordered_bytes, -num_bytes,
+				 fs_info->delalloc_batch);
 	if (test_bit(BTRFS_ORDERED_COMPRESSED, &ordered->flags)) {
 		WARN_ON_ONCE(1);
 		ret = btrfs_add_ordered_extent_compress(BTRFS_I(inode),


