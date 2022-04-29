Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECB251476C
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357990AbiD2KsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357993AbiD2Kr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:47:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4719C90F1;
        Fri, 29 Apr 2022 03:43:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 163A4B83451;
        Fri, 29 Apr 2022 10:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D76C385A4;
        Fri, 29 Apr 2022 10:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228981;
        bh=t4ZAcEpHL5kdU7mhAeykmKY0Crjoy6r0tHnE013x2pY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZXqFOjiaHAV9c7RwwX0uqQIMYSd0K2ZdvnkUU4CG88R3f6OIvY0987FRvdCuiYIr
         bcrnTwRicB7PF7q5dru2DqrugRnoC9FPitEVR5FGHWlBo2dyb5kT+3H166KBYApdZ+
         CTe+nh/Wx0kw465lmHFy/nAM+QR+2mSvouIuNitA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.15 20/33] gfs2: Introduce flag for glock holder auto-demotion
Date:   Fri, 29 Apr 2022 12:42:07 +0200
Message-Id: <20220429104052.925310854@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429104052.345760505@linuxfoundation.org>
References: <20220429104052.345760505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

commit dc732906c2450939c319fec6e258aa89ecb5a632 upstream

This patch introduces a new HIF_MAY_DEMOTE flag and infrastructure that
will allow glocks to be demoted automatically on locking conflicts.
When a locking request comes in that isn't compatible with the locking
state of an active holder and that holder has the HIF_MAY_DEMOTE flag
set, the holder will be demoted before the incoming locking request is
granted.

Note that this mechanism demotes active holders (with the HIF_HOLDER
flag set), while before we were only demoting glocks without any active
holders.  This allows processes to keep hold of locks that may form a
cyclic locking dependency; the core glock logic will then break those
dependencies in case a conflicting locking request occurs.  We'll use
this to avoid giving up the inode glock proactively before faulting in
pages.

Processes that allow a glock holder to be taken away indicate this by
calling gfs2_holder_allow_demote(), which sets the HIF_MAY_DEMOTE flag.
Later, they call gfs2_holder_disallow_demote() to clear the flag again,
and then they check if their holder is still queued: if it is, they are
still holding the glock; if it isn't, they can re-acquire the glock (or
abort).

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/glock.c  |  215 +++++++++++++++++++++++++++++++++++++++++++++----------
 fs/gfs2/glock.h  |   20 +++++
 fs/gfs2/incore.h |    1 
 3 files changed, 200 insertions(+), 36 deletions(-)

