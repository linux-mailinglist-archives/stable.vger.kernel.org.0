Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808D926F14E
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgIRCIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:08:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbgIRCIo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDB6523976;
        Fri, 18 Sep 2020 02:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394923;
        bh=ngS+1Y2+NKJbTmEutQwT4xsvGK9vpdEfek0alqaCQuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpQTPqK0tGlW9za6qCmfaDXrelaqNg5BHGHpecpgcF5ct6koO/7c+xw+JfzQ0AZdU
         ViWQNPTc5OSoVK5V8aBy4159g7RH1enOPXOz3RWfEPYXA6DWH6MAbtG5FCX6HQ9/lv
         DlEgO49lQWblR/2/aLOZHLJ6Wwr+7D2l1jjs2yyQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.19 035/206] gfs2: clean up iopen glock mess in gfs2_create_inode
Date:   Thu, 17 Sep 2020 22:05:11 -0400
Message-Id: <20200918020802.2065198-35-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 2c47c1be51fbded1f7baa2ceaed90f97932f79be ]

Before this patch, gfs2_create_inode had a use-after-free for the
iopen glock in some error paths because it did this:

	gfs2_glock_put(io_gl);
fail_gunlock2:
	if (io_gl)
		clear_bit(GLF_INODE_CREATING, &io_gl->gl_flags);

In some cases, the io_gl was used for create and only had one
reference, so the glock might be freed before the clear_bit().
This patch tries to straighten it out by only jumping to the
error paths where iopen is properly set, and moving the
gfs2_glock_put after the clear_bit.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index d968b5c5df217..a52b8b0dceeb9 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -715,7 +715,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 
 	error = gfs2_trans_begin(sdp, blocks, 0);
 	if (error)
-		goto fail_gunlock2;
+		goto fail_free_inode;
 
 	if (blocks > 1) {
 		ip->i_eattr = ip->i_no_addr + 1;
@@ -726,7 +726,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 
 	error = gfs2_glock_get(sdp, ip->i_no_addr, &gfs2_iopen_glops, CREATE, &io_gl);
 	if (error)
-		goto fail_gunlock2;
+		goto fail_free_inode;
 
 	BUG_ON(test_and_set_bit(GLF_INODE_CREATING, &io_gl->gl_flags));
 
@@ -735,7 +735,6 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		goto fail_gunlock2;
 
 	glock_set_object(ip->i_iopen_gh.gh_gl, ip);
-	gfs2_glock_put(io_gl);
 	gfs2_set_iop(inode);
 	insert_inode_hash(inode);
 
@@ -768,6 +767,8 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 
 	mark_inode_dirty(inode);
 	d_instantiate(dentry, inode);
+	/* After instantiate, errors should result in evict which will destroy
+	 * both inode and iopen glocks properly. */
 	if (file) {
 		file->f_mode |= FMODE_CREATED;
 		error = finish_open(file, dentry, gfs2_open_common);
@@ -775,15 +776,15 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	gfs2_glock_dq_uninit(ghs);
 	gfs2_glock_dq_uninit(ghs + 1);
 	clear_bit(GLF_INODE_CREATING, &io_gl->gl_flags);
+	gfs2_glock_put(io_gl);
 	return error;
 
 fail_gunlock3:
 	glock_clear_object(io_gl, ip);
 	gfs2_glock_dq_uninit(&ip->i_iopen_gh);
-	gfs2_glock_put(io_gl);
 fail_gunlock2:
-	if (io_gl)
-		clear_bit(GLF_INODE_CREATING, &io_gl->gl_flags);
+	clear_bit(GLF_INODE_CREATING, &io_gl->gl_flags);
+	gfs2_glock_put(io_gl);
 fail_free_inode:
 	if (ip->i_gl) {
 		glock_clear_object(ip->i_gl, ip);
-- 
2.25.1

