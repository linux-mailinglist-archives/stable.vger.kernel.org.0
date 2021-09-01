Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F063FDB05
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244801AbhIAMhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343493AbhIAMfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:35:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E970261102;
        Wed,  1 Sep 2021 12:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499599;
        bh=bwLrbux92Y5Vm+qskrzyq96eeJLwc3+rzDBPF2PqXJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVwDyrARsxYjWE1yJ/VlcseTCU066XtqcjhUxjIubpLTyP1okLLquHJRCa5nht0lr
         +1Pdv4EAhcaX8l6Ch/eVC4tWrrd8iqqE4VNVpBVk258isVSHg4jxG4OFzD5jSlgDA+
         rBemPZHTK/XAHGx0thk0V0Pq9zkEOAbYgq6p0urU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 013/103] ceph: correctly handle releasing an embedded cap flush
Date:   Wed,  1 Sep 2021 14:27:23 +0200
Message-Id: <20210901122300.975643502@linuxfoundation.org>
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

From: Xiubo Li <xiubli@redhat.com>

commit b2f9fa1f3bd8846f50b355fc2168236975c4d264 upstream.

The ceph_cap_flush structures are usually dynamically allocated, but
the ceph_cap_snap has an embedded one.

When force umounting, the client will try to remove all the session
caps. During this, it will free them, but that should not be done
with the ones embedded in a capsnap.

Fix this by adding a new boolean that indicates that the cap flush is
embedded in a capsnap, and skip freeing it if that's set.

At the same time, switch to using list_del_init() when detaching the
i_list and g_list heads.  It's possible for a forced umount to remove
these objects but then handle_cap_flushsnap_ack() races in and does the
list_del_init() again, corrupting memory.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/52283
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c       |   21 +++++++++++++--------
 fs/ceph/mds_client.c |    7 ++++---
 fs/ceph/snap.c       |    3 +++
 fs/ceph/super.h      |    3 ++-
 4 files changed, 22 insertions(+), 12 deletions(-)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1752,7 +1752,11 @@ int __ceph_mark_dirty_caps(struct ceph_i
 
 struct ceph_cap_flush *ceph_alloc_cap_flush(void)
 {
-	return kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
+	struct ceph_cap_flush *cf;
+
+	cf = kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
+	cf->is_capsnap = false;
+	return cf;
 }
 
 void ceph_free_cap_flush(struct ceph_cap_flush *cf)
@@ -1787,7 +1791,7 @@ static bool __detach_cap_flush_from_mdsc
 		prev->wake = true;
 		wake = false;
 	}
-	list_del(&cf->g_list);
+	list_del_init(&cf->g_list);
 	return wake;
 }
 
@@ -1802,7 +1806,7 @@ static bool __detach_cap_flush_from_ci(s
 		prev->wake = true;
 		wake = false;
 	}
-	list_del(&cf->i_list);
+	list_del_init(&cf->i_list);
 	return wake;
 }
 
@@ -2422,7 +2426,7 @@ static void __kick_flushing_caps(struct
 	ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
 
 	list_for_each_entry_reverse(cf, &ci->i_cap_flush_list, i_list) {
-		if (!cf->caps) {
+		if (cf->is_capsnap) {
 			last_snap_flush = cf->tid;
 			break;
 		}
@@ -2441,7 +2445,7 @@ static void __kick_flushing_caps(struct
 
 		first_tid = cf->tid + 1;
 
-		if (cf->caps) {
+		if (!cf->is_capsnap) {
 			struct cap_msg_args arg;
 
 			dout("kick_flushing_caps %p cap %p tid %llu %s\n",
@@ -3564,7 +3568,7 @@ static void handle_cap_flush_ack(struct
 			cleaned = cf->caps;
 
 		/* Is this a capsnap? */
-		if (cf->caps == 0)
+		if (cf->is_capsnap)
 			continue;
 
 		if (cf->tid <= flush_tid) {
@@ -3637,8 +3641,9 @@ out:
 	while (!list_empty(&to_remove)) {
 		cf = list_first_entry(&to_remove,
 				      struct ceph_cap_flush, i_list);
-		list_del(&cf->i_list);
-		ceph_free_cap_flush(cf);
+		list_del_init(&cf->i_list);
+		if (!cf->is_capsnap)
+			ceph_free_cap_flush(cf);
 	}
 
 	if (wake_ci)
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1618,7 +1618,7 @@ static int remove_session_caps_cb(struct
 		spin_lock(&mdsc->cap_dirty_lock);
 
 		list_for_each_entry(cf, &to_remove, i_list)
-			list_del(&cf->g_list);
+			list_del_init(&cf->g_list);
 
 		if (!list_empty(&ci->i_dirty_item)) {
 			pr_warn_ratelimited(
@@ -1670,8 +1670,9 @@ static int remove_session_caps_cb(struct
 		struct ceph_cap_flush *cf;
 		cf = list_first_entry(&to_remove,
 				      struct ceph_cap_flush, i_list);
-		list_del(&cf->i_list);
-		ceph_free_cap_flush(cf);
+		list_del_init(&cf->i_list);
+		if (!cf->is_capsnap)
+			ceph_free_cap_flush(cf);
 	}
 
 	wake_up_all(&ci->i_cap_wq);
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -487,6 +487,9 @@ void ceph_queue_cap_snap(struct ceph_ino
 		pr_err("ENOMEM allocating ceph_cap_snap on %p\n", inode);
 		return;
 	}
+	capsnap->cap_flush.is_capsnap = true;
+	INIT_LIST_HEAD(&capsnap->cap_flush.i_list);
+	INIT_LIST_HEAD(&capsnap->cap_flush.g_list);
 
 	spin_lock(&ci->i_ceph_lock);
 	used = __ceph_caps_used(ci);
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -181,8 +181,9 @@ struct ceph_cap {
 
 struct ceph_cap_flush {
 	u64 tid;
-	int caps; /* 0 means capsnap */
+	int caps;
 	bool wake; /* wake up flush waiters when finish ? */
+	bool is_capsnap; /* true means capsnap */
 	struct list_head g_list; // global
 	struct list_head i_list; // per inode
 };


