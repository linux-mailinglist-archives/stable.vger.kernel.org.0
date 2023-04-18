Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4256E624B
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjDRMbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjDRMbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:31:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED1F1024B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:31:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9ABB631ED
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FDCC433A0;
        Tue, 18 Apr 2023 12:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821064;
        bh=kOHjxe6NJ8Tu5Um7c3bx+Hrh30Dcf0IyQeXQpD0y0r8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3pV8MAwj34TIjFzmVGLaoyhGNyx4m4licZATCAfe7d/ywZfu5Kdh6grWnQhTNFJi
         nvTGkRCND4yr76da/EtC70BxQz4fOk/bsPuD8cDNF3Vn6W/yXQfC1A1fqpq90Bbd8d
         cDHQJw9r9fTrAd7o7KmzXBDHoOwMGSNWyNUTcntI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 78/92] xfs: ensure that the inode uid/gid match values match the icdinode ones
Date:   Tue, 18 Apr 2023 14:21:53 +0200
Message-Id: <20230418120307.505807865@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 3d8f2821502d0b60bac2789d0bea951fda61de0c upstream.

Instead of only synchronizing the uid/gid values in xfs_setup_inode,
ensure that they always match to prepare for removing the icdinode
fields.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    2 ++
 fs/xfs/xfs_icache.c           |    4 ++++
 fs/xfs/xfs_inode.c            |    8 ++++++--
 fs/xfs/xfs_iops.c             |    3 ---
 4 files changed, 12 insertions(+), 5 deletions(-)

--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -223,7 +223,9 @@ xfs_inode_from_disk(
 
 	to->di_format = from->di_format;
 	to->di_uid = be32_to_cpu(from->di_uid);
+	inode->i_uid = xfs_uid_to_kuid(to->di_uid);
 	to->di_gid = be32_to_cpu(from->di_gid);
+	inode->i_gid = xfs_gid_to_kgid(to->di_gid);
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -289,6 +289,8 @@ xfs_reinit_inode(
 	uint64_t	version = inode_peek_iversion(inode);
 	umode_t		mode = inode->i_mode;
 	dev_t		dev = inode->i_rdev;
+	kuid_t		uid = inode->i_uid;
+	kgid_t		gid = inode->i_gid;
 
 	error = inode_init_always(mp->m_super, inode);
 
@@ -297,6 +299,8 @@ xfs_reinit_inode(
 	inode_set_iversion_queried(inode, version);
 	inode->i_mode = mode;
 	inode->i_rdev = dev;
+	inode->i_uid = uid;
+	inode->i_gid = gid;
 	return error;
 }
 
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -806,15 +806,19 @@ xfs_ialloc(
 
 	inode->i_mode = mode;
 	set_nlink(inode, nlink);
-	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
-	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
+	inode->i_uid = current_fsuid();
+	ip->i_d.di_uid = xfs_kuid_to_uid(inode->i_uid);
 	inode->i_rdev = rdev;
 	ip->i_d.di_projid = prid;
 
 	if (pip && XFS_INHERIT_GID(pip)) {
+		inode->i_gid = VFS_I(pip)->i_gid;
 		ip->i_d.di_gid = pip->i_d.di_gid;
 		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
 			inode->i_mode |= S_ISGID;
+	} else {
+		inode->i_gid = current_fsgid();
+		ip->i_d.di_gid = xfs_kgid_to_gid(inode->i_gid);
 	}
 
 	/*
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1288,9 +1288,6 @@ xfs_setup_inode(
 	/* make the inode look hashed for the writeback code */
 	inode_fake_hash(inode);
 
-	inode->i_uid    = xfs_uid_to_kuid(ip->i_d.di_uid);
-	inode->i_gid    = xfs_gid_to_kgid(ip->i_d.di_gid);
-
 	i_size_write(inode, ip->i_d.di_size);
 	xfs_diflags_to_iflags(inode, ip);
 


