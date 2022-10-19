Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE80B603D4C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbiJSJAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbiJSI67 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:58:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CB389AE6;
        Wed, 19 Oct 2022 01:54:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09E63617ED;
        Wed, 19 Oct 2022 08:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16C1C433D6;
        Wed, 19 Oct 2022 08:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169049;
        bh=L6bCui+LWfZcqs4FoaY6lvRSWnyksq2zNJEPHZlL5D8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNKAdhIVkjk2Fmlx8agDDrLHhBDcJ669Cy46c9yhtVqpQvoQnCXCVtDqi6ass6kWT
         gy7XOc9ULTrJAc/uT/3zrpHZCINzPu8GDunEQUdpL9IisdiT+V22SVrAcRMFM+c+fz
         xJ18Z0lX83pjLLg6o6wwnHx6FFgm1VMmOXmtIG84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Lukas Czerner <lczerner@redhat.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.0 140/862] ext4: unconditionally enable the i_version counter
Date:   Wed, 19 Oct 2022 10:23:47 +0200
Message-Id: <20221019083256.173609700@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 1ff20307393e17dc57fde62226df625a3a3c36e9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    5 ++---
 fs/ext4/super.c |   22 +++++-----------------
 2 files changed, 7 insertions(+), 20 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5425,7 +5425,7 @@ int ext4_setattr(struct user_namespace *
 			return -EINVAL;
 		}
 
-		if (IS_I_VERSION(inode) && attr->ia_size != inode->i_size)
+		if (attr->ia_size != inode->i_size)
 			inode_inc_iversion(inode);
 
 		if (shrink) {
@@ -5735,8 +5735,7 @@ int ext4_mark_iloc_dirty(handle_t *handl
 	 * ea_inodes are using i_version for storing reference count, don't
 	 * mess with it
 	 */
-	if (IS_I_VERSION(inode) &&
-	    !(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL))
+	if (!(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL))
 		inode_inc_iversion(inode);
 
 	/* the do_update_inode consumes one bh->b_count */
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
@@ -1694,7 +1694,7 @@ static const struct fs_parameter_spec ex
 	fsparam_flag	("barrier",		Opt_barrier),
 	fsparam_u32	("barrier",		Opt_barrier),
 	fsparam_flag	("nobarrier",		Opt_nobarrier),
-	fsparam_flag	("i_version",		Opt_i_version),
+	fsparam_flag	("i_version",		Opt_removed),
 	fsparam_flag	("dax",			Opt_dax),
 	fsparam_enum	("dax",			Opt_dax_type, ext4_param_dax),
 	fsparam_u32	("stripe",		Opt_stripe),
@@ -2140,11 +2140,6 @@ static int ext4_parse_param(struct fs_co
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
@@ -2814,14 +2809,6 @@ static void ext4_apply_options(struct fs
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
@@ -2970,8 +2957,6 @@ static int _ext4_show_options(struct seq
 		SEQ_OPTS_PRINT("min_batch_time=%u", sbi->s_min_batch_time);
 	if (nodefs || sbi->s_max_batch_time != EXT4_DEF_MAX_BATCH_TIME)
 		SEQ_OPTS_PRINT("max_batch_time=%u", sbi->s_max_batch_time);
-	if (sb->s_flags & SB_I_VERSION)
-		SEQ_OPTS_PUTS("i_version");
 	if (nodefs || sbi->s_stripe)
 		SEQ_OPTS_PRINT("stripe=%lu", sbi->s_stripe);
 	if (nodefs || EXT4_MOUNT_DATA_FLAGS &
@@ -4641,6 +4626,9 @@ static int __ext4_fill_super(struct fs_c
 	sb->s_flags = (sb->s_flags & ~SB_POSIXACL) |
 		(test_opt(sb, POSIX_ACL) ? SB_POSIXACL : 0);
 
+	/* i_version is always enabled now */
+	sb->s_flags |= SB_I_VERSION;
+
 	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV &&
 	    (ext4_has_compat_features(sb) ||
 	     ext4_has_ro_compat_features(sb) ||


