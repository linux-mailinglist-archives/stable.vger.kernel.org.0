Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66AC445E533
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243800AbhKZCkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:40:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358176AbhKZCiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:38:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C25A6120E;
        Fri, 26 Nov 2021 02:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894025;
        bh=q8nOXiEsn2t8A6ekNr7cIY0OmtEJD6FLJWD55i/I3wA=;
        h=From:To:Cc:Subject:Date:From;
        b=XgKiuWBZEidA8wpe7QpgwJv9mdQd2uiPLnPsyfaOgrC23iiGP4dEK/WRUNCyzZXdz
         oSXszqgrgmAKceXaSeDUPuCTZFTzHZjwjv1swbJnemEL3kLNTb9VmixRDotc6Cc6TB
         WKJZX/VkAm7OFenUNIRh0fliqYnqnkD/d/1btza+MtnVjA1gQWWatojg1vhSIFYy+/
         4KTyPA0qZvrsWb/J0DPOyzcEv8rrRbkxkqBslFih8wMdINQrQpMv/vxFNlhXBwUL0x
         nbIuOR2Xod5kBQ+9WW2qsSsKluYMeeXnP6ciLt6JHXOZs3zNmlHrT1zmqUErqjGchd
         u/ARxBfDAgl8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.10 01/28] gfs2: release iopen glock early in evict
Date:   Thu, 25 Nov 2021 21:33:16 -0500
Message-Id: <20211126023343.442045-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 6a355e1347d7f..d2b7ecbd1b150 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1438,13 +1438,6 @@ static void gfs2_evict_inode(struct inode *inode)
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
 
@@ -1457,6 +1450,13 @@ static void gfs2_evict_inode(struct inode *inode)
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

