Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6EC3A9FD8
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235526AbhFPPmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:42:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235285AbhFPPj7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:39:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1553F613E4;
        Wed, 16 Jun 2021 15:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857826;
        bh=dgcNpxbz9aCzwe8nT8tB69hZGRYOiIKpI+qPr00x8y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMN0tOdtIAAE7eQCetNNXmfmGNwX0tGzLPm0c0t6BXoQJw9ighE8PWtcbBUC/RLx4
         ToL0zEhP7uscP9xTFfQ7Z5RDJ2tE8TgMpdyf9HEF3LUpbYMmgTZpEDv4caeWVzsyZg
         WmkSEBFDCz8mHKGUnjUznqySCNaqqywH2C/U0Am8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 21/48] gfs2: fix a deadlock on withdraw-during-mount
Date:   Wed, 16 Jun 2021 17:33:31 +0200
Message-Id: <20210616152837.325028932@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
References: <20210616152836.655643420@linuxfoundation.org>
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
index 7c2ba81213da..611c56febf8c 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -583,6 +583,16 @@ out_locked:
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
@@ -672,17 +682,25 @@ skip_inval:
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



