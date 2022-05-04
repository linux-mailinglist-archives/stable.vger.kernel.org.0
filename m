Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE3051A708
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354686AbiEDRBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355544AbiEDRAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:00:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2674F4B849;
        Wed,  4 May 2022 09:51:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7018AB8279F;
        Wed,  4 May 2022 16:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BE9C385AA;
        Wed,  4 May 2022 16:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683102;
        bh=Q47rXhNzfck/KPKdxhbKGRwmlg2Gb/udeLwxXi3qXtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBZj4PHHrugEh2SRi34FqcW/b8hmkp+FEI5UGzszFLb2b8QkA2RXDng6HNIscQziP
         lQQjnH5EjkCVZDjwDC2f0El7xCzHC0mFzMANoOc3zjVogqqiGTpcE5hNomoxpwadpe
         kxnHZSpVK7rlexTa2c6e/Jfea3VmOS+mF2zYsOoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH 5.10 106/129] zonefs: Fix management of open zones
Date:   Wed,  4 May 2022 18:44:58 +0200
Message-Id: <20220504153029.412540267@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit 1da18a296f5ba4f99429e62a7cf4fdbefa598902 upstream.

The mount option "explicit_open" manages the device open zone
resources to ensure that if an application opens a sequential file for
writing, the file zone can always be written by explicitly opening
the zone and accounting for that state with the s_open_zones counter.

However, if some zones are already open when mounting, the device open
zone resource usage status will be larger than the initial s_open_zones
value of 0. Ensure that this inconsistency does not happen by closing
any sequential zone that is open when mounting.

Furthermore, with ZNS drives, closing an explicitly open zone that has
not been written will change the zone state to "closed", that is, the
zone will remain in an active state. Since this can then cause failures
of explicit open operations on other zones if the drive active zone
resources are exceeded, we need to make sure that the zone is not
active anymore by resetting it instead of closing it. To address this,
zonefs_zone_mgmt() is modified to change a REQ_OP_ZONE_CLOSE request
into a REQ_OP_ZONE_RESET for sequential zones that have not been
written.

Fixes: b5c00e975779 ("zonefs: open/close zone on file open/close")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/zonefs/super.c |   45 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -32,6 +32,17 @@ static inline int zonefs_zone_mgmt(struc
 
 	lockdep_assert_held(&zi->i_truncate_mutex);
 
+	/*
+	 * With ZNS drives, closing an explicitly open zone that has not been
+	 * written will change the zone state to "closed", that is, the zone
+	 * will remain active. Since this can then cause failure of explicit
+	 * open operation on other zones if the drive active zone resources
+	 * are exceeded, make sure that the zone does not remain active by
+	 * resetting it.
+	 */
+	if (op == REQ_OP_ZONE_CLOSE && !zi->i_wpoffset)
+		op = REQ_OP_ZONE_RESET;
+
 	ret = blkdev_zone_mgmt(inode->i_sb->s_bdev, op, zi->i_zsector,
 			       zi->i_zone_size >> SECTOR_SHIFT, GFP_NOFS);
 	if (ret) {
@@ -1306,12 +1317,13 @@ static void zonefs_init_dir_inode(struct
 	inc_nlink(parent);
 }
 
-static void zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
-				   enum zonefs_ztype type)
+static int zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
+				  enum zonefs_ztype type)
 {
 	struct super_block *sb = inode->i_sb;
 	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+	int ret = 0;
 
 	inode->i_ino = zone->start >> sbi->s_zone_sectors_shift;
 	inode->i_mode = S_IFREG | sbi->s_perm;
@@ -1336,6 +1348,22 @@ static void zonefs_init_file_inode(struc
 	sb->s_maxbytes = max(zi->i_max_size, sb->s_maxbytes);
 	sbi->s_blocks += zi->i_max_size >> sb->s_blocksize_bits;
 	sbi->s_used_blocks += zi->i_wpoffset >> sb->s_blocksize_bits;
+
+	/*
+	 * For sequential zones, make sure that any open zone is closed first
+	 * to ensure that the initial number of open zones is 0, in sync with
+	 * the open zone accounting done when the mount option
+	 * ZONEFS_MNTOPT_EXPLICIT_OPEN is used.
+	 */
+	if (type == ZONEFS_ZTYPE_SEQ &&
+	    (zone->cond == BLK_ZONE_COND_IMP_OPEN ||
+	     zone->cond == BLK_ZONE_COND_EXP_OPEN)) {
+		mutex_lock(&zi->i_truncate_mutex);
+		ret = zonefs_zone_mgmt(inode, REQ_OP_ZONE_CLOSE);
+		mutex_unlock(&zi->i_truncate_mutex);
+	}
+
+	return ret;
 }
 
 static struct dentry *zonefs_create_inode(struct dentry *parent,
@@ -1345,6 +1373,7 @@ static struct dentry *zonefs_create_inod
 	struct inode *dir = d_inode(parent);
 	struct dentry *dentry;
 	struct inode *inode;
+	int ret;
 
 	dentry = d_alloc_name(parent, name);
 	if (!dentry)
@@ -1355,10 +1384,16 @@ static struct dentry *zonefs_create_inod
 		goto dput;
 
 	inode->i_ctime = inode->i_mtime = inode->i_atime = dir->i_ctime;
-	if (zone)
-		zonefs_init_file_inode(inode, zone, type);
-	else
+	if (zone) {
+		ret = zonefs_init_file_inode(inode, zone, type);
+		if (ret) {
+			iput(inode);
+			goto dput;
+		}
+	} else {
 		zonefs_init_dir_inode(dir, inode, type);
+	}
+
 	d_add(dentry, inode);
 	dir->i_size++;
 


