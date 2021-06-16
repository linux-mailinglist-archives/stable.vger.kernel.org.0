Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF4C3A9F7B
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbhFPPi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234749AbhFPPhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:37:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07564613CB;
        Wed, 16 Jun 2021 15:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857728;
        bh=kvSrNLIh+uOkr9jxyOKYG8oS7k48Q+7gWUhGNQ4QAyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0LfEa4eYvGJO1H3tEY/m1cKw5Ius2W4WHnxNin6h07xCYbl4uPZJGOWd0IvA+E3n
         nUlp+eQUG0Ve+VaxW2IA2c6zeXtL/w42Jk9UulWpgjztKdYU+xl7+iHzGgDYk58C8M
         34Pcprl2mvJZ557lKHnAgJESMZeOriPzOgtN/tAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/38] gfs2: fix a deadlock on withdraw-during-mount
Date:   Wed, 16 Jun 2021 17:33:25 +0200
Message-Id: <20210616152835.912416286@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
References: <20210616152835.407925718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ea2f2de44806..59130cbbd995 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -569,6 +569,16 @@ out_locked:
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
@@ -658,17 +668,25 @@ skip_inval:
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



