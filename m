Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C012471AA2
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 15:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbhLLOVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 09:21:21 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39788 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhLLOVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 09:21:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B7BBACE0B6A
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 14:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D537C341C5;
        Sun, 12 Dec 2021 14:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639318877;
        bh=phYWOtZ3DZgxz2jvhd4J5yFlsf5dTVru8nttJ5xMa3c=;
        h=Subject:To:Cc:From:Date:From;
        b=1S6gnf679JXakzx+AReEUW0oNW/sCTdz0grDQo8c+CbO4ajRurUkaBNRyWI/kMrD+
         ozlnWXKJadkUC7hCwKSwHJ/yz7WX6PU44H6fmSs7FcEQsEzXMTTUed2b3XkmgaWM17
         ZuMo/emi+2Msa5CPFC4F3dUEOLUpKqS5La5yieyA=
Subject: FAILED: patch "[PATCH] btrfs: zoned: clear data relocation bg on zone finish" failed to apply to 5.15-stable tree
To:     johannes.thumshirn@wdc.com, dsterba@suse.com, naohiro.aota@wdc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 12 Dec 2021 15:21:15 +0100
Message-ID: <16393188751463@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5911f5382022aff2b817cb88f276756af229664d Mon Sep 17 00:00:00 2001
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Date: Thu, 2 Dec 2021 00:47:14 -0800
Subject: [PATCH] btrfs: zoned: clear data relocation bg on zone finish

When finishing a zone that is used by a dedicated data relocation
block group, also remove its reference from fs_info, so we're not trying
to use a full block group for allocations during data relocation, which
will always fail.

The result is we're not making any forward progress and end up in a
deadlock situation.

Fixes: c2707a255623 ("btrfs: zoned: add a dedicated data relocation block group")
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 67d932d70798..678a29469511 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1860,6 +1860,7 @@ int btrfs_zone_finish(struct btrfs_block_group *block_group)
 	block_group->alloc_offset = block_group->zone_capacity;
 	block_group->free_space_ctl->free_space = 0;
 	btrfs_clear_treelog_bg(block_group);
+	btrfs_clear_data_reloc_bg(block_group);
 	spin_unlock(&block_group->lock);
 
 	ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
@@ -1942,6 +1943,7 @@ void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical, u64 len
 	ASSERT(block_group->alloc_offset == block_group->zone_capacity);
 	ASSERT(block_group->free_space_ctl->free_space == 0);
 	btrfs_clear_treelog_bg(block_group);
+	btrfs_clear_data_reloc_bg(block_group);
 	spin_unlock(&block_group->lock);
 
 	map = block_group->physical_map;

