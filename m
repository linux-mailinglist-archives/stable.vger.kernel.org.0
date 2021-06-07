Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCAD39E270
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhFGQQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231873AbhFGQPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:15:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBD7D61441;
        Mon,  7 Jun 2021 16:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082419;
        bh=zKN+sJE2iaafm8xvKy7s7AL6GbuSS5H4H1mIaLewCw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gC79sTkhE5OooiqtxbqqmEa6c/BcUkDlNEjUIDrRhki/JES6X7loSPoMxZrG6fKhQ
         UrVBdRC4/dIce9jVm/Ag1GZ7Bl+lAoKImP5GTdURBAKRp34RVkt0ob+VAxVDhvDAXO
         OOsFZIKeAqSFOQ925MO7qjtAqvu3q2vRRadpcHXsow0SiFVdLNZ++IbbJjMnyGnwnW
         bxgF/vfDAoB0rN9VuH1HJMJ8NuV/2H7E9MxfoFEYUODfz2R4sNf2oixrxzjyCXBpEo
         ZehcuaYy6tSpamgObplB/e5mlqBgOUnRFHrqQ/IDf3PQBUqFh52IU98sBo+Mp2w6HH
         VCv5PkHzgL4cA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.10 16/39] gfs2: fix a deadlock on withdraw-during-mount
Date:   Mon,  7 Jun 2021 12:12:55 -0400
Message-Id: <20210607161318.3583636-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 865cc3e9cc0b1d4b81c10d53174bced76decf888 ]

Before this patch, gfs2 would deadlock because of the following
sequence during mount:

mount
   gfs2_fill_super
      gfs2_make_fs_rw <--- Detects IO error with glock
         kthread_stop(sdp->sd_quotad_process);
            <--- Blocked waiting for quotad to finish

logd
   Detects IO error and the need to withdraw
   calls gfs2_withdraw
      gfs2_make_fs_ro
         kthread_stop(sdp->sd_quotad_process);
            <--- Blocked waiting for quotad to finish

gfs2_quotad
   gfs2_statfs_sync
      gfs2_glock_wait <---- Blocked waiting for statfs glock to be granted

glock_work_func
   do_xmote <---Detects IO error, can't release glock: blocked on withdraw
      glops->go_inval
      glock_blocked_by_withdraw
         requeue glock work & exit <--- work requeued, blocked by withdraw

This patch makes a special exception for the statfs system inode glock,
which allows the statfs glock UNLOCK to proceed normally. That allows the
quotad daemon to exit during the withdraw, which allows the logd daemon
to exit during the withdraw, which allows the mount to exit.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 35a6fd103761..5feb8f01de8a 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -569,6 +569,16 @@ static void finish_xmote(struct gfs2_glock *gl, unsigned int ret)
 	spin_unlock(&gl->gl_lockref.lock);
 }
 
+static bool is_system_glock(struct gfs2_glock *gl)
+{
+	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
+	struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
+
+	if (gl == m_ip->i_gl)
+		return true;
+	return false;
+}
+
 /**
  * do_xmote - Calls the DLM to change the state of a lock
  * @gl: The lock state
@@ -658,17 +668,25 @@ __acquires(&gl->gl_lockref.lock)
 	 * to see sd_log_error and withdraw, and in the meantime, requeue the
 	 * work for later.
 	 *
+	 * We make a special exception for some system glocks, such as the
+	 * system statfs inode glock, which needs to be granted before the
+	 * gfs2_quotad daemon can exit, and that exit needs to finish before
+	 * we can unmount the withdrawn file system.
+	 *
 	 * However, if we're just unlocking the lock (say, for unmount, when
 	 * gfs2_gl_hash_clear calls clear_glock) and recovery is complete
 	 * then it's okay to tell dlm to unlock it.
 	 */
 	if (unlikely(sdp->sd_log_error && !gfs2_withdrawn(sdp)))
 		gfs2_withdraw_delayed(sdp);
-	if (glock_blocked_by_withdraw(gl)) {
-		if (target != LM_ST_UNLOCKED ||
-		    test_bit(SDF_WITHDRAW_RECOVERY, &sdp->sd_flags)) {
+	if (glock_blocked_by_withdraw(gl) &&
+	    (target != LM_ST_UNLOCKED ||
+	     test_bit(SDF_WITHDRAW_RECOVERY, &sdp->sd_flags))) {
+		if (!is_system_glock(gl)) {
 			gfs2_glock_queue_work(gl, GL_GLOCK_DFT_HOLD);
 			goto out;
+		} else {
+			clear_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags);
 		}
 	}
 
-- 
2.30.2

