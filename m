Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F0B15F456
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394590AbgBNSU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:20:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:53788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730306AbgBNPuF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:50:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB79124689;
        Fri, 14 Feb 2020 15:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695404;
        bh=QDbcSE8Xu5JeiofYS9+dLJs+2AYt2A/dcxPo4yHaiRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdeSOTcHm/L/OzlMFPklhX268BEITsk+xfUqGqSqPIXLIHH6fwqwjhGKjKcoIKL4d
         l+cxmEONiaFnMaabTqcpQW5hn0ZpZpgsSqXW/1Sp6YAYnqq/aPd1dJVme+blwlBGXt
         CT5hp6r0NwGabczXNowrSjP94uMS6sIJj8MCBhFk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heinz Mauelshagen <heinzm@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com,
        linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 053/542] dm raid: table line rebuild status fixes
Date:   Fri, 14 Feb 2020 10:40:45 -0500
Message-Id: <20200214154854.6746-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

[ Upstream commit 43f3952a51f8198d365acb7f51fe42d578fe5d0a ]

raid_status() wasn't emitting rebuild flags on the table line properly
because the rdev number was not yet set properly; index raid component
devices array directly to solve.

Also fix wrong argument count on emitted table line caused by 1 too
many rebuild/write_mostly argument and consider any journal_(dev|mode)
pairs.

Link: https://bugzilla.redhat.com/1782045
Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/device-mapper/dm-raid.rst     |  2 +
 drivers/md/dm-raid.c                          | 43 ++++++++++---------
 2 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-raid.rst b/Documentation/admin-guide/device-mapper/dm-raid.rst
index f6344675e3951..695a2ea1d1ae2 100644
--- a/Documentation/admin-guide/device-mapper/dm-raid.rst
+++ b/Documentation/admin-guide/device-mapper/dm-raid.rst
@@ -419,3 +419,5 @@ Version History
 	rebuild errors.
  1.15.0 Fix size extensions not being synchronized in case of new MD bitmap
         pages allocated;  also fix those not occuring after previous reductions
+ 1.15.1 Fix argument count and arguments for rebuild/write_mostly/journal_(dev|mode)
+        on the status line.
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index c412eaa975fc0..9a18bef0a5ff0 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -129,7 +129,9 @@ struct raid_dev {
 				  CTR_FLAG_RAID10_COPIES | \
 				  CTR_FLAG_RAID10_FORMAT | \
 				  CTR_FLAG_DELTA_DISKS | \
-				  CTR_FLAG_DATA_OFFSET)
+				  CTR_FLAG_DATA_OFFSET | \
+				  CTR_FLAG_JOURNAL_DEV | \
+				  CTR_FLAG_JOURNAL_MODE)
 
 /* Valid options definitions per raid level... */
 
@@ -3001,7 +3003,6 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		{ 1, 254, "Cannot understand number of raid devices parameters" }
 	};
 
