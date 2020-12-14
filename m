Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCCDE2DA0EE
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502729AbgLNT53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:57:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502820AbgLNT5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 14:57:24 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.1
Date:   Mon, 14 Dec 2020 20:57:41 +0100
Message-Id: <160797467277129@kroah.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <16079746727695@kroah.com>
References: <16079746727695@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


diff --git a/Makefile b/Makefile
index e30cf02da8b8..076d4e6b9ccc 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 0
+SUBLEVEL = 1
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index dc8568ab96f2..56b723d012ac 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3730,14 +3730,12 @@ static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	blk_limits_io_opt(limits, chunk_size_bytes * mddev_data_stripes(rs));
 
 	/*
-	 * RAID10 personality requires bio splitting,
-	 * RAID0/1/4/5/6 don't and process large discard bios properly.
+	 * RAID1 and RAID10 personalities require bio splitting,
+	 * RAID0/4/5/6 don't and process large discard bios properly.
 	 */
-	if (rs_is_raid10(rs)) {
-		limits->discard_granularity = max(chunk_size_bytes,
-						  limits->discard_granularity);
-		limits->max_discard_sectors = min_not_zero(rs->md.chunk_sectors,
-							   limits->max_discard_sectors);
+	if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
+		limits->discard_granularity = chunk_size_bytes;
+		limits->max_discard_sectors = rs->md.chunk_sectors;
 	}
 }
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index bb645bc3ba6d..2175a5ac4f7c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -311,7 +311,7 @@ struct mddev {
 	int				external;	/* metadata is
 							 * managed externally */
 	char				metadata_type[17]; /* externally set*/
-	unsigned int			chunk_sectors;
+	int				chunk_sectors;
 	time64_t			ctime, utime;
 	int				level, layout;
 	char				clevel[16];
@@ -339,7 +339,7 @@ struct mddev {
 	 */
 	sector_t			reshape_position;
 	int				delta_disks, new_level, new_layout;
-	unsigned int			new_chunk_sectors;
+	int				new_chunk_sectors;
 	int				reshape_backwards;
 
 	struct md_thread		*thread;	/* management thread */