--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -58,6 +58,7 @@ struct gfs2_glock_iter {
 typedef void (*glock_examiner) (struct gfs2_glock * gl);
 
 static void do_xmote(struct gfs2_glock *gl, struct gfs2_holder *gh, unsigned int target);
+static void __gfs2_glock_dq(struct gfs2_holder *gh);
 
 static struct dentry *gfs2_root;
 static struct workqueue_struct *glock_workqueue;
@@ -197,6 +198,12 @@ static int demote_ok(const struct gfs2_g
 
 	if (gl->gl_state == LM_ST_UNLOCKED)
 		return 0;
+	/*
+	 * Note that demote_ok is used for the lru process of disposing of
+	 * glocks. For this purpose, we don't care if the glock's holders
+	 * have the HIF_MAY_DEMOTE flag set or not. If someone is using
+	 * them, don't demote.
+	 */
 	if (!list_empty(&gl->gl_holders))
 		return 0;
 	if (glops->go_demote_ok)
@@ -379,7 +386,7 @@ static void do_error(struct gfs2_glock *
 	struct gfs2_holder *gh, *tmp;
 
 	list_for_each_entry_safe(gh, tmp, &gl->gl_holders, gh_list) {
-		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
+		if (!test_bit(HIF_WAIT, &gh->gh_iflags))
 			continue;
 		if (ret & LM_OUT_ERROR)
 			gh->gh_error = -EIO;
@@ -394,6 +401,40 @@ static void do_error(struct gfs2_glock *
 }
 
 /**
+ * demote_incompat_holders - demote incompatible demoteable holders
+ * @gl: the glock we want to promote
+ * @new_gh: the new holder to be promoted
+ */
+static void demote_incompat_holders(struct gfs2_glock *gl,
+				    struct gfs2_holder *new_gh)
+{
+	struct gfs2_holder *gh;
+
+	/*
+	 * Demote incompatible holders before we make ourselves eligible.
+	 * (This holder may or may not allow auto-demoting, but we don't want
+	 * to demote the new holder before it's even granted.)
+	 */
+	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
+		/*
+		 * Since holders are at the front of the list, we stop when we
+		 * find the first non-holder.
+		 */
+		if (!test_bit(HIF_HOLDER, &gh->gh_iflags))
+			return;
+		if (test_bit(HIF_MAY_DEMOTE, &gh->gh_iflags) &&
+		    !may_grant(gl, new_gh, gh)) {
+			/*
+			 * We should not recurse into do_promote because
+			 * __gfs2_glock_dq only calls handle_callback,
+			 * gfs2_glock_add_to_lru and __gfs2_glock_queue_work.
+			 */
+			__gfs2_glock_dq(gh);
+		}
+	}
+}
+
+/**
  * find_first_holder - find the first "holder" gh
  * @gl: the glock
  */
@@ -412,6 +453,26 @@ static inline struct gfs2_holder *find_f
 }
 
 /**
+ * find_first_strong_holder - find the first non-demoteable holder
+ * @gl: the glock
+ *
+ * Find the first holder that doesn't have the HIF_MAY_DEMOTE flag set.
+ */
+static inline struct gfs2_holder *
+find_first_strong_holder(struct gfs2_glock *gl)
+{
+	struct gfs2_holder *gh;
+
+	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
+		if (!test_bit(HIF_HOLDER, &gh->gh_iflags))
+			return NULL;
+		if (!test_bit(HIF_MAY_DEMOTE, &gh->gh_iflags))
+			return gh;
+	}
+	return NULL;
+}
+
+/**
  * do_promote - promote as many requests as possible on the current queue
  * @gl: The glock
  * 
@@ -425,14 +486,20 @@ __acquires(&gl->gl_lockref.lock)
 {
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 	struct gfs2_holder *gh, *tmp, *first_gh;
+	bool incompat_holders_demoted = false;
 	int ret;
 
 restart:
-	first_gh = find_first_holder(gl);
+	first_gh = find_first_strong_holder(gl);
 	list_for_each_entry_safe(gh, tmp, &gl->gl_holders, gh_list) {
-		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
+		if (!test_bit(HIF_WAIT, &gh->gh_iflags))
 			continue;
 		if (may_grant(gl, first_gh, gh)) {
+			if (!incompat_holders_demoted) {
+				demote_incompat_holders(gl, first_gh);
+				incompat_holders_demoted = true;
+				first_gh = gh;
+			}
 			if (gh->gh_list.prev == &gl->gl_holders &&
 			    glops->go_lock) {
 				spin_unlock(&gl->gl_lockref.lock);
@@ -458,6 +525,11 @@ restart:
 			gfs2_holder_wake(gh);
 			continue;
 		}
+		/*
+		 * If we get here, it means we may not grant this holder for
+		 * some reason. If this holder is the head of the list, it
+		 * means we have a blocked holder at the head, so return 1.
+		 */
 		if (gh->gh_list.prev == &gl->gl_holders)
 			return 1;
 		do_error(gl, 0);
@@ -1372,7 +1444,7 @@ __acquires(&gl->gl_lockref.lock)
 		if (test_bit(GLF_LOCK, &gl->gl_flags)) {
 			struct gfs2_holder *first_gh;
 
-			first_gh = find_first_holder(gl);
+			first_gh = find_first_strong_holder(gl);
 			try_futile = !may_grant(gl, first_gh, gh);
 		}
 		if (test_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags))
@@ -1381,7 +1453,8 @@ __acquires(&gl->gl_lockref.lock)
 
 	list_for_each_entry(gh2, &gl->gl_holders, gh_list) {
 		if (unlikely(gh2->gh_owner_pid == gh->gh_owner_pid &&
-		    (gh->gh_gl->gl_ops->go_type != LM_TYPE_FLOCK)))
+		    (gh->gh_gl->gl_ops->go_type != LM_TYPE_FLOCK) &&
+		    !test_bit(HIF_MAY_DEMOTE, &gh2->gh_iflags)))
 			goto trap_recursive;
 		if (try_futile &&
 		    !(gh2->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB))) {
@@ -1477,51 +1550,83 @@ int gfs2_glock_poll(struct gfs2_holder *
 	return test_bit(HIF_WAIT, &gh->gh_iflags) ? 0 : 1;
 }
 
-/**
- * gfs2_glock_dq - dequeue a struct gfs2_holder from a glock (release a glock)
- * @gh: the glock holder
- *
- */
+static inline bool needs_demote(struct gfs2_glock *gl)
+{
+	return (test_bit(GLF_DEMOTE, &gl->gl_flags) ||
+		test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags));
+}
 
