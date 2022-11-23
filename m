Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C6F635DE9
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237390AbiKWMsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238040AbiKWMrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:47:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C738C71F33;
        Wed, 23 Nov 2022 04:43:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A949B81F40;
        Wed, 23 Nov 2022 12:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A217C4347C;
        Wed, 23 Nov 2022 12:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207398;
        bh=8nCLnTjd0moyvDEAfw8zrPFSvHHSPL3gq5y8aBgKvxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHEiDupT5vAozlkoxVM+eldD9wbrTGK/KJfPSHvuSMsjVHtPsKq2UA7G3HBlyVZOS
         NbNKYmNj7KMz0/+PG+YxP//cASptSckq33ObwUMIXyYPLEHCg+I1Mks41rQeJMy8Kn
         EX3XuIBliy8yUklEeC489RNTTEunIf+EzLpJd1NmXU2VdFB9oFvbRfTLemn1yaN6xg
         5dvxJvkVhyM4rQDUttefutDyjjw/nX/ZuPSoGPTM/D5GeqS9QY+5ckuNCNAPv4lUIG
         D36jhXxGRV5iYIP7yxtHMYLKRqwcv+8f/CmdmaKsWvTTy8Obr6uMRBWk3yu04vv0Uz
         b2xGhdbXRk1fg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Sasha Levin <sashal@kernel.org>, naohiro.aota@wdc.com,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 18/31] zonefs: fix zone report size in __zonefs_io_error()
Date:   Wed, 23 Nov 2022 07:42:19 -0500
Message-Id: <20221123124234.265396-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124234.265396-1-sashal@kernel.org>
References: <20221123124234.265396-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 7dd12d65ac646046a3fe0bbf9a4e86f4514207b3 ]

When an IO error occurs, the function __zonefs_io_error() is used to
issue a zone report to obtain the latest zone information from the
device. This function gets a zone report for all zones used as storage
for a file, which is always 1 zone except for files representing
aggregated conventional zones.

The number of zones of a zone report for a file is calculated in
__zonefs_io_error() by doing a bit-shift of the inode i_zone_size field,
which is equal to or larger than the device zone size. However, this
calculation does not take into account that the last zone of a zoned
device may be smaller than the zone size reported by bdev_zone_sectors()
(which is used to set the bit shift size). As a result, if an error
occurs for an IO targetting such last smaller zone, the zone report will
ask for 0 zones, leading to an invalid zone report.

Fix this by using the fact that all files require a 1 zone report,
except if the inode i_zone_size field indicates a zone size larger than
the device zone size. This exception case corresponds to a mount with
aggregated conventional zones.

A check for this exception is added to the file inode initialization
during mount. If an invalid setup is detected, emit an error and fail
the mount (check contributed by Johannes Thumshirn).

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/zonefs/super.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index f8feaed0b54d..85a98590b6ef 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -448,14 +448,22 @@ static void __zonefs_io_error(struct inode *inode, bool write)
 	struct super_block *sb = inode->i_sb;
 	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
 	unsigned int noio_flag;
-	unsigned int nr_zones =
-		zi->i_zone_size >> (sbi->s_zone_sectors_shift + SECTOR_SHIFT);
+	unsigned int nr_zones = 1;
 	struct zonefs_ioerr_data err = {
 		.inode = inode,
 		.write = write,
 	};
 	int ret;
 
+	/*
+	 * The only files that have more than one zone are conventional zone
+	 * files with aggregated conventional zones, for which the inode zone
+	 * size is always larger than the device zone size.
+	 */
+	if (zi->i_zone_size > bdev_zone_sectors(sb->s_bdev))
+		nr_zones = zi->i_zone_size >>
+			(sbi->s_zone_sectors_shift + SECTOR_SHIFT);
+
 	/*
 	 * Memory allocations in blkdev_report_zones() can trigger a memory
 	 * reclaim which may in turn cause a recursion into zonefs as well as
@@ -1354,6 +1362,14 @@ static int zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
 	zi->i_ztype = type;
 	zi->i_zsector = zone->start;
 	zi->i_zone_size = zone->len << SECTOR_SHIFT;
+	if (zi->i_zone_size > bdev_zone_sectors(sb->s_bdev) << SECTOR_SHIFT &&
+	    !(sbi->s_features & ZONEFS_F_AGGRCNV)) {
+		zonefs_err(sb,
+			   "zone size %llu doesn't match device's zone sectors %llu\n",
+			   zi->i_zone_size,
+			   bdev_zone_sectors(sb->s_bdev) << SECTOR_SHIFT);
+		return -EINVAL;
+	}
 
 	zi->i_max_size = min_t(loff_t, MAX_LFS_FILESIZE,
 			       zone->capacity << SECTOR_SHIFT);
@@ -1396,11 +1412,11 @@ static struct dentry *zonefs_create_inode(struct dentry *parent,
 	struct inode *dir = d_inode(parent);
 	struct dentry *dentry;
 	struct inode *inode;
-	int ret;
+	int ret = -ENOMEM;
 
 	dentry = d_alloc_name(parent, name);
 	if (!dentry)
-		return NULL;
+		return ERR_PTR(ret);
 
 	inode = new_inode(parent->d_sb);
 	if (!inode)
@@ -1425,7 +1441,7 @@ static struct dentry *zonefs_create_inode(struct dentry *parent,
 dput:
 	dput(dentry);
 
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 struct zonefs_zone_data {
@@ -1445,7 +1461,7 @@ static int zonefs_create_zgroup(struct zonefs_zone_data *zd,
 	struct blk_zone *zone, *next, *end;
 	const char *zgroup_name;
 	char *file_name;
-	struct dentry *dir;
+	struct dentry *dir, *dent;
 	unsigned int n = 0;
 	int ret;
 
@@ -1463,8 +1479,8 @@ static int zonefs_create_zgroup(struct zonefs_zone_data *zd,
 		zgroup_name = "seq";
 
 	dir = zonefs_create_inode(sb->s_root, zgroup_name, NULL, type);
-	if (!dir) {
-		ret = -ENOMEM;
+	if (IS_ERR(dir)) {
+		ret = PTR_ERR(dir);
 		goto free;
 	}
 
@@ -1510,8 +1526,9 @@ static int zonefs_create_zgroup(struct zonefs_zone_data *zd,
 		 * Use the file number within its group as file name.
 		 */
 		snprintf(file_name, ZONEFS_NAME_MAX - 1, "%u", n);
-		if (!zonefs_create_inode(dir, file_name, zone, type)) {
-			ret = -ENOMEM;
+		dent = zonefs_create_inode(dir, file_name, zone, type);
+		if (IS_ERR(dent)) {
+			ret = PTR_ERR(dent);
 			goto free;
 		}
 
-- 
2.35.1

