Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CACD341C9C
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCSMVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231126AbhCSMV1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:21:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4943564F6C;
        Fri, 19 Mar 2021 12:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156486;
        bh=el9gCeIUxJUoQ53pFck9IjHrKEeG7ykNL8NFzn74DyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mflkf5pY7B6+xd9L2RvJin9sMVQxM6QQ9t8hfUhnN+n604B1YF7IHYAZoKkyQqqYi
         hV7QTsVyU0lkKGisMFRgCreGMu/po+Da99LNoNaywlZmYM3zv7/Y+JQYsjVONbDnDg
         9lzkt8p7beofMQ2xcBxSdCdx4cLOaVPiwL1o5ZOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 18/31] gfs2: move freeze glock outside the make_fs_rw and _ro functions
Date:   Fri, 19 Mar 2021 13:19:12 +0100
Message-Id: <20210319121747.784269859@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
References: <20210319121747.203523570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 96b1454f2e8ede4c619fde405a1bb4e9ba8d218e ]

Before this patch, sister functions gfs2_make_fs_rw and gfs2_make_fs_ro locked
(held) the freeze glock by calling gfs2_freeze_lock and gfs2_freeze_unlock.
The problem is, not all the callers of gfs2_make_fs_ro should be doing this.
The three callers of gfs2_make_fs_ro are: remount (gfs2_reconfigure),
signal_our_withdraw, and unmount (gfs2_put_super). But when unmounting the
file system we can get into the following circular lock dependency:

deactivate_super
   down_write(&s->s_umount); <-------------------------------------- s_umount
   deactivate_locked_super
      gfs2_kill_sb
         kill_block_super
            generic_shutdown_super
               gfs2_put_super
                  gfs2_make_fs_ro
                     gfs2_glock_nq_init sd_freeze_gl
                        freeze_go_sync
                           if (freeze glock in SH)
                              freeze_super (vfs)
                                 down_write(&sb->s_umount); <------- s_umount

This patch moves the hold of the freeze glock outside the two sister rw/ro
functions to their callers, but it doesn't request the glock from
gfs2_put_super, thus eliminating the circular dependency.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/ops_fstype.c | 31 +++++++++++++++++--------------
 fs/gfs2/super.c      | 23 -----------------------
 fs/gfs2/util.c       | 18 ++++++++++++++++--
 3 files changed, 33 insertions(+), 39 deletions(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 4ee56f5e93cb..f2c6bbe5cdb8 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1084,6 +1084,7 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 	int silent = fc->sb_flags & SB_SILENT;
 	struct gfs2_sbd *sdp;
 	struct gfs2_holder mount_gh;
+	struct gfs2_holder freeze_gh;
 	int error;
 
 	sdp = init_sbd(sb);
@@ -1195,23 +1196,18 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto fail_per_node;
 	}
 
-	if (sb_rdonly(sb)) {
-		struct gfs2_holder freeze_gh;
+	error = gfs2_freeze_lock(sdp, &freeze_gh, 0);
+	if (error)
+		goto fail_per_node;
 
-		error = gfs2_freeze_lock(sdp, &freeze_gh, 0);
-		if (error) {
-			fs_err(sdp, "can't make FS RO: %d\n", error);
-			goto fail_per_node;
-		}
-		gfs2_freeze_unlock(&freeze_gh);
-	} else {
+	if (!sb_rdonly(sb))
 		error = gfs2_make_fs_rw(sdp);
-		if (error) {
-			fs_err(sdp, "can't make FS RW: %d\n", error);
-			goto fail_per_node;
-		}
-	}
 
+	gfs2_freeze_unlock(&freeze_gh);
+	if (error) {
+		fs_err(sdp, "can't make FS RW: %d\n", error);
+		goto fail_per_node;
+	}
 	gfs2_glock_dq_uninit(&mount_gh);
 	gfs2_online_uevent(sdp);
 	return 0;
