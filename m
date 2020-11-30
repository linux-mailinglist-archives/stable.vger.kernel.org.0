Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083102C927F
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 00:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgK3X2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 18:28:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24104 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725933AbgK3X2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 18:28:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606778819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pvWvNGan1SxrNBUZl9nFkAEn1lvy21Erq/cTovFLU/4=;
        b=aYI/D9vqquPwVkTMJH0csgIPrmKlyWIRuf33NlXkNJZDkvy8uQmoS5HkXNj7s8wLoBrylm
        Degi2UjvfDxNzWDMNsCYi7JFd9JwuIcB1CT0iMxFKGlVzwKVqN8wuSWT5b1NdHIcd/yRVk
        pN7PzxXgZ5e0vh+MFOApFfjWdMSjeJ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-42V2bR8nOzmv-kUC2WWfWQ-1; Mon, 30 Nov 2020 18:26:56 -0500
X-MC-Unique: 42V2bR8nOzmv-kUC2WWfWQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05563107ACF6
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 23:26:56 +0000 (UTC)
Received: from max.home.com (unknown [10.40.192.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0FE15C1A3;
        Mon, 30 Nov 2020 23:26:49 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     cluster-devel@redhat.com
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Alexander Aring <aahringo@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2] gfs2: Fix deadlock between gfs2_{create_inode,inode_lookup} and delete_work_func
Date:   Tue,  1 Dec 2020 00:26:48 +0100
Message-Id: <20201130232648.749135-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In gfs2_create_inode and gfs2_inode_lookup, make sure to cancel any pending
delete work before taking the inode glock.  Otherwise, gfs2_cancel_delete_work
may block waiting for delete_work_func to complete, and delete_work_func may
block trying to acquire the inode glock in gfs2_inode_lookup.

Reported-by: Alexander Aring <aahringo@redhat.com>
Fixes: a0e3cc65fa29 ("gfs2: Turn gl_delete into a delayed work")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/inode.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index eed1a1bac6f6..65ae4fc28ede 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -150,6 +150,8 @@ struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned int type,
 		error = gfs2_glock_get(sdp, no_addr, &gfs2_iopen_glops, CREATE, &io_gl);
 		if (unlikely(error))
 			goto fail;
+		if (blktype != GFS2_BLKST_UNLINKED)
+			gfs2_cancel_delete_work(io_gl);
 
 		if (type == DT_UNKNOWN || blktype != GFS2_BLKST_FREE) {
 			/*
@@ -180,8 +182,6 @@ struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned int type,
 		error = gfs2_glock_nq_init(io_gl, LM_ST_SHARED, GL_EXACT, &ip->i_iopen_gh);
 		if (unlikely(error))
 			goto fail;
-		if (blktype != GFS2_BLKST_UNLINKED)
-			gfs2_cancel_delete_work(ip->i_iopen_gh.gh_gl);
 		glock_set_object(ip->i_iopen_gh.gh_gl, ip);
 		gfs2_glock_put(io_gl);
 		io_gl = NULL;
@@ -725,13 +725,19 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
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
@@ -740,18 +746,12 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
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
 
@@ -803,6 +803,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	gfs2_glock_dq_uninit(&ip->i_iopen_gh);
 fail_gunlock2:
 	clear_bit(GLF_INODE_CREATING, &io_gl->gl_flags);
+	glock_clear_object(io_gl, ip);
 	gfs2_glock_put(io_gl);
 fail_free_inode:
 	if (ip->i_gl) {
-- 
2.26.2

