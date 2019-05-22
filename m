Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 660612707B
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 22:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbfEVTV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729874AbfEVTV0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:21:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D20F217D9;
        Wed, 22 May 2019 19:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552885;
        bh=ArSHjs28NdkfbTowzn7Wt6gNKxncZUHW8jAxRtOEqXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2I6H0gJ2SxVpooePrIkWJ84WThPuWAjVpkULP4Jw1UclrTdZ6xXvD6kzwpX9WBuLZ
         oQvDeisgACpaPXftDCNRQyTNvHhAzrBDAFjT3L79VxpXJBf1Rt/IQ/LihlKkbOEGQy
         yoGrxp/TnIFQ+z2ffVbWTT6340pVdSgiV98QlpHw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Ross Lagerwall <ross.lagerwall@citrix.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.1 008/375] gfs2: Fix occasional glock use-after-free
Date:   Wed, 22 May 2019 15:15:08 -0400
Message-Id: <20190522192115.22666-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 9287c6452d2b1f24ea8e84bd3cf6f3c6f267f712 ]

This patch has to do with the life cycle of glocks and buffers.  When
gfs2 metadata or journaled data is queued to be written, a gfs2_bufdata
object is assigned to track the buffer, and that is queued to various
lists, including the glock's gl_ail_list to indicate it's on the active
items list.  Once the page associated with the buffer has been written,
it is removed from the ail list, but its life isn't over until a revoke
has been successfully written.

So after the block is written, its bufdata object is moved from the
glock's gl_ail_list to a file-system-wide list of pending revokes,
sd_log_le_revoke.  At that point the glock still needs to track how many
revokes it contributed to that list (in gl_revokes) so that things like
glock go_sync can ensure all the metadata has been not only written, but
also revoked before the glock is granted to a different node.  This is
to guarantee journal replay doesn't replay the block once the glock has
been granted to another node.

Ross Lagerwall recently discovered a race in which an inode could be
evicted, and its glock freed after its ail list had been synced, but
while it still had unwritten revokes on the sd_log_le_revoke list.  The
evict decremented the glock reference count to zero, which allowed the
glock to be freed.  After the revoke was written, function
revoke_lo_after_commit tried to adjust the glock's gl_revokes counter
and clear its GLF_LFLUSH flag, at which time it referenced the freed
glock.

This patch fixes the problem by incrementing the glock reference count
in gfs2_add_revoke when the glock's first bufdata object is moved from
the glock to the global revokes list. Later, when the glock's last such
bufdata object is freed, the reference count is decremented. This
guarantees that whichever process finishes last (the revoke writing or
the evict) will properly free the glock, and neither will reference the
glock after it has been freed.

Reported-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 1 +
 fs/gfs2/log.c   | 3 ++-
 fs/gfs2/lops.c  | 6 ++++--
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index e4f6d39500bcc..71c28ff98b564 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -140,6 +140,7 @@ void gfs2_glock_free(struct gfs2_glock *gl)
 {
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
 
+	BUG_ON(atomic_read(&gl->gl_revokes));
 	rhashtable_remove_fast(&gl_hash_table, &gl->gl_node, ht_parms);
 	smp_mb();
 	wake_up_glock(gl);
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index b8830fda51e8f..0e04f87a7dddb 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -606,7 +606,8 @@ void gfs2_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 	gfs2_remove_from_ail(bd); /* drops ref on bh */
 	bd->bd_bh = NULL;
 	sdp->sd_log_num_revoke++;
-	atomic_inc(&gl->gl_revokes);
+	if (atomic_inc_return(&gl->gl_revokes) == 1)
+		gfs2_glock_hold(gl);
 	set_bit(GLF_LFLUSH, &gl->gl_flags);
 	list_add(&bd->bd_list, &sdp->sd_log_le_revoke);
 }
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 8722c60b11feb..4b280611246df 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -669,8 +669,10 @@ static void revoke_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 		bd = list_entry(head->next, struct gfs2_bufdata, bd_list);
 		list_del_init(&bd->bd_list);
 		gl = bd->bd_gl;
-		atomic_dec(&gl->gl_revokes);
-		clear_bit(GLF_LFLUSH, &gl->gl_flags);
+		if (atomic_dec_return(&gl->gl_revokes) == 0) {
+			clear_bit(GLF_LFLUSH, &gl->gl_flags);
+			gfs2_glock_queue_put(gl);
+		}
 		kmem_cache_free(gfs2_bufdata_cachep, bd);
 	}
 }
-- 
2.20.1

