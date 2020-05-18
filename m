Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACB71D8327
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731993AbgERSCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732509AbgERSCY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:02:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A62D0207F5;
        Mon, 18 May 2020 18:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824944;
        bh=u9GjzKj/aPiAqe3X8tN9HEszZ3EIsc2zXBSCISpLFQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ws8W+siLZ9H52tW4RTsOZhUech6ihnnlNrW4I5nLzpr9Ln5Wuysn6q1B344n61BVS
         ktadE0KM2vsxNYBSiVi+/L2e36tzAe704jvpOOFrJJ+djrtGG7QUnxRWHk8OP6zfd5
         9DC+7W4YvpsSsmqjCb971+wee70BZcmEBCiSS8k0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ritesh Harjani <riteshh@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 066/194] fibmap: Warn and return an error in case of block > INT_MAX
Date:   Mon, 18 May 2020 19:35:56 +0200
Message-Id: <20200518173537.221590529@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



