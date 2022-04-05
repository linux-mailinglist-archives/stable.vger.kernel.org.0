Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7C54F39DA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378802AbiDELjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354034AbiDEKLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:11:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDA54BBA5;
        Tue,  5 Apr 2022 02:56:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4168DB817D3;
        Tue,  5 Apr 2022 09:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A581C385A1;
        Tue,  5 Apr 2022 09:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152606;
        bh=IS0LmQcQrqxmwm4rURgQy707TCHc6pQBCukr7IiT28Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGybfjeodl4rp0U4xj9vIrZ1YLiMjO0rhSd93VhyLIb8c1wf7oo5aDoLC+gpl/u4q
         Z2yyjx8XuLxzVjmd29u1eOVXLdX5S35O/EHPi7F0hUSBXymRm47piG3OsKcbpsUMSN
         xp6ufrDje66aBsHViHBOWvIWTqDcupUtqrmlnYq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.15 838/913] gfs2: gfs2_setattr_size error path fix
Date:   Tue,  5 Apr 2022 09:31:40 +0200
Message-Id: <20220405070404.949894656@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 7336905a89f19173bf9301cd50a24421162f417c upstream.

When gfs2_setattr_size() fails, it calls gfs2_rs_delete(ip, NULL) to get
rid of any reservations the inode may have.  Instead, it should pass in
the inode's write count as the second parameter to allow
gfs2_rs_delete() to figure out if the inode has any writers left.

In a next step, there are two instances of gfs2_rs_delete(ip, NULL) left
where we know that there can be no other users of the inode.  Replace
those with gfs2_rs_deltree(&ip->i_res) to avoid the unnecessary write
count check.

With that, gfs2_rs_delete() is only called with the inode's actual write
count, so get rid of the second parameter.

Fixes: a097dc7e24cb ("GFS2: Make rgrp reservations part of the gfs2_inode structure")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/bmap.c  |    2 +-
 fs/gfs2/file.c  |    2 +-
 fs/gfs2/inode.c |    2 +-
 fs/gfs2/rgrp.c  |    7 ++++---
 fs/gfs2/rgrp.h  |    2 +-
 fs/gfs2/super.c |    2 +-
 6 files changed, 9 insertions(+), 8 deletions(-)

--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -2204,7 +2204,7 @@ int gfs2_setattr_size(struct inode *inod
 
 	ret = do_shrink(inode, newsize);
 out:
-	gfs2_rs_delete(ip, NULL);
+	gfs2_rs_delete(ip);
 	gfs2_qa_put(ip);
 	return ret;
 }
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -713,7 +713,7 @@ static int gfs2_release(struct inode *in
 
 	if (file->f_mode & FMODE_WRITE) {
 		if (gfs2_rs_active(&ip->i_res))
-			gfs2_rs_delete(ip, &inode->i_writecount);
+			gfs2_rs_delete(ip);
 		gfs2_qa_put(ip);
 	}
 	return 0;
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -811,7 +811,7 @@ fail_free_inode:
 		if (free_vfs_inode) /* else evict will do the put for us */
 			gfs2_glock_put(ip->i_gl);
 	}
-	gfs2_rs_delete(ip, NULL);
+	gfs2_rs_deltree(&ip->i_res);
 	gfs2_qa_put(ip);
 fail_free_acls:
 	posix_acl_release(default_acl);
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -680,13 +680,14 @@ void gfs2_rs_deltree(struct gfs2_blkrese
 /**
  * gfs2_rs_delete - delete a multi-block reservation
  * @ip: The inode for this reservation
- * @wcount: The inode's write count, or NULL
  *
  */
-void gfs2_rs_delete(struct gfs2_inode *ip, atomic_t *wcount)
+void gfs2_rs_delete(struct gfs2_inode *ip)
 {
+	struct inode *inode = &ip->i_inode;
+
 	down_write(&ip->i_rw_mutex);
-	if ((wcount == NULL) || (atomic_read(wcount) <= 1))
+	if (atomic_read(&inode->i_writecount) <= 1)
 		gfs2_rs_deltree(&ip->i_res);
 	up_write(&ip->i_rw_mutex);
 }
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -45,7 +45,7 @@ extern int gfs2_alloc_blocks(struct gfs2
 			     bool dinode, u64 *generation);
 
 extern void gfs2_rs_deltree(struct gfs2_blkreserv *rs);
-extern void gfs2_rs_delete(struct gfs2_inode *ip, atomic_t *wcount);
+extern void gfs2_rs_delete(struct gfs2_inode *ip);
 extern void __gfs2_free_blocks(struct gfs2_inode *ip, struct gfs2_rgrpd *rgd,
 			       u64 bstart, u32 blen, int meta);
 extern void gfs2_free_meta(struct gfs2_inode *ip, struct gfs2_rgrpd *rgd,
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1398,7 +1398,7 @@ out:
 	truncate_inode_pages_final(&inode->i_data);
 	if (ip->i_qadata)
 		gfs2_assert_warn(sdp, ip->i_qadata->qa_ref == 0);
-	gfs2_rs_delete(ip, NULL);
+	gfs2_rs_deltree(&ip->i_res);
 	gfs2_ordered_del_inode(ip);
 	clear_inode(inode);
 	gfs2_dir_hash_inval(ip);


