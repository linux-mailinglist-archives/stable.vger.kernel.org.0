Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225284FCFDE
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349116AbiDLGia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349777AbiDLGhL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:37:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585511039;
        Mon, 11 Apr 2022 23:34:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC9C3618A8;
        Tue, 12 Apr 2022 06:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEE7C385A1;
        Tue, 12 Apr 2022 06:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745242;
        bh=cCF3v0HKS+OhhTX9jSF/rd3/wwsIUZjFlVDapiyC07c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNg6BziBeQp6xT9aetL0pyvpJVR+D6iUKd1QKW+p0xpgW4+ASzfUefhUD+T6Mel56
         CwvzQZORWoFGFW5sgqclln7yGkuhCfOoA8eHjpCGfwcr9jnzCyPlfPetb9/FW6KS6j
         Vl/K3tde20hQBVkSxuQhyK1p6Rr5Kv+qo8x7X6TQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/171] gfs2: gfs2_setattr_size error path fix
Date:   Tue, 12 Apr 2022 08:28:15 +0200
Message-Id: <20220412062928.004569672@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
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

[ Upstream commit 7336905a89f19173bf9301cd50a24421162f417c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c  | 2 +-
 fs/gfs2/file.c  | 2 +-
 fs/gfs2/inode.c | 2 +-
 fs/gfs2/rgrp.c  | 7 ++++---
 fs/gfs2/rgrp.h  | 2 +-
 fs/gfs2/super.c | 2 +-
 6 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index b34c02985d9d..6c047570d6a9 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -2200,7 +2200,7 @@ int gfs2_setattr_size(struct inode *inode, u64 newsize)
 
 	ret = do_shrink(inode, newsize);
 out:
-	gfs2_rs_delete(ip, NULL);
+	gfs2_rs_delete(ip);
 	gfs2_qa_put(ip);
 	return ret;
 }
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 7bd7581aa682..2e6f622ed428 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -718,7 +718,7 @@ static int gfs2_release(struct inode *inode, struct file *file)
 
 	if (file->f_mode & FMODE_WRITE) {
 		if (gfs2_rs_active(&ip->i_res))
-			gfs2_rs_delete(ip, &inode->i_writecount);
+			gfs2_rs_delete(ip);
 		gfs2_qa_put(ip);
 	}
 	return 0;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 65ae4fc28ede..74a6b0800e05 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -811,7 +811,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		if (free_vfs_inode) /* else evict will do the put for us */
 			gfs2_glock_put(ip->i_gl);
 	}
-	gfs2_rs_delete(ip, NULL);
+	gfs2_rs_deltree(&ip->i_res);
 	gfs2_qa_put(ip);
 fail_free_acls:
 	posix_acl_release(default_acl);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index eb775e93de97..dc55b029afaa 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -664,13 +664,14 @@ void gfs2_rs_deltree(struct gfs2_blkreserv *rs)
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
index 9a587ada51ed..2d3c150c55bd 100644
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
index d2b7ecbd1b15..d14b98aa1c3e 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1434,7 +1434,7 @@ static void gfs2_evict_inode(struct inode *inode)
 	truncate_inode_pages_final(&inode->i_data);
 	if (ip->i_qadata)
 		gfs2_assert_warn(sdp, ip->i_qadata->qa_ref == 0);
-	gfs2_rs_delete(ip, NULL);
+	gfs2_rs_deltree(&ip->i_res);
 	gfs2_ordered_del_inode(ip);
 	clear_inode(inode);
 	gfs2_dir_hash_inval(ip);
-- 
2.35.1



