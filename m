Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D7653EA07
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236785AbiFFM2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 08:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236836AbiFFM2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 08:28:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B35A23B70B
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 05:28:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E209B818AC
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 12:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE598C34119;
        Mon,  6 Jun 2022 12:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654518492;
        bh=roTLRv1uI+z3mvJGLpmlncWwYTO9V73zjFabgFZ4uIg=;
        h=Subject:To:Cc:From:Date:From;
        b=XXTS1mHLUoS/M1py1XW94PkajN1+iUH6puaJOYHIwFmEPjBKBdyJj1jolXoTD4Ej5
         +WjAItPm7tEmPyC96wcD3zVv2icIZpLgXr8Y0vfy2h62GBa2+CfHzD+6M+Kauwu9cf
         DqeEF9TzhIa0RNQ+UENS+O0jF7hQBp+zH6INfaPA=
Subject: FAILED: patch "[PATCH] zonefs: Fix management of open zones" failed to apply to 5.17-stable tree
To:     damien.lemoal@opensource.wdc.com, hans.holmberg@wdc.com,
        johannes.thumshirn@wdc.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 14:28:01 +0200
Message-ID: <1654518481124138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 19139539207934aef6335bdef09c9e4bd70d1808 Mon Sep 17 00:00:00 2001
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Tue, 12 Apr 2022 17:41:37 +0900
Subject: [PATCH] zonefs: Fix management of open zones

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

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 75d8dabe0807..e20e7c841489 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -35,6 +35,17 @@ static inline int zonefs_zone_mgmt(struct inode *inode,
 
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
 	trace_zonefs_zone_mgmt(inode, op);
 	ret = blkdev_zone_mgmt(inode->i_sb->s_bdev, op, zi->i_zsector,
 			       zi->i_zone_size >> SECTOR_SHIFT, GFP_NOFS);
@@ -1294,12 +1305,13 @@ static void zonefs_init_dir_inode(struct inode *parent, struct inode *inode,
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
@@ -1324,6 +1336,22 @@ static void zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
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
@@ -1333,6 +1361,7 @@ static struct dentry *zonefs_create_inode(struct dentry *parent,
 	struct inode *dir = d_inode(parent);
 	struct dentry *dentry;
 	struct inode *inode;
+	int ret;
 
 	dentry = d_alloc_name(parent, name);
 	if (!dentry)
@@ -1343,10 +1372,16 @@ static struct dentry *zonefs_create_inode(struct dentry *parent,
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
 

