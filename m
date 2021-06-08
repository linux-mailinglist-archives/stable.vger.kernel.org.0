Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FCB3A0235
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235336AbhFHTBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:01:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236573AbhFHS72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:59:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37A746162B;
        Tue,  8 Jun 2021 18:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177794;
        bh=jUHfzZ4J1q+T/6LIeaLr46c78R1ZaMe2tMYfgIJbomA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cluMyE+dYZUhlG4yI+x4AuU+OobjaOKdt0Jg5CNZQuf8pmfC1RAmt4O3NTgqZDIMm
         IxipByrK8PQFKR0EzXbQVkTjGfk0tpJChioiRhwXbVGq9R3wmlgOYWedTIIBCZMKjB
         YYjMDA69z+3WLUCJl8z9iu/ZNiAePzGNZPQ0FRX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Makhalov <amakhalov@vmware.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.10 102/137] ext4: fix memory leak in ext4_fill_super
Date:   Tue,  8 Jun 2021 20:27:22 +0200
Message-Id: <20210608175945.839794181@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Makhalov <amakhalov@vmware.com>

commit afd09b617db3786b6ef3dc43e28fe728cfea84df upstream.

Buffer head references must be released before calling kill_bdev();
otherwise the buffer head (and its page referenced by b_data) will not
be freed by kill_bdev, and subsequently that bh will be leaked.

If blocksizes differ, sb_set_blocksize() will kill current buffers and
page cache by using kill_bdev(). And then super block will be reread
again but using correct blocksize this time. sb_set_blocksize() didn't
fully free superblock page and buffer head, and being busy, they were
not freed and instead leaked.

This can easily be reproduced by calling an infinite loop of:

  systemctl start <ext4_on_lvm>.mount, and
  systemctl stop <ext4_on_lvm>.mount

... since systemd creates a cgroup for each slice which it mounts, and
the bh leak get amplified by a dying memory cgroup that also never
gets freed, and memory consumption is much more easily noticed.

Fixes: ce40733ce93d ("ext4: Check for return value from sb_set_blocksize")
Fixes: ac27a0ec112a ("ext4: initial copy of files from ext3")
Link: https://lore.kernel.org/r/20210521075533.95732-1-amakhalov@vmware.com
Signed-off-by: Alexey Makhalov <amakhalov@vmware.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4451,14 +4451,20 @@ static int ext4_fill_super(struct super_
 	}
 
 	if (sb->s_blocksize != blocksize) {
+		/*
+		 * bh must be released before kill_bdev(), otherwise
+		 * it won't be freed and its page also. kill_bdev()
+		 * is called by sb_set_blocksize().
+		 */
+		brelse(bh);
 		/* Validate the filesystem blocksize */
 		if (!sb_set_blocksize(sb, blocksize)) {
 			ext4_msg(sb, KERN_ERR, "bad block size %d",
 					blocksize);
+			bh = NULL;
 			goto failed_mount;
 		}
 
-		brelse(bh);
 		logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
 		offset = do_div(logical_sb_block, blocksize);
 		bh = ext4_sb_bread_unmovable(sb, logical_sb_block);
@@ -5181,8 +5187,9 @@ failed_mount:
 		kfree(get_qf_name(sb, sbi, i));
 #endif
 	fscrypt_free_dummy_policy(&sbi->s_dummy_enc_policy);
-	ext4_blkdev_remove(sbi);
+	/* ext4_blkdev_remove() calls kill_bdev(), release bh before it. */
 	brelse(bh);
+	ext4_blkdev_remove(sbi);
 out_fail:
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);


