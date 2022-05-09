Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D0B51F7DF
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 11:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbiEIJWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 05:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236528AbiEIIv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 04:51:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB82B1FD877
        for <stable@vger.kernel.org>; Mon,  9 May 2022 01:48:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5A3DECE135F
        for <stable@vger.kernel.org>; Mon,  9 May 2022 08:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8AAC385A8;
        Mon,  9 May 2022 08:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652086080;
        bh=Op+ZMwlBsqt5PN4VnOwvg0x9yDf/TjQHYrti5TUM9rU=;
        h=Subject:To:Cc:From:Date:From;
        b=iL3cUGn8G94byTqFIozCXeXbAiq9y6qevzE8U3jJ/0xjYbnr+cZYnSThzsTxevEZA
         PwKAuPzAnZD8S8kvOxi5hohVH5Bn+Oo6wJdRoOIjJHRzViI84kZREQ9yid1BjDE3pR
         U411PtWCRf5NyeoZy5ibM/ChDVHWnhN+rQiCTius=
Subject: FAILED: patch "[PATCH] btrfs: skip compression property for anything other than" failed to apply to 5.10-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 10:47:50 +0200
Message-ID: <165208607031112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4b73c55fdebd8939f0f6000921075f7f6fa41397 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Thu, 21 Apr 2022 11:01:22 +0100
Subject: [PATCH] btrfs: skip compression property for anything other than
 files and dirs

The compression property only has effect on regular files and directories
(so that it's propagated to files and subdirectories created inside a
directory). For any other inode type (symlink, fifo, device, socket),
it's pointless to set the compression property because it does nothing
and ends up unnecessarily wasting leaf space due to the pointless xattr
(75 or 76 bytes, depending on the compression value). Symlinks in
particular are very common (for example, I have almost 10k symlinks under
/etc, /usr and /var alone) and therefore it's worth to avoid wasting
leaf space with the compression xattr.

For example, the compression property can end up on a symlink or character
device implicitly, through inheritance from a parent directory

  $ mkdir /mnt/testdir
  $ btrfs property set /mnt/testdir compression lzo

  $ ln -s yadayada /mnt/testdir/lnk
  $ mknod /mnt/testdir/dev c 0 0

Or explicitly like this:

  $ ln -s yadayda /mnt/lnk
  $ setfattr -h -n btrfs.compression -v lzo /mnt/lnk

So skip the compression property on inodes that are neither a regular
file nor a directory.

CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 5a6f87744c28..1b31481f9e72 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -21,6 +21,7 @@ struct prop_handler {
 			size_t len);
 	int (*apply)(struct inode *inode, const char *value, size_t len);
 	const char *(*extract)(struct inode *inode);
+	bool (*ignore)(const struct btrfs_inode *inode);
 	int inheritable;
 };
 
@@ -74,6 +75,28 @@ int btrfs_validate_prop(const struct btrfs_inode *inode, const char *name,
 	return handler->validate(inode, value, value_len);
 }
 
+/*
+ * Check if a property should be ignored (not set) for an inode.
+ *
+ * @inode:     The target inode.
+ * @name:      The property's name.
+ *
+ * The caller must be sure the given property name is valid, for example by
+ * having previously called btrfs_validate_prop().
+ *
+ * Returns:    true if the property should be ignored for the given inode
+ *             false if the property must not be ignored for the given inode
+ */
+bool btrfs_ignore_prop(const struct btrfs_inode *inode, const char *name)
+{
+	const struct prop_handler *handler;
+
+	handler = find_prop_handler(name, NULL);
+	ASSERT(handler != NULL);
+
+	return handler->ignore(inode);
+}
+
 int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 		   const char *name, const char *value, size_t value_len,
 		   int flags)
@@ -316,6 +339,22 @@ static int prop_compression_apply(struct inode *inode, const char *value,
 	return 0;
 }
 
+static bool prop_compression_ignore(const struct btrfs_inode *inode)
+{
+	/*
+	 * Compression only has effect for regular files, and for directories
+	 * we set it just to propagate it to new files created inside them.
+	 * Everything else (symlinks, devices, sockets, fifos) is pointless as
+	 * it will do nothing, so don't waste metadata space on a compression
+	 * xattr for anything that is neither a file nor a directory.
+	 */
+	if (!S_ISREG(inode->vfs_inode.i_mode) &&
+	    !S_ISDIR(inode->vfs_inode.i_mode))
+		return true;
+
+	return false;
+}
+
 static const char *prop_compression_extract(struct inode *inode)
 {
 	switch (BTRFS_I(inode)->prop_compress) {
@@ -336,6 +375,7 @@ static struct prop_handler prop_handlers[] = {
 		.validate = prop_compression_validate,
 		.apply = prop_compression_apply,
 		.extract = prop_compression_extract,
+		.ignore = prop_compression_ignore,
 		.inheritable = 1
 	},
 };
@@ -362,6 +402,9 @@ static int inherit_props(struct btrfs_trans_handle *trans,
 		if (!h->inheritable)
 			continue;
 
+		if (h->ignore(BTRFS_I(inode)))
+			continue;
+
 		value = h->extract(parent);
 		if (!value)
 			continue;
diff --git a/fs/btrfs/props.h b/fs/btrfs/props.h
index 2b2ac15ab788..59bea741cfcf 100644
--- a/fs/btrfs/props.h
+++ b/fs/btrfs/props.h
@@ -15,6 +15,7 @@ int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 		   int flags);
 int btrfs_validate_prop(const struct btrfs_inode *inode, const char *name,
 			const char *value, size_t value_len);
+bool btrfs_ignore_prop(const struct btrfs_inode *inode, const char *name);
 
 int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path);
 
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 367bb87b66df..85691dc2232f 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -408,6 +408,9 @@ static int btrfs_xattr_handler_set_prop(const struct xattr_handler *handler,
 	if (ret)
 		return ret;
 
+	if (btrfs_ignore_prop(BTRFS_I(inode), name))
+		return 0;
+
 	trans = btrfs_start_transaction(root, 2);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);

