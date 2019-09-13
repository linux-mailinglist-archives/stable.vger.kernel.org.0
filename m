Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF590B2027
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389990AbfIMNRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:17:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389415AbfIMNRG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:17:06 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AD41208C0;
        Fri, 13 Sep 2019 13:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380626;
        bh=idB7S4GBwREfJt9IsNiq7AuzPjumW9BsBfo2bRyJezg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oH9p1YssbclE8qHTUliWsrI/JfSXCfda4pJDY3icx7GJxlZVNe9F3v0hUaM9yRJ42
         +ltNf0wttSWP0E9QN7NRSQ6b3SG7Jv3SyxsogmEWVzSuuZJvnPR2WGtwG6q0V8Y+cK
         8tqi1jOI04787h4yBvhofJaTJ9hQTQLsJ5yGscTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@vger.kernl.org,
        Yufen Yu <yuyufen@huawei.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 126/190] dm mpath: fix missing call of path selector type->end_io
Date:   Fri, 13 Sep 2019 14:06:21 +0100
Message-Id: <20190913130609.957728739@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5de719e3d01b4abe0de0d7b857148a880ff2a90b ]

After commit 396eaf21ee17 ("blk-mq: improve DM's blk-mq IO merging via
blk_insert_cloned_request feedback"), map_request() will requeue the tio
when issued clone request return BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE.

Thus, if device driver status is error, a tio may be requeued multiple
times until the return value is not DM_MAPIO_REQUEUE.  That means
type->start_io may be called multiple times, while type->end_io is only
called when IO complete.

In fact, even without commit 396eaf21ee17, setup_clone() failure can
also cause tio requeue and associated missed call to type->end_io.

The service-time path selector selects path based on in_flight_size,
which is increased by st_start_io() and decreased by st_end_io().
Missed calls to st_end_io() can lead to in_flight_size count error and
will cause the selector to make the wrong choice.  In addition,
queue-length path selector will also be affected.

To fix the problem, call type->end_io in ->release_clone_rq before tio
requeue.  map_info is passed to ->release_clone_rq() for map_request()
error path that result in requeue.

Fixes: 396eaf21ee17 ("blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback")
Cc: stable@vger.kernl.org
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-mpath.c         | 17 ++++++++++++++++-
 drivers/md/dm-rq.c            |  8 ++++----
 drivers/md/dm-target.c        |  3 ++-
 include/linux/device-mapper.h |  3 ++-
 4 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index baa966e2778c0..481e54ded9dc7 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -554,8 +554,23 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 	return DM_MAPIO_REMAPPED;
 }
 
-static void multipath_release_clone(struct request *clone)
+static void multipath_release_clone(struct request *clone,
+				    union map_info *map_context)
 {
+	if (unlikely(map_context)) {
+		/*
+		 * non-NULL map_context means caller is still map
+		 * method; must undo multipath_clone_and_map()
+		 */
+		struct dm_mpath_io *mpio = get_mpio(map_context);
+		struct pgpath *pgpath = mpio->pgpath;
+
+		if (pgpath && pgpath->pg->ps.type->end_io)
+			pgpath->pg->ps.type->end_io(&pgpath->pg->ps,
+						    &pgpath->path,
+						    mpio->nr_bytes);
+	}
+
 	blk_put_request(clone);
 }
 
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 264b84e274aac..17c6a73c536c6 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -219,7 +219,7 @@ static void dm_end_request(struct request *clone, blk_status_t error)
 	struct request *rq = tio->orig;
 
 	blk_rq_unprep_clone(clone);
-	tio->ti->type->release_clone_rq(clone);
+	tio->ti->type->release_clone_rq(clone, NULL);
 
 	rq_end_stats(md, rq);
 	if (!rq->q->mq_ops)
@@ -270,7 +270,7 @@ static void dm_requeue_original_request(struct dm_rq_target_io *tio, bool delay_
 	rq_end_stats(md, rq);
 	if (tio->clone) {
 		blk_rq_unprep_clone(tio->clone);
-		tio->ti->type->release_clone_rq(tio->clone);
+		tio->ti->type->release_clone_rq(tio->clone, NULL);
 	}
 
 	if (!rq->q->mq_ops)
@@ -495,7 +495,7 @@ check_again:
 	case DM_MAPIO_REMAPPED:
 		if (setup_clone(clone, rq, tio, GFP_ATOMIC)) {
 			/* -ENOMEM */
-			ti->type->release_clone_rq(clone);
+			ti->type->release_clone_rq(clone, &tio->info);
 			return DM_MAPIO_REQUEUE;
 		}
 
@@ -505,7 +505,7 @@ check_again:
 		ret = dm_dispatch_clone_request(clone, rq);
 		if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE) {
 			blk_rq_unprep_clone(clone);
-			tio->ti->type->release_clone_rq(clone);
+			tio->ti->type->release_clone_rq(clone, &tio->info);
 			tio->clone = NULL;
 			if (!rq->q->mq_ops)
 				r = DM_MAPIO_DELAY_REQUEUE;
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 314d17ca64668..64dd0b34fcf49 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -136,7 +136,8 @@ static int io_err_clone_and_map_rq(struct dm_target *ti, struct request *rq,
 	return DM_MAPIO_KILL;
 }
 
-static void io_err_release_clone_rq(struct request *clone)
+static void io_err_release_clone_rq(struct request *clone,
+				    union map_info *map_context)
 {
 }
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index bef2e36c01b4b..91f9f95ad5066 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -62,7 +62,8 @@ typedef int (*dm_clone_and_map_request_fn) (struct dm_target *ti,
 					    struct request *rq,
 					    union map_info *map_context,
 					    struct request **clone);
-typedef void (*dm_release_clone_request_fn) (struct request *clone);
+typedef void (*dm_release_clone_request_fn) (struct request *clone,
+					     union map_info *map_context);
 
 /*
  * Returns:
-- 
2.20.1



