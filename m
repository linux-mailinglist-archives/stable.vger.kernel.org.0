Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4396C27C9DD
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730428AbgI2MOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730085AbgI2Lh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4361D2311C;
        Tue, 29 Sep 2020 11:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379194;
        bh=OLESydZQ4gmgfkoqbmc/SAbiZeY7XhikeW9o0UcETjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlgxldrcCTYllZVgJVGwZR5qRM/+b6ux07LycuCg6MRsA+egERIUFK/i6Ue9Mq0LY
         XsNoensKrVw2d/LvoK7qzTbefY5RacIVlFEGZScHrj3tXhtb872qYfpAEAjMuNWU5X
         CiNVvWWI8c52963slw4k33k0aqfagCIqPx1TrcMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/388] gfs2: clean up iopen glock mess in gfs2_create_inode
Date:   Tue, 29 Sep 2020 12:56:24 +0200
Message-Id: <20200929110013.062556528@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8466166f22e3d..988bb7b17ed8f 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -712,7 +712,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 
 	error = gfs2_trans_begin(sdp, blocks, 0);
 	if (error)
-		goto fail_gunlock2;
+		goto fail_free_inode;
 
 	if (blocks > 1) {
 		ip->i_eattr = ip->i_no_addr + 1;
@@ -723,7 +723,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 
 	error = gfs2_glock_get(sdp, ip->i_no_addr, &gfs2_iopen_glops, CREATE, &io_gl);
 	if (error)
-		goto fail_gunlock2;
+		goto fail_free_inode;
 
 	BUG_ON(test_and_set_bit(GLF_INODE_CREATING, &io_gl->gl_flags));
 
@@ -732,7 +732,6 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		goto fail_gunlock2;
 
 	glock_set_object(ip->i_iopen_gh.gh_gl, ip);
-	gfs2_glock_put(io_gl);
 	gfs2_set_iop(inode);
 	insert_inode_hash(inode);
 
@@ -765,6 +764,8 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 
 	mark_inode_dirty(inode);
 	d_instantiate(dentry, inode);
+	/* After instantiate, errors should result in evict which will destroy
+	 * both inode and iopen glocks properly. */
 	if (file) {
 		file->f_mode |= FMODE_CREATED;
 		error = finish_open(file, dentry, gfs2_open_common);
@@ -772,15 +773,15 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
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



