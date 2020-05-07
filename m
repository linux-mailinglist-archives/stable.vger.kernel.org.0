Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5CA1C8FF0
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgEGOgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:36:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728074AbgEGO2V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:28:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 104DD20936;
        Thu,  7 May 2020 14:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861701;
        bh=u9GjzKj/aPiAqe3X8tN9HEszZ3EIsc2zXBSCISpLFQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QP01BDKjEI8PXgFba7sfh9cJbxaGRNCFDYWZj2qH06SCcm/iKNyHLz1P167lWyNIt
         IZZUB373ZcKgdZpZExMgRO0V51UMwd7hQU2c7rJj0OUsCI8SI14AmddV0nBOXsF1JW
         AVh0huTdFCL8Bkz4s+E3p0WnOYcX3gUNZFogfFlU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ritesh Harjani <riteshh@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 42/50] fibmap: Warn and return an error in case of block > INT_MAX
Date:   Thu,  7 May 2020 10:27:18 -0400
Message-Id: <20200507142726.25751-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

[ Upstream commit b75dfde1212991b24b220c3995101c60a7b8ae74 ]

We better warn the fibmap user and not return a truncated and therefore
an incorrect block map address if the bmap() returned block address
is greater than INT_MAX (since user supplied integer pointer).

It's better to pr_warn() all user of ioctl_fibmap() and return a proper
error code rather than silently letting a FS corruption happen if the
user tries to fiddle around with the returned block map address.

We fix this by returning an error code of -ERANGE and returning 0 as the
block mapping address in case if it is > INT_MAX.

Now iomap_bmap() could be called from either of these two paths.
Either when a user is calling an ioctl_fibmap() interface to get
the block mapping address or by some filesystem via use of bmap()
internal kernel API.
bmap() kernel API is well equipped with handling of u64 addresses.

WARN condition in iomap_bmap_actor() was mainly added to warn all
the fibmap users. But now that we have directly added this warning
for all fibmap users and also made sure to return 0 as block map address
in case if addr > INT_MAX.
So we can now remove this logic from iomap_bmap_actor().

Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ioctl.c        | 8 ++++++++
 fs/iomap/fiemap.c | 5 +----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 282d45be6f453..5e80b40bc1b5c 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -55,6 +55,7 @@ EXPORT_SYMBOL(vfs_ioctl);
 static int ioctl_fibmap(struct file *filp, int __user *p)
 {
 	struct inode *inode = file_inode(filp);
+	struct super_block *sb = inode->i_sb;
 	int error, ur_block;
 	sector_t block;
 
@@ -71,6 +72,13 @@ static int ioctl_fibmap(struct file *filp, int __user *p)
 	block = ur_block;
 	error = bmap(inode, &block);
 
+	if (block > INT_MAX) {
+		error = -ERANGE;
+		pr_warn_ratelimited("[%s/%d] FS: %s File: %pD4 would truncate fibmap result\n",
+				    current->comm, task_pid_nr(current),
+				    sb->s_id, filp);
+	}
+
 	if (error)
 		ur_block = 0;
 	else
diff --git a/fs/iomap/fiemap.c b/fs/iomap/fiemap.c
index bccf305ea9ce2..d55e8f491a5e5 100644
--- a/fs/iomap/fiemap.c
+++ b/fs/iomap/fiemap.c
@@ -117,10 +117,7 @@ iomap_bmap_actor(struct inode *inode, loff_t pos, loff_t length,
 
 	if (iomap->type == IOMAP_MAPPED) {
 		addr = (pos - iomap->offset + iomap->addr) >> inode->i_blkbits;
-		if (addr > INT_MAX)
-			WARN(1, "would truncate bmap result\n");
-		else
-			*bno = addr;
+		*bno = addr;
 	}
 	return 0;
 }
-- 
2.20.1

