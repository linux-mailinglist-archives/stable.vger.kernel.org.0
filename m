Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B1F323D34
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbhBXNFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:05:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232673AbhBXM7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:59:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AA9C64F42;
        Wed, 24 Feb 2021 12:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171161;
        bh=uyV4Fsd/5vmg6wt4KA9Es4ZqNqkil7DPubeM55oQoRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tSwG5Kh32smG2BaVIDg7N5UF2N8eJJm30iQF7VTTm2+7qGyZdVvnr/FBUDtdkuqVL
         VJEZK3BS7on+bBh59mrCPm84CylCwDUwi4flqKOn8tjgE0kv47m82fwYzzEsO0jMwH
         Bm40DS5CIGDmALYQU5Sa6AcScnjBbFvKkwEjLtKJNuhjlhIamF7D6xUHB89yPXDt4e
         /nI4QUEmovXZWPUitTUr/Jv5Ib47ubOluTAeL8nKqNn8Y1TimveoDEhqHEawsE1Agm
         F4B+znNXGfJgyVsiDCvi1W15mA5JPM2C0aQtqyfK2nlpti3Ml6p/lsxRkMUykc6ESN
         5ncy737m9JgxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        syzbot+36315852ece4132ec193@syzkaller.appspotmail.com,
        kernel test robot <lkp@intel.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        jfs-discussion@lists.sourceforge.net,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 21/56] JFS: more checks for invalid superblock
Date:   Wed, 24 Feb 2021 07:51:37 -0500
Message-Id: <20210224125212.482485-21-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 3bef198f1b17d1bb89260bad947ef084c0a2d1a6 ]

syzbot is feeding invalid superblock data to JFS for mount testing.
JFS does not check several of the fields -- just assumes that they
are good since the JFS_MAGIC and version fields are good.

In this case (syzbot reproducer), we have s_l2bsize == 0xda0c,
pad == 0xf045, and s_state == 0x50, all of which are invalid IMO.
Having s_l2bsize == 0xda0c causes this UBSAN warning:
  UBSAN: shift-out-of-bounds in fs/jfs/jfs_mount.c:373:25
  shift exponent -9716 is negative

s_l2bsize can be tested for correctness. pad can be tested for non-0
and punted. s_state can be tested for its valid values and punted.

Do those 3 tests and if any of them fails, report the superblock as
invalid/corrupt and let fsck handle it.

With this patch, chkSuper() says this when JFS_DEBUG is enabled:
  jfs_mount: Mount Failure: superblock is corrupt!
  Mount JFS Failure: -22
  jfs_mount failed w/return code = -22

The obvious problem with this method is that next week there could
be another syzbot test that uses different fields for invalid values,
this making this like a game of whack-a-mole.

syzkaller link: https://syzkaller.appspot.com/bug?extid=36315852ece4132ec193

Reported-by: syzbot+36315852ece4132ec193@syzkaller.appspotmail.com
Reported-by: kernel test robot <lkp@intel.com> # v2
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: jfs-discussion@lists.sourceforge.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_filsys.h |  1 +
 fs/jfs/jfs_mount.c  | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/fs/jfs/jfs_filsys.h b/fs/jfs/jfs_filsys.h
index 1e899298f7f00..b5d702df7111a 100644
--- a/fs/jfs/jfs_filsys.h
+++ b/fs/jfs/jfs_filsys.h
@@ -268,5 +268,6 @@
 				 * fsck() must be run to repair
 				 */
 #define	FM_EXTENDFS 0x00000008	/* file system extendfs() in progress */
+#define	FM_STATE_MAX 0x0000000f	/* max value of s_state */
 
 #endif				/* _H_JFS_FILSYS */
diff --git a/fs/jfs/jfs_mount.c b/fs/jfs/jfs_mount.c
index 2935d4c776ec7..5d7d7170c03c0 100644
--- a/fs/jfs/jfs_mount.c
+++ b/fs/jfs/jfs_mount.c
@@ -37,6 +37,7 @@
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
 #include <linux/blkdev.h>
+#include <linux/log2.h>
 
 #include "jfs_incore.h"
 #include "jfs_filsys.h"
@@ -366,6 +367,15 @@ static int chkSuper(struct super_block *sb)
 	sbi->bsize = bsize;
 	sbi->l2bsize = le16_to_cpu(j_sb->s_l2bsize);
 
+	/* check some fields for possible corruption */
+	if (sbi->l2bsize != ilog2((u32)bsize) ||
+	    j_sb->pad != 0 ||
+	    le32_to_cpu(j_sb->s_state) > FM_STATE_MAX) {
+		rc = -EINVAL;
+		jfs_err("jfs_mount: Mount Failure: superblock is corrupt!");
+		goto out;
+	}
+
 	/*
 	 * For now, ignore s_pbsize, l2bfactor.  All I/O going through buffer
 	 * cache.
-- 
2.27.0

