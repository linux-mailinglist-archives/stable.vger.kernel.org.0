Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0373FDB7D
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344331AbhIAMly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345024AbhIAMkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EF2D61090;
        Wed,  1 Sep 2021 12:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499799;
        bh=Slas5ioF+scPwRjP9/R0Fg+V/Sln45bYU25gWaOz6Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ySdNV5OGnsLerAUXHcAFjt/Xl5PtdoGMuw0Ii1RyrUJkxBU0b8eccrNgpp1gaCWK2
         54Vp5/i/Uq1zb29OkKiTJ3yZSx494G+iI/zbop+tQY9x/QyKXqK2hI9cfMrutvqQzG
         2P3xERun24Ahu/JXG2doMjc+cHrXwmB/IzIZvDn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.10 090/103] srcu: Provide polling interfaces for Tiny SRCU grace periods
Date:   Wed,  1 Sep 2021 14:28:40 +0200
Message-Id: <20210901122303.565740274@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

commit 8b5bd67cf6422b63ee100d76d8de8960ca2df7f0 upstream.

There is a need for a polling interface for SRCU grace
periods, so this commit supplies get_state_synchronize_srcu(),
start_poll_synchronize_srcu(), and poll_state_synchronize_srcu() for this
purpose.  The first can be used if future grace periods are inevitable
(perhaps due to a later call_srcu() invocation), the second if future
grace periods might not otherwise happen, and the third to check if a
grace period has elapsed since the corresponding call to either of the
first two.

As with get_state_synchronize_rcu() and cond_synchronize_rcu(),
the return value from either get_state_synchronize_srcu() or
start_poll_synchronize_srcu() must be passed in to a later call to
poll_state_synchronize_srcu().

Link: https://lore.kernel.org/rcu/20201112201547.GF3365678@moria.home.lan/
Reported-by: Kent Overstreet <kent.overstreet@gmail.com>
[ paulmck: Add EXPORT_SYMBOL_GPL() per kernel test robot feedback. ]
[ paulmck: Apply feedback from Neeraj Upadhyay. ]
Link: https://lore.kernel.org/lkml/20201117004017.GA7444@paulmck-ThinkPad-P72/
Reviewed-by: Neeraj Upadhyay <neeraju@codeaurora.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rcupdate.h |    2 +
 include/linux/srcu.h     |    3 ++
 include/linux/srcutiny.h |    1 
 kernel/rcu/srcutiny.c    |   55 +++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 59 insertions(+), 2 deletions(-)

--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -33,6 +33,8 @@
 #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
 #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
 #define ulong2long(a)		(*(long *)(&(a)))