@@ -1512,6 +1508,12 @@ static int gfs2_reconfigure(struct fs_context *fc)
 		fc->sb_flags |= SB_RDONLY;
 
 	if ((sb->s_flags ^ fc->sb_flags) & SB_RDONLY) {
+		struct gfs2_holder freeze_gh;
+
+		error = gfs2_freeze_lock(sdp, &freeze_gh, 0);
+		if (error)
+			return -EINVAL;
+
 		if (fc->sb_flags & SB_RDONLY) {
 			error = gfs2_make_fs_ro(sdp);
 			if (error)
@@ -1521,6 +1523,7 @@ static int gfs2_reconfigure(struct fs_context *fc)
 			if (error)
 				errorfc(fc, "unable to remount read-write");
 		}
+		gfs2_freeze_unlock(&freeze_gh);
 	}
 	sdp->sd_args = *newargs;
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index ea312a94ce69..754ea2a137b4 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -165,7 +165,6 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 {
 	struct gfs2_inode *ip = GFS2_I(sdp->sd_jdesc->jd_inode);
 	struct gfs2_glock *j_gl = ip->i_gl;
-	struct gfs2_holder freeze_gh;
 	struct gfs2_log_header_host head;
 	int error;
 
@@ -173,10 +172,6 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	if (error)
 		return error;
 
-	error = gfs2_freeze_lock(sdp, &freeze_gh, 0);
-	if (error)
-		goto fail_threads;
-
 	j_gl->gl_ops->go_inval(j_gl, DIO_METADATA);
 	if (gfs2_withdrawn(sdp)) {
 		error = -EIO;
@@ -203,13 +198,9 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 
 	set_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
 
-	gfs2_freeze_unlock(&freeze_gh);
-
 	return 0;
 
 fail:
-	gfs2_freeze_unlock(&freeze_gh);
-fail_threads:
 	if (sdp->sd_quotad_process)
 		kthread_stop(sdp->sd_quotad_process);
 	sdp->sd_quotad_process = NULL;
@@ -607,21 +598,9 @@ static void gfs2_dirty_inode(struct inode *inode, int flags)
 
 int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 {
-	struct gfs2_holder freeze_gh;
 	int error = 0;
 	int log_write_allowed = test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
 
-	gfs2_holder_mark_uninitialized(&freeze_gh);
-	if (sdp->sd_freeze_gl &&
-	    !gfs2_glock_is_locked_by_me(sdp->sd_freeze_gl)) {
-		error = gfs2_freeze_lock(sdp, &freeze_gh,
-					 log_write_allowed ? 0 : LM_FLAG_TRY);
-		if (error == GLR_TRYFAILED)
-			error = 0;
-		if (error && !gfs2_withdrawn(sdp))
-			return error;
-	}
-
 	gfs2_flush_delete_work(sdp);
 	if (!log_write_allowed && current == sdp->sd_quotad_process)
 		fs_warn(sdp, "The quotad daemon is withdrawing.\n");
@@ -650,8 +629,6 @@ int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 				   atomic_read(&sdp->sd_reserving_log) == 0,
 				   HZ * 5);
 	}
-	gfs2_freeze_unlock(&freeze_gh);
-
 	gfs2_quota_cleanup(sdp);
 
 	if (!log_write_allowed)
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index e6c93e811c3e..8d3c670c990f 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -123,6 +123,7 @@ static void signal_our_withdraw(struct gfs2_sbd *sdp)
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_glock *i_gl = ip->i_gl;
 	u64 no_formal_ino = ip->i_no_formal_ino;
+	int log_write_allowed = test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
 	int ret = 0;
 	int tries;
 
@@ -143,8 +144,21 @@ static void signal_our_withdraw(struct gfs2_sbd *sdp)
 	 * therefore we need to clear SDF_JOURNAL_LIVE manually.
 	 */
 	clear_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
-	if (!sb_rdonly(sdp->sd_vfs))
-		ret = gfs2_make_fs_ro(sdp);
+	if (!sb_rdonly(sdp->sd_vfs)) {
+		struct gfs2_holder freeze_gh;
+
+		gfs2_holder_mark_uninitialized(&freeze_gh);
+		if (sdp->sd_freeze_gl &&
+		    !gfs2_glock_is_locked_by_me(sdp->sd_freeze_gl)) {
+			ret = gfs2_freeze_lock(sdp, &freeze_gh,
+				       log_write_allowed ? 0 : LM_FLAG_TRY);
+			if (ret == GLR_TRYFAILED)
+				ret = 0;
+		}
+		if (!ret)
+			ret = gfs2_make_fs_ro(sdp);
+		gfs2_freeze_unlock(&freeze_gh);
+	}
 
 	if (sdp->sd_lockstruct.ls_ops->lm_lock == NULL) { /* lock_nolock */
 		if (!ret)
-- 
2.30.1



