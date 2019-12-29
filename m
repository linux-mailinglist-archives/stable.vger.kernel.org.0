Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579B112C7F1
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731507AbfL2Rsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:48:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731242AbfL2Rsq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:48:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E43C9207FF;
        Sun, 29 Dec 2019 17:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641725;
        bh=V4eOyXkk4N9xmbfUukjFxKPeosyoSEs+Nc6oot6P/a0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sw2vNdgBuae0HLyWddsyyLJLYQyKPLXmVgx8QfNPeAf7vVl6Sk29ePYp5yuNG3AK8
         mpBQUWy3SdB110voJHFtGXq9MmQABHH6nBDlFOQ9oHO5XdQq85XoBXzJr5tWORvbbP
         LrkE+pQxJVtoFrl3dS7kZF5EtO3X/bLYu22hTOc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufen Yu <yuyufen@huawei.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/434] md: no longer compare spare disk superblock events in super_load
Date:   Sun, 29 Dec 2019 18:23:56 +0100
Message-Id: <20191229172713.972247562@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufen Yu <yuyufen@huawei.com>

[ Upstream commit 6a5cb53aaa4ef515ddeffa04ce18b771121127b4 ]

We have a test case as follow:

  mdadm -CR /dev/md1 -l 1 -n 4 /dev/sd[a-d] \
	--assume-clean --bitmap=internal
  mdadm -S /dev/md1
  mdadm -A /dev/md1 /dev/sd[b-c] --run --force

  mdadm --zero /dev/sda
  mdadm /dev/md1 -a /dev/sda

  echo offline > /sys/block/sdc/device/state
  echo offline > /sys/block/sdb/device/state
  sleep 5
  mdadm -S /dev/md1

  echo running > /sys/block/sdb/device/state
  echo running > /sys/block/sdc/device/state
  mdadm -A /dev/md1 /dev/sd[a-c] --run --force

When we readd /dev/sda to the array, it started to do recovery.
After offline the other two disks in md1, the recovery have
been interrupted and superblock update info cannot be written
to the offline disks. While the spare disk (/dev/sda) can continue
to update superblock info.

After stopping the array and assemble it, we found the array
run fail, with the follow kernel message:

[  172.986064] md: kicking non-fresh sdb from array!
[  173.004210] md: kicking non-fresh sdc from array!
[  173.022383] md/raid1:md1: active with 0 out of 4 mirrors
[  173.022406] md1: failed to create bitmap (-5)
[  173.023466] md: md1 stopped.

Since both sdb and sdc have the value of 'sb->events' smaller than
that in sda, they have been kicked from the array. However, the only
remained disk sda is in 'spare' state before stop and it cannot be
added to conf->mirrors[] array. In the end, raid array assemble
and run fail.

In fact, we can use the older disk sdb or sdc to assemble the array.
That means we should not choose the 'spare' disk as the fresh disk in
analyze_sbs().

To fix the problem, we do not compare superblock events when it is
a spare disk, as same as validate_super.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 57 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 51 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b8dd56b746da..6f0ecfe8eab2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1156,7 +1156,15 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		rdev->desc_nr = sb->this_disk.number;
 
 	if (!refdev) {
-		ret = 1;
+		/*
+		 * Insist on good event counter while assembling, except
+		 * for spares (which don't need an event count)
+		 */
+		if (sb->disks[rdev->desc_nr].state & (
+			(1<<MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE)))
+			ret = 1;
+		else
+			ret = 0;
 	} else {
 		__u64 ev1, ev2;
 		mdp_super_t *refsb = page_address(refdev->sb_page);
@@ -1172,7 +1180,14 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		}
 		ev1 = md_event(sb);
 		ev2 = md_event(refsb);
-		if (ev1 > ev2)
+
+		/*
+		 * Insist on good event counter while assembling, except
+		 * for spares (which don't need an event count)
+		 */
+		if (sb->disks[rdev->desc_nr].state & (
+			(1<<MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE)) &&
+			(ev1 > ev2))
 			ret = 1;
 		else
 			ret = 0;
@@ -1532,6 +1547,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	sector_t sectors;
 	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 	int bmask;
+	__u64 role;
 
 	/*
 	 * Calculate the position of the superblock in 512byte sectors.
@@ -1665,8 +1681,20 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	    sb->level != 0)
 		return -EINVAL;
 
+	role = le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
+
 	if (!refdev) {
-		ret = 1;
+		/*
+		 * Insist of good event counter while assembling, except for
+		 * spares (which don't need an event count)
+		 */
+		if (rdev->desc_nr >= 0 &&
+		    rdev->desc_nr < le32_to_cpu(sb->max_dev) &&
+			(role < MD_DISK_ROLE_MAX ||
+			 role == MD_DISK_ROLE_JOURNAL))
+			ret = 1;
+		else
+			ret = 0;
 	} else {
 		__u64 ev1, ev2;
 		struct mdp_superblock_1 *refsb = page_address(refdev->sb_page);
@@ -1683,7 +1711,14 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 		ev1 = le64_to_cpu(sb->events);
 		ev2 = le64_to_cpu(refsb->events);
 
-		if (ev1 > ev2)
+		/*
+		 * Insist of good event counter while assembling, except for
+		 * spares (which don't need an event count)
+		 */
+		if (rdev->desc_nr >= 0 &&
+		    rdev->desc_nr < le32_to_cpu(sb->max_dev) &&
+			(role < MD_DISK_ROLE_MAX ||
+			 role == MD_DISK_ROLE_JOURNAL) && ev1 > ev2)
 			ret = 1;
 		else
 			ret = 0;
@@ -3604,7 +3639,7 @@ abort_free:
  * Check a full RAID array for plausibility
  */
 
-static void analyze_sbs(struct mddev *mddev)
+static int analyze_sbs(struct mddev *mddev)
 {
 	int i;
 	struct md_rdev *rdev, *freshest, *tmp;
@@ -3625,6 +3660,12 @@ static void analyze_sbs(struct mddev *mddev)
 			md_kick_rdev_from_array(rdev);
 		}
 
+	/* Cannot find a valid fresh disk */
+	if (!freshest) {
+		pr_warn("md: cannot find a valid disk\n");
+		return -EINVAL;
+	}
+
 	super_types[mddev->major_version].
 		validate_super(mddev, freshest);
 
@@ -3659,6 +3700,8 @@ static void analyze_sbs(struct mddev *mddev)
 			clear_bit(In_sync, &rdev->flags);
 		}
 	}
+
+	return 0;
 }
 
 /* Read a fixed-point number.
@@ -5577,7 +5620,9 @@ int md_run(struct mddev *mddev)
 	if (!mddev->raid_disks) {
 		if (!mddev->persistent)
 			return -EINVAL;
-		analyze_sbs(mddev);
+		err = analyze_sbs(mddev);
+		if (err)
+			return -EINVAL;
 	}
 
 	if (mddev->level != LEVEL_NONE)
-- 
2.20.1



