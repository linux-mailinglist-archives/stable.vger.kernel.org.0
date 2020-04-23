Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F108E1B696A
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgDWXX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:23:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48442 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728176AbgDWXGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:31 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvL-0004bZ-2G; Fri, 24 Apr 2020 00:06:27 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-00E6iM-Os; Fri, 24 Apr 2020 00:06:25 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Su Yue" <suy.fnst@cn.fujitsu.com>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>,
        "Qu Wenruo" <wqu@suse.com>, "David Sterba" <dsterba@suse.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Fri, 24 Apr 2020 00:04:40 +0100
Message-ID: <lsq.1587683028.12048215@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 053/245] btrfs: tree-checker: Check level for leaves
 and nodes
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit f556faa46eb4e96d0d0772e74ecf66781e132f72 upstream.

Although we have tree level check at tree read runtime, it's completely
based on its parent level.
We still need to do accurate level check to avoid invalid tree blocks
sneak into kernel space.

The check itself is simple, for leaf its level should always be 0.
For nodes its level should be in range [1, BTRFS_MAX_LEVEL - 1].

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Backported to 4.4:
 - Pass root instead of fs_info to generic_err()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/tree-checker.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -447,6 +447,13 @@ static int check_leaf(struct btrfs_root
 	u32 nritems = btrfs_header_nritems(leaf);
 	int slot;
 
+	if (btrfs_header_level(leaf) != 0) {
+		generic_err(root, leaf, 0,
+			"invalid level for leaf, have %d expect 0",
+			btrfs_header_level(leaf));
+		return -EUCLEAN;
+	}
+
 	/*
 	 * Extent buffers from a relocation tree have a owner field that
 	 * corresponds to the subvolume tree they are based on. So just from an
@@ -589,9 +596,16 @@ int btrfs_check_node(struct btrfs_root *
 	unsigned long nr = btrfs_header_nritems(node);
 	struct btrfs_key key, next_key;
 	int slot;
+	int level = btrfs_header_level(node);
 	u64 bytenr;
 	int ret = 0;
 
+	if (level <= 0 || level >= BTRFS_MAX_LEVEL) {
+		generic_err(root, node, 0,
+			"invalid level for node, have %d expect [1, %d]",
+			level, BTRFS_MAX_LEVEL - 1);
+		return -EUCLEAN;
+	}
 	if (nr == 0 || nr > BTRFS_NODEPTRS_PER_BLOCK(root)) {
 		btrfs_crit(root->fs_info,
 "corrupt node: root=%llu block=%llu, nritems too %s, have %lu expect range [1,%zu]",

