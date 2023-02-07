Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B8868D874
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbjBGNJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbjBGNJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:09:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B95A1E9CB
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:09:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03F19613EA
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03825C433A0;
        Tue,  7 Feb 2023 13:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775340;
        bh=07K9p89gxShzJmG7D98uLbLagE01zg0t9gIKKt5wSQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2/pFAWm3TypanQfuCntwWd1BeyCrqIlX15pOW/ahDyII+2KCFEO1hU7iWZDkIyRX
         UfOzN1gpCE0i80A0v8wgL1yLTvCjcli4k2JEnaJsrOSyeTOavzSSp9/oIVkm3BA1g6
         ZcmgScHaAzJqY2PFN9v1KkwvouTWTf3k0SfmLpRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 6.1 206/208] gfs2: Cosmetic gfs2_dinode_{in,out} cleanup
Date:   Tue,  7 Feb 2023 13:57:40 +0100
Message-Id: <20230207125643.858005750@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 7db354444ad8429e660b0f8145d425285d4f90ff upstream.

In each of the two functions, add an inode variable that points to
&ip->i_inode and use that throughout the rest of the function.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/glops.c |   41 +++++++++++++++++++++--------------------
 fs/gfs2/super.c |   27 ++++++++++++++-------------
 2 files changed, 35 insertions(+), 33 deletions(-)

