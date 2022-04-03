Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27CB44F096F
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 14:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356296AbiDCMfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 08:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357917AbiDCMfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 08:35:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E472BEBA
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 05:33:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B702B80D33
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 12:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3E6C340ED;
        Sun,  3 Apr 2022 12:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648989213;
        bh=IHFaEZTofqjw0z/tdgWMR2J+LEF52s+FkTbSXuJ4CRc=;
        h=Subject:To:Cc:From:Date:From;
        b=xSKfQhUcAaezRrX3yBRFKYNbBj41lM5amjuYNWvAWu5LPVKs3BJI6teX7CnehNivd
         cggiV3N1oIbOVAuA8HYk2z2v2kIKs81WKuZv2Qco5y9X9Xqu29bAejHheSqBVtdvN5
         s0uOdWHir6r5a4N218/2qvATwlCJY8RoXZHx/PGM=
Subject: FAILED: patch "[PATCH] gfs2: gfs2_setattr_size error path fix" failed to apply to 4.9-stable tree
To:     agruenba@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Apr 2022 14:33:18 +0200
Message-ID: <164898919875118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7336905a89f19173bf9301cd50a24421162f417c Mon Sep 17 00:00:00 2001
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 10 Dec 2021 14:43:36 +0100
Subject: [PATCH] gfs2: gfs2_setattr_size error path fix

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

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index d67108489148..fbdb7a30470a 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -2146,7 +2146,7 @@ int gfs2_setattr_size(struct inode *inode, u64 newsize)
 
 	ret = do_shrink(inode, newsize);
 out:
-	gfs2_rs_delete(ip, NULL);
+	gfs2_rs_delete(ip);
 	gfs2_qa_put(ip);
 	return ret;
 }
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 8c39a8571b1f..5bac4f6e8e05 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -706,7 +706,7 @@ static int gfs2_release(struct inode *inode, struct file *file)
 
 	if (file->f_mode & FMODE_WRITE) {
 		if (gfs2_rs_active(&ip->i_res))
-			gfs2_rs_delete(ip, &inode->i_writecount);
+			gfs2_rs_delete(ip);
 		gfs2_qa_put(ip);
 	}
 	return 0;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 89905f4f29bb..66a123306aec 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -793,7 +793,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		if (free_vfs_inode) /* else evict will do the put for us */
 			gfs2_glock_put(ip->i_gl);
 	}
-	gfs2_rs_delete(ip, NULL);
+	gfs2_rs_deltree(&ip->i_res);
 	gfs2_qa_put(ip);
 fail_free_acls:
 	posix_acl_release(default_acl);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 9b04a570c582..9df8a84f85a6 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -680,13 +680,14 @@ void gfs2_rs_deltree(struct gfs2_blkreserv *rs)
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
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 3e2ca1fb4305..46dd94e9e085 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -45,7 +45,7 @@ extern int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
 			     bool dinode, u64 *generation);
 
 extern void gfs2_rs_deltree(struct gfs2_blkreserv *rs);
-extern void gfs2_rs_delete(struct gfs2_inode *ip, atomic_t *wcount);
+extern void gfs2_rs_delete(struct gfs2_inode *ip);
 extern void __gfs2_free_blocks(struct gfs2_inode *ip, struct gfs2_rgrpd *rgd,
 			       u64 bstart, u32 blen, int meta);
 extern void gfs2_free_meta(struct gfs2_inode *ip, struct gfs2_rgrpd *rgd,
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 64c67090f503..143a47359d1b 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1396,7 +1396,7 @@ static void gfs2_evict_inode(struct inode *inode)
 	truncate_inode_pages_final(&inode->i_data);
 	if (ip->i_qadata)
 		gfs2_assert_warn(sdp, ip->i_qadata->qa_ref == 0);
-	gfs2_rs_delete(ip, NULL);
+	gfs2_rs_deltree(&ip->i_res);
 	gfs2_ordered_del_inode(ip);
 	clear_inode(inode);
 	gfs2_dir_hash_inval(ip);

