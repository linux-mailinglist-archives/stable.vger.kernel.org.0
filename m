Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88FE2C8E55
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 20:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgK3Tp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 14:45:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51173 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727952AbgK3Tp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 14:45:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606765472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=AaFyPJmplGhVXa5tN5jnZ059syGIAzsENaLwF1V70QY=;
        b=cwGz/3xlao+6kFai1sK/f8RQyLuA7K/Q/e3iB0QkSNGyBRgnKV1R/wU0elQcUpETtKgl5w
        ikwCbP8WVtX9j91pEqkxY1K09qtcnhzOyBKFFY501spjV12nZrQ8pCJPwY3ermLSF41iW1
        6RLJn/zSvC6XcJegQoP92WYsucZA/aM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-i1_tvjWEPAmQU6f7vutq1g-1; Mon, 30 Nov 2020 14:44:29 -0500
X-MC-Unique: i1_tvjWEPAmQU6f7vutq1g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFE9DE743
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 19:44:28 +0000 (UTC)
Received: from max.home.com (unknown [10.40.192.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89CF060873;
        Mon, 30 Nov 2020 19:44:24 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     cluster-devel@redhat.com
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Alexander Aring <aahringo@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] gfs2: Fix deadlock between gfs2_create_inode and delete_work_func
Date:   Mon, 30 Nov 2020 20:44:22 +0100
Message-Id: <20201130194422.741935-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In gfs2_create_inode, make sure to cancel any pending delete work before
locking the inode glock.  Otherwise, gfs2_cancel_delete_work may block
waiting for delete_work_func to complete, and delete_work_func may block
trying to acquire the inode glock in gfs2_inode_lookup.

Reported-by: Alexander Aring <aahringo@redhat.com>
Fixes: a0e3cc65fa29 ("gfs2: Turn gl_delete into a delayed work")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/inode.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index eed1a1bac6f6..3b9e8c99293c 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
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

