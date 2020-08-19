Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15BA6249BEA
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgHSLgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:36:13 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:57783 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727116AbgHSLgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:36:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4C6161940219;
        Wed, 19 Aug 2020 07:36:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:36:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=E3EpVt
        J35MSLLZ+Qc3o/CZIpSzX4yeg+ksQTNB/Iaj4=; b=Bq3ZzKV5tuPQi2yMKJDSh1
        3/lJc7dOLIjCjdl0MPpks/d5c+U1S3o2Zr/YVl8wd12s0d0AYh/bRaHHvLYm7yzS
        PVQgedUF0hroAJWNPCA1D7iOnwKivNBUbdYJgdSl5AYl/gbqriXor6Oa73kSWFP8
        2UZDFauUtyAs1PDGN3qqLtDF2GfrppI08WsMu6+HH7fL0VE0ea2Gt4ZKE17d5SZC
        ibI9m2qVdi/1QUdtPzmnfKVYW2cnpkU37DubGJyJT1fMgkbg8LLICeTsHcbasyyD
        hfiVxG6et+PO3OmC0zruERXRA2MwKsLFanPGyfojgmC+oeLNYvaT67xIdwFaSxTw
        ==
X-ME-Sender: <xms:qg49XwvoPcujaGs3LDqyCERugzseMY9_hL-kCP6xOd96A_X9EKxJnw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepiedtffetffduvdfgkeevgfdtieekueduffehffeftd
    egvdejuedvudegudeltdeinecuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:qg49X9fK7-O0WLpNW3mCB9j1-MjXCwJCk6J3bCwz2nR79itMtjW0vg>
    <xmx:qg49X7zf6uSL8ZHoDHZtgmcdmKQYalnsO4aOCiVeyUcuwxXt1eYlLw>
    <xmx:qg49XzOXNwv8Ae0KVEF_CmnKeELBkMQX7rwmnOPYIr1vsGOrL-NiHw>
    <xmx:qg49X1G4taUECOBbbgoHzXzRGsqgrHT2xZvnTd6AQ5JOPOK1iZnV3g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CA10F30600B1;
        Wed, 19 Aug 2020 07:36:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: trim: fix underflow in trim length to prevent access" failed to apply to 5.4-stable tree
To:     wqu@suse.com, dsterba@suse.com, fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:36:33 +0200
Message-ID: <15978369934613@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c57dd1f2f6a7cd1bb61802344f59ccdc5278c983 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Fri, 31 Jul 2020 19:29:11 +0800
Subject: [PATCH] btrfs: trim: fix underflow in trim length to prevent access
 beyond device boundary

[BUG]
The following script can lead to tons of beyond device boundary access:

  mkfs.btrfs -f $dev -b 10G
  mount $dev $mnt
  trimfs $mnt
  btrfs filesystem resize 1:-1G $mnt
  trimfs $mnt

[CAUSE]
Since commit 929be17a9b49 ("btrfs: Switch btrfs_trim_free_extents to
find_first_clear_extent_bit"), we try to avoid trimming ranges that's
already trimmed.

So we check device->alloc_state by finding the first range which doesn't
have CHUNK_TRIMMED and CHUNK_ALLOCATED not set.

But if we shrunk the device, that bits are not cleared, thus we could
easily got a range starts beyond the shrunk device size.

This results the returned @start and @end are all beyond device size,
then we call "end = min(end, device->total_bytes -1);" making @end
smaller than device size.

Then finally we goes "len = end - start + 1", totally underflow the
result, and lead to the beyond-device-boundary access.

[FIX]
This patch will fix the problem in two ways:

- Clear CHUNK_TRIMMED | CHUNK_ALLOCATED bits when shrinking device
  This is the root fix

- Add extra safety check when trimming free device extents
  We check and warn if the returned range is already beyond current
  device.

Link: https://github.com/kdave/btrfs-progs/issues/282
Fixes: 929be17a9b49 ("btrfs: Switch btrfs_trim_free_extents to find_first_clear_extent_bit")
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/extent-io-tree.h b/fs/btrfs/extent-io-tree.h
index f39d47a2d01a..219a09a2b734 100644
--- a/fs/btrfs/extent-io-tree.h
+++ b/fs/btrfs/extent-io-tree.h
@@ -34,6 +34,8 @@ struct io_failure_record;
  */
 #define CHUNK_ALLOCATED				EXTENT_DIRTY
 #define CHUNK_TRIMMED				EXTENT_DEFRAG
+#define CHUNK_STATE_MASK			(CHUNK_ALLOCATED |		\
+						 CHUNK_TRIMMED)
 
 enum {
 	IO_TREE_FS_PINNED_EXTENTS,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 61ede335f6c3..de6fe176fdfb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -33,6 +33,7 @@
 #include "delalloc-space.h"
 #include "block-group.h"
 #include "discard.h"
+#include "rcu-string.h"
 
 #undef SCRAMBLE_DELAYED_REFS
 
@@ -5668,6 +5669,19 @@ static int btrfs_trim_free_extents(struct btrfs_device *device, u64 *trimmed)
 					    &start, &end,
 					    CHUNK_TRIMMED | CHUNK_ALLOCATED);
 
+		/* Check if there are any CHUNK_* bits left */
+		if (start > device->total_bytes) {
+			WARN_ON(IS_ENABLED(CONFIG_BTRFS_DEBUG));
+			btrfs_warn_in_rcu(fs_info,
+"ignoring attempt to trim beyond device size: offset %llu length %llu device %s device size %llu",
+					  start, end - start + 1,
+					  rcu_str_deref(device->name),
+					  device->total_bytes);
+			mutex_unlock(&fs_info->chunk_mutex);
+			ret = 0;
+			break;
+		}
+
 		/* Ensure we skip the reserved area in the first 1M */
 		start = max_t(u64, start, SZ_1M);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d7670e2a9f39..ee96c5869f57 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4720,6 +4720,10 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	}
 
 	mutex_lock(&fs_info->chunk_mutex);
+	/* Clear all state bits beyond the shrunk device size */
+	clear_extent_bits(&device->alloc_state, new_size, (u64)-1,
+			  CHUNK_STATE_MASK);
+
 	btrfs_device_set_disk_total_bytes(device, new_size);
 	if (list_empty(&device->post_commit_list))
 		list_add_tail(&device->post_commit_list,

