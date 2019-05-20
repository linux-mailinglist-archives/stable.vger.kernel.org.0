Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCE22374E
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388776AbfETMYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:24:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388764AbfETMYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:24:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D72520815;
        Mon, 20 May 2019 12:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355048;
        bh=rbaUw09nTDaxvuLdWWQ0id19Ppq7bCyJwobak7LfE4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBiR8rsifdGbyiHoKwFacQdkZooBh9IL6kBV45i9pTQuTMeopW24fYu+R/onyBbGU
         8KOgnk7gNZKQRiW+MapB0xvb0HQ+BAdCd1g5L4+0yhyUC6J6OTOzBnlkS9+CKavMJs
         1NHtRZps7K42juwO+gfryF31MOEMS60CpxSC9l5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 076/105] Btrfs: send, flush dellaloc in order to avoid data loss
Date:   Mon, 20 May 2019 14:14:22 +0200
Message-Id: <20190520115252.487467638@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 9f89d5de8631c7930898a601b6612e271aa2261c upstream.

When we set a subvolume to read-only mode we do not flush dellaloc for any
of its inodes (except if the filesystem is mounted with -o flushoncommit),
since it does not affect correctness for any subsequent operations - except
for a future send operation. The send operation will not be able to see the
delalloc data since the respective file extent items, inode item updates,
backreferences, etc, have not hit yet the subvolume and extent trees.

Effectively this means data loss, since the send stream will not contain
any data from existing delalloc. Another problem from this is that if the
writeback starts and finishes while the send operation is in progress, we
have the subvolume tree being being modified concurrently which can result
in send failing unexpectedly with EIO or hitting runtime errors, assertion
failures or hitting BUG_ONs, etc.

Simple reproducer:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ btrfs subvolume create /mnt/sv
  $ xfs_io -f -c "pwrite -S 0xea 0 108K" /mnt/sv/foo

  $ btrfs property set /mnt/sv ro true
  $ btrfs send -f /tmp/send.stream /mnt/sv

  $ od -t x1 -A d /mnt/sv/foo
  0000000 ea ea ea ea ea ea ea ea ea ea ea ea ea ea ea ea
  *
  0110592

  $ umount /mnt
  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt

  $ btrfs receive -f /tmp/send.stream /mnt
  $ echo $?
  0
  $ od -t x1 -A d /mnt/sv/foo
  0000000
  # ---> empty file

Since this a problem that affects send only, fix it in send by flushing
dellaloc for all the roots used by the send operation before send starts
to process the commit roots.

This is a problem that affects send since it was introduced (commit
31db9f7c23fbf7 ("Btrfs: introduce BTRFS_IOC_SEND for btrfs send/receive"))
but backporting it to older kernels has some dependencies:

- For kernels between 3.19 and 4.20, it depends on commit 3cd24c698004d2
  ("btrfs: use tagged writepage to mitigate livelock of snapshot") because
  the function btrfs_start_delalloc_snapshot() does not exist before that
  commit. So one has to either pick that commit or replace the calls to
  btrfs_start_delalloc_snapshot() in this patch with calls to
  btrfs_start_delalloc_inodes().

- For kernels older than 3.19 it also requires commit e5fa8f865b3324
  ("Btrfs: ensure send always works on roots without orphans") because
  it depends on the function ensure_commit_roots_uptodate() which that
  commits introduced.

- No dependencies for 5.0+ kernels.

A test case for fstests follows soon.

CC: stable@vger.kernel.org # 3.19+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/send.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6583,6 +6583,38 @@ commit_trans:
 	return btrfs_commit_transaction(trans);
 }
 
+/*
+ * Make sure any existing dellaloc is flushed for any root used by a send
+ * operation so that we do not miss any data and we do not race with writeback
+ * finishing and changing a tree while send is using the tree. This could
+ * happen if a subvolume is in RW mode, has delalloc, is turned to RO mode and
+ * a send operation then uses the subvolume.
+ * After flushing delalloc ensure_commit_roots_uptodate() must be called.
+ */
+static int flush_delalloc_roots(struct send_ctx *sctx)
+{
+	struct btrfs_root *root = sctx->parent_root;
+	int ret;
+	int i;
+
+	if (root) {
+		ret = btrfs_start_delalloc_snapshot(root);
+		if (ret)
+			return ret;
+		btrfs_wait_ordered_extents(root, U64_MAX, 0, U64_MAX);
+	}
+
+	for (i = 0; i < sctx->clone_roots_cnt; i++) {
+		root = sctx->clone_roots[i].root;
+		ret = btrfs_start_delalloc_snapshot(root);
+		if (ret)
+			return ret;
+		btrfs_wait_ordered_extents(root, U64_MAX, 0, U64_MAX);
+	}
+
+	return 0;
+}
+
 static void btrfs_root_dec_send_in_progress(struct btrfs_root* root)
 {
 	spin_lock(&root->root_item_lock);
@@ -6807,6 +6839,10 @@ long btrfs_ioctl_send(struct file *mnt_f
 			NULL);
 	sort_clone_roots = 1;
 
+	ret = flush_delalloc_roots(sctx);
+	if (ret)
+		goto out;
+
 	ret = ensure_commit_roots_uptodate(sctx);
 	if (ret)
 		goto out;


