Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F5034C9E9
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbhC2IeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234600AbhC2IdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD073619BA;
        Mon, 29 Mar 2021 08:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006736;
        bh=FJSI5A/QV1SqGxKsCKmziCupLjs37PH95WhuTZ5/Ioo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08mSjfy+Iw8LExRtn9Gnu38OvUaFEYHhmE5jA/fQ2M+FpyE0z3CfnKJJ8xLxyFFFD
         DaOhbrtzcHyNKHWfbalLUV95zPoezJ0H54Clb8suqkE13XBm6JTAfv5CRutkzA51Pq
         H+Z2feWEaT1zCuuXGswpqy74JV3DHK67LM3v/b/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robbie Ko <robbieko@synology.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.11 072/254] btrfs: fix subvolume/snapshot deletion not triggered on mount
Date:   Mon, 29 Mar 2021 09:56:28 +0200
Message-Id: <20210329075635.518142775@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 8d488a8c7ba22d7112fbf6b0a82beb1cdea1c0d5 upstream.

During the mount procedure we are calling btrfs_orphan_cleanup() against
the root tree, which will find all orphans items in this tree. When an
orphan item corresponds to a deleted subvolume/snapshot (instead of an
inode space cache), it must not delete the orphan item, because that will
cause btrfs_find_orphan_roots() to not find the orphan item and therefore
not add the corresponding subvolume root to the list of dead roots, which
results in the subvolume's tree never being deleted by the cleanup thread.

The same applies to the remount from RO to RW path.

Fix this by making btrfs_find_orphan_roots() run before calling
btrfs_orphan_cleanup() against the root tree.

A test case for fstests will follow soon.

Reported-by: Robbie Ko <robbieko@synology.com>
Link: https://lore.kernel.org/linux-btrfs/b19f4310-35e0-606e-1eea-2dd84d28c5da@synology.com/
Fixes: 638331fa56caea ("btrfs: fix transaction leak and crash after cleaning up orphans on RO mount")
CC: stable@vger.kernel.org # 5.11+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2914,6 +2914,21 @@ int btrfs_start_pre_rw_mount(struct btrf
 		}
 	}
 
+	/*
+	 * btrfs_find_orphan_roots() is responsible for finding all the dead
+	 * roots (with 0 refs), flag them with BTRFS_ROOT_DEAD_TREE and load
+	 * them into the fs_info->fs_roots_radix tree. This must be done before
+	 * calling btrfs_orphan_cleanup() on the tree root. If we don't do it
+	 * first, then btrfs_orphan_cleanup() will delete a dead root's orphan
+	 * item before the root's tree is deleted - this means that if we unmount
+	 * or crash before the deletion completes, on the next mount we will not
+	 * delete what remains of the tree because the orphan item does not
+	 * exists anymore, which is what tells us we have a pending deletion.
+	 */
+	ret = btrfs_find_orphan_roots(fs_info);
+	if (ret)
+		goto out;
+
 	ret = btrfs_cleanup_fs_roots(fs_info);
 	if (ret)
 		goto out;
@@ -2973,7 +2988,6 @@ int btrfs_start_pre_rw_mount(struct btrf
 		}
 	}
 
-	ret = btrfs_find_orphan_roots(fs_info);
 out:
 	return ret;
 }


