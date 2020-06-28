Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420B120C667
	for <lists+stable@lfdr.de>; Sun, 28 Jun 2020 08:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgF1GKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 02:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbgF1GKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jun 2020 02:10:36 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33EFA2076C;
        Sun, 28 Jun 2020 06:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593324635;
        bh=eQb+Fz3rRAzfKslIoQDAR5opE1JytzPdjZ4dAMCRjCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Qu4KmCXffqy3QlBCH9YucJ8xWAVejd8vUslbePuJeGh/h55TvRjA4NQIgyjK+AWc
         eGNAvIM27aGihdMrP3nWit1dL8d2Nc3W7zZ7ACIySQVTuNpjROj3zE9nAhUOXlykP2
         vkCtu9CvpTPOg97slGXqbOxUyRGP+asygqOqEDFU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        stable@vger.kernel.org,
        syzbot+c7d9ec7a1a7272dd71b3@syzkaller.appspotmail.com,
        syzbot+3b7b03a0c28948054fb5@syzkaller.appspotmail.com,
        syzbot+6e056ee473568865f3e6@syzkaller.appspotmail.com
Subject: [PATCH 3/6] fs/minix: reject too-large maximum file size
Date:   Sat, 27 Jun 2020 23:08:42 -0700
Message-Id: <20200628060846.682158-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628060846.682158-1-ebiggers@kernel.org>
References: <20200628060846.682158-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

If the minix filesystem tries to map a very large logical block number
to its on-disk location, block_to_path() can return offsets that are too
large, causing out-of-bounds memory accesses when accessing indirect
index blocks.  This should be prevented by the check against the maximum
file size, but this doesn't work because the maximum file size is read
directly from the on-disk superblock and isn't validated itself.

Fix this by validating the maximum file size at mount time.

Reported-by: syzbot+c7d9ec7a1a7272dd71b3@syzkaller.appspotmail.com
Reported-by: syzbot+3b7b03a0c28948054fb5@syzkaller.appspotmail.com
Reported-by: syzbot+6e056ee473568865f3e6@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/minix/inode.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 2bca95abe8f4..0dd929346f3f 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -150,6 +150,23 @@ static int minix_remount (struct super_block * sb, int * flags, char * data)
 	return 0;
 }
 
+static bool minix_check_superblock(struct minix_sb_info *sbi)
+{
+	if (sbi->s_imap_blocks == 0 || sbi->s_zmap_blocks == 0)
+		return false;
+
+	/*
+	 * s_max_size must not exceed the block mapping limitation.  This check
+	 * is only needed for V1 filesystems, since V2/V3 support an extra level
+	 * of indirect blocks which places the limit well above U32_MAX.
+	 */
+	if (sbi->s_version == MINIX_V1 &&
+	    sbi->s_max_size > (7 + 512 + 512*512) * BLOCK_SIZE)
+		return false;
+
+	return true;
+}
+
 static int minix_fill_super(struct super_block *s, void *data, int silent)
 {
 	struct buffer_head *bh;
@@ -228,11 +245,12 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
 	} else
 		goto out_no_fs;
 
+	if (!minix_check_superblock(sbi))
+		goto out_illegal_sb;
+
 	/*
 	 * Allocate the buffer map to keep the superblock small.
 	 */
-	if (sbi->s_imap_blocks == 0 || sbi->s_zmap_blocks == 0)
-		goto out_illegal_sb;
 	i = (sbi->s_imap_blocks + sbi->s_zmap_blocks) * sizeof(bh);
 	map = kzalloc(i, GFP_KERNEL);
 	if (!map)
-- 
2.27.0

