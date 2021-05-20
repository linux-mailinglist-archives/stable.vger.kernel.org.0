Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111B838A2BC
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbhETJpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:45:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233622AbhETJnS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:43:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 781D461441;
        Thu, 20 May 2021 09:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503161;
        bh=4CC9lbFKiUJ0lTB6o/9nFMkQJYstxkCnZbSCm6SU7sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9K1BfOFzoHe+0vzTlo9iQecQzYe/bitned3B9KspJivIcG8r3gn03UChGHHCZVvI
         g8wU/98lxjl2HP8A+/3FA7ZtSFw6Cz/WcncHK5G4D8iwWiJ4YTmwLsdb8Sy6iLT1/D
         v7gavV3FdGDJz0y/923cuhZtrTnxSMAY0x6R1QK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 096/425] dm raid: fix inconclusive reshape layout on fast raid4/5/6 table reload sequences
Date:   Thu, 20 May 2021 11:17:45 +0200
Message-Id: <20210520092134.611856577@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

commit f99a8e4373eeacb279bc9696937a55adbff7a28a upstream.

If fast table reloads occur during an ongoing reshape of raid4/5/6
devices the target may race reading a superblock vs the the MD resync
thread; causing an inconclusive reshape state to be read in its
constructor.

lvm2 test lvconvert-raid-reshape-stripes-load-reload.sh can cause
BUG_ON() to trigger in md_run(), e.g.:
"kernel BUG at drivers/md/raid5.c:7567!".

Scenario triggering the bug:

1. the MD sync thread calls end_reshape() from raid5_sync_request()
   when done reshaping. However end_reshape() _only_ updates the
   reshape position to MaxSector keeping the changed layout
   configuration though (i.e. any delta disks, chunk sector or RAID
   algorithm changes). That inconclusive configuration is stored in
   the superblock.

2. dm-raid constructs a mapping, loading named inconsistent superblock
   as of step 1 before step 3 is able to finish resetting the reshape
   state completely, and calls md_run() which leads to mentioned bug
   in raid5.c.

3. the MD RAID personality's finish_reshape() is called; which resets
   the reshape information on chunk sectors, delta disks, etc. This
   explains why the bug is rarely seen on multi-core machines, as MD's
   finish_reshape() superblock update races with the dm-raid
   constructor's superblock load in step 2.

Fix identifies inconclusive superblock content in the dm-raid
constructor and resets it before calling md_run(), factoring out
identifying checks into rs_is_layout_change() to share in existing
rs_reshape_requested() and new rs_reset_inclonclusive_reshape(). Also
enhance a comment and remove an empty line.

Cc: stable@vger.kernel.org
Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-raid.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1892,6 +1892,14 @@ static bool rs_takeover_requested(struct
 	return rs->md.new_level != rs->md.level;
 }
 
+/* True if layout is set to reshape. */
+static bool rs_is_layout_change(struct raid_set *rs, bool use_mddev)
+{
+	return (use_mddev ? rs->md.delta_disks : rs->delta_disks) ||
+	       rs->md.new_layout != rs->md.layout ||
+	       rs->md.new_chunk_sectors != rs->md.chunk_sectors;
+}
+
 /* True if @rs is requested to reshape by ctr */
 static bool rs_reshape_requested(struct raid_set *rs)
 {
@@ -1904,9 +1912,7 @@ static bool rs_reshape_requested(struct
 	if (rs_is_raid0(rs))
 		return false;
 
-	change = mddev->new_layout != mddev->layout ||
-		 mddev->new_chunk_sectors != mddev->chunk_sectors ||
-		 rs->delta_disks;
+	change = rs_is_layout_change(rs, false);
 
 	/* Historical case to support raid1 reshape without delta disks */
 	if (rs_is_raid1(rs)) {
@@ -2843,7 +2849,7 @@ static sector_t _get_reshape_sectors(str
 }
 
 /*
- *
+ * Reshape:
  * - change raid layout
  * - change chunk size
  * - add disks
@@ -2953,6 +2959,20 @@ static int rs_setup_reshape(struct raid_
 }
 
 /*
+ * If the md resync thread has updated superblock with max reshape position
+ * at the end of a reshape but not (yet) reset the layout configuration
+ * changes -> reset the latter.
+ */
+static void rs_reset_inconclusive_reshape(struct raid_set *rs)
+{
+	if (!rs_is_reshaping(rs) && rs_is_layout_change(rs, true)) {
+		rs_set_cur(rs);
+		rs->md.delta_disks = 0;
+		rs->md.reshape_backwards = 0;
+	}
+}
+
+/*
  * Enable/disable discard support on RAID set depending on
  * RAID level and discard properties of underlying RAID members.
  */
@@ -3221,11 +3241,14 @@ static int raid_ctr(struct dm_target *ti
 	if (r)
 		goto bad;
 
+	/* Catch any inconclusive reshape superblock content. */
+	rs_reset_inconclusive_reshape(rs);
+
 	/* Start raid set read-only and assumed clean to change in raid_resume() */
 	rs->md.ro = 1;
 	rs->md.in_sync = 1;
 
-	/* Keep array frozen */
+	/* Keep array frozen until resume. */
 	set_bit(MD_RECOVERY_FROZEN, &rs->md.recovery);
 
 	/* Has to be held on running the array */
@@ -3239,7 +3262,6 @@ static int raid_ctr(struct dm_target *ti
 	}
 
 	r = md_start(&rs->md);
-
 	if (r) {
 		ti->error = "Failed to start raid array";
 		mddev_unlock(&rs->md);


