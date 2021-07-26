Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D263D61A8
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhGZPcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231674AbhGZP2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:28:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FC8A60FD7;
        Mon, 26 Jul 2021 16:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315625;
        bh=Vd/X1vc8VcfRMAmh0C+ZoQXOmp81scgTnTXft9foiX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NjUpRWLLrOZn52cBHLSi8KzR3Rc+Rd2ueFKIWyvoSP4ti+WbkdG6aHrYVm5cSqnQ+
         qH52yfNR9z/dj3Mqk3Gt3W4fdJzYVFdtKToTvrcuby4GQo8KYRYnsjWbQOb3Wt85wz
         PGEcCJq4E9Aye4Lkj2lL3H2gxyiWMhwFIE16sjo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Robin Geuze <robin.geuze@nl.team.blue>
Subject: [PATCH 5.10 149/167] rbd: dont hold lock_rwsem while running_list is being drained
Date:   Mon, 26 Jul 2021 17:39:42 +0200
Message-Id: <20210726153844.421709292@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

commit ed9eb71085ecb7ded9a5118cec2ab70667cc7350 upstream.

Currently rbd_quiesce_lock() holds lock_rwsem for read while blocking
on releasing_wait completion.  On the I/O completion side, each image
request also needs to take lock_rwsem for read.  Because rw_semaphore
implementation doesn't allow new readers after a writer has indicated
interest in the lock, this can result in a deadlock if something that
needs to take lock_rwsem for write gets involved.  For example:

1. watch error occurs
2. rbd_watch_errcb() takes lock_rwsem for write, clears owner_cid and
   releases lock_rwsem
3. after reestablishing the watch, rbd_reregister_watch() takes
   lock_rwsem for write and calls rbd_reacquire_lock()
4. rbd_quiesce_lock() downgrades lock_rwsem to for read and blocks on
   releasing_wait until running_list becomes empty
5. another watch error occurs
6. rbd_watch_errcb() blocks trying to take lock_rwsem for write
7. no in-flight image request can complete and delete itself from
   running_list because lock_rwsem won't be granted anymore

A similar scenario can occur with "lock has been acquired" and "lock
has been released" notification handers which also take lock_rwsem for
write to update owner_cid.

We don't actually get anything useful from sitting on lock_rwsem in
rbd_quiesce_lock() -- owner_cid updates certainly don't need to be
synchronized with.  In fact the whole owner_cid tracking logic could
probably be removed from the kernel client because we don't support
proxied maintenance operations.

Cc: stable@vger.kernel.org # 5.3+
URL: https://tracker.ceph.com/issues/42757
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Tested-by: Robin Geuze <robin.geuze@nl.team.blue>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4147,8 +4147,6 @@ again:
 
 static bool rbd_quiesce_lock(struct rbd_device *rbd_dev)
 {
-	bool need_wait;
-
 	dout("%s rbd_dev %p\n", __func__, rbd_dev);
 	lockdep_assert_held_write(&rbd_dev->lock_rwsem);
 
@@ -4160,11 +4158,11 @@ static bool rbd_quiesce_lock(struct rbd_
 	 */
 	rbd_dev->lock_state = RBD_LOCK_STATE_RELEASING;
 	rbd_assert(!completion_done(&rbd_dev->releasing_wait));
-	need_wait = !list_empty(&rbd_dev->running_list);
-	downgrade_write(&rbd_dev->lock_rwsem);
-	if (need_wait)
-		wait_for_completion(&rbd_dev->releasing_wait);
-	up_read(&rbd_dev->lock_rwsem);
+	if (list_empty(&rbd_dev->running_list))
+		return true;
+
+	up_write(&rbd_dev->lock_rwsem);
+	wait_for_completion(&rbd_dev->releasing_wait);
 
 	down_write(&rbd_dev->lock_rwsem);
 	if (rbd_dev->lock_state != RBD_LOCK_STATE_RELEASING)


