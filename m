Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1851451F7DC
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 11:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbiEIJV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 05:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236201AbiEIIvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 04:51:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DF61FD1F4
        for <stable@vger.kernel.org>; Mon,  9 May 2022 01:47:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AA9261447
        for <stable@vger.kernel.org>; Mon,  9 May 2022 08:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D55C385A8;
        Mon,  9 May 2022 08:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652086062;
        bh=mD1jKOYYSwfggyNX3ms5Rwu1udpjVpaBViYR1bJT0cY=;
        h=Subject:To:Cc:From:Date:From;
        b=PRDsRacA9EXUsQp9nbePQTyBV1Q8tyKH6tMoKSO36q/01UK6O4YIH2TF7CE0PCitb
         1I/6UQbvZO9bE7NrJ9t9otxcSHW+e7C/amdNNw7gjlGfoQLmguv1K11gEG4HKfqBec
         yPlyPrNw8Olt6F9QXjG2Rum5bnePhBB9DZcOzmE4=
Subject: FAILED: patch "[PATCH] btrfs: do not allow compression on nodatacow files" failed to apply to 5.10-stable tree
To:     cccheng@synology.com, dsterba@suse.com, fdmanana@suse.com,
        jaycelin@synology.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 10:47:31 +0200
Message-ID: <165208605158163@kroah.com>
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

From 0e852ab8974cd2b5946766b2d9baf82c78ace03d Mon Sep 17 00:00:00 2001
From: Chung-Chiang Cheng <cccheng@synology.com>
Date: Fri, 15 Apr 2022 16:04:06 +0800
Subject: [PATCH] btrfs: do not allow compression on nodatacow files

Compression and nodatacow are mutually exclusive. A similar issue was
fixed by commit f37c563bab429 ("btrfs: add missing check for nocow and
compression inode flags"). Besides ioctl, there is another way to
enable/disable/reset compression directly via xattr. The following
steps will result in a invalid combination.

  $ touch bar
  $ chattr +C bar
  $ lsattr bar
  ---------------C-- bar
  $ setfattr -n btrfs.compression -v zstd bar
  $ lsattr bar
  --------c------C-- bar

To align with the logic in check_fsflags, nocompress will also be
unacceptable after this patch, to prevent mix any compression-related
options with nodatacow.

  $ touch bar
  $ chattr +C bar
  $ lsattr bar
  ---------------C-- bar
  $ setfattr -n btrfs.compression -v zstd bar
  setfattr: bar: Invalid argument
  $ setfattr -n btrfs.compression -v no bar
  setfattr: bar: Invalid argument

When both compression and nodatacow are enabled, then
btrfs_run_delalloc_range prefers nodatacow and no compression happens.

Reported-by: Jayce Lin <jaycelin@synology.com>
CC: stable@vger.kernel.org # 5.10.x: e6f9d6964802: btrfs: export a helper for compression hard check
CC: stable@vger.kernel.org # 5.10.x
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Chung-Chiang Cheng <cccheng@synology.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 1a6d2d5b4b33..5a6f87744c28 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -17,7 +17,8 @@ static DEFINE_HASHTABLE(prop_handlers_ht, BTRFS_PROP_HANDLERS_HT_BITS);
 struct prop_handler {
 	struct hlist_node node;
 	const char *xattr_name;
-	int (*validate)(const char *value, size_t len);
+	int (*validate)(const struct btrfs_inode *inode, const char *value,
+			size_t len);
 	int (*apply)(struct inode *inode, const char *value, size_t len);
 	const char *(*extract)(struct inode *inode);
 	int inheritable;
@@ -55,7 +56,8 @@ find_prop_handler(const char *name,
 	return NULL;
 }
 
-int btrfs_validate_prop(const char *name, const char *value, size_t value_len)
+int btrfs_validate_prop(const struct btrfs_inode *inode, const char *name,
+			const char *value, size_t value_len)
 {
 	const struct prop_handler *handler;
 
@@ -69,7 +71,7 @@ int btrfs_validate_prop(const char *name, const char *value, size_t value_len)
 	if (value_len == 0)
 		return 0;
 
-	return handler->validate(value, value_len);
+	return handler->validate(inode, value, value_len);
 }
 
 int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
@@ -252,8 +254,12 @@ int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path)
 	return ret;
 }
 
-static int prop_compression_validate(const char *value, size_t len)
+static int prop_compression_validate(const struct btrfs_inode *inode,
+				     const char *value, size_t len)
 {
+	if (!btrfs_inode_can_compress(inode))
+		return -EINVAL;
+
 	if (!value)
 		return 0;
 
@@ -364,7 +370,7 @@ static int inherit_props(struct btrfs_trans_handle *trans,
 		 * This is not strictly necessary as the property should be
 		 * valid, but in case it isn't, don't propagate it further.
 		 */
-		ret = h->validate(value, strlen(value));
+		ret = h->validate(BTRFS_I(inode), value, strlen(value));
 		if (ret)
 			continue;
 
diff --git a/fs/btrfs/props.h b/fs/btrfs/props.h
index 40b2c65b518c..2b2ac15ab788 100644
--- a/fs/btrfs/props.h
+++ b/fs/btrfs/props.h
@@ -13,7 +13,8 @@ void __init btrfs_props_init(void);
 int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 		   const char *name, const char *value, size_t value_len,
 		   int flags);
-int btrfs_validate_prop(const char *name, const char *value, size_t value_len);
+int btrfs_validate_prop(const struct btrfs_inode *inode, const char *name,
+			const char *value, size_t value_len);
 
 int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path);
 
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 99abf41b89b9..9632d0ff2038 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -403,7 +403,7 @@ static int btrfs_xattr_handler_set_prop(const struct xattr_handler *handler,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
 	name = xattr_full_name(handler, name);
-	ret = btrfs_validate_prop(name, value, size);
+	ret = btrfs_validate_prop(BTRFS_I(inode), name, value, size);
 	if (ret)
 		return ret;
 