-	/* Must have <raid_type> */
 	arg = dm_shift_arg(&as);
 	if (!arg) {
 		ti->error = "No arguments";
@@ -3508,8 +3509,7 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 	unsigned long recovery;
 	unsigned int raid_param_cnt = 1; /* at least 1 for chunksize */
 	unsigned int sz = 0;
-	unsigned int rebuild_disks;
-	unsigned int write_mostly_params = 0;
+	unsigned int rebuild_writemostly_count = 0;
 	sector_t progress, resync_max_sectors, resync_mismatches;
 	enum sync_state state;
 	struct raid_type *rt;
@@ -3593,18 +3593,20 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 	case STATUSTYPE_TABLE:
 		/* Report the table line string you would use to construct this raid set */
 
-		/* Calculate raid parameter count */
-		for (i = 0; i < rs->raid_disks; i++)
-			if (test_bit(WriteMostly, &rs->dev[i].rdev.flags))
-				write_mostly_params += 2;
-		rebuild_disks = memweight(rs->rebuild_disks, DISKS_ARRAY_ELEMS * sizeof(*rs->rebuild_disks));
-		raid_param_cnt += rebuild_disks * 2 +
-				  write_mostly_params +
+		/*
+		 * Count any rebuild or writemostly argument pairs and subtract the
+		 * hweight count being added below of any rebuild and writemostly ctr flags.
+		 */
+		for (i = 0; i < rs->raid_disks; i++) {
+			rebuild_writemostly_count += (test_bit(i, (void *) rs->rebuild_disks) ? 2 : 0) +
+						     (test_bit(WriteMostly, &rs->dev[i].rdev.flags) ? 2 : 0);
+		}
+		rebuild_writemostly_count -= (test_bit(__CTR_FLAG_REBUILD, &rs->ctr_flags) ? 2 : 0) +
+					     (test_bit(__CTR_FLAG_WRITE_MOSTLY, &rs->ctr_flags) ? 2 : 0);
+		/* Calculate raid parameter count based on ^ rebuild/writemostly argument counts and ctr flags set. */
+		raid_param_cnt += rebuild_writemostly_count +
 				  hweight32(rs->ctr_flags & CTR_FLAG_OPTIONS_NO_ARGS) +
-				  hweight32(rs->ctr_flags & CTR_FLAG_OPTIONS_ONE_ARG) * 2 +
-				  (test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags) ? 2 : 0) +
-				  (test_bit(__CTR_FLAG_JOURNAL_MODE, &rs->ctr_flags) ? 2 : 0);
-
+				  hweight32(rs->ctr_flags & CTR_FLAG_OPTIONS_ONE_ARG) * 2;
 		/* Emit table line */
 		/* This has to be in the documented order for userspace! */
 		DMEMIT("%s %u %u", rs->raid_type->name, raid_param_cnt, mddev->new_chunk_sectors);
@@ -3612,11 +3614,10 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 			DMEMIT(" %s", dm_raid_arg_name_by_flag(CTR_FLAG_SYNC));
 		if (test_bit(__CTR_FLAG_NOSYNC, &rs->ctr_flags))
 			DMEMIT(" %s", dm_raid_arg_name_by_flag(CTR_FLAG_NOSYNC));
-		if (rebuild_disks)
+		if (test_bit(__CTR_FLAG_REBUILD, &rs->ctr_flags))
 			for (i = 0; i < rs->raid_disks; i++)
-				if (test_bit(rs->dev[i].rdev.raid_disk, (void *) rs->rebuild_disks))
-					DMEMIT(" %s %u", dm_raid_arg_name_by_flag(CTR_FLAG_REBUILD),
-							 rs->dev[i].rdev.raid_disk);
+				if (test_bit(i, (void *) rs->rebuild_disks))
+					DMEMIT(" %s %u", dm_raid_arg_name_by_flag(CTR_FLAG_REBUILD), i);
 		if (test_bit(__CTR_FLAG_DAEMON_SLEEP, &rs->ctr_flags))
 			DMEMIT(" %s %lu", dm_raid_arg_name_by_flag(CTR_FLAG_DAEMON_SLEEP),
 					  mddev->bitmap_info.daemon_sleep);
@@ -3626,7 +3627,7 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 		if (test_bit(__CTR_FLAG_MAX_RECOVERY_RATE, &rs->ctr_flags))
 			DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_MAX_RECOVERY_RATE),
 					 mddev->sync_speed_max);
-		if (write_mostly_params)
+		if (test_bit(__CTR_FLAG_WRITE_MOSTLY, &rs->ctr_flags))
 			for (i = 0; i < rs->raid_disks; i++)
 				if (test_bit(WriteMostly, &rs->dev[i].rdev.flags))
 					DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_WRITE_MOSTLY),
@@ -4029,7 +4030,7 @@ static void raid_resume(struct dm_target *ti)
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 15, 0},
+	.version = {1, 15, 1},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
-- 
2.20.1

