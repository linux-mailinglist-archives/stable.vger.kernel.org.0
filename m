Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BC93EC910
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 14:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhHOMkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 08:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhHOMkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Aug 2021 08:40:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC4D66112D;
        Sun, 15 Aug 2021 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629031212;
        bh=M8eBdYMSYkbDEwK+D2IdeFGGGxEpynB7akTZlPlrMyc=;
        h=Subject:To:Cc:From:Date:From;
        b=sFRdWRQxgAJWytxcGxoAt5a3S08wJhC3FRVoJIfRKXPT8ZNE5plLnN/uRPuLNnHSL
         m9WfgzcBg7b4oTmSM9CBE0BY197tI6K93Pkha8mGJP82D+UTHvjDL7u6vleSL7Ya3+
         4dCwMFhCTwpcCmJhusmRWI3HoLJB4W7vNlg8F86g=
Subject: FAILED: patch "[PATCH] ceph: take snap_empty_lock atomically with snaprealm refcount" failed to apply to 5.10-stable tree
To:     jlayton@kernel.org, idryomov@gmail.com, lhenriques@suse.de,
        mnelson@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Aug 2021 14:40:10 +0200
Message-ID: <162903121071131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8434ffe71c874b9c4e184b88d25de98c2bf5fe3f Mon Sep 17 00:00:00 2001
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 3 Aug 2021 12:47:34 -0400
Subject: [PATCH] ceph: take snap_empty_lock atomically with snaprealm refcount
 change

There is a race in ceph_put_snap_realm. The change to the nref and the
spinlock acquisition are not done atomically, so you could decrement
nref, and before you take the spinlock, the nref is incremented again.
At that point, you end up putting it on the empty list when it
shouldn't be there. Eventually __cleanup_empty_realms runs and frees
it when it's still in-use.

Fix this by protecting the 1->0 transition with atomic_dec_and_lock,
and just drop the spinlock if we can get the rwsem.

Because these objects can also undergo a 0->1 refcount transition, we
must protect that change as well with the spinlock. Increment locklessly
unless the value is at 0, in which case we take the spinlock, increment
and then take it off the empty list if it did the 0->1 transition.

With these changes, I'm removing the dout() messages from these
functions, as well as in __put_snap_realm. They've always been racy, and
it's better to not print values that may be misleading.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/46419
Reported-by: Mark Nelson <mnelson@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Luis Henriques <lhenriques@suse.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 4ac0606dcbd4..4c6bd1042c94 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -67,19 +67,19 @@ void ceph_get_snap_realm(struct ceph_mds_client *mdsc,
 {
 	lockdep_assert_held(&mdsc->snap_rwsem);
 
-	dout("get_realm %p %d -> %d\n", realm,
-	     atomic_read(&realm->nref), atomic_read(&realm->nref)+1);
 	/*
-	 * since we _only_ increment realm refs or empty the empty
-	 * list with snap_rwsem held, adjusting the empty list here is
-	 * safe.  we do need to protect against concurrent empty list
-	 * additions, however.
+	 * The 0->1 and 1->0 transitions must take the snap_empty_lock
+	 * atomically with the refcount change. Go ahead and bump the
+	 * nref here, unless it's 0, in which case we take the spinlock
+	 * and then do the increment and remove it from the list.
 	 */
-	if (atomic_inc_return(&realm->nref) == 1) {
-		spin_lock(&mdsc->snap_empty_lock);
+	if (atomic_inc_not_zero(&realm->nref))
+		return;
+
+	spin_lock(&mdsc->snap_empty_lock);
+	if (atomic_inc_return(&realm->nref) == 1)
 		list_del_init(&realm->empty_item);
-		spin_unlock(&mdsc->snap_empty_lock);
-	}
+	spin_unlock(&mdsc->snap_empty_lock);
 }
 
 static void __insert_snap_realm(struct rb_root *root,
@@ -208,28 +208,28 @@ static void __put_snap_realm(struct ceph_mds_client *mdsc,
 {
 	lockdep_assert_held_write(&mdsc->snap_rwsem);
 
-	dout("__put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
-	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
+	/*
+	 * We do not require the snap_empty_lock here, as any caller that
+	 * increments the value must hold the snap_rwsem.
+	 */
 	if (atomic_dec_and_test(&realm->nref))
 		__destroy_snap_realm(mdsc, realm);
 }
 
 /*
- * caller needn't hold any locks
+ * See comments in ceph_get_snap_realm. Caller needn't hold any locks.
  */
 void ceph_put_snap_realm(struct ceph_mds_client *mdsc,
 			 struct ceph_snap_realm *realm)
 {
-	dout("put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
-	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
-	if (!atomic_dec_and_test(&realm->nref))
+	if (!atomic_dec_and_lock(&realm->nref, &mdsc->snap_empty_lock))
 		return;
 
 	if (down_write_trylock(&mdsc->snap_rwsem)) {
+		spin_unlock(&mdsc->snap_empty_lock);
 		__destroy_snap_realm(mdsc, realm);
 		up_write(&mdsc->snap_rwsem);
 	} else {
-		spin_lock(&mdsc->snap_empty_lock);
 		list_add(&realm->empty_item, &mdsc->snap_empty);
 		spin_unlock(&mdsc->snap_empty_lock);
 	}

