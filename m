Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8F2566B58
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbiGEMF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233918AbiGEMFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:05:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499D317E22;
        Tue,  5 Jul 2022 05:04:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A52766190B;
        Tue,  5 Jul 2022 12:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE41C341CB;
        Tue,  5 Jul 2022 12:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022676;
        bh=EWbhujnAMtHpYF/xosUJ3dY70/+NT5WgglLtH/DHuMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1jtd0gtTZHdgpfu4hJ/D5+DM4ivy0GmCb1Ll+M4C/fLgbbFeZuqVOWGHBLg1lhdX
         Q3IGdICBQGJvh9lpRU7bs/1k3Fab3Cmwf0p+ZtA+EuFVAImOLXgjkKUOfy2jNKx7Kd
         vUdc49Z8anPEj2Zef9UX8nUQ8PPTk6ZcoxaOOALs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.4 05/58] dm raid: fix accesses beyond end of raid member array
Date:   Tue,  5 Jul 2022 13:57:41 +0200
Message-Id: <20220705115610.401694686@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
References: <20220705115610.236040773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

commit 332bd0778775d0cf105c4b9e03e460b590749916 upstream.

On dm-raid table load (using raid_ctr), dm-raid allocates an array
rs->devs[rs->raid_disks] for the raid device members. rs->raid_disks
is defined by the number of raid metadata and image tupples passed
into the target's constructor.

In the case of RAID layout changes being requested, that number can be
different from the current number of members for existing raid sets as
defined in their superblocks. Example RAID layout changes include:
- raid1 legs being added/removed
- raid4/5/6/10 number of stripes changed (stripe reshaping)
- takeover to higher raid level (e.g. raid5 -> raid6)

When accessing array members, rs->raid_disks must be used in control
loops instead of the potentially larger value in rs->md.raid_disks.
Otherwise it will cause memory access beyond the end of the rs->devs
array.

Fix this by changing code that is prone to out-of-bounds access.
Also fix validate_raid_redundancy() to validate all devices that are
added. Also, use braces to help clean up raid_iterate_devices().

The out-of-bounds memory accesses was discovered using KASAN.

This commit was verified to pass all LVM2 RAID tests (with KASAN
enabled).

Cc: stable@vger.kernel.org
Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-raid.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -998,12 +998,13 @@ static int validate_region_size(struct r
 static int validate_raid_redundancy(struct raid_set *rs)
 {
 	unsigned int i, rebuild_cnt = 0;
-	unsigned int rebuilds_per_group = 0, copies;
+	unsigned int rebuilds_per_group = 0, copies, raid_disks;
 	unsigned int group_size, last_group_start;
 
-	for (i = 0; i < rs->md.raid_disks; i++)
-		if (!test_bit(In_sync, &rs->dev[i].rdev.flags) ||
-		    !rs->dev[i].rdev.sb_page)
+	for (i = 0; i < rs->raid_disks; i++)
+		if (!test_bit(FirstUse, &rs->dev[i].rdev.flags) &&
+		    ((!test_bit(In_sync, &rs->dev[i].rdev.flags) ||
+		      !rs->dev[i].rdev.sb_page)))
 			rebuild_cnt++;
 
 	switch (rs->md.level) {
@@ -1043,8 +1044,9 @@ static int validate_raid_redundancy(stru
 		 *	    A	 A    B	   B	C
 		 *	    C	 D    D	   E	E
 		 */
+		raid_disks = min(rs->raid_disks, rs->md.raid_disks);
 		if (__is_raid10_near(rs->md.new_layout)) {
-			for (i = 0; i < rs->md.raid_disks; i++) {
+			for (i = 0; i < raid_disks; i++) {
 				if (!(i % copies))
 					rebuilds_per_group = 0;
 				if ((!rs->dev[i].rdev.sb_page ||
@@ -1067,10 +1069,10 @@ static int validate_raid_redundancy(stru
 		 * results in the need to treat the last (potentially larger)
 		 * set differently.
 		 */
-		group_size = (rs->md.raid_disks / copies);
-		last_group_start = (rs->md.raid_disks / group_size) - 1;
+		group_size = (raid_disks / copies);
+		last_group_start = (raid_disks / group_size) - 1;
 		last_group_start *= group_size;
-		for (i = 0; i < rs->md.raid_disks; i++) {
+		for (i = 0; i < raid_disks; i++) {
 			if (!(i % copies) && !(i > last_group_start))
 				rebuilds_per_group = 0;
 			if ((!rs->dev[i].rdev.sb_page ||
@@ -1585,7 +1587,7 @@ static sector_t __rdev_sectors(struct ra
 {
 	int i;
 
-	for (i = 0; i < rs->md.raid_disks; i++) {
+	for (i = 0; i < rs->raid_disks; i++) {
 		struct md_rdev *rdev = &rs->dev[i].rdev;
 
 		if (!test_bit(Journal, &rdev->flags) &&
@@ -3746,13 +3748,13 @@ static int raid_iterate_devices(struct d
 	unsigned int i;
 	int r = 0;
 
-	for (i = 0; !r && i < rs->md.raid_disks; i++)
-		if (rs->dev[i].data_dev)
-			r = fn(ti,
-				 rs->dev[i].data_dev,
-				 0, /* No offset on data devs */
-				 rs->md.dev_sectors,
-				 data);
+	for (i = 0; !r && i < rs->raid_disks; i++) {
+		if (rs->dev[i].data_dev) {
+			r = fn(ti, rs->dev[i].data_dev,
+			       0, /* No offset on data devs */
+			       rs->md.dev_sectors, data);
+		}
+	}
 
 	return r;
 }


