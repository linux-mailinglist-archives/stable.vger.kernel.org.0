Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7134A3442BF
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhCVMok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:44:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232636AbhCVMm5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:42:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21BF1619E5;
        Mon, 22 Mar 2021 12:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416852;
        bh=ZD6rj4eGPsc6mPVMS4DrO56Igbea4eA6XllDSHahwIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R12YabpWUidJwgp50duQzblbC+eniPCuh8bel4GhwQuq1w5pCzSdsF81dlw+Dy7LU
         QaI10y+m72xX+eKuQLoNfTCwCC/6KeQh+8cZMbCV/b/NSf0U40fD8aTqW7p3UJsabR
         gnJ3m8mtYEnecZsohIxRBiGHJMoFqRKZfJ81M23M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/157] gfs2: Add common helper for holding and releasing the freeze glock
Date:   Mon, 22 Mar 2021 13:27:49 +0100
Message-Id: <20210322121937.322631112@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit c77b52c0a137994ad796f44544c802b0b766e496 ]

Many places in the gfs2 code queued and dequeued the freeze glock.
Almost all of them acquire it in SHARED mode, and need to specify the
same LM_FLAG_NOEXP and GL_EXACT flags.

This patch adds common helper functions gfs2_freeze_lock and gfs2_freeze_unlock
to make the code more readable, and to prepare for the next patch.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/ops_fstype.c |  6 ++----
 fs/gfs2/recovery.c   |  8 +++-----
 fs/gfs2/super.c      | 42 ++++++++++++++----------------------------
 fs/gfs2/util.c       | 25 +++++++++++++++++++++++++
 fs/gfs2/util.h       |  3 +++
 5 files changed, 47 insertions(+), 37 deletions(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 61fce59cb4d3..4ee56f5e93cb 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1198,14 +1198,12 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (sb_rdonly(sb)) {
 		struct gfs2_holder freeze_gh;
 
-		error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED,
-					   LM_FLAG_NOEXP | GL_EXACT,
-					   &freeze_gh);
+		error = gfs2_freeze_lock(sdp, &freeze_gh, 0);
 		if (error) {
 			fs_err(sdp, "can't make FS RO: %d\n", error);
 			goto fail_per_node;
 		}
-		gfs2_glock_dq_uninit(&freeze_gh);
+		gfs2_freeze_unlock(&freeze_gh);
 	} else {
 		error = gfs2_make_fs_rw(sdp);
 		if (error) {
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index a3c1911862f0..8f9c6480a5df 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -470,9 +470,7 @@ void gfs2_recover_func(struct work_struct *work)
 
 		/* Acquire a shared hold on the freeze lock */
 
-		error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED,
-					   LM_FLAG_NOEXP | LM_FLAG_PRIORITY |
-					   GL_EXACT, &thaw_gh);
+		error = gfs2_freeze_lock(sdp, &thaw_gh, LM_FLAG_PRIORITY);
 		if (error)
 			goto fail_gunlock_ji;
 
@@ -524,7 +522,7 @@ void gfs2_recover_func(struct work_struct *work)
 		clean_journal(jd, &head);
 		up_read(&sdp->sd_log_flush_lock);
 
-		gfs2_glock_dq_uninit(&thaw_gh);
+		gfs2_freeze_unlock(&thaw_gh);
 		t_rep = ktime_get();
 		fs_info(sdp, "jid=%u: Journal replayed in %lldms [jlck:%lldms, "
 			"jhead:%lldms, tlck:%lldms, replay:%lldms]\n",
@@ -546,7 +544,7 @@ void gfs2_recover_func(struct work_struct *work)
 	goto done;
 
 fail_gunlock_thaw:
-	gfs2_glock_dq_uninit(&thaw_gh);
+	gfs2_freeze_unlock(&thaw_gh);
 fail_gunlock_ji:
 	if (jlocked) {
 		gfs2_glock_dq_uninit(&ji_gh);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index b3d951ab8068..6b0e8c0bb110 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -173,9 +173,7 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	if (error)
 		return error;
 
-	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED,
-				   LM_FLAG_NOEXP | GL_EXACT,
-				   &freeze_gh);
+	error = gfs2_freeze_lock(sdp, &freeze_gh, 0);
 	if (error)
 		goto fail_threads;
 
@@ -205,12 +203,12 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 
 	set_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
 
-	gfs2_glock_dq_uninit(&freeze_gh);
+	gfs2_freeze_unlock(&freeze_gh);
 
 	return 0;
 
 fail:
-	gfs2_glock_dq_uninit(&freeze_gh);
+	gfs2_freeze_unlock(&freeze_gh);
 fail_threads:
 	if (sdp->sd_quotad_process)
 		kthread_stop(sdp->sd_quotad_process);
@@ -454,7 +452,7 @@ static int gfs2_lock_fs_check_clean(struct gfs2_sbd *sdp)
 	}
 
 	if (error)
-		gfs2_glock_dq_uninit(&sdp->sd_freeze_gh);
+		gfs2_freeze_unlock(&sdp->sd_freeze_gh);
 
 out:
 	while (!list_empty(&list)) {
@@ -618,21 +616,12 @@ int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 	gfs2_holder_mark_uninitialized(&freeze_gh);
 	if (sdp->sd_freeze_gl &&
 	    !gfs2_glock_is_locked_by_me(sdp->sd_freeze_gl)) {
-		if (!log_write_allowed) {
-			error = gfs2_glock_nq_init(sdp->sd_freeze_gl,
-						   LM_ST_SHARED, LM_FLAG_TRY |
-						   LM_FLAG_NOEXP | GL_EXACT,
-						   &freeze_gh);
-			if (error == GLR_TRYFAILED)
-				error = 0;
-		} else {
-			error = gfs2_glock_nq_init(sdp->sd_freeze_gl,
-						   LM_ST_SHARED,
-						   LM_FLAG_NOEXP | GL_EXACT,
-						   &freeze_gh);
-			if (error && !gfs2_withdrawn(sdp))
-				return error;
-		}
+		error = gfs2_freeze_lock(sdp, &freeze_gh,
+					 log_write_allowed ? 0 : LM_FLAG_TRY);
+		if (error == GLR_TRYFAILED)
+			error = 0;
+		if (error && !gfs2_withdrawn(sdp))
+			return error;
 	}
 
 	gfs2_flush_delete_work(sdp);
@@ -663,8 +652,7 @@ int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 				   atomic_read(&sdp->sd_reserving_log) == 0,
 				   HZ * 5);
 	}
