Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B338C21A76
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 17:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbfEQPWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 11:22:52 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:58537 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728749AbfEQPWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 11:22:52 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 7926747F;
        Fri, 17 May 2019 11:22:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 17 May 2019 11:22:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=iWr+2i
        rY6+31bNMrWD/nfvZACt28dVNdx8AEWpIS/Ls=; b=2CZ7eTOIIRy5ZM72T9ckPg
        2VvNhnMbLQHTx9DtEcEPl7Y4NDucWNb/gPFXA+y+/AY6w36FytESdX4MVVGEKpab
        YN0sBvyDk5R3QvaTX7ZYQS7buY0K5w7nnUqUXHlvLEsru+J5RVjACLcXw9T+omG2
        WxM/yBno4dNyH/L4V50AKP2/2cXxIs7ImGIXseljrxVfo4tWEYgGc7BRMdgCcyIo
        QI8w3zdOadIjXDhbcTvg5As9l/YIaNqBi8cG/5/dbi3wkvmGnh+jB9ZxawYxISSq
        UicY4QszHDsdbyt1iE5zVnlU8AWRNcveMJZtQA0G9dwnc1WMvCDWM7YEQiz0SQow
        ==
X-ME-Sender: <xms:ytHeXFtpDXIG7OwKBabtU3JuxFGdJ9jpP4zwI-cqYPM7YRqnyo9dQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehsvghnugdrshhtrhgvrghmnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:ytHeXBvF7NK1mUgIeFcKpEmFGoNctfqXqd3Hi1QuLz7_lTjmLnNllQ>
    <xmx:ytHeXM2aWbC9Nj4Vf9r8qz3hm506h1pn4_2ocvO7sANyz0o3yzuSzg>
    <xmx:ytHeXGNSwtqnLbM7Z_3aLq8uamPpRCrY9iLmWKU7Gx1cszecLV8cKw>
    <xmx:ytHeXOO2-KmRGZB8rLFRxH4Bgtl0Ql8RND_R1eSIk4q_iuCY951Phg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0D9B7103DC;
        Fri, 17 May 2019 11:22:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Btrfs: send, flush dellaloc in order to avoid data loss" failed to apply to 4.4-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 17:22:48 +0200
Message-ID: <1558106568193225@kroah.com>
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

From 9f89d5de8631c7930898a601b6612e271aa2261c Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 15 Apr 2019 09:29:36 +0100
Subject: [PATCH] Btrfs: send, flush dellaloc in order to avoid data loss

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

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 1e9caa552235..12363081f53b 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6593,6 +6593,38 @@ static int ensure_commit_roots_uptodate(struct send_ctx *sctx)
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
@@ -6817,6 +6849,10 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
 			NULL);
 	sort_clone_roots = 1;
 
+	ret = flush_delalloc_roots(sctx);
+	if (ret)
+		goto out;
+
 	ret = ensure_commit_roots_uptodate(sctx);
 	if (ret)
 		goto out;

