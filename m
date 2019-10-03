Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6613C994B
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 09:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbfJCHxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 03:53:53 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55843 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728102AbfJCHxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 03:53:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 68A6521C82;
        Thu,  3 Oct 2019 03:53:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 03:53:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=W6HKF2
        4Nb6URk1hKT8guWZoSg+VQNcfPSYCoMLXcUe8=; b=ioiNwdzU7UtcBYjvlphAC0
        +PvYGkhwrq7pfOwrfEIWi+Ku7weAoeGDSU7AT2mOvo2DX3bfauvTzhfzr7QDnHAb
        CgdDOLP+OKwpN9EJstqHlLTZmvUDZ3T70vXo7ZR599lp+Oxddpn5olFjFYGB3QrX
        TRwNSo/KXliIDiBMubtQJMjEUw5Jp/Enk7mBVcHJXAR8Z6fI+m2Wj12Ayq6i/KXB
        m0In/LX5U0MCXWQJzqX6CQ9XE0cW5/o379Uyd4+w1QXYuQnPvAJtH5g98OkF5L84
        RX2eOqPjmoNIpbeHxowQr68twCxzhnJlQTjinKDAZR+/Dd3Mrz/X/tTPWDoRjXbQ
        ==
X-ME-Sender: <xms:EKmVXQ4XmsJvQhzwyFG8xNnw_Cr8LhZDyncnCGzoQpyIkMd5a9QOow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeejgdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepge
X-ME-Proxy: <xmx:EKmVXaW__flIAPdaXusuyN7dO2bByYfyWl_vXrF7-7kWfwhCusfNsw>
    <xmx:EKmVXf5GQhGe0VXfH0PrYpymjeqWEIZfBRSqwv8si0ZnLJw99cPabw>
    <xmx:EKmVXVo9ngG_9wtLSeRLIyxyz24073_Q8WwrAGiB9WnUIDGar-EmZg>
    <xmx:EKmVXf1_W7MvbQYWe_ZocnyWmruARXnGhFjKd62a4XVRE-Z2aEgrOw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD2FF80062;
        Thu,  3 Oct 2019 03:53:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] md/raid0: avoid RAID0 data corruption due to layout" failed to apply to 4.9-stable tree
To:     neilb@suse.de, guoqing.jiang@cloud.ionos.com, songliubraving@fb.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 09:53:38 +0200
Message-ID: <157008921815426@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c84a1372df929033cb1a0441fb57bd3932f39ac9 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 9 Sep 2019 16:30:02 +1000
Subject: [PATCH] md/raid0: avoid RAID0 data corruption due to layout
 confusion.

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

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index bc422eae2c95..ec611abda835 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -19,6 +19,9 @@
 #include "raid0.h"
 #include "raid5.h"
 
+static int default_layout = 0;
+module_param(default_layout, int, 0644);
+
 #define UNSUPPORTED_MDDEV_FLAGS		\
 	((1L << MD_HAS_JOURNAL) |	\
 	 (1L << MD_JOURNAL_CLEAN) |	\
@@ -139,6 +142,19 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
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
@@ -547,10 +563,12 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 
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
 
@@ -584,8 +602,20 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
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
 
 	if (unlikely(is_mddev_broken(tmp_dev, "raid0"))) {
 		bio_io_error(bio);
diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
index 540e65d92642..3816e5477db1 100644
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

