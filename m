Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78F52121865
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbfLPSnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:43:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:32974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbfLPR7p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:59:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99B89205C9;
        Mon, 16 Dec 2019 17:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519185;
        bh=eRMUhsOZB2UzrhVWcwpyvpslMKCzC00Koai3F01Gycw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVY8UD5DS4ZEMRWgiquUR9XHCcyQWIPcHlrvkp4QmUKTrRxRgijHUfZ5rzFCd3nMx
         wYiogOg9MzT9/KfLkup8cmDMC5WZNm9GHUfDJzJlknRC1BNPr6Uur6X8JXPK8+Zb61
         G6xi6Cw29ZklJy77yQW1zFQyCCG1c0hYRETCiEK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atemu <atemu.main@gmail.com>,
        Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 189/267] Btrfs: send, skip backreference walking for extents with many references
Date:   Mon, 16 Dec 2019 18:48:35 +0100
Message-Id: <20191216174912.879616002@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
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
@@ -1324,6 +1332,7 @@ static int find_extent_clone(struct send
 	struct clone_root *cur_clone_root;
 	struct btrfs_key found_key;
 	struct btrfs_path *tmp_path;
+	struct btrfs_extent_item *ei;
 	int compressed;
 	u32 i;
 
@@ -1373,7 +1382,6 @@ static int find_extent_clone(struct send
 	ret = extent_from_logical(fs_info, disk_byte, tmp_path,
 				  &found_key, &flags);
 	up_read(&fs_info->commit_root_sem);
-	btrfs_release_path(tmp_path);
 
 	if (ret < 0)
 		goto out;
@@ -1382,6 +1390,21 @@ static int find_extent_clone(struct send
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