-void gfs2_glock_dq(struct gfs2_holder *gh)
+static void __gfs2_glock_dq(struct gfs2_holder *gh)
 {
 	struct gfs2_glock *gl = gh->gh_gl;
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
 	unsigned delay = 0;
 	int fast_path = 0;
 
-	spin_lock(&gl->gl_lockref.lock);
 	/*
-	 * If we're in the process of file system withdraw, we cannot just
-	 * dequeue any glocks until our journal is recovered, lest we
-	 * introduce file system corruption. We need two exceptions to this
-	 * rule: We need to allow unlocking of nondisk glocks and the glock
-	 * for our own journal that needs recovery.
+	 * This while loop is similar to function demote_incompat_holders:
+	 * If the glock is due to be demoted (which may be from another node
+	 * or even if this holder is GL_NOCACHE), the weak holders are
+	 * demoted as well, allowing the glock to be demoted.
 	 */
-	if (test_bit(SDF_WITHDRAW_RECOVERY, &sdp->sd_flags) &&
-	    glock_blocked_by_withdraw(gl) &&
-	    gh->gh_gl != sdp->sd_jinode_gl) {
-		sdp->sd_glock_dqs_held++;
-		spin_unlock(&gl->gl_lockref.lock);
-		might_sleep();
-		wait_on_bit(&sdp->sd_flags, SDF_WITHDRAW_RECOVERY,
-			    TASK_UNINTERRUPTIBLE);
-		spin_lock(&gl->gl_lockref.lock);
-	}
-	if (gh->gh_flags & GL_NOCACHE)
-		handle_callback(gl, LM_ST_UNLOCKED, 0, false);
+	while (gh) {
+		/*
+		 * If we're in the process of file system withdraw, we cannot
+		 * just dequeue any glocks until our journal is recovered, lest
+		 * we introduce file system corruption. We need two exceptions
+		 * to this rule: We need to allow unlocking of nondisk glocks
+		 * and the glock for our own journal that needs recovery.
+		 */
+		if (test_bit(SDF_WITHDRAW_RECOVERY, &sdp->sd_flags) &&
+		    glock_blocked_by_withdraw(gl) &&
+		    gh->gh_gl != sdp->sd_jinode_gl) {
+			sdp->sd_glock_dqs_held++;
+			spin_unlock(&gl->gl_lockref.lock);
+			might_sleep();
+			wait_on_bit(&sdp->sd_flags, SDF_WITHDRAW_RECOVERY,
+				    TASK_UNINTERRUPTIBLE);
+			spin_lock(&gl->gl_lockref.lock);
+		}
 
-	list_del_init(&gh->gh_list);
-	clear_bit(HIF_HOLDER, &gh->gh_iflags);
-	if (list_empty(&gl->gl_holders) &&
-	    !test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
-	    !test_bit(GLF_DEMOTE, &gl->gl_flags))
-		fast_path = 1;
+		/*
+		 * This holder should not be cached, so mark it for demote.
+		 * Note: this should be done before the check for needs_demote
+		 * below.
+		 */
+		if (gh->gh_flags & GL_NOCACHE)
+			handle_callback(gl, LM_ST_UNLOCKED, 0, false);
+
+		list_del_init(&gh->gh_list);
+		clear_bit(HIF_HOLDER, &gh->gh_iflags);
+		trace_gfs2_glock_queue(gh, 0);
+
+		/*
+		 * If there hasn't been a demote request we are done.
+		 * (Let the remaining holders, if any, keep holding it.)
+		 */
+		if (!needs_demote(gl)) {
+			if (list_empty(&gl->gl_holders))
+				fast_path = 1;
+			break;
+		}
+		/*
+		 * If we have another strong holder (we cannot auto-demote)
+		 * we are done. It keeps holding it until it is done.
+		 */
+		if (find_first_strong_holder(gl))
+			break;
+
+		/*
+		 * If we have a weak holder at the head of the list, it
+		 * (and all others like it) must be auto-demoted. If there
+		 * are no more weak holders, we exit the while loop.
+		 */
+		gh = find_first_holder(gl);
+	}
 
 	if (!test_bit(GLF_LFLUSH, &gl->gl_flags) && demote_ok(gl))
 		gfs2_glock_add_to_lru(gl);
 
-	trace_gfs2_glock_queue(gh, 0);
 	if (unlikely(!fast_path)) {
 		gl->gl_lockref.count++;
 		if (test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
@@ -1530,6 +1635,19 @@ void gfs2_glock_dq(struct gfs2_holder *g
 			delay = gl->gl_hold_time;
 		__gfs2_glock_queue_work(gl, delay);
 	}
+}
+
+/**
+ * gfs2_glock_dq - dequeue a struct gfs2_holder from a glock (release a glock)
+ * @gh: the glock holder
+ *
+ */
+void gfs2_glock_dq(struct gfs2_holder *gh)
+{
+	struct gfs2_glock *gl = gh->gh_gl;
+
+	spin_lock(&gl->gl_lockref.lock);
+	__gfs2_glock_dq(gh);
 	spin_unlock(&gl->gl_lockref.lock);
 }
 
@@ -1692,6 +1810,7 @@ void gfs2_glock_dq_m(unsigned int num_gh
 
 void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state)
 {
+	struct gfs2_holder mock_gh = { .gh_gl = gl, .gh_state = state, };
 	unsigned long delay = 0;
 	unsigned long holdtime;
 	unsigned long now = jiffies;
@@ -1706,6 +1825,28 @@ void gfs2_glock_cb(struct gfs2_glock *gl
 		if (test_bit(GLF_REPLY_PENDING, &gl->gl_flags))
 			delay = gl->gl_hold_time;
 	}
+	/*
+	 * Note 1: We cannot call demote_incompat_holders from handle_callback
+	 * or gfs2_set_demote due to recursion problems like: gfs2_glock_dq ->
+	 * handle_callback -> demote_incompat_holders -> gfs2_glock_dq
+	 * Plus, we only want to demote the holders if the request comes from
+	 * a remote cluster node because local holder conflicts are resolved
+	 * elsewhere.
+	 *
+	 * Note 2: if a remote node wants this glock in EX mode, lock_dlm will
+	 * request that we set our state to UNLOCKED. Here we mock up a holder
+	 * to make it look like someone wants the lock EX locally. Any SH
+	 * and DF requests should be able to share the lock without demoting.
+	 *
+	 * Note 3: We only want to demote the demoteable holders when there
+	 * are no more strong holders. The demoteable holders might as well
+	 * keep the glock until the last strong holder is done with it.
+	 */
+	if (!find_first_strong_holder(gl)) {
+		if (state == LM_ST_UNLOCKED)
+			mock_gh.gh_state = LM_ST_EXCLUSIVE;
+		demote_incompat_holders(gl, &mock_gh);
+	}
 	handle_callback(gl, state, delay, true);
 	__gfs2_glock_queue_work(gl, delay);
 	spin_unlock(&gl->gl_lockref.lock);
@@ -2097,6 +2238,8 @@ static const char *hflags2str(char *buf,
 		*p++ = 'H';
 	if (test_bit(HIF_WAIT, &iflags))
 		*p++ = 'W';
+	if (test_bit(HIF_MAY_DEMOTE, &iflags))
+		*p++ = 'D';
 	*p = 0;
 	return buf;
 }
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -150,6 +150,8 @@ static inline struct gfs2_holder *gfs2_g
 	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
 		if (!test_bit(HIF_HOLDER, &gh->gh_iflags))
 			break;
+		if (test_bit(HIF_MAY_DEMOTE, &gh->gh_iflags))
+			continue;
 		if (gh->gh_owner_pid == pid)
 			goto out;
 	}
@@ -325,6 +327,24 @@ static inline void glock_clear_object(st
 	spin_unlock(&gl->gl_lockref.lock);
 }
 
+static inline void gfs2_holder_allow_demote(struct gfs2_holder *gh)
+{
+	struct gfs2_glock *gl = gh->gh_gl;
+
+	spin_lock(&gl->gl_lockref.lock);
+	set_bit(HIF_MAY_DEMOTE, &gh->gh_iflags);
+	spin_unlock(&gl->gl_lockref.lock);
+}
+
+static inline void gfs2_holder_disallow_demote(struct gfs2_holder *gh)
+{
+	struct gfs2_glock *gl = gh->gh_gl;
+
+	spin_lock(&gl->gl_lockref.lock);
+	clear_bit(HIF_MAY_DEMOTE, &gh->gh_iflags);
+	spin_unlock(&gl->gl_lockref.lock);
+}
+
 extern void gfs2_inode_remember_delete(struct gfs2_glock *gl, u64 generation);
 extern bool gfs2_inode_already_deleted(struct gfs2_glock *gl, u64 generation);
 
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -252,6 +252,7 @@ struct gfs2_lkstats {
 
 enum {
 	/* States */
+	HIF_MAY_DEMOTE		= 1,
 	HIF_HOLDER		= 6,  /* Set for gh that "holds" the glock */
 	HIF_WAIT		= 10,
 };


