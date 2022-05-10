Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD945219CB
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244799AbiEJNvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343711AbiEJNsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:48:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56772D9EFA;
        Tue, 10 May 2022 06:36:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E966618CF;
        Tue, 10 May 2022 13:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33039C385C2;
        Tue, 10 May 2022 13:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189805;
        bh=7EOlkagCuaSCpsJRB/bfcScFi2TgH0RRwlzbd6ObCfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SH/4e6y/z52RDM+H9Q5YNYT4b+dDWDILmQ1dIdlGcX4oIqS8wxJUcmwUnAyHDEsPg
         HJX4lzPkHHkoqwg9zwexfZUIpOz/y29GI55kaOCHylxEBAPbz/7F2Ow5F83/cBHkld
         6vyxM3C1CALFM21/hCtqXXzoUAf0wNdWwlTOQMpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 033/140] btrfs: skip compression property for anything other than files and dirs
Date:   Tue, 10 May 2022 15:07:03 +0200
Message-Id: <20220510130742.563550943@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 4b73c55fdebd8939f0f6000921075f7f6fa41397 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/props.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/props.h |    1 +
 fs/btrfs/xattr.c |    3 +++
 3 files changed, 47 insertions(+)

--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -21,6 +21,7 @@ struct prop_handler {
 			size_t len);
 	int (*apply)(struct inode *inode, const char *value, size_t len);
 	const char *(*extract)(struct inode *inode);
+	bool (*ignore)(const struct btrfs_inode *inode);
 	int inheritable;
 };
 
@@ -74,6 +75,28 @@ int btrfs_validate_prop(const struct btr
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
@@ -316,6 +339,22 @@ static int prop_compression_apply(struct
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
@@ -336,6 +375,7 @@ static struct prop_handler prop_handlers
 		.validate = prop_compression_validate,
 		.apply = prop_compression_apply,
 		.extract = prop_compression_extract,
+		.ignore = prop_compression_ignore,
 		.inheritable = 1
 	},
 };
@@ -362,6 +402,9 @@ static int inherit_props(struct btrfs_tr
 		if (!h->inheritable)
 			continue;
 
+		if (h->ignore(BTRFS_I(inode)))
+			continue;
+
 		value = h->extract(parent);
 		if (!value)
 			continue;
--- a/fs/btrfs/props.h
+++ b/fs/btrfs/props.h
@@ -15,6 +15,7 @@ int btrfs_set_prop(struct btrfs_trans_ha
 		   int flags);
 int btrfs_validate_prop(const struct btrfs_inode *inode, const char *name,
 			const char *value, size_t value_len);
+bool btrfs_ignore_prop(const struct btrfs_inode *inode, const char *name);
 
 int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path);
 
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -408,6 +408,9 @@ static int btrfs_xattr_handler_set_prop(
 	if (ret)
 		return ret;
 
+	if (btrfs_ignore_prop(BTRFS_I(inode), name))
+		return 0;
+
 	trans = btrfs_start_transaction(root, 2);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);


