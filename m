Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 250CC39109
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbfFGPoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:44:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731051AbfFGPoX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:44:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4614212F5;
        Fri,  7 Jun 2019 15:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922262;
        bh=vz2Hju4XkVHuKTY2CzNYKgUyFgz8nWuf0spIaAcb1sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcIz4NgKwxSrfeElmy/U4fYIkN8rlLW+JTtDPhB+g4Xd0AIvTVyQeO9KeUQd3bvWV
         YK2Cjla3J6enQ/TH0GhQC5Stcyfyu+KFOMemBksOUTaeTB2+TH5JmY46ekPFBxf1br
         MrDeTBJYFlJUc30HWzGsp6NigOhIoO3hkpb6h56A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 24/73] Btrfs: incremental send, fix file corruption when no-holes feature is enabled
Date:   Fri,  7 Jun 2019 17:39:11 +0200
Message-Id: <20190607153851.704772725@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
References: <20190607153848.669070800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 6b1f72e5b82a5c2a4da4d1ebb8cc01913ddbea21 upstream.

When using the no-holes feature, if we have a file with prealloc extents
with a start offset beyond the file's eof, doing an incremental send can
cause corruption of the file due to incorrect hole detection. Such case
requires that the prealloc extent(s) exist in both the parent and send
snapshots, and that a hole is punched into the file that covers all its
extents that do not cross the eof boundary.

Example reproducer:

  $ mkfs.btrfs -f -O no-holes /dev/sdb
  $ mount /dev/sdb /mnt/sdb

  $ xfs_io -f -c "pwrite -S 0xab 0 500K" /mnt/sdb/foobar
  $ xfs_io -c "falloc -k 1200K 800K" /mnt/sdb/foobar

  $ btrfs subvolume snapshot -r /mnt/sdb /mnt/sdb/base

  $ btrfs send -f /tmp/base.snap /mnt/sdb/base

  $ xfs_io -c "fpunch 0 500K" /mnt/sdb/foobar

  $ btrfs subvolume snapshot -r /mnt/sdb /mnt/sdb/incr

  $ btrfs send -p /mnt/sdb/base -f /tmp/incr.snap /mnt/sdb/incr

  $ md5sum /mnt/sdb/incr/foobar
  816df6f64deba63b029ca19d880ee10a   /mnt/sdb/incr/foobar

  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt/sdc

  $ btrfs receive -f /tmp/base.snap /mnt/sdc
  $ btrfs receive -f /tmp/incr.snap /mnt/sdc

  $ md5sum /mnt/sdc/incr/foobar
  cf2ef71f4a9e90c2f6013ba3b2257ed2   /mnt/sdc/incr/foobar

    --> Different checksum, because the prealloc extent beyond the
        file's eof confused the hole detection code and it assumed
        a hole starting at offset 0 and ending at the offset of the
        prealloc extent (1200Kb) instead of ending at the offset
        500Kb (the file's size).

Fix this by ensuring we never cross the file's size when issuing the
write operations for a hole.

Fixes: 16e7549f045d33 ("Btrfs: incompatible format change to remove hole extents")
CC: stable@vger.kernel.org # 3.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/send.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5021,6 +5021,12 @@ static int send_hole(struct send_ctx *sc
 	if (offset >= sctx->cur_inode_size)
 		return 0;
 
+	/*
+	 * Don't go beyond the inode's i_size due to prealloc extents that start
+	 * after the i_size.
+	 */
+	end = min_t(u64, end, sctx->cur_inode_size);
+
 	if (sctx->flags & BTRFS_SEND_FLAG_NO_FILE_DATA)
 		return send_update_extent(sctx, offset, end - offset);
 