+#define USHORT_CMP_GE(a, b)	(USHRT_MAX / 2 >= (unsigned short)((a) - (b)))
+#define USHORT_CMP_LT(a, b)	(USHRT_MAX / 2 < (unsigned short)((a) - (b)))
 
 /* Exported common interfaces */
 void call_rcu(struct rcu_head *head, rcu_callback_t func);
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -60,6 +60,9 @@ void cleanup_srcu_struct(struct srcu_str
 int __srcu_read_lock(struct srcu_struct *ssp) __acquires(ssp);
 void __srcu_read_unlock(struct srcu_struct *ssp, int idx) __releases(ssp);
 void synchronize_srcu(struct srcu_struct *ssp);
+unsigned long get_state_synchronize_srcu(struct srcu_struct *ssp);
+unsigned long start_poll_synchronize_srcu(struct srcu_struct *ssp);
+bool poll_state_synchronize_srcu(struct srcu_struct *ssp, unsigned long cookie);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
--- a/include/linux/srcutiny.h
+++ b/include/linux/srcutiny.h
@@ -16,6 +16,7 @@
 struct srcu_struct {
 	short srcu_lock_nesting[2];	/* srcu_read_lock() nesting depth. */
 	unsigned short srcu_idx;	/* Current reader array element in bit 0x2. */
+	unsigned short srcu_idx_max;	/* Furthest future srcu_idx request. */
 	u8 srcu_gp_running;		/* GP workqueue running? */
 	u8 srcu_gp_waiting;		/* GP waiting for readers? */
 	struct swait_queue_head srcu_wq;
--- a/kernel/rcu/srcutiny.c
+++ b/kernel/rcu/srcutiny.c
@@ -34,6 +34,7 @@ static int init_srcu_struct_fields(struc
 	ssp->srcu_gp_running = false;
 	ssp->srcu_gp_waiting = false;
 	ssp->srcu_idx = 0;
+	ssp->srcu_idx_max = 0;
 	INIT_WORK(&ssp->srcu_work, srcu_drive_gp);
 	INIT_LIST_HEAD(&ssp->srcu_work.entry);
 	return 0;
@@ -84,6 +85,8 @@ void cleanup_srcu_struct(struct srcu_str
 	WARN_ON(ssp->srcu_gp_waiting);
 	WARN_ON(ssp->srcu_cb_head);
 	WARN_ON(&ssp->srcu_cb_head != ssp->srcu_cb_tail);
+	WARN_ON(ssp->srcu_idx != ssp->srcu_idx_max);
+	WARN_ON(ssp->srcu_idx & 0x1);
 }
 EXPORT_SYMBOL_GPL(cleanup_srcu_struct);
 
@@ -114,7 +117,7 @@ void srcu_drive_gp(struct work_struct *w
 	struct srcu_struct *ssp;
 
 	ssp = container_of(wp, struct srcu_struct, srcu_work);
-	if (ssp->srcu_gp_running || !READ_ONCE(ssp->srcu_cb_head))
+	if (ssp->srcu_gp_running || USHORT_CMP_GE(ssp->srcu_idx, READ_ONCE(ssp->srcu_idx_max)))
 		return; /* Already running or nothing to do. */
 
 	/* Remove recently arrived callbacks and wait for readers. */
@@ -147,13 +150,19 @@ void srcu_drive_gp(struct work_struct *w
 	 * straighten that out.
 	 */
 	WRITE_ONCE(ssp->srcu_gp_running, false);
-	if (READ_ONCE(ssp->srcu_cb_head))
+	if (USHORT_CMP_LT(ssp->srcu_idx, READ_ONCE(ssp->srcu_idx_max)))
 		schedule_work(&ssp->srcu_work);
 }
 EXPORT_SYMBOL_GPL(srcu_drive_gp);
 
 static void srcu_gp_start_if_needed(struct srcu_struct *ssp)
 {
+	unsigned short cookie;
+
+	cookie = get_state_synchronize_srcu(ssp);
+	if (USHORT_CMP_GE(READ_ONCE(ssp->srcu_idx_max), cookie))
+		return;
+	WRITE_ONCE(ssp->srcu_idx_max, cookie);
 	if (!READ_ONCE(ssp->srcu_gp_running)) {
 		if (likely(srcu_init_done))
 			schedule_work(&ssp->srcu_work);
@@ -196,6 +205,48 @@ void synchronize_srcu(struct srcu_struct
 }
 EXPORT_SYMBOL_GPL(synchronize_srcu);
 
+/*
+ * get_state_synchronize_srcu - Provide an end-of-grace-period cookie
+ */
+unsigned long get_state_synchronize_srcu(struct srcu_struct *ssp)
+{
+	unsigned long ret;
+
+	barrier();
+	ret = (READ_ONCE(ssp->srcu_idx) + 3) & ~0x1;
+	barrier();
+	return ret & USHRT_MAX;
+}
+EXPORT_SYMBOL_GPL(get_state_synchronize_srcu);
+
+/*
+ * start_poll_synchronize_srcu - Provide cookie and start grace period
+ *
+ * The difference between this and get_state_synchronize_srcu() is that
+ * this function ensures that the poll_state_synchronize_srcu() will
+ * eventually return the value true.
+ */
+unsigned long start_poll_synchronize_srcu(struct srcu_struct *ssp)
+{
+	unsigned long ret = get_state_synchronize_srcu(ssp);
+
+	srcu_gp_start_if_needed(ssp);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(start_poll_synchronize_srcu);
+
+/*
+ * poll_state_synchronize_srcu - Has cookie's grace period ended?
+ */
+bool poll_state_synchronize_srcu(struct srcu_struct *ssp, unsigned long cookie)
+{
+	bool ret = USHORT_CMP_GE(READ_ONCE(ssp->srcu_idx), cookie);
+
+	barrier();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(poll_state_synchronize_srcu);
+
 /* Lockdep diagnostics.  */
 void __init rcu_scheduler_starting(void)
 {


