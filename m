Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155CE5EA3D7
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234998AbiIZLew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238140AbiIZLeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:34:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A676DFB4;
        Mon, 26 Sep 2022 03:43:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35BBF60C41;
        Mon, 26 Sep 2022 10:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47845C433B5;
        Mon, 26 Sep 2022 10:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189004;
        bh=5rApP3s+hqY64Ey6r7vcgj8Y9gYyzKQTvi/sbRmv/PI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6cnxKXK6LROac4+U5BJl+65j4dDKmHQZF80iJ/aLLFM58j9/DufcVaVOGZWY3ylV
         t6vEVAG6aRtQHZeKk0wJjDXn1xs0FUFHCi9sAXME6JaPK8CWA5wpZyEVmERHL9YPA8
         IIMYx77FJWBImA0j5wK8pxamY1/cWoVX9ETEPD6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.19 043/207] btrfs: zoned: wait for extent buffer IOs before finishing a zone
Date:   Mon, 26 Sep 2022 12:10:32 +0200
Message-Id: <20220926100808.543420988@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 2dd7e7bc02829eded71be2342a93dc035f5223f9 upstream.

Before sending REQ_OP_ZONE_FINISH to a zone, we need to ensure that
ongoing IOs already finished. Or, we will see a "Zone Is Full" error for
the IOs, as the ZONE_FINISH command makes the zone full.

We ensure that with btrfs_wait_block_group_reservations() and
btrfs_wait_ordered_roots() for a data block group. And, for a metadata
block group, the comparison of alloc_offset vs meta_write_pointer mostly
ensures IOs for the allocated region already sent. However, there still
can be a little time frame where the IOs are sent but not yet completed.

Introduce wait_eb_writebacks() to ensure such IOs are completed for a
metadata block group. It walks the buffer_radix to find extent buffers in
the block group and calls wait_on_extent_buffer_writeback() on them.

Fixes: afba2bc036b0 ("btrfs: zoned: implement active zone tracking")
CC: stable@vger.kernel.org # 5.19+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 62e7007a7e46..73c6929f7be6 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1918,10 +1918,44 @@ out_unlock:
 	return ret;
 }
 
+static void wait_eb_writebacks(struct btrfs_block_group *block_group)
+{
+	struct btrfs_fs_info *fs_info = block_group->fs_info;
+	const u64 end = block_group->start + block_group->length;
+	struct radix_tree_iter iter;
+	struct extent_buffer *eb;
+	void __rcu **slot;
+
+	rcu_read_lock();
+	radix_tree_for_each_slot(slot, &fs_info->buffer_radix, &iter,
+				 block_group->start >> fs_info->sectorsize_bits) {
+		eb = radix_tree_deref_slot(slot);
+		if (!eb)
+			continue;
+		if (radix_tree_deref_retry(eb)) {
+			slot = radix_tree_iter_retry(&iter);
+			continue;
+		}
+
+		if (eb->start < block_group->start)
+			continue;
+		if (eb->start >= end)
+			break;
+
+		slot = radix_tree_iter_resume(slot, &iter);
+		rcu_read_unlock();
+		wait_on_extent_buffer_writeback(eb);
+		rcu_read_lock();
+	}
+	rcu_read_unlock();
+}
+
 static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_written)
 {
 	struct btrfs_fs_info *fs_info = block_group->fs_info;
 	struct map_lookup *map;
+	const bool is_metadata = (block_group->flags &
+			(BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM));
 	int ret = 0;
 	int i;
 
@@ -1932,8 +1966,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	}
 
 	/* Check if we have unwritten allocated space */
-	if ((block_group->flags &
-	     (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)) &&
+	if (is_metadata &&
 	    block_group->start + block_group->alloc_offset > block_group->meta_write_pointer) {
 		spin_unlock(&block_group->lock);
 		return -EAGAIN;
@@ -1958,6 +1991,9 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 		/* No need to wait for NOCOW writers. Zoned mode does not allow that */
 		btrfs_wait_ordered_roots(fs_info, U64_MAX, block_group->start,
 					 block_group->length);
+		/* Wait for extent buffers to be written. */
+		if (is_metadata)
+			wait_eb_writebacks(block_group);
 
 		spin_lock(&block_group->lock);
 
-- 
2.37.3



