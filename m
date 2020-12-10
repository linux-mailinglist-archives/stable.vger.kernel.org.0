Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102202D6049
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgLJPq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 10:46:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391227AbgLJOjj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:39:39 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.9 27/75] gfs2: Fix deadlock between gfs2_{create_inode,inode_lookup} and delete_work_func
Date:   Thu, 10 Dec 2020 15:26:52 +0100
Message-Id: <20201210142607.388481254@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit dd0ecf544125639e54056d851e4887dbb94b6d2f upstream.

In gfs2_create_inode and gfs2_inode_lookup, make sure to cancel any pending
delete work before taking the inode glock.  Otherwise, gfs2_cancel_delete_work
may block waiting for delete_work_func to complete, and delete_work_func may
block trying to acquire the inode glock in gfs2_inode_lookup.

Reported-by: Alexander Aring <aahringo@redhat.com>
Fixes: a0e3cc65fa29 ("gfs2: Turn gl_delete into a delayed work")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/inode.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -150,6 +150,8 @@ struct inode *gfs2_inode_lookup(struct s
 		error = gfs2_glock_get(sdp, no_addr, &gfs2_iopen_glops, CREATE, &io_gl);
 		if (unlikely(error))
 			goto fail;
+		if (blktype != GFS2_BLKST_UNLINKED)
+			gfs2_cancel_delete_work(io_gl);
 
 		if (type == DT_UNKNOWN || blktype != GFS2_BLKST_FREE) {
 			/*
@@ -180,8 +182,6 @@ struct inode *gfs2_inode_lookup(struct s
 		error = gfs2_glock_nq_init(io_gl, LM_ST_SHARED, GL_EXACT, &ip->i_iopen_gh);
 		if (unlikely(error))
 			goto fail;
-		if (blktype != GFS2_BLKST_UNLINKED)
-			gfs2_cancel_delete_work(ip->i_iopen_gh.gh_gl);
 		glock_set_object(ip->i_iopen_gh.gh_gl, ip);
 		gfs2_glock_put(io_gl);
 		io_gl = NULL;
@@ -725,13 +725,19 @@ static int gfs2_create_inode(struct inod
 	flush_delayed_work(&ip->i_gl->gl_work);
 	glock_set_object(ip->i_gl, ip);
 
-	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, GL_SKIP, ghs + 1);
+	error = gfs2_glock_get(sdp, ip->i_no_addr, &gfs2_iopen_glops, CREATE, &io_gl);
 	if (error)
 		goto fail_free_inode;
+	gfs2_cancel_delete_work(io_gl);
+	glock_set_object(io_gl, ip);
+
+	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, GL_SKIP, ghs + 1);
+	if (error)
+		goto fail_gunlock2;
 
 	error = gfs2_trans_begin(sdp, blocks, 0);
 	if (error)
-		goto fail_free_inode;
+		goto fail_gunlock2;
 
 	if (blocks > 1) {
 		ip->i_eattr = ip->i_no_addr + 1;
@@ -740,18 +746,12 @@ static int gfs2_create_inode(struct inod
 	init_dinode(dip, ip, symname);
 	gfs2_trans_end(sdp);
 
-	error = gfs2_glock_get(sdp, ip->i_no_addr, &gfs2_iopen_glops, CREATE, &io_gl);
-	if (error)
-		goto fail_free_inode;
-
 	BUG_ON(test_and_set_bit(GLF_INODE_CREATING, &io_gl->gl_flags));
 
 	error = gfs2_glock_nq_init(io_gl, LM_ST_SHARED, GL_EXACT, &ip->i_iopen_gh);
 	if (error)
 		goto fail_gunlock2;
 
-	gfs2_cancel_delete_work(ip->i_iopen_gh.gh_gl);
-	glock_set_object(ip->i_iopen_gh.gh_gl, ip);
 	gfs2_set_iop(inode);
 	insert_inode_hash(inode);
 
@@ -803,6 +803,7 @@ fail_gunlock3:
 	gfs2_glock_dq_uninit(&ip->i_iopen_gh);
 fail_gunlock2:
 	clear_bit(GLF_INODE_CREATING, &io_gl->gl_flags);
+	glock_clear_object(io_gl, ip);
 	gfs2_glock_put(io_gl);
 fail_free_inode:
 	if (ip->i_gl) {


