Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF6C1FF94D
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 18:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgFRQdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 12:33:22 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:56369 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726928AbgFRQdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 12:33:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 1E97C9DE;
        Thu, 18 Jun 2020 12:33:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 12:33:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=lS10pT
        NtD48hUDR7gs2XCpjA2VdPc1vN/4oF/di4bMM=; b=E6a00kNEw/SJMHMWLYTDBF
        MoblXPzifS+AfyyxA56CTSk0mqo09vM26d4i5FSZgKNcRueLIzDH/8zSAzbkEO6g
        Eka4Xfj5lgcYV8A6JtrzqV0NeeVz18dHH2egUAG0etBJJYp380OXuSsMjX9kdDG9
        UCalACtlrhIaxjqQNPr9eVRuuQfoRQtzoL+SJp+pXC6ylhSj4pvCAbsmQkvtQGIn
        0PROeSCC4qDqFy8PB9JsMEaEeG8xU2Gi+VzBts1sohUdOxx2gg9vcZgxSRdGnpzI
        yXO5rMDHjJKcI8MPDwrpcBiG6aSBM1H+gE5yZgL1WAY9bLhY3wKUzd+zHIuzx/4Q
        ==
X-ME-Sender: <xms:TpfrXrB0Ex6WoaN5a8sztEizBwL0CFqPjnXTc4hNpNDb8fHsEdeF0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejgedguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:TpfrXhjrVMMUmmoASAUAOG_Y_wF7kbSfY6Mxm0wn5cGtmA8ouZlpoA>
    <xmx:TpfrXmkB4Pd1yF57vka3w_76BhDSVhjbhMoL3gSxDIT5asVIWdA5zA>
    <xmx:TpfrXtxbVGsJvunDHOHZjGl6Zc6Z_xr_OFVKlPFluDN4WX8E2scdkA>
    <xmx:TpfrXvNoMj6-puDPXoBzae4ahI_ZonsKBs_WWDFXs_j69s723t5bWzWQ4f8>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 15DA93280068;
        Thu, 18 Jun 2020 12:33:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: fix race between ext4_sync_parent() and rename()" failed to apply to 4.4-stable tree
To:     ebiggers@google.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 18:33:10 +0200
Message-ID: <159249799084104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 08adf452e628b0e2ce9a01048cfbec52353703d7 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Wed, 6 May 2020 11:31:40 -0700
Subject: [PATCH] ext4: fix race between ext4_sync_parent() and rename()

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

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index e10206e7f4bb..093c359952cd 100644
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
@@ -76,7 +74,7 @@ static int ext4_sync_parent(struct inode *inode)
 		if (ret)
 			break;
 	}
-	iput(inode);
+	dput(dentry);
 	return ret;
 }
 

