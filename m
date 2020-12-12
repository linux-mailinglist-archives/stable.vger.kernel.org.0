Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D354C2D880C
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 17:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439348AbgLLQJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 11:09:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:57010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439334AbgLLQIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Dec 2020 11:08:51 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.9 05/23] gfs2: set lockdep subclass for iopen glocks
Date:   Sat, 12 Dec 2020 11:07:46 -0500
Message-Id: <20201212160804.2334982-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212160804.2334982-1-sashal@kernel.org>
References: <20201212160804.2334982-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 515b269d5bd29a986d5e1c0a0cba87fa865a48b4 ]

This patch introduce a new globs attribute to define the subclass of the
glock lockref spinlock. This avoid the following lockdep warning, which
occurs when we lock an inode lock while an iopen lock is held:

============================================
WARNING: possible recursive locking detected
5.10.0-rc3+ #4990 Not tainted
--------------------------------------------
kworker/0:1/12 is trying to acquire lock:
ffff9067d45672d8 (&gl->gl_lockref.lock){+.+.}-{3:3}, at: lockref_get+0x9/0x20

but task is already holding lock:
ffff9067da308588 (&gl->gl_lockref.lock){+.+.}-{3:3}, at: delete_work_func+0x164/0x260

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&gl->gl_lockref.lock);
  lock(&gl->gl_lockref.lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by kworker/0:1/12:
 #0: ffff9067c1bfdd38 ((wq_completion)delete_workqueue){+.+.}-{0:0}, at: process_one_work+0x1b7/0x540
 #1: ffffac594006be70 ((work_completion)(&(&gl->gl_delete)->work)){+.+.}-{0:0}, at: process_one_work+0x1b7/0x540
 #2: ffff9067da308588 (&gl->gl_lockref.lock){+.+.}-{3:3}, at: delete_work_func+0x164/0x260

stack backtrace:
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.10.0-rc3+ #4990
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
Workqueue: delete_workqueue delete_work_func
Call Trace:
 dump_stack+0x8b/0xb0
 __lock_acquire.cold+0x19e/0x2e3
 lock_acquire+0x150/0x410
 ? lockref_get+0x9/0x20
 _raw_spin_lock+0x27/0x40
 ? lockref_get+0x9/0x20
 lockref_get+0x9/0x20
 delete_work_func+0x188/0x260
 process_one_work+0x237/0x540
 worker_thread+0x4d/0x3b0
 ? process_one_work+0x540/0x540
 kthread+0x127/0x140
 ? __kthread_bind_mask+0x60/0x60
 ret_from_fork+0x22/0x30

Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c  | 1 +
 fs/gfs2/glops.c  | 1 +
 fs/gfs2/incore.h | 1 +
 3 files changed, 3 insertions(+)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 120a4193a75a7..ac14ba220340d 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1038,6 +1038,7 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	gl->gl_node.next = NULL;
 	gl->gl_flags = 0;
 	gl->gl_name = name;
+	lockdep_set_subclass(&gl->gl_lockref.lock, glops->go_subclass);
 	gl->gl_lockref.count = 1;
 	gl->gl_state = LM_ST_UNLOCKED;
 	gl->gl_target = LM_ST_UNLOCKED;
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 138500953b56f..27bffac51ed55 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -751,6 +751,7 @@ const struct gfs2_glock_operations gfs2_iopen_glops = {
 	.go_callback = iopen_go_callback,
 	.go_demote_ok = iopen_go_demote_ok,
 	.go_flags = GLOF_LRU | GLOF_NONDISK,
+	.go_subclass = 1,
 };
 
 const struct gfs2_glock_operations gfs2_flock_glops = {
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 387e99d6eda9e..d167307a36299 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -243,6 +243,7 @@ struct gfs2_glock_operations {
 			const char *fs_id_buf);
 	void (*go_callback)(struct gfs2_glock *gl, bool remote);
 	void (*go_free)(struct gfs2_glock *gl);
+	const int go_subclass;
 	const int go_type;
 	const unsigned long go_flags;
 #define GLOF_ASPACE 1 /* address space attached */
-- 
2.27.0

