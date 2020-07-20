Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F682268D7
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgGTQVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:21:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731987AbgGTQHm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:07:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 846A120672;
        Mon, 20 Jul 2020 16:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261262;
        bh=MPIiRSXIw+RgAs8DqRmsqGIdg6Fimrhtbb/qeQv14zM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mHVJkcGBMgc9cT9eQ3JMcrAotcDwHDAAqay9Tdvv6lz12xRkMvpekaaJHFBSdK3OM
         FxH/AI64DICYA/qTY3f5HsaUAEcExNqG/DxTylrhKpu7fAl22oNOQC59wbfHzGxoJB
         qB5YvsiZBdT0+2Sd0xiBoc4sadRBk3oxWWe+Z15k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 053/244] gfs2: When freezing gfs2, use GL_EXACT and not GL_NOCACHE
Date:   Mon, 20 Jul 2020 17:35:24 +0200
Message-Id: <20200720152828.382141361@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 623ba664b74a20f22a2ef7ebd71e171d2d7c626f ]

Before this patch, the freeze code in gfs2 specified GL_NOCACHE in
several places. That's wrong because we always want to know the state
of whether the file system is frozen.

There was also a problem with freeze/thaw transitioning the glock from
frozen (EX) to thawed (SH) because gfs2 will normally grant glocks in EX
to processes that request it in SH mode, unless GL_EXACT is specified.
Therefore, the freeze/thaw code, which tried to reacquire the glock in
SH mode would get the glock in EX mode, and miss the transition from EX
to SH. That made it think the thaw had completed normally, but since the
glock was still cached in EX, other nodes could not freeze again.

This patch removes the GL_NOCACHE flag to allow the freeze glock to be
cached. It also adds the GL_EXACT flag so the glock is fully transitioned
from EX to SH, thereby allowing future freeze operations.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/recovery.c |  4 ++--
 fs/gfs2/super.c    | 16 +++++++---------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 96c345f492738..390ea79d682c2 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -364,8 +364,8 @@ void gfs2_recover_func(struct work_struct *work)
 		/* Acquire a shared hold on the freeze lock */
 
 		error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED,
-					   LM_FLAG_NOEXP | LM_FLAG_PRIORITY,
-					   &thaw_gh);
+					   LM_FLAG_NOEXP | LM_FLAG_PRIORITY |
+					   GL_EXACT, &thaw_gh);
 		if (error)
 			goto fail_gunlock_ji;
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 956fced0a8ec2..3bc76cf382fb9 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -167,7 +167,7 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	if (error)
 		return error;
 
-	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED, 0,
+	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED, GL_EXACT,
 				   &freeze_gh);
 	if (error)
 		goto fail_threads;
@@ -203,7 +203,6 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	return 0;
 
 fail:
-	freeze_gh.gh_flags |= GL_NOCACHE;
 	gfs2_glock_dq_uninit(&freeze_gh);
 fail_threads:
 	if (sdp->sd_quotad_process)
@@ -430,7 +429,7 @@ static int gfs2_lock_fs_check_clean(struct gfs2_sbd *sdp)
 	}
 
 	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_EXCLUSIVE,
-				   GL_NOCACHE, &sdp->sd_freeze_gh);
+				   0, &sdp->sd_freeze_gh);
 	if (error)
 		goto out;
 
@@ -613,13 +612,14 @@ int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 	    !gfs2_glock_is_locked_by_me(sdp->sd_freeze_gl)) {
 		if (!log_write_allowed) {
 			error = gfs2_glock_nq_init(sdp->sd_freeze_gl,
-						   LM_ST_SHARED, GL_NOCACHE |
-						   LM_FLAG_TRY, &freeze_gh);
+						   LM_ST_SHARED,
+						   LM_FLAG_TRY | GL_EXACT,
+						   &freeze_gh);
 			if (error == GLR_TRYFAILED)
 				error = 0;
 		} else {
 			error = gfs2_glock_nq_init(sdp->sd_freeze_gl,
-						   LM_ST_SHARED, GL_NOCACHE,
+						   LM_ST_SHARED, GL_EXACT,
 						   &freeze_gh);
 			if (error && !gfs2_withdrawn(sdp))
 				return error;
@@ -761,7 +761,7 @@ void gfs2_freeze_func(struct work_struct *work)
 	struct super_block *sb = sdp->sd_vfs;
 
 	atomic_inc(&sb->s_active);
-	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED, 0,
+	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED, GL_EXACT,
 				   &freeze_gh);
 	if (error) {
 		fs_info(sdp, "GFS2: couldn't get freeze lock : %d\n", error);
@@ -774,8 +774,6 @@ void gfs2_freeze_func(struct work_struct *work)
 				error);
 			gfs2_assert_withdraw(sdp, 0);
 		}
-		if (!test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags))
-			freeze_gh.gh_flags |= GL_NOCACHE;
 		gfs2_glock_dq_uninit(&freeze_gh);
 	}
 	deactivate_super(sb);
-- 
2.25.1



