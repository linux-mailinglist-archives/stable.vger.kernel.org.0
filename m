Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D09E3D6268
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237170AbhGZPf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233829AbhGZPfO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:35:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8800360FDA;
        Mon, 26 Jul 2021 16:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316141;
        bh=MEJHq/SKopmXcuLagfFWfaOFyUiAuIfkbUbDQ1LTcz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sXqmvq6s930t/tdSMBaZNQBIStYUlPo6yLttyKVvPud/FVdZDa1eQmW8Wh5Q3JSlJ
         Y1SSwkzIPfbIoqdQtYYetGltJpZXULaz9IC3cZRjI4udZCcIiUNMYDkPWaShfhnjLS
         x5qTtjDh3PCF3u07S1K3SGxfNU1aoVkM5PYOpTCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Robin Geuze <robin.geuze@nl.team.blue>
Subject: [PATCH 5.13 204/223] rbd: always kick acquire on "acquired" and "released" notifications
Date:   Mon, 26 Jul 2021 17:39:56 +0200
Message-Id: <20210726153852.865597181@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

commit 8798d070d416d18a75770fc19787e96705073f43 upstream.

Skipping the "lock has been released" notification if the lock owner
is not what we expect based on owner_cid can lead to I/O hangs.
One example is our own notifications: because owner_cid is cleared
in rbd_unlock(), when we get our own notification it is processed as
unexpected/duplicate and maybe_kick_acquire() isn't called.  If a peer
that requested the lock then doesn't go through with acquiring it,
I/O requests that came in while the lock was being quiesced would
be stalled until another I/O request is submitted and kicks acquire
from rbd_img_exclusive_lock().

This makes the comment in rbd_release_lock() actually true: prior to
this change the canceled work was being requeued in response to the
"lock has been acquired" notification from rbd_handle_acquired_lock().

Cc: stable@vger.kernel.org # 5.3+
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Tested-by: Robin Geuze <robin.geuze@nl.team.blue>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4201,15 +4201,11 @@ static void rbd_handle_acquired_lock(str
 	if (!rbd_cid_equal(&cid, &rbd_empty_cid)) {
 		down_write(&rbd_dev->lock_rwsem);
 		if (rbd_cid_equal(&cid, &rbd_dev->owner_cid)) {
-			/*
-			 * we already know that the remote client is
-			 * the owner
-			 */
-			up_write(&rbd_dev->lock_rwsem);
-			return;
+			dout("%s rbd_dev %p cid %llu-%llu == owner_cid\n",
+			     __func__, rbd_dev, cid.gid, cid.handle);
+		} else {
+			rbd_set_owner_cid(rbd_dev, &cid);
 		}
-
-		rbd_set_owner_cid(rbd_dev, &cid);
 		downgrade_write(&rbd_dev->lock_rwsem);
 	} else {
 		down_read(&rbd_dev->lock_rwsem);
@@ -4234,14 +4230,12 @@ static void rbd_handle_released_lock(str
 	if (!rbd_cid_equal(&cid, &rbd_empty_cid)) {
 		down_write(&rbd_dev->lock_rwsem);
 		if (!rbd_cid_equal(&cid, &rbd_dev->owner_cid)) {
-			dout("%s rbd_dev %p unexpected owner, cid %llu-%llu != owner_cid %llu-%llu\n",
+			dout("%s rbd_dev %p cid %llu-%llu != owner_cid %llu-%llu\n",
 			     __func__, rbd_dev, cid.gid, cid.handle,
 			     rbd_dev->owner_cid.gid, rbd_dev->owner_cid.handle);
-			up_write(&rbd_dev->lock_rwsem);
-			return;
+		} else {
+			rbd_set_owner_cid(rbd_dev, &rbd_empty_cid);
 		}
-
-		rbd_set_owner_cid(rbd_dev, &rbd_empty_cid);
 		downgrade_write(&rbd_dev->lock_rwsem);
 	} else {
 		down_read(&rbd_dev->lock_rwsem);


