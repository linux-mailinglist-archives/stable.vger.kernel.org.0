Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C855FFF7F
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 15:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiJPNUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 09:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiJPNUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 09:20:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B44024F20
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 06:20:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F82FB80CB8
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C68FC433D6;
        Sun, 16 Oct 2022 13:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665926398;
        bh=ZBQ6rcUIdI7OYtWx1beZ4UBNbC3W4+fx3up+4XM8IBs=;
        h=Subject:To:Cc:From:Date:From;
        b=0P/i34ud3Sw+qq+QdzUBATtug3fVsyaxcfwAGp2UeRExyAjxOUMrW0OrY4tB6YDYw
         /BkF4BRtBmehX9u25/B8EE+rDlr01qU5y9mRA8hgQFAr7Ug3VVzdKuQsm5DjzVm0LH
         74U+HW5MkibSCLJbvzBwl7c6G9lTVGB7A1B9HuMU=
Subject: FAILED: patch "[PATCH] ext4: unconditionally enable the i_version counter" failed to apply to 5.15-stable tree
To:     jlayton@kernel.org, bcodding@redhat.com, brauner@kernel.org,
        david@fromorbit.com, djwong@kernel.org, hch@infradead.org,
        jack@suse.cz, lczerner@redhat.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 15:20:37 +0200
Message-ID: <166592643719321@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

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

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1ff20307393e17dc57fde62226df625a3a3c36e9 Mon Sep 17 00:00:00 2001
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 24 Aug 2022 18:03:49 +0200
Subject: [PATCH] ext4: unconditionally enable the i_version counter

The original i_version implementation was pretty expensive, requiring a
log flush on every change. Because of this, it was gated behind a mount
option (implemented via the MS_I_VERSION mountoption flag).

Commit ae5e165d855d (fs: new API for handling inode->i_version) made the
i_version flag much less expensive, so there is no longer a performance
penalty from enabling it. xfs and btrfs already enable it
unconditionally when the on-disk format can support it.

Have ext4 ignore the SB_I_VERSION flag, and just enable it
unconditionally.  While we're in here, mark the i_version mount
option Opt_removed.

[ Removed leftover bits of i_version from ext4_apply_options() since it
  now can't ever be set in ctx->mask_s_flags -- lczerner ]

Cc: stable@kernel.org
Cc: Dave Chinner <david@fromorbit.com>
Cc: Benjamin Coddington <bcodding@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220824160349.39664-3-lczerner@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2a220be34caa..c77d40f05763 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5425,7 +5425,7 @@ int ext4_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 			return -EINVAL;
 		}
 
-		if (IS_I_VERSION(inode) && attr->ia_size != inode->i_size)
+		if (attr->ia_size != inode->i_size)
 			inode_inc_iversion(inode);
 
 		if (shrink) {
@@ -5735,8 +5735,7 @@ int ext4_mark_iloc_dirty(handle_t *handle,
 	 * ea_inodes are using i_version for storing reference count, don't
 	 * mess with it
 	 */
-	if (IS_I_VERSION(inode) &&
-	    !(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL))
+	if (!(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL))
 		inode_inc_iversion(inode);
 
 	/* the do_update_inode consumes one bh->b_count */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6bb0f493221c..2a7af6cbe5e0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1585,7 +1585,7 @@ enum {
 	Opt_inlinecrypt,
 	Opt_usrjquota, Opt_grpjquota, Opt_quota,
 	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
-	Opt_usrquota, Opt_grpquota, Opt_prjquota, Opt_i_version,
+	Opt_usrquota, Opt_grpquota, Opt_prjquota,
 	Opt_dax, Opt_dax_always, Opt_dax_inode, Opt_dax_never,
 	Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_warn_on_error,
 	Opt_nowarn_on_error, Opt_mblk_io_submit, Opt_debug_want_extra_isize,
@@ -1692,7 +1692,7 @@ static const struct fs_parameter_spec ext4_param_specs[] = {
 	fsparam_flag	("barrier",		Opt_barrier),
 	fsparam_u32	("barrier",		Opt_barrier),
 	fsparam_flag	("nobarrier",		Opt_nobarrier),
-	fsparam_flag	("i_version",		Opt_i_version),
+	fsparam_flag	("i_version",		Opt_removed),
 	fsparam_flag	("dax",			Opt_dax),
 	fsparam_enum	("dax",			Opt_dax_type, ext4_param_dax),
 	fsparam_u32	("stripe",		Opt_stripe),
@@ -2131,11 +2131,6 @@ static int ext4_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_abort:
 		ctx_set_mount_flag(ctx, EXT4_MF_FS_ABORTED);
 		return 0;
-	case Opt_i_version:
-		ext4_msg(NULL, KERN_WARNING, deprecated_msg, param->key, "5.20");
-		ext4_msg(NULL, KERN_WARNING, "Use iversion instead\n");
-		ctx_set_flags(ctx, SB_I_VERSION);
-		return 0;
 	case Opt_inlinecrypt:
 #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
 		ctx_set_flags(ctx, SB_INLINECRYPT);
@@ -2805,14 +2800,6 @@ static void ext4_apply_options(struct fs_context *fc, struct super_block *sb)
 	sb->s_flags &= ~ctx->mask_s_flags;
 	sb->s_flags |= ctx->vals_s_flags;
 
-	/*
-	 * i_version differs from common mount option iversion so we have
-	 * to let vfs know that it was set, otherwise it would get cleared
-	 * on remount
-	 */
-	if (ctx->mask_s_flags & SB_I_VERSION)
-		fc->sb_flags |= SB_I_VERSION;
-
 #define APPLY(X) ({ if (ctx->spec & EXT4_SPEC_##X) sbi->X = ctx->X; })
 	APPLY(s_commit_interval);
 	APPLY(s_stripe);
@@ -2961,8 +2948,6 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 		SEQ_OPTS_PRINT("min_batch_time=%u", sbi->s_min_batch_time);
 	if (nodefs || sbi->s_max_batch_time != EXT4_DEF_MAX_BATCH_TIME)
 		SEQ_OPTS_PRINT("max_batch_time=%u", sbi->s_max_batch_time);
-	if (sb->s_flags & SB_I_VERSION)
-		SEQ_OPTS_PUTS("i_version");
 	if (nodefs || sbi->s_stripe)
 		SEQ_OPTS_PRINT("stripe=%lu", sbi->s_stripe);
 	if (nodefs || EXT4_MOUNT_DATA_FLAGS &
@@ -4632,6 +4617,9 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	sb->s_flags = (sb->s_flags & ~SB_POSIXACL) |
 		(test_opt(sb, POSIX_ACL) ? SB_POSIXACL : 0);
 
+	/* i_version is always enabled now */
+	sb->s_flags |= SB_I_VERSION;
+
 	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV &&
 	    (ext4_has_compat_features(sb) ||
 	     ext4_has_ro_compat_features(sb) ||

