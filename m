Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E8028B73B
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731096AbgJLNlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730538AbgJLNlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:41:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67C6320678;
        Mon, 12 Oct 2020 13:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510065;
        bh=jQi2E8JFqGCg1MtXW3mSS/ZR2oZmHW+9bj8lJ015Zt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WeBqsXyB8QZI4KsAeLdVfRlIQF65T7XNeo4TRSWO1wX/7MHFumM5VrtG/BzsOuYcJ
         85Z0GlHoa1tH2CkoEMt2aUdktE9cen7DHEV864PAwxZSSWALL6YCpv1opUB5cnuHkd
         GhWh8npTAeMqSfNEeeeuPDXNUmGcvixYEeThGIQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.4 26/85] Btrfs: send, allow clone operations within the same file
Date:   Mon, 12 Oct 2020 15:26:49 +0200
Message-Id: <20201012132634.114097309@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 11f2069c113e02971b8db6fda62f9b9cd31a030f upstream.

For send we currently skip clone operations when the source and
destination files are the same. This is so because clone didn't support
this case in its early days, but support for it was added back in May
2013 by commit a96fbc72884fcb ("Btrfs: allow file data clone within a
file"). This change adds support for it.

Example:

  $ mkfs.btrfs -f /dev/sdd
  $ mount /dev/sdd /mnt/sdd

  $ xfs_io -f -c "pwrite -S 0xab -b 64K 0 64K" /mnt/sdd/foobar
  $ xfs_io -c "reflink /mnt/sdd/foobar 0 64K 64K" /mnt/sdd/foobar

  $ btrfs subvolume snapshot -r /mnt/sdd /mnt/sdd/snap

  $ mkfs.btrfs -f /dev/sde
  $ mount /dev/sde /mnt/sde

  $ btrfs send /mnt/sdd/snap | btrfs receive /mnt/sde

Without this change file foobar at the destination has a single 128Kb
extent:

  $ filefrag -v /mnt/sde/snap/foobar
  Filesystem type is: 9123683e
  File size of /mnt/sde/snap/foobar is 131072 (32 blocks of 4096 bytes)
   ext:     logical_offset:        physical_offset: length:   expected: flags:
     0:        0..      31:          0..        31:     32:             last,unknown_loc,delalloc,eof
  /mnt/sde/snap/foobar: 1 extent found

With this we get a single 64Kb extent that is shared at file offsets 0
and 64K, just like in the source filesystem:

  $ filefrag -v /mnt/sde/snap/foobar
  Filesystem type is: 9123683e
  File size of /mnt/sde/snap/foobar is 131072 (32 blocks of 4096 bytes)
   ext:     logical_offset:        physical_offset: length:   expected: flags:
     0:        0..      15:       3328..      3343:     16:             shared
     1:       16..      31:       3328..      3343:     16:       3344: last,shared,eof
  /mnt/sde/snap/foobar: 2 extents found

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/send.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1257,12 +1257,20 @@ static int __iterate_backrefs(u64 ino, u
 	 */
 	if (found->root == bctx->sctx->send_root) {
 		/*
-		 * TODO for the moment we don't accept clones from the inode
-		 * that is currently send. We may change this when
-		 * BTRFS_IOC_CLONE_RANGE supports cloning from and to the same
-		 * file.
+		 * If the source inode was not yet processed we can't issue a
+		 * clone operation, as the source extent does not exist yet at
+		 * the destination of the stream.
 		 */
-		if (ino >= bctx->cur_objectid)
+		if (ino > bctx->cur_objectid)
+			return 0;
+		/*
+		 * We clone from the inode currently being sent as long as the
+		 * source extent is already processed, otherwise we could try
+		 * to clone from an extent that does not exist yet at the
+		 * destination of the stream.
+		 */
+		if (ino == bctx->cur_objectid &&
+		    offset >= bctx->sctx->cur_inode_next_write_offset)
 			return 0;
 	}
 


