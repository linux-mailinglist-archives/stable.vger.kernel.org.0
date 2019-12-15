Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6F111F761
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 12:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfLOLMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 06:12:01 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:54043 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726083AbfLOLMB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 06:12:01 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D933864E;
        Sun, 15 Dec 2019 06:11:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 06:12:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=UN+053
        f6iI9fJVLNs2Ud2FsYdILYaWI9nScPeQQihds=; b=o0pRtMCU8l6P2TpyH2UFoS
        pUvEuZlZIhgzZMwUZ8nX6NkxX4VNDsM3xDQpqecsYw+QGOYeaVJT55JtFtgY8c0U
        JjeSCvcZfWFGEadNK3Zlsf5+UxxbKAJbRbpb6FWElzuWq1B0ekXmytx2hBdXu+4D
        xrbHjqF+fkv1IXLJbOrgflhDKpN8JdAO+s6IxqyjQgTeOsXPuMxcmt7UNTh9HkF6
        SeKMv/K30bYTwmu3NXwL1vdfCwD8U/R/pIpFXTwUu7FzChEkXRyDswNW+aIXXWSp
        /TtMzA1LY+eKlW81UIIPrnCPFrilXE8mRsnd7FPlqm5A3ewProFoO9+67oKGxPBA
        ==
X-ME-Sender: <xms:_xT2XTFgXzlxYKeYdxi3fhGTsz26JBeDzsjJ5divnkPmQCwjQF-cwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:_xT2XUDu-eYCSUwJohdVqTjoWE7Gzjgw8VLWeXqPTc_W9sM8b2_tuQ>
    <xmx:_xT2Xdw-785wNCI3Wb70LCkugJwoBehm6vu4DRo7nJHduchJGacUMA>
    <xmx:_xT2XSezp_mWw6AU1kknUiytcaG3cG9pBATnZJhyNzXZntkAH3EYFg>
    <xmx:_xT2XfufSwOwBgayeCYgyJGmaoCHbEVX_qEQyqPWJnYFIyS5KsBRTg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 63D6A80084;
        Sun, 15 Dec 2019 06:11:57 -0500 (EST)
Subject: FAILED: patch "[PATCH] Btrfs: send, skip backreference walking for extents with many" failed to apply to 4.4-stable tree
To:     fdmanana@suse.com, atemu.main@gmail.com, dsterba@suse.com,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 12:11:55 +0100
Message-ID: <1576408315167108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fd0ddbe2509568b00df364156f47561e9f469f15 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Wed, 30 Oct 2019 12:23:01 +0000
Subject: [PATCH] Btrfs: send, skip backreference walking for extents with many
 references

Backreference walking, which is used by send to figure if it can issue
clone operations instead of write operations, can be very slow and use
too much memory when extents have many references. This change simply
skips backreference walking when an extent has more than 64 references,
in which case we fallback to a write operation instead of a clone
operation. This limit is conservative and in practice I observed no
signicant slowdown with up to 100 references and still low memory usage
up to that limit.

This is a temporary workaround until there are speedups in the backref
walking code, and as such it does not attempt to add extra interfaces or
knobs to tweak the threshold.

Reported-by: Atemu <atemu.main@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAE4GHgkvqVADtS4AzcQJxo0Q1jKQgKaW3JGp3SGdoinVo=C9eQ@mail.gmail.com/T/#me55dc0987f9cc2acaa54372ce0492c65782be3fa
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index cbf4909f5cd9..ae2db5eb1549 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -24,6 +24,14 @@
 #include "transaction.h"
 #include "compression.h"
 
+/*
+ * Maximum number of references an extent can have in order for us to attempt to
+ * issue clone operations instead of write operations. This currently exists to
+ * avoid hitting limitations of the backreference walking code (taking a lot of
+ * time and using too much memory for extents with large number of references).
+ */
+#define SEND_MAX_EXTENT_REFS	64
+
 /*
  * A fs_path is a helper to dynamically build path names with unknown size.
  * It reallocates the internal buffer on demand.
@@ -1310,6 +1318,7 @@ static int find_extent_clone(struct send_ctx *sctx,
 	struct clone_root *cur_clone_root;
 	struct btrfs_key found_key;
 	struct btrfs_path *tmp_path;
+	struct btrfs_extent_item *ei;
 	int compressed;
 	u32 i;
 
@@ -1357,7 +1366,6 @@ static int find_extent_clone(struct send_ctx *sctx,
 	ret = extent_from_logical(fs_info, disk_byte, tmp_path,
 				  &found_key, &flags);
 	up_read(&fs_info->commit_root_sem);
-	btrfs_release_path(tmp_path);
 
 	if (ret < 0)
 		goto out;
@@ -1366,6 +1374,21 @@ static int find_extent_clone(struct send_ctx *sctx,
 		goto out;
 	}
 
+	ei = btrfs_item_ptr(tmp_path->nodes[0], tmp_path->slots[0],
+			    struct btrfs_extent_item);
+	/*
+	 * Backreference walking (iterate_extent_inodes() below) is currently
+	 * too expensive when an extent has a large number of references, both
+	 * in time spent and used memory. So for now just fallback to write
+	 * operations instead of clone operations when an extent has more than
+	 * a certain amount of references.
+	 */
+	if (btrfs_extent_refs(tmp_path->nodes[0], ei) > SEND_MAX_EXTENT_REFS) {
+		ret = -ENOENT;
+		goto out;
+	}
+	btrfs_release_path(tmp_path);
+
 	/*
 	 * Setup the clone roots.
 	 */

