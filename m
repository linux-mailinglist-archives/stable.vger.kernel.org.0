Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E46469E5B
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345322AbhLFPiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389360AbhLFPf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:35:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBBBC08EA4D;
        Mon,  6 Dec 2021 07:21:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AFBF61321;
        Mon,  6 Dec 2021 15:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0CBC341C5;
        Mon,  6 Dec 2021 15:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804060;
        bh=Y2dxcry5bN5+Fd62OnD546+RhVQk/SxgpdbOb/0knh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rP1aHPKuc1KSoy/PtwuIye48ZE0MuAmLBiK2WYr/XEfGtsxS7GnnUrmaydVFQX/ok
         B1Bg76R5DNEnro7TUM1a2YfRzPWPoo7NTPaD0BzIkJQM9gMfXDKYrO4B1N6Lf5wnkk
         TPROfJiqpWVf0EI99L+RY5ClzS/P8yw3Typbst1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Bob Peterson <rpeterso@redhat.com>
Subject: [PATCH 5.15 013/207] gfs2: release iopen glock early in evict
Date:   Mon,  6 Dec 2021 15:54:27 +0100
Message-Id: <20211206145610.654464578@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 49462e2be119d38c5eb5759d0d1b712df3a41239 ]

Before this patch, evict would clear the iopen glock's gl_object after
releasing the inode glock.  In the meantime, another process could reuse
the same block and thus glocks for a new inode.  It would lock the inode
glock (exclusively), and then the iopen glock (shared).  The shared
locking mode doesn't provide any ordering against the evict, so by the
time the iopen glock is reused, evict may not have gotten to setting
gl_object to NULL.

Fix that by releasing the iopen glock before the inode glock in
gfs2_evict_inode.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>gl_object
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 6e00d15ef0a82..cc51b5f5f52d8 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1402,13 +1402,6 @@ static void gfs2_evict_inode(struct inode *inode)
 	gfs2_ordered_del_inode(ip);
 	clear_inode(inode);
 	gfs2_dir_hash_inval(ip);
-	if (ip->i_gl) {
-		glock_clear_object(ip->i_gl, ip);
-		wait_on_bit_io(&ip->i_flags, GIF_GLOP_PENDING, TASK_UNINTERRUPTIBLE);
-		gfs2_glock_add_to_lru(ip->i_gl);
-		gfs2_glock_put_eventually(ip->i_gl);
-		ip->i_gl = NULL;
-	}
 	if (gfs2_holder_initialized(&ip->i_iopen_gh)) {
 		struct gfs2_glock *gl = ip->i_iopen_gh.gh_gl;
 
@@ -1421,6 +1414,13 @@ static void gfs2_evict_inode(struct inode *inode)
 		gfs2_holder_uninit(&ip->i_iopen_gh);
 		gfs2_glock_put_eventually(gl);
 	}
+	if (ip->i_gl) {
+		glock_clear_object(ip->i_gl, ip);
+		wait_on_bit_io(&ip->i_flags, GIF_GLOP_PENDING, TASK_UNINTERRUPTIBLE);
+		gfs2_glock_add_to_lru(ip->i_gl);
+		gfs2_glock_put_eventually(ip->i_gl);
+		ip->i_gl = NULL;
+	}
 }
 
 static struct inode *gfs2_alloc_inode(struct super_block *sb)
-- 
2.33.0



