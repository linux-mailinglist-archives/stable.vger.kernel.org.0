Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424222A56DC
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732294AbgKCVbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:31:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:59986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732219AbgKCU5g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:57:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E77D22053B;
        Tue,  3 Nov 2020 20:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437055;
        bh=6k1PCzL6AZQeW2dSgd0OaDlVHBN/yvSzAsbn/HrF0tA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMVV/1R8jjofidXc44KfP/vxOSPHaiyJQ33T6IjCkkItBKHLlyvazBkW3w6o757JN
         qYfZjsDb1A+OFJ+WxLRQ7y5NkuO+Miz8qXjHFIbDbMZO3cSoAcWIENfbKc/7pDQ0aJ
         aFmVUqKbJRQF3mEnEZfTbzGrC+DGTfFPnYVsXSi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Steigerwald <martin@lichtvoll.de>,
        Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 128/214] btrfs: tree-checker: fix false alert caused by legacy btrfs root item
Date:   Tue,  3 Nov 2020 21:36:16 +0100
Message-Id: <20201103203302.843409963@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 1465af12e254a68706e110846f59cf0f09683184 upstream.

Commit 259ee7754b67 ("btrfs: tree-checker: Add ROOT_ITEM check")
introduced btrfs root item size check, however btrfs root item has two
versions, the legacy one which just ends before generation_v2 member, is
smaller than current btrfs root item size.

This caused btrfs kernel to reject valid but old tree root leaves.

Fix this problem by also allowing legacy root item, since kernel can
already handle them pretty well and upgrade to newer root item format
when needed.

Reported-by: Martin Steigerwald <martin@lichtvoll.de>
Fixes: 259ee7754b67 ("btrfs: tree-checker: Add ROOT_ITEM check")
CC: stable@vger.kernel.org # 5.4+
Tested-By: Martin Steigerwald <martin@lichtvoll.de>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-checker.c         |   17 ++++++++++++-----
 include/uapi/linux/btrfs_tree.h |   14 ++++++++++++++
 2 files changed, 26 insertions(+), 5 deletions(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -869,7 +869,7 @@ static int check_root_item(struct extent
 			   int slot)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
-	struct btrfs_root_item ri;
+	struct btrfs_root_item ri = { 0 };
 	const u64 valid_root_flags = BTRFS_ROOT_SUBVOL_RDONLY |
 				     BTRFS_ROOT_SUBVOL_DEAD;
 
@@ -889,14 +889,21 @@ static int check_root_item(struct extent
 		return -EUCLEAN;
 	}
 
-	if (btrfs_item_size_nr(leaf, slot) != sizeof(ri)) {
+	if (btrfs_item_size_nr(leaf, slot) != sizeof(ri) &&
+	    btrfs_item_size_nr(leaf, slot) != btrfs_legacy_root_item_size()) {
 		generic_err(leaf, slot,
-			    "invalid root item size, have %u expect %zu",
-			    btrfs_item_size_nr(leaf, slot), sizeof(ri));
+			    "invalid root item size, have %u expect %zu or %u",
+			    btrfs_item_size_nr(leaf, slot), sizeof(ri),
+			    btrfs_legacy_root_item_size());
 	}
 
+	/*
+	 * For legacy root item, the members starting at generation_v2 will be
+	 * all filled with 0.
+	 * And since we allow geneartion_v2 as 0, it will still pass the check.
+	 */
 	read_extent_buffer(leaf, &ri, btrfs_item_ptr_offset(leaf, slot),
-			   sizeof(ri));
+			   btrfs_item_size_nr(leaf, slot));
 
 	/* Generation related */
 	if (btrfs_root_generation(&ri) >
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -4,6 +4,11 @@
 
 #include <linux/btrfs.h>
 #include <linux/types.h>
+#ifdef __KERNEL__
+#include <linux/stddef.h>
+#else
+#include <stddef.h>
+#endif
 
 /*
  * This header contains the structure definitions and constants used
@@ -651,6 +656,15 @@ struct btrfs_root_item {
 } __attribute__ ((__packed__));
 
 /*
+ * Btrfs root item used to be smaller than current size.  The old format ends
+ * at where member generation_v2 is.
+ */
+static inline __u32 btrfs_legacy_root_item_size(void)
+{
+	return offsetof(struct btrfs_root_item, generation_v2);
+}
+
+/*
  * this is used for both forward and backward root refs
  */
 struct btrfs_root_ref {


