Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4392D15779F
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgBJNBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:01:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:41782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729818AbgBJMkw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:52 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FE7120661;
        Mon, 10 Feb 2020 12:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338451;
        bh=N6y3J6xDI4G6Rv3ZfZ7XKKwjKaRnqtJz6uGMUI0REg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zhdhq6S8IbmfUFJB+kGfs/KmPnD+T2Uj3dNeTLfwiQU8bcfNvD5Wkf4XkgpFJSumV
         3k2wN8IeUj5CJNkLGyGuT7st/5qJ+05b25YK/uMHoHCAolKHYOZDPiG8oVkrrTrkyx
         ZbNKFLC4wYAZN220Df985j5dpeSIQ8Sx/CUaOxqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.5 197/367] Btrfs: fix infinite loop during fsync after rename operations
Date:   Mon, 10 Feb 2020 04:31:50 -0800
Message-Id: <20200210122442.771729919@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit b5e4ff9d465da1233a2d9a47ebce487c70d8f4ab upstream.

Recently fsstress (from fstests) sporadically started to trigger an
infinite loop during fsync operations. This turned out to be because
support for the rename exchange and whiteout operations was added to
fsstress in fstests. These operations, unlike any others in fsstress,
cause file names to be reused, whence triggering this issue. However
it's not necessary to use rename exchange and rename whiteout operations
trigger this issue, simple rename operations and file creations are
enough to trigger the issue.

The issue boils down to when we are logging inodes that conflict (that
had the name of any inode we need to log during the fsync operation), we
keep logging them even if they were already logged before, and after
that we check if there's any other inode that conflicts with them and
then add it again to the list of inodes to log. Skipping already logged
inodes fixes the issue.

Consider the following example:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ mkdir /mnt/testdir                           # inode 257

  $ touch /mnt/testdir/zz                        # inode 258
  $ ln /mnt/testdir/zz /mnt/testdir/zz_link

  $ touch /mnt/testdir/a                         # inode 259

  $ sync

  # The following 3 renames achieve the same result as a rename exchange
  # operation (<rename_exchange> /mnt/testdir/zz_link to /mnt/testdir/a).

  $ mv /mnt/testdir/a /mnt/testdir/a/tmp
  $ mv /mnt/testdir/zz_link /mnt/testdir/a
  $ mv /mnt/testdir/a/tmp /mnt/testdir/zz_link

  # The following rename and file creation give the same result as a
  # rename whiteout operation (<rename_whiteout> zz to a2).

  $ mv /mnt/testdir/zz /mnt/testdir/a2
  $ touch /mnt/testdir/zz                        # inode 260

  $ xfs_io -c fsync /mnt/testdir/zz
    --> results in the infinite loop

The following steps happen:

1) When logging inode 260, we find that its reference named "zz" was
   used by inode 258 in the previous transaction (through the commit
   root), so inode 258 is added to the list of conflicting indoes that
   need to be logged;

2) After logging inode 258, we find that its reference named "a" was
   used by inode 259 in the previous transaction, and therefore we add
   inode 259 to the list of conflicting inodes to be logged;

3) After logging inode 259, we find that its reference named "zz_link"
   was used by inode 258 in the previous transaction - we add inode 258
   to the list of conflicting inodes to log, again - we had already
   logged it before at step 3. After logging it again, we find again
   that inode 259 conflicts with him, and we add again 259 to the list,
   etc - we end up repeating all the previous steps.

So fix this by skipping logging of conflicting inodes that were already
logged.

Fixes: 6b5fc433a7ad67 ("Btrfs: fix fsync after succession of renames of different files")
CC: stable@vger.kernel.org # 5.1+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-log.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4836,6 +4836,50 @@ static int log_conflicting_inodes(struct
 			continue;
 		}
 		/*
+		 * If the inode was already logged skip it - otherwise we can
+		 * hit an infinite loop. Example:
+		 *
+		 * From the commit root (previous transaction) we have the
+		 * following inodes:
+		 *
+		 * inode 257 a directory
+		 * inode 258 with references "zz" and "zz_link" on inode 257
+		 * inode 259 with reference "a" on inode 257
+		 *
+		 * And in the current (uncommitted) transaction we have:
+		 *
+		 * inode 257 a directory, unchanged
+		 * inode 258 with references "a" and "a2" on inode 257
+		 * inode 259 with reference "zz_link" on inode 257
+		 * inode 261 with reference "zz" on inode 257
+		 *
+		 * When logging inode 261 the following infinite loop could
+		 * happen if we don't skip already logged inodes:
+		 *
+		 * - we detect inode 258 as a conflicting inode, with inode 261
+		 *   on reference "zz", and log it;
+		 *
+		 * - we detect inode 259 as a conflicting inode, with inode 258
+		 *   on reference "a", and log it;
+		 *
+		 * - we detect inode 258 as a conflicting inode, with inode 259
+		 *   on reference "zz_link", and log it - again! After this we
+		 *   repeat the above steps forever.
+		 */
+		spin_lock(&BTRFS_I(inode)->lock);
+		/*
+		 * Check the inode's logged_trans only instead of
+		 * btrfs_inode_in_log(). This is because the last_log_commit of
+		 * the inode is not updated when we only log that it exists and
+		 * and it has the full sync bit set (see btrfs_log_inode()).
+		 */
+		if (BTRFS_I(inode)->logged_trans == trans->transid) {
+			spin_unlock(&BTRFS_I(inode)->lock);
+			btrfs_add_delayed_iput(inode);
+			continue;
+		}
+		spin_unlock(&BTRFS_I(inode)->lock);
+		/*
 		 * We are safe logging the other inode without acquiring its
 		 * lock as long as we log with the LOG_INODE_EXISTS mode. We
 		 * are safe against concurrent renames of the other inode as


