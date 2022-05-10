Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5645219D7
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244969AbiEJNvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343661AbiEJNsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:48:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C4E2B0330;
        Tue, 10 May 2022 06:36:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44820618CC;
        Tue, 10 May 2022 13:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7F7C385C2;
        Tue, 10 May 2022 13:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189802;
        bh=bgz/2X6IG8w921/J81l1uzDT8qcoLY0061kOj25IVSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rfZYkbOr3aeC92coeC6CJKSooa75ey1GlM8F9XCPJLHI2IterQ4vUiuJFuciUA1Xr
         cIaKl2kuvDpPX1VPnw2+COvUTexVzYBA+UIJFSy40XscmW0gaPGkr8XjrqtJNUfFHx
         Ys7stk7+RGySewiiVYPJ+Rb8S1a3oLd486OE1Q3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jayce Lin <jaycelin@synology.com>,
        Filipe Manana <fdmanana@suse.com>,
        Chung-Chiang Cheng <cccheng@synology.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 032/140] btrfs: do not allow compression on nodatacow files
Date:   Tue, 10 May 2022 15:07:02 +0200
Message-Id: <20220510130742.533607158@linuxfoundation.org>
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

From: Chung-Chiang Cheng <cccheng@synology.com>

commit 0e852ab8974cd2b5946766b2d9baf82c78ace03d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/props.c |   16 +++++++++++-----
 fs/btrfs/props.h |    3 ++-
 fs/btrfs/xattr.c |    2 +-
 3 files changed, 14 insertions(+), 7 deletions(-)

--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -17,7 +17,8 @@ static DEFINE_HASHTABLE(prop_handlers_ht
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
 
@@ -69,7 +71,7 @@ int btrfs_validate_prop(const char *name
 	if (value_len == 0)
 		return 0;
 
-	return handler->validate(value, value_len);
+	return handler->validate(inode, value, value_len);
 }
 
 int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
@@ -252,8 +254,12 @@ int btrfs_load_inode_props(struct inode
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
 
@@ -364,7 +370,7 @@ static int inherit_props(struct btrfs_tr
 		 * This is not strictly necessary as the property should be
 		 * valid, but in case it isn't, don't propagate it further.
 		 */
-		ret = h->validate(value, strlen(value));
+		ret = h->validate(BTRFS_I(inode), value, strlen(value));
 		if (ret)
 			continue;
 
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
 
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -404,7 +404,7 @@ static int btrfs_xattr_handler_set_prop(
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
 	name = xattr_full_name(handler, name);
-	ret = btrfs_validate_prop(name, value, size);
+	ret = btrfs_validate_prop(BTRFS_I(inode), name, value, size);
 	if (ret)
 		return ret;
 


