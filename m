Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C119ECA83C
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389355AbfJCQXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390623AbfJCQXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:23:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C670721783;
        Thu,  3 Oct 2019 16:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119826;
        bh=ZgMD5LS9rP9jruVcdmXKmsNbWPivkcYupkyZ+TpJgVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBlskKwbfftefSqNtVJvJvTK7bL/C3I9pP8x5mYFRF7YqA7y1dWiDiMqT4gnfL+2s
         X9netffrgmH3uIDwWrYpYRVgkTaOHrMeoyQtkjQTX820V5N0TPt2HaK/sf4RgNlm7G
         33sk3a3t7iAk9rdgB+q1zFupFbkVdVnFeCPzbOFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        NeilBrown <neilb@suse.de>, Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 208/211] md/raid0: avoid RAID0 data corruption due to layout confusion.
Date:   Thu,  3 Oct 2019 17:54:34 +0200
Message-Id: <20191003154530.538572497@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

[ Upstream commit c84a1372df929033cb1a0441fb57bd3932f39ac9 ]

If the drives in a RAID0 are not all the same size, the array is
divided into zones.
The first zone covers all drives, to the size of the smallest.
The second zone covers all drives larger than the smallest, up to
the size of the second smallest - etc.

A change in Linux 3.14 unintentionally changed the layout for the
second and subsequent zones.  All the correct data is still stored, but
each chunk may be assigned to a different device than in pre-3.14 kernels.
This can lead to data corruption.

It is not possible to determine what layout to use - it depends which
kernel the data was written by.
So we add a module parameter to allow the old (0) or new (1) layout to be
specified, and refused to assemble an affected array if that parameter is
not set.

Fixes: 20d0189b1012 ("block: Introduce new bio_split()")
cc: stable@vger.kernel.org (3.14+)
Acked-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid0.c | 33 ++++++++++++++++++++++++++++++++-
 drivers/md/raid0.h | 14 ++++++++++++++
 2 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index f4daa56d204dd..43fa7dbf844b0 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -26,6 +26,9 @@
 #include "raid0.h"
 #include "raid5.h"
 
+static int default_layout = 0;
+module_param(default_layout, int, 0644);
+
 #define UNSUPPORTED_MDDEV_FLAGS		\
 	((1L << MD_HAS_JOURNAL) |	\
 	 (1L << MD_JOURNAL_CLEAN) |	\
@@ -146,6 +149,19 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	}
 	pr_debug("md/raid0:%s: FINAL %d zones\n",
 		 mdname(mddev), conf->nr_strip_zones);
+
+	if (conf->nr_strip_zones == 1) {
+		conf->layout = RAID0_ORIG_LAYOUT;
+	} else if (default_layout == RAID0_ORIG_LAYOUT ||
+		   default_layout == RAID0_ALT_MULTIZONE_LAYOUT) {
+		conf->layout = default_layout;
+	} else {
+		pr_err("md/raid0:%s: cannot assemble multi-zone RAID0 with default_layout setting\n",
+		       mdname(mddev));
+		pr_err("md/raid0: please set raid.default_layout to 1 or 2\n");
+		err = -ENOTSUPP;
+		goto abort;
+	}
 	/*
 	 * now since we have the hard sector sizes, we can make sure
 	 * chunk size is a multiple of that sector size
@@ -555,10 +571,12 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 
 static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 {
+	struct r0conf *conf = mddev->private;
 	struct strip_zone *zone;
 	struct md_rdev *tmp_dev;
 	sector_t bio_sector;
 	sector_t sector;
+	sector_t orig_sector;
 	unsigned chunk_sects;
 	unsigned sectors;
 
@@ -592,8 +610,21 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 		bio = split;
 	}
 
+	orig_sector = sector;
 	zone = find_zone(mddev->private, &sector);
-	tmp_dev = map_sector(mddev, zone, sector, &sector);
+	switch (conf->layout) {
+	case RAID0_ORIG_LAYOUT:
+		tmp_dev = map_sector(mddev, zone, orig_sector, &sector);
+		break;
+	case RAID0_ALT_MULTIZONE_LAYOUT:
+		tmp_dev = map_sector(mddev, zone, sector, &sector);
+		break;
+	default:
+		WARN("md/raid0:%s: Invalid layout\n", mdname(mddev));
+		bio_io_error(bio);
+		return true;
+	}
+
 	bio_set_dev(bio, tmp_dev->bdev);
 	bio->bi_iter.bi_sector = sector + zone->dev_start +
 		tmp_dev->data_offset;
diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
index 540e65d92642d..3816e5477db1e 100644
--- a/drivers/md/raid0.h
+++ b/drivers/md/raid0.h
@@ -8,11 +8,25 @@ struct strip_zone {
 	int	 nb_dev;	/* # of devices attached to the zone */
 };
 
+/* Linux 3.14 (20d0189b101) made an unintended change to
+ * the RAID0 layout for multi-zone arrays (where devices aren't all
+ * the same size.
+ * RAID0_ORIG_LAYOUT restores the original layout
+ * RAID0_ALT_MULTIZONE_LAYOUT uses the altered layout
+ * The layouts are identical when there is only one zone (all
+ * devices the same size).
+ */
+
+enum r0layout {
+	RAID0_ORIG_LAYOUT = 1,
+	RAID0_ALT_MULTIZONE_LAYOUT = 2,
+};
 struct r0conf {
 	struct strip_zone	*strip_zone;
 	struct md_rdev		**devlist; /* lists of rdevs, pointed to
 					    * by strip_zone->dev */
 	int			nr_strip_zones;
+	enum r0layout		layout;
 };
 
 #endif
-- 
2.20.1