--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -397,38 +397,39 @@ static int gfs2_dinode_in(struct gfs2_in
 	struct timespec64 atime;
 	u16 height, depth;
 	umode_t mode = be32_to_cpu(str->di_mode);
-	bool is_new = ip->i_inode.i_state & I_NEW;
+	struct inode *inode = &ip->i_inode;
+	bool is_new = inode->i_state & I_NEW;
 
 	if (unlikely(ip->i_no_addr != be64_to_cpu(str->di_num.no_addr)))
 		goto corrupt;
-	if (unlikely(!is_new && inode_wrong_type(&ip->i_inode, mode)))
+	if (unlikely(!is_new && inode_wrong_type(inode, mode)))
 		goto corrupt;
 	ip->i_no_formal_ino = be64_to_cpu(str->di_num.no_formal_ino);
-	ip->i_inode.i_mode = mode;
+	inode->i_mode = mode;
 	if (is_new) {
-		ip->i_inode.i_rdev = 0;
+		inode->i_rdev = 0;
 		switch (mode & S_IFMT) {
 		case S_IFBLK:
 		case S_IFCHR:
-			ip->i_inode.i_rdev = MKDEV(be32_to_cpu(str->di_major),
-						   be32_to_cpu(str->di_minor));
+			inode->i_rdev = MKDEV(be32_to_cpu(str->di_major),
+					      be32_to_cpu(str->di_minor));
 			break;
 		}
 	}
 
-	i_uid_write(&ip->i_inode, be32_to_cpu(str->di_uid));
-	i_gid_write(&ip->i_inode, be32_to_cpu(str->di_gid));
-	set_nlink(&ip->i_inode, be32_to_cpu(str->di_nlink));
-	i_size_write(&ip->i_inode, be64_to_cpu(str->di_size));
-	gfs2_set_inode_blocks(&ip->i_inode, be64_to_cpu(str->di_blocks));
+	i_uid_write(inode, be32_to_cpu(str->di_uid));
+	i_gid_write(inode, be32_to_cpu(str->di_gid));
+	set_nlink(inode, be32_to_cpu(str->di_nlink));
+	i_size_write(inode, be64_to_cpu(str->di_size));
+	gfs2_set_inode_blocks(inode, be64_to_cpu(str->di_blocks));
 	atime.tv_sec = be64_to_cpu(str->di_atime);
 	atime.tv_nsec = be32_to_cpu(str->di_atime_nsec);
-	if (timespec64_compare(&ip->i_inode.i_atime, &atime) < 0)
-		ip->i_inode.i_atime = atime;
-	ip->i_inode.i_mtime.tv_sec = be64_to_cpu(str->di_mtime);
-	ip->i_inode.i_mtime.tv_nsec = be32_to_cpu(str->di_mtime_nsec);
-	ip->i_inode.i_ctime.tv_sec = be64_to_cpu(str->di_ctime);
-	ip->i_inode.i_ctime.tv_nsec = be32_to_cpu(str->di_ctime_nsec);
+	if (timespec64_compare(&inode->i_atime, &atime) < 0)
+		inode->i_atime = atime;
+	inode->i_mtime.tv_sec = be64_to_cpu(str->di_mtime);
+	inode->i_mtime.tv_nsec = be32_to_cpu(str->di_mtime_nsec);
+	inode->i_ctime.tv_sec = be64_to_cpu(str->di_ctime);
+	inode->i_ctime.tv_nsec = be32_to_cpu(str->di_ctime_nsec);
 
 	ip->i_goal = be64_to_cpu(str->di_goal_meta);
 	ip->i_generation = be64_to_cpu(str->di_generation);
@@ -436,7 +437,7 @@ static int gfs2_dinode_in(struct gfs2_in
 	ip->i_diskflags = be32_to_cpu(str->di_flags);
 	ip->i_eattr = be64_to_cpu(str->di_eattr);
 	/* i_diskflags and i_eattr must be set before gfs2_set_inode_flags() */
-	gfs2_set_inode_flags(&ip->i_inode);
+	gfs2_set_inode_flags(inode);
 	height = be16_to_cpu(str->di_height);
 	if (unlikely(height > GFS2_MAX_META_HEIGHT))
 		goto corrupt;
@@ -448,8 +449,8 @@ static int gfs2_dinode_in(struct gfs2_in
 	ip->i_depth = (u8)depth;
 	ip->i_entries = be32_to_cpu(str->di_entries);
 
-	if (S_ISREG(ip->i_inode.i_mode))
-		gfs2_set_aops(&ip->i_inode);
+	if (S_ISREG(inode->i_mode))
+		gfs2_set_aops(inode);
 
 	return 0;
 corrupt:
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -379,6 +379,7 @@ out:
 
 void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 {
+	const struct inode *inode = &ip->i_inode;
 	struct gfs2_dinode *str = buf;
 
 	str->di_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
@@ -386,15 +387,15 @@ void gfs2_dinode_out(const struct gfs2_i
 	str->di_header.mh_format = cpu_to_be32(GFS2_FORMAT_DI);
 	str->di_num.no_addr = cpu_to_be64(ip->i_no_addr);
 	str->di_num.no_formal_ino = cpu_to_be64(ip->i_no_formal_ino);
-	str->di_mode = cpu_to_be32(ip->i_inode.i_mode);
-	str->di_uid = cpu_to_be32(i_uid_read(&ip->i_inode));
-	str->di_gid = cpu_to_be32(i_gid_read(&ip->i_inode));
-	str->di_nlink = cpu_to_be32(ip->i_inode.i_nlink);
-	str->di_size = cpu_to_be64(i_size_read(&ip->i_inode));
-	str->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(&ip->i_inode));
-	str->di_atime = cpu_to_be64(ip->i_inode.i_atime.tv_sec);
-	str->di_mtime = cpu_to_be64(ip->i_inode.i_mtime.tv_sec);
-	str->di_ctime = cpu_to_be64(ip->i_inode.i_ctime.tv_sec);
+	str->di_mode = cpu_to_be32(inode->i_mode);
+	str->di_uid = cpu_to_be32(i_uid_read(inode));
+	str->di_gid = cpu_to_be32(i_gid_read(inode));
+	str->di_nlink = cpu_to_be32(inode->i_nlink);
+	str->di_size = cpu_to_be64(i_size_read(inode));
+	str->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(inode));
+	str->di_atime = cpu_to_be64(inode->i_atime.tv_sec);
+	str->di_mtime = cpu_to_be64(inode->i_mtime.tv_sec);
+	str->di_ctime = cpu_to_be64(inode->i_ctime.tv_sec);
 
 	str->di_goal_meta = cpu_to_be64(ip->i_goal);
 	str->di_goal_data = cpu_to_be64(ip->i_goal);
@@ -402,16 +403,16 @@ void gfs2_dinode_out(const struct gfs2_i
 
 	str->di_flags = cpu_to_be32(ip->i_diskflags);
 	str->di_height = cpu_to_be16(ip->i_height);
-	str->di_payload_format = cpu_to_be32(S_ISDIR(ip->i_inode.i_mode) &&
+	str->di_payload_format = cpu_to_be32(S_ISDIR(inode->i_mode) &&
 					     !(ip->i_diskflags & GFS2_DIF_EXHASH) ?
 					     GFS2_FORMAT_DE : 0);
 	str->di_depth = cpu_to_be16(ip->i_depth);
 	str->di_entries = cpu_to_be32(ip->i_entries);
 
 	str->di_eattr = cpu_to_be64(ip->i_eattr);
-	str->di_atime_nsec = cpu_to_be32(ip->i_inode.i_atime.tv_nsec);
-	str->di_mtime_nsec = cpu_to_be32(ip->i_inode.i_mtime.tv_nsec);
-	str->di_ctime_nsec = cpu_to_be32(ip->i_inode.i_ctime.tv_nsec);
+	str->di_atime_nsec = cpu_to_be32(inode->i_atime.tv_nsec);
+	str->di_mtime_nsec = cpu_to_be32(inode->i_mtime.tv_nsec);
+	str->di_ctime_nsec = cpu_to_be32(inode->i_ctime.tv_nsec);
 }
 
 /**


