Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A105B7206
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiIMOts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234553AbiIMOs6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:48:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92B166A6F;
        Tue, 13 Sep 2022 07:25:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9342CB80F96;
        Tue, 13 Sep 2022 14:15:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E69C433D6;
        Tue, 13 Sep 2022 14:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078499;
        bh=c6FvBD8yQkQtsl3Ale++K1LhGRD001HoYBrwAXHU86g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t552qXAxvfP2XLQPvHNL3ijCRMt0tTW9kmOZM5g/xmX3fOQ/TjrjL9Q9Haso3c95z
         qxBQvi6kwwr2qLG1PjinEhlEtRH9DNyAZNQH7GVeCpINJLTdpNfHHzCs4XL4ul6+TK
         4w4bb9XW9/quFJ+jza20+WZjly2/kytbczZW7N5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Yugui <wangyugui@e16-tech.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 138/192] btrfs: fix the max chunk size and stripe length calculation
Date:   Tue, 13 Sep 2022 16:04:04 +0200
Message-Id: <20220913140416.891620574@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 5da431b71d4b9be3c8cf6786eff9e2d41a5f9f65 ]

[BEHAVIOR CHANGE]
Since commit f6fca3917b4d ("btrfs: store chunk size in space-info
struct"), btrfs no longer can create larger data chunks than 1G:

  mkfs.btrfs -f -m raid1 -d raid0 $dev1 $dev2 $dev3 $dev4
  mount $dev1 $mnt

  btrfs balance start --full $mnt
  btrfs balance start --full $mnt
  umount $mnt

  btrfs ins dump-tree -t chunk $dev1 | grep "DATA|RAID0" -C 2

Before that offending commit, what we got is a 4G data chunk:

	item 6 key (FIRST_CHUNK_TREE CHUNK_ITEM 9492758528) itemoff 15491 itemsize 176
		length 4294967296 owner 2 stripe_len 65536 type DATA|RAID0
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 4 sub_stripes 1

Now what we got is only 1G data chunk:

	item 6 key (FIRST_CHUNK_TREE CHUNK_ITEM 6271533056) itemoff 15491 itemsize 176
		length 1073741824 owner 2 stripe_len 65536 type DATA|RAID0
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 4 sub_stripes 1

This will increase the number of data chunks by the number of devices,
not only increase system chunk usage, but also greatly increase mount
time.

Without a proper reason, we should not change the max chunk size.

[CAUSE]
Previously, we set max data chunk size to 10G, while max data stripe
length to 1G.

Commit f6fca3917b4d ("btrfs: store chunk size in space-info struct")
completely ignored the 10G limit, but use 1G max stripe limit instead,
causing above shrink in max data chunk size.

[FIX]
Fix the max data chunk size to 10G, and in decide_stripe_size_regular()
we limit stripe_size to 1G manually.

This should only affect data chunks, as for metadata chunks we always
set the max stripe size the same as max chunk size (256M or 1G
depending on fs size).

Now the same script result the same old result:

	item 6 key (FIRST_CHUNK_TREE CHUNK_ITEM 9492758528) itemoff 15491 itemsize 176
		length 4294967296 owner 2 stripe_len 65536 type DATA|RAID0
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 4 sub_stripes 1

Reported-by: Wang Yugui <wangyugui@e16-tech.com>
Fixes: f6fca3917b4d ("btrfs: store chunk size in space-info struct")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/space-info.c | 2 +-
 fs/btrfs/volumes.c    | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index b0c5b4738b1f7..17623e6410c5d 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -199,7 +199,7 @@ static u64 calc_chunk_size(const struct btrfs_fs_info *fs_info, u64 flags)
 	ASSERT(flags & BTRFS_BLOCK_GROUP_TYPE_MASK);
 
 	if (flags & BTRFS_BLOCK_GROUP_DATA)
-		return SZ_1G;
+		return BTRFS_MAX_DATA_CHUNK_SIZE;
 	else if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
 		return SZ_32M;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3460fd6743807..16e01fbdcec83 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5266,6 +5266,9 @@ static int decide_stripe_size_regular(struct alloc_chunk_ctl *ctl,
 				       ctl->stripe_size);
 	}
 
+	/* Stripe size should not go beyond 1G. */
+	ctl->stripe_size = min_t(u64, ctl->stripe_size, SZ_1G);
+
 	/* Align to BTRFS_STRIPE_LEN */
 	ctl->stripe_size = round_down(ctl->stripe_size, BTRFS_STRIPE_LEN);
 	ctl->chunk_size = ctl->stripe_size * data_stripes;
-- 
2.35.1



