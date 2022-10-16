Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F1A5FFF81
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 15:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJPNU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 09:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiJPNUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 09:20:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0286F32DA1
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 06:20:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 70648CE0DA2
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F60C433D6;
        Sun, 16 Oct 2022 13:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665926450;
        bh=E0OdE84Cg2XZO1pn1r+yk5hRKI5mTPDLYX4SoPRoe0Q=;
        h=Subject:To:Cc:From:Date:From;
        b=JsEYkEPDioipmmLb0uKPvpf59Jyg3KAkhHUa+a5DJ4cY0PgbBMv4B7eh3rwQOUd38
         jbSieMfIGIXem/x/uWRGU5yIx7qdeGY+mBzfdV0xGdo/WIihF3p4SvV51MlPMB5A4n
         fwZ5SGAJZn/cIPVoLPT3JW+eN9vCrvANkSF0qsAc=
Subject: FAILED: patch "[PATCH] ext4: fix i_version handling in ext4" failed to apply to 5.10-stable tree
To:     jlayton@kernel.org, brauner@kernel.org, jack@suse.cz,
        lczerner@redhat.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 15:21:36 +0200
Message-ID: <1665926496248202@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

a642c2c0827f ("ext4: fix i_version handling in ext4")
1ff20307393e ("ext4: unconditionally enable the i_version counter")
50f094a5580e ("ext4: don't increase iversion counter for ea_inodes")
960e0ab63b2e ("ext4: fix i_version handling on remount")
4437992be7ca ("ext4: remove lazytime/nolazytime mount options handled by MS_LAZYTIME")
cebe85d570cf ("ext4: switch to the new mount api")
02f960f8db1c ("ext4: clean up return values in handle_mount_opt()")
7edfd85b1ffd ("ext4: Completely separate options parsing and sb setup")
6e47a3cc68fc ("ext4: get rid of super block and sbi from handle_mount_ops()")
b6bd243500b6 ("ext4: check ext2/3 compatibility outside handle_mount_opt()")
e6e268cb6822 ("ext4: move quota configuration out of handle_mount_opt()")
da812f611934 ("ext4: Allow sb to be NULL in ext4_msg()")
461c3af045d3 ("ext4: Change handle_mount_opt() to use fs_parameter")
4c94bff967d9 ("ext4: move option validation to a separate function")
e5a185c26c11 ("ext4: Add fs parameter specifications for mount options")
9a089b21f79b ("ext4: Send notifications on error")
2e5fd489a4e5 ("Merge tag 'libnvdimm-for-5.15' of git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a642c2c0827f5604a93f9fa1e5701eecdce4ae22 Mon Sep 17 00:00:00 2001
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 8 Sep 2022 13:24:42 -0400
Subject: [PATCH] ext4: fix i_version handling in ext4

ext4 currently updates the i_version counter when the atime is updated
during a read. This is less than ideal as it can cause unnecessary cache
invalidations with NFSv4 and unnecessary remeasurements for IMA.

The increment in ext4_mark_iloc_dirty is also problematic since it can
corrupt the i_version counter for ea_inodes. We aren't bumping the file
times in ext4_mark_iloc_dirty, so changing the i_version there seems
wrong, and is the cause of both problems.

Remove that callsite and add increments to the setattr, setxattr and
ioctl codepaths, at the same times that we update the ctime. The
i_version bump that already happens during timestamp updates should take
care of the rest.

In ext4_move_extents, increment the i_version on both inodes, and also
add in missing ctime updates.

[ Some minor updates since we've already enabled the i_version counter
  unconditionally already via another patch series. -- TYT ]

Cc: stable@kernel.org
Cc: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20220908172448.208585-3-jlayton@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a56c57375456..6da73be32bff 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5349,6 +5349,7 @@ int ext4_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 	int error, rc = 0;
 	int orphan = 0;
 	const unsigned int ia_valid = attr->ia_valid;
+	bool inc_ivers = true;
 
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
 		return -EIO;
@@ -5432,8 +5433,8 @@ int ext4_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 			return -EINVAL;
 		}
 
-		if (attr->ia_size != inode->i_size)
-			inode_inc_iversion(inode);
+		if (attr->ia_size == inode->i_size)
+			inc_ivers = false;
 
 		if (shrink) {
 			if (ext4_should_order_data(inode)) {
@@ -5535,6 +5536,8 @@ int ext4_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 	}
 
 	if (!error) {
+		if (inc_ivers)
+			inode_inc_iversion(inode);
 		setattr_copy(mnt_userns, inode, attr);
 		mark_inode_dirty(inode);
 	}
@@ -5738,13 +5741,6 @@ int ext4_mark_iloc_dirty(handle_t *handle,
 	}
 	ext4_fc_track_inode(handle, inode);
 
-	/*
-	 * ea_inodes are using i_version for storing reference count, don't
-	 * mess with it
-	 */
-	if (!(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL))
-		inode_inc_iversion(inode);
-
 	/* the do_update_inode consumes one bh->b_count */
 	get_bh(iloc->bh);
 
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 3cf3ec4b1c21..ad3a294a88eb 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -452,6 +452,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	swap_inode_data(inode, inode_bl);
 
 	inode->i_ctime = inode_bl->i_ctime = current_time(inode);
+	inode_inc_iversion(inode);
 
 	inode->i_generation = prandom_u32();
 	inode_bl->i_generation = prandom_u32();
@@ -665,6 +666,7 @@ static int ext4_ioctl_setflags(struct inode *inode,
 	ext4_set_inode_flags(inode, false);
 
 	inode->i_ctime = current_time(inode);
+	inode_inc_iversion(inode);
 
 	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
 flags_err:
@@ -775,6 +777,7 @@ static int ext4_ioctl_setproject(struct inode *inode, __u32 projid)
 
 	EXT4_I(inode)->i_projid = kprojid;
 	inode->i_ctime = current_time(inode);
+	inode_inc_iversion(inode);
 out_dirty:
 	rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
 	if (!err)
@@ -1257,6 +1260,7 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		err = ext4_reserve_inode_write(handle, inode, &iloc);
 		if (err == 0) {
 			inode->i_ctime = current_time(inode);
+			inode_inc_iversion(inode);
 			inode->i_generation = generation;
 			err = ext4_mark_iloc_dirty(handle, inode, &iloc);
 		}
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 533216e80fa2..36d6ba7190b6 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2412,6 +2412,7 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 	if (!error) {
 		ext4_xattr_update_super_block(handle, inode->i_sb);
 		inode->i_ctime = current_time(inode);
+		inode_inc_iversion(inode);
 		if (!value)
 			no_expand = 0;
 		error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);

