Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F65F1AC286
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895403AbgDPN3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:29:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895195AbgDPN33 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:29:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9DFC208E4;
        Thu, 16 Apr 2020 13:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043766;
        bh=0CSh/3iuY/hLOBpsWWHw2RMNg5o9HoNcm5Ux17DNj/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPNRDfgfjsXaeGzp+lCG+4XQbtI0P94mE56S/J9lX3VpMopO8p4P31IwguDpUTnaQ
         6sakn4oPcJkyIDT8GaiSKAXGXb8nzjzpXyHVsTnZlDlFKVeWAbGSTRKzmv/PX+k6SW
         CZ7hMpkmPZ5LO+ZTwf3s5FAMoPEaz79hO1puuuzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 092/146] btrfs: fix missing file extent item for hole after ranged fsync
Date:   Thu, 16 Apr 2020 15:23:53 +0200
Message-Id: <20200416131255.350339700@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 95418ed1d10774cd9a49af6f39e216c1256f1eeb upstream.

When doing a fast fsync for a range that starts at an offset greater than
zero, we can end up with a log that when replayed causes the respective
inode miss a file extent item representing a hole if we are not using the
NO_HOLES feature. This is because for fast fsyncs we don't log any extents
that cover a range different from the one requested in the fsync.

Example scenario to trigger it:

  $ mkfs.btrfs -O ^no-holes -f /dev/sdd
  $ mount /dev/sdd /mnt

  # Create a file with a single 256K and fsync it to clear to full sync
  # bit in the inode - we want the msync below to trigger a fast fsync.
  $ xfs_io -f -c "pwrite -S 0xab 0 256K" -c "fsync" /mnt/foo

  # Force a transaction commit and wipe out the log tree.
  $ sync

  # Dirty 768K of data, increasing the file size to 1Mb, and flush only
  # the range from 256K to 512K without updating the log tree
  # (sync_file_range() does not trigger fsync, it only starts writeback
  # and waits for it to finish).

  $ xfs_io -c "pwrite -S 0xcd 256K 768K" /mnt/foo
  $ xfs_io -c "sync_range -abw 256K 256K" /mnt/foo

  # Now dirty the range from 768K to 1M again and sync that range.
  $ xfs_io -c "mmap -w 768K 256K"        \
           -c "mwrite -S 0xef 768K 256K" \
           -c "msync -s 768K 256K"       \
           -c "munmap"                   \
           /mnt/foo

  <power fail>

  # Mount to replay the log.
  $ mount /dev/sdd /mnt
  $ umount /mnt

  $ btrfs check /dev/sdd
  Opening filesystem to check...
  Checking filesystem on /dev/sdd
  UUID: 482fb574-b288-478e-a190-a9c44a78fca6
  [1/7] checking root items
  [2/7] checking extents
  [3/7] checking free space cache
  [4/7] checking fs roots
  root 5 inode 257 errors 100, file extent discount
  Found file extent holes:
       start: 262144, len: 524288
  ERROR: errors found in fs roots
  found 720896 bytes used, error(s) found
  total csum bytes: 512
  total tree bytes: 131072
  total fs tree bytes: 32768
  total extent tree bytes: 16384
  btree space waste bytes: 123514
  file data blocks allocated: 589824
    referenced 589824

Fix this issue by setting the range to full (0 to LLONG_MAX) when the
NO_HOLES feature is not enabled. This results in extra work being done
but it gives the guarantee we don't end up with missing holes after
replaying the log.

CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/file.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2074,6 +2074,16 @@ int btrfs_sync_file(struct file *file, l
 	btrfs_init_log_ctx(&ctx, inode);
 
 	/*
+	 * Set the range to full if the NO_HOLES feature is not enabled.
+	 * This is to avoid missing file extent items representing holes after
+	 * replaying the log.
+	 */
+	if (!btrfs_fs_incompat(fs_info, NO_HOLES)) {
+		start = 0;
+		end = LLONG_MAX;
+	}
+
+	/*
 	 * We write the dirty pages in the range and wait until they complete
 	 * out of the ->i_mutex. If so, we can flush the dirty pages by
 	 * multi-task, and make the performance up.  See


