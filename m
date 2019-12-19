Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 203C4126A5B
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbfLSSqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:46:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:39192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728945AbfLSSqa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:46:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 485AC206D7;
        Thu, 19 Dec 2019 18:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781189;
        bh=3meat4GAxA5yeKcb9u/aD+NUxNzTC+2FO4R5XzIejTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PTHzhHkplQi4CtOrzh5enI2wndtsB+x3x+/U/uWmacnRmeRy9SE3UN4w0GLLj37qF
         IdLJG49UwlDbF5yzHjYNS/W3e32A9GNFUg/fantUMEQvCQKj5mnk3YBm3Se8ihkgpk
         /DFvvlDwnHMbP0ZpbNF3JsZE4xmo8cg1hc5tv+Vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atemu <atemu.main@gmail.com>,
        Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 118/199] Btrfs: send, skip backreference walking for extents with many references
Date:   Thu, 19 Dec 2019 19:33:20 +0100
Message-Id: <20191219183221.434717247@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit fd0ddbe2509568b00df364156f47561e9f469f15 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/send.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -37,6 +37,14 @@
 #include "compression.h"
 
 /*
+ * Maximum number of references an extent can have in order for us to attempt to
+ * issue clone operations instead of write operations. This currently exists to
+ * avoid hitting limitations of the backreference walking code (taking a lot of
+ * time and using too much memory for extents with large number of references).
+ */
+#define SEND_MAX_EXTENT_REFS	64
+
+/*
  * A fs_path is a helper to dynamically build path names with unknown size.
  * It reallocates the internal buffer on demand.
  * It allows fast adding of path elements on the right side (normal path) and
@@ -1327,6 +1335,7 @@ static int find_extent_clone(struct send
 	struct clone_root *cur_clone_root;
 	struct btrfs_key found_key;
 	struct btrfs_path *tmp_path;
+	struct btrfs_extent_item *ei;
 	int compressed;
 	u32 i;
 
@@ -1376,7 +1385,6 @@ static int find_extent_clone(struct send
 	ret = extent_from_logical(fs_info, disk_byte, tmp_path,
 				  &found_key, &flags);
 	up_read(&fs_info->commit_root_sem);
-	btrfs_release_path(tmp_path);
 
 	if (ret < 0)
 		goto out;
@@ -1385,6 +1393,21 @@ static int find_extent_clone(struct send
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