-	if (gfs2_holder_initialized(&freeze_gh))
-		gfs2_glock_dq_uninit(&freeze_gh);
+	gfs2_freeze_unlock(&freeze_gh);
 
 	gfs2_quota_cleanup(sdp);
 
@@ -774,10 +762,8 @@ void gfs2_freeze_func(struct work_struct *work)
 	struct super_block *sb = sdp->sd_vfs;
 
 	atomic_inc(&sb->s_active);
-	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED,
-				   LM_FLAG_NOEXP | GL_EXACT, &freeze_gh);
+	error = gfs2_freeze_lock(sdp, &freeze_gh, 0);
 	if (error) {
-		fs_info(sdp, "GFS2: couldn't get freeze lock : %d\n", error);
 		gfs2_assert_withdraw(sdp, 0);
 	} else {
 		atomic_set(&sdp->sd_freeze_state, SFS_UNFROZEN);
@@ -787,7 +773,7 @@ void gfs2_freeze_func(struct work_struct *work)
 				error);
 			gfs2_assert_withdraw(sdp, 0);
 		}
-		gfs2_glock_dq_uninit(&freeze_gh);
+		gfs2_freeze_unlock(&freeze_gh);
 	}
 	deactivate_super(sb);
 	clear_bit_unlock(SDF_FS_FROZEN, &sdp->sd_flags);
@@ -855,7 +841,7 @@ static int gfs2_unfreeze(struct super_block *sb)
                 return 0;
 	}
 
-	gfs2_glock_dq_uninit(&sdp->sd_freeze_gh);
+	gfs2_freeze_unlock(&sdp->sd_freeze_gh);
 	mutex_unlock(&sdp->sd_freeze_mutex);
 	return wait_on_bit(&sdp->sd_flags, SDF_FS_FROZEN, TASK_INTERRUPTIBLE);
 }
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index b7d4e4550880..c8d55055e495 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -91,6 +91,31 @@ int check_journal_clean(struct gfs2_sbd *sdp, struct gfs2_jdesc *jd,
 	return error;
 }
 
+/**
+ * gfs2_freeze_lock - hold the freeze glock
+ * @sdp: the superblock
+ * @freeze_gh: pointer to the requested holder
+ * @caller_flags: any additional flags needed by the caller
+ */
+int gfs2_freeze_lock(struct gfs2_sbd *sdp, struct gfs2_holder *freeze_gh,
+		     int caller_flags)
+{
+	int flags = LM_FLAG_NOEXP | GL_EXACT | caller_flags;
+	int error;
+
+	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED, flags,
+				   freeze_gh);
+	if (error && error != GLR_TRYFAILED)
+		fs_err(sdp, "can't lock the freeze lock: %d\n", error);
+	return error;
+}
+
+void gfs2_freeze_unlock(struct gfs2_holder *freeze_gh)
+{
+	if (gfs2_holder_initialized(freeze_gh))
+		gfs2_glock_dq_uninit(freeze_gh);
+}
+
 static void signal_our_withdraw(struct gfs2_sbd *sdp)
 {
 	struct gfs2_glock *live_gl = sdp->sd_live_gh.gh_gl;
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index d7562981b3a0..aa3771281aca 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -149,6 +149,9 @@ int gfs2_io_error_i(struct gfs2_sbd *sdp, const char *function,
 
 extern int check_journal_clean(struct gfs2_sbd *sdp, struct gfs2_jdesc *jd,
 			       bool verbose);
+extern int gfs2_freeze_lock(struct gfs2_sbd *sdp,
+			    struct gfs2_holder *freeze_gh, int caller_flags);
+extern void gfs2_freeze_unlock(struct gfs2_holder *freeze_gh);
 
 #define gfs2_io_error(sdp) \
 gfs2_io_error_i((sdp), __func__, __FILE__, __LINE__);
-- 
2.30.1



