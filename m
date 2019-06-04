Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7D73418B
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 10:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfFDIQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 04:16:00 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:33959 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727160AbfFDIPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 04:15:19 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id BF7392922;
        Tue,  4 Jun 2019 04:15:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 04:15:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZYdRUV
        HI68eoUfskQA2kC0VeH6M5C49/DkvEHtoFwso=; b=49BwCP1eG953+ASBFSqBiS
        eV83wc+ExWW24dtkzXHBBuSe/oHh7vfa02Q8uTQR9J4KTKoDHEc1PIZTp9rk1tvP
        T0RkS5qozyi8ne1GxQKtAudqzWTfjZDNyV4fNwRjNMedOOl9rYggEhw1nZnYbIvK
        pRLkiWPv2qLagJ+vu1MdEPwmubY2fdiwXl45vyPCtZ8MUrHV0NJcB/0ayd0DXIkJ
        tVOiZvo2XnywGqfrWhlmcwH0LwtS43w77yf2eaeKUUwp8S8mEQLrCNXkRkbj3una
        9TRzYOB27O33mHosSB62Vivthn26gDd/bSAwiNBn0OgsSQnIdHQ5sWWkVCkB0LZw
        ==
X-ME-Sender: <xms:lij2XNc4mxzm4Gw_GHKCs5J9M1cwDFq_Xkc6wRMrLx5S4jhN0vu3hQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefledgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:lij2XLoT_ox-FFBkSn61i3XfHWCmZ2WG0_qMdU3fMclhy9kOmO8V5A>
    <xmx:lij2XHN-ZpJHmDnxeBAF-KKHduV2fSwf0YT98mC0MKuGGQJAyjVJMw>
    <xmx:lij2XOgPDy_AqRNFfTnl7P-Tz3AHqiwQzGe3KXVioc7eC9HO6jl8XA>
    <xmx:lij2XNc6vk8-AiBbdVa_PBexi9FOeQWGm15mLRa7miqAfHwJ4PJeWQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CCF2E80064;
        Tue,  4 Jun 2019 04:15:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Btrfs: fix fsync not persisting changed attributes of a" failed to apply to 4.4-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 04 Jun 2019 10:15:08 +0200
Message-ID: <1559636108166121@kroah.com>
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

From 60d9f50308e5df19bc18c2fefab0eba4a843900a Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Thu, 16 May 2019 15:48:55 +0100
Subject: [PATCH] Btrfs: fix fsync not persisting changed attributes of a
 directory

While logging an inode we follow its ancestors and for each one we mark
it as logged in the current transaction, even if we have not logged it.
As a consequence if we change an attribute of an ancestor, such as the
UID or GID for example, and then explicitly fsync it, we end up not
logging the inode at all despite returning success to user space, which
results in the attribute being lost if a power failure happens after
the fsync.

Sample reproducer:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ mkdir /mnt/dir
  $ chown 6007:6007 /mnt/dir

  $ sync

  $ chown 9003:9003 /mnt/dir
  $ touch /mnt/dir/file
  $ xfs_io -c fsync /mnt/dir/file

  # fsync our directory after fsync'ing the new file, should persist the
  # new values for the uid and gid.
  $ xfs_io -c fsync /mnt/dir

  <power failure>

  $ mount /dev/sdb /mnt
  $ stat -c %u:%g /mnt/dir
  6007:6007

    --> should be 9003:9003, the uid and gid were not persisted, despite
        the explicit fsync on the directory prior to the power failure

Fix this by not updating the logged_trans field of ancestor inodes when
logging an inode, since we have not logged them. Let only future calls to
btrfs_log_inode() to mark inodes as logged.

This could be triggered by my recent fsync fuzz tester for fstests, for
which an fstests patch exists titled "fstests: generic, fsync fuzz tester
with fsstress".

Fixes: 12fcfd22fe5b ("Btrfs: tree logging unlink/rename fixes")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 6c47f6ed3e94..de729acee738 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5478,7 +5478,6 @@ static noinline int check_parent_dirs_for_sync(struct btrfs_trans_handle *trans,
 {
 	int ret = 0;
 	struct dentry *old_parent = NULL;
-	struct btrfs_inode *orig_inode = inode;
 
 	/*
 	 * for regular files, if its inode is already on disk, we don't
@@ -5498,16 +5497,6 @@ static noinline int check_parent_dirs_for_sync(struct btrfs_trans_handle *trans,
 	}
 
 	while (1) {
-		/*
-		 * If we are logging a directory then we start with our inode,
-		 * not our parent's inode, so we need to skip setting the
-		 * logged_trans so that further down in the log code we don't
-		 * think this inode has already been logged.
-		 */
-		if (inode != orig_inode)
-			inode->logged_trans = trans->transid;
-		smp_mb();
-
 		if (btrfs_must_commit_transaction(trans, inode)) {
 			ret = 1;
 			break;
@@ -6384,7 +6373,6 @@ void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
 	 * if this directory was already logged any new
 	 * names for this file/dir will get recorded
 	 */
-	smp_mb();
 	if (dir->logged_trans == trans->transid)
 		return;
 

