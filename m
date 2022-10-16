Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870E05FFF19
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 14:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJPMYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 08:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiJPMYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 08:24:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD78B7F9
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 05:24:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFFE860B55
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 12:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB89C433D6;
        Sun, 16 Oct 2022 12:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665923068;
        bh=Bf8LWqjZRfpj2I2wL/zV/9uhZ+ooxjFHXgqVei1ZH/U=;
        h=Subject:To:Cc:From:Date:From;
        b=S+zcvSm3toWK/JsFYaQYw4Y2eiTSYufGY9WisdAW3uwCUFNIU9J4OjOuDUSGZcSqF
         hboT7oWAW6osHtaP0B2gVbEF+UWdykvNqJBZNPqH2eQga9dnjR7d+u/YfXoVzW3/DB
         09VX5/06mkeSI5OflruFvX02BR/pblBb9Q3Sik50=
Subject: FAILED: patch "[PATCH] btrfs: enhance unsupported compat RO flags handling" failed to apply to 4.14-stable tree
To:     wqu@suse.com, dsterba@suse.com, nborisov@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 14:25:01 +0200
Message-ID: <1665923101120132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

81d5d61454c3 ("btrfs: enhance unsupported compat RO flags handling")
dfe8aec4520b ("btrfs: add a btrfs_block_group_root() helper")
b6e9f16c5fda ("btrfs: replace open coded while loop with proper construct")
42437a6386ff ("btrfs: introduce mount option rescue=ignorebadroots")
68319c18cb21 ("btrfs: show rescue=usebackuproot in /proc/mounts")
ab0b4a3ebf14 ("btrfs: add a helper to print out rescue= options")
ceafe3cc3992 ("btrfs: sysfs: export supported rescue= mount options")
334c16d82cfe ("btrfs: push the NODATASUM check into btrfs_lookup_bio_sums")
d70bf7484f72 ("btrfs: unify the ro checking for mount options")
7573df5547c0 ("btrfs: sysfs: export supported send stream version")
3ef3959b29c4 ("btrfs: don't show full path of bind mounts in subvol=")
74ef00185eb8 ("btrfs: introduce "rescue=" mount option")
e3ba67a108ff ("btrfs: factor out reading of bg from find_frist_block_group")
89d7da9bc592 ("btrfs: get mapping tree directly from fsinfo in find_first_block_group")
c730ae0c6bb3 ("btrfs: convert comments to fallthrough annotations")
aeb935a45581 ("btrfs: don't set SHAREABLE flag for data reloc tree")
92a7cc425223 ("btrfs: rename BTRFS_ROOT_REF_COWS to BTRFS_ROOT_SHAREABLE")
3be4d8efe3cf ("btrfs: block-group: rename write_one_cache_group()")
97f4728af888 ("btrfs: block-group: refactor how we insert a block group item")
7357623a7f4b ("btrfs: block-group: refactor how we delete one block group item")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 81d5d61454c365718655cfc87d8200c84e25d596 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Tue, 9 Aug 2022 13:02:16 +0800
Subject: [PATCH] btrfs: enhance unsupported compat RO flags handling

Currently there are two corner cases not handling compat RO flags
correctly:

- Remount
  We can still mount the fs RO with compat RO flags, then remount it RW.
  We should not allow any write into a fs with unsupported RO flags.

- Still try to search block group items
  In fact, behavior/on-disk format change to extent tree should not
  need a full incompat flag.

  And since we can ensure fs with unsupported RO flags never got any
  writes (with above case fixed), then we can even skip block group
  items search at mount time.

This patch will enhance the unsupported RO compat flags by:

- Reject read-write remount if there are unsupported RO compat flags

- Go dummy block group items directly for unsupported RO compat flags
  In fact, only changes to chunk/subvolume/root/csum trees should go
  incompat flags.

The latter part should allow future change to extent tree to be compat
RO flags.

Thus this patch also needs to be backported to all stable trees.

CC: stable@vger.kernel.org # 4.9+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 53c44c52cb79..e7b5a54c8258 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2164,7 +2164,16 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 	int need_clear = 0;
 	u64 cache_gen;
 
-	if (!root)
+	/*
+	 * Either no extent root (with ibadroots rescue option) or we have
+	 * unsupported RO options. The fs can never be mounted read-write, so no
+	 * need to waste time searching block group items.
+	 *
+	 * This also allows new extent tree related changes to be RO compat,
+	 * no need for a full incompat flag.
+	 */
+	if (!root || (btrfs_super_compat_ro_flags(info->super_copy) &
+		      ~BTRFS_FEATURE_COMPAT_RO_SUPP))
 		return fill_dummy_bgs(info);
 
 	key.objectid = 0;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 7291e9d67e92..eb0ae7e396ef 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2117,6 +2117,15 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 			ret = -EINVAL;
 			goto restore;
 		}
+		if (btrfs_super_compat_ro_flags(fs_info->super_copy) &
+		    ~BTRFS_FEATURE_COMPAT_RO_SUPP) {
+			btrfs_err(fs_info,
+		"can not remount read-write due to unsupported optional flags 0x%llx",
+				btrfs_super_compat_ro_flags(fs_info->super_copy) &
+				~BTRFS_FEATURE_COMPAT_RO_SUPP);
+			ret = -EINVAL;
+			goto restore;
+		}
 		if (fs_info->fs_devices->rw_devices == 0) {
 			ret = -EACCES;
 			goto restore;

