Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A5E201067
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404771AbgFSPaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404408AbgFSPaH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:30:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87CC121D79;
        Fri, 19 Jun 2020 15:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580606;
        bh=biZxo7xIfF834z9nqNS71nzofZ7r6Uqho9xZzSIhqPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/M4uGwE4cFSiLPvH4M0BCwwOH0UDMR2e7KdhdMgxQda9UrkWO+baqRn7ue9+jVVs
         3VdL20tpM5PQTGi89gLUpbY0UWJ+5nnlrJ6m03a0uHVrtqrJCLXa2+xHjlr+/02sIS
         sorhIKrMGn9SaXdscFTSIbsflBqIf3bU3P9BX+9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.7 283/376] ext4: fix race between ext4_sync_parent() and rename()
Date:   Fri, 19 Jun 2020 16:33:21 +0200
Message-Id: <20200619141723.728742706@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 08adf452e628b0e2ce9a01048cfbec52353703d7 upstream.

'igrab(d_inode(dentry->d_parent))' without holding dentry->d_lock is
broken because without d_lock, d_parent can be concurrently changed due
to a rename().  Then if the old directory is immediately deleted, old
d_parent->inode can be NULL.  That causes a NULL dereference in igrab().

To fix this, use dget_parent() to safely grab a reference to the parent
dentry, which pins the inode.  This also eliminates the need to use
d_find_any_alias() other than for the initial inode, as we no longer
throw away the dentry at each step.

This is an extremely hard race to hit, but it is possible.  Adding a
udelay() in between the reads of ->d_parent and its ->d_inode makes it
reproducible on a no-journal filesystem using the following program:

    #include <fcntl.h>
    #include <unistd.h>

    int main()
    {
        if (fork()) {
            for (;;) {
                mkdir("dir1", 0700);
                int fd = open("dir1/file", O_RDWR|O_CREAT|O_SYNC);
                write(fd, "X", 1);
                close(fd);
            }
        } else {
            mkdir("dir2", 0700);
            for (;;) {
                rename("dir1/file", "dir2/file");
                rmdir("dir1");
            }
        }
    }

Fixes: d59729f4e794 ("ext4: fix races in ext4_sync_parent()")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20200506183140.541194-1-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/fsync.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -44,30 +44,28 @@
  */
 static int ext4_sync_parent(struct inode *inode)
 {
-	struct dentry *dentry = NULL;
-	struct inode *next;
+	struct dentry *dentry, *next;
 	int ret = 0;
 
 	if (!ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY))
 		return 0;
-	inode = igrab(inode);
+	dentry = d_find_any_alias(inode);
+	if (!dentry)
+		return 0;
 	while (ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY)) {
 		ext4_clear_inode_state(inode, EXT4_STATE_NEWENTRY);
-		dentry = d_find_any_alias(inode);
-		if (!dentry)
-			break;
-		next = igrab(d_inode(dentry->d_parent));
+
+		next = dget_parent(dentry);
 		dput(dentry);
-		if (!next)
-			break;
-		iput(inode);
-		inode = next;
+		dentry = next;
+		inode = dentry->d_inode;
+
 		/*
 		 * The directory inode may have gone through rmdir by now. But
 		 * the inode itself and its blocks are still allocated (we hold
-		 * a reference to the inode so it didn't go through
-		 * ext4_evict_inode()) and so we are safe to flush metadata
-		 * blocks and the inode.
+		 * a reference to the inode via its dentry), so it didn't go
+		 * through ext4_evict_inode()) and so we are safe to flush
+		 * metadata blocks and the inode.
 		 */
 		ret = sync_mapping_buffers(inode->i_mapping);
 		if (ret)
@@ -76,7 +74,7 @@ static int ext4_sync_parent(struct inode
 		if (ret)
 			break;
 	}
-	iput(inode);
+	dput(dentry);
 	return ret;
 }
 


