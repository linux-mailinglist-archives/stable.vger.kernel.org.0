Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44CBD39E1F9
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhFGQOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230363AbhFGQOe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B824613C8;
        Mon,  7 Jun 2021 16:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082363;
        bh=yqHSEfuPh4AEz7Rf+I2vqAtViecRi1IMdFI4VrYekKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XktHBJksEjZlWPAWN4mWiL6TRv/N5Z3xwRXVENtiVUEzw/o/cGbFe8lhzN1Pxkd4r
         rQK8icVqaWOL8i+TQ4NSurEYsqzccL1KhTaa+cjtpJtoro4odsBQRiijSB/DCrr8Ws
         v9QtuE33V5exLNqwt4GaMXJbzDH3EWg1RDokXVUvH9rqUuUtTGOu8USLQl9qBl8g1T
         tCJZIF07KLHCGtP+YvWKS9bIRclHpHP/laU8Pw0j7NsmJ5Pu63FGZo0gRo5C8DqQzz
         DFW52maYMfX9N8J/HnqQ8QA5VTb1HpoQJc0Etao2SX61vvaJBjm2eaAF4WJp3QqTXM
         +OBI5fLwG3dNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.12 22/49] gfs2: Clean up revokes on normal withdraws
Date:   Mon,  7 Jun 2021 12:11:48 -0400
Message-Id: <20210607161215.3583176-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit f5456b5d67cf812fd31fe3e130ca216b2e0908e5 ]

Before this patch, the system ail lists were cleaned up if the logd
process withdrew, but on other withdraws, they were not cleaned up.
This included the cleaning up of the revokes as well.

This patch reorganizes things a bit so that all withdraws (not just logd)
clean up the ail lists, including any pending revokes.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/log.c  | 6 +++---
 fs/gfs2/log.h  | 1 +
 fs/gfs2/lops.c | 7 ++++++-
 fs/gfs2/lops.h | 1 +
 fs/gfs2/util.c | 1 +
 5 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 6410281546f9..47287a7056fe 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -923,10 +923,10 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags)
 }
 
 /**
- * ail_drain - drain the ail lists after a withdraw
+ * gfs2_ail_drain - drain the ail lists after a withdraw
  * @sdp: Pointer to GFS2 superblock
  */
-static void ail_drain(struct gfs2_sbd *sdp)
+void gfs2_ail_drain(struct gfs2_sbd *sdp)
 {
 	struct gfs2_trans *tr;
 
@@ -953,6 +953,7 @@ static void ail_drain(struct gfs2_sbd *sdp)
 		list_del(&tr->tr_list);
 		gfs2_trans_free(sdp, tr);
 	}
+	gfs2_drain_revokes(sdp);
 	spin_unlock(&sdp->sd_ail_lock);
 }
 
@@ -1159,7 +1160,6 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
 	if (tr && list_empty(&tr->tr_list))
 		list_add(&tr->tr_list, &sdp->sd_ail1_list);
 	spin_unlock(&sdp->sd_ail_lock);
-	ail_drain(sdp); /* frees all transactions */
 	tr = NULL;
 	goto out_end;
 }
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index eea58015710e..fc905c2af53c 100644
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -93,5 +93,6 @@ extern int gfs2_logd(void *data);
 extern void gfs2_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd);
 extern void gfs2_glock_remove_revoke(struct gfs2_glock *gl);
 extern void gfs2_flush_revokes(struct gfs2_sbd *sdp);
+extern void gfs2_ail_drain(struct gfs2_sbd *sdp);
 
 #endif /* __LOG_DOT_H__ */
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index a82f4747aa8d..ef44d325e518 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -882,7 +882,7 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 	gfs2_log_write_page(sdp, page);
 }
 
-static void revoke_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
+void gfs2_drain_revokes(struct gfs2_sbd *sdp)
 {
 	struct list_head *head = &sdp->sd_log_revokes;
 	struct gfs2_bufdata *bd;
@@ -897,6 +897,11 @@ static void revoke_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 	}
 }
 
+static void revoke_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
+{
+	gfs2_drain_revokes(sdp);
+}
+
 static void revoke_lo_before_scan(struct gfs2_jdesc *jd,
 				  struct gfs2_log_header_host *head, int pass)
 {
diff --git a/fs/gfs2/lops.h b/fs/gfs2/lops.h
index 31b6dd0d2e5d..f707601597dc 100644
--- a/fs/gfs2/lops.h
+++ b/fs/gfs2/lops.h
@@ -20,6 +20,7 @@ extern void gfs2_log_submit_bio(struct bio **biop, int opf);
 extern void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh);
 extern int gfs2_find_jhead(struct gfs2_jdesc *jd,
 			   struct gfs2_log_header_host *head, bool keep_cache);
+extern void gfs2_drain_revokes(struct gfs2_sbd *sdp);
 static inline unsigned int buf_limit(struct gfs2_sbd *sdp)
 {
 	return sdp->sd_ldptrs;
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 4f034b87b427..cffb346fb9b3 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -130,6 +130,7 @@ static void signal_our_withdraw(struct gfs2_sbd *sdp)
 	if (test_bit(SDF_NORECOVERY, &sdp->sd_flags) || !sdp->sd_jdesc)
 		return;
 
+	gfs2_ail_drain(sdp); /* frees all transactions */
 	inode = sdp->sd_jdesc->jd_inode;
 	ip = GFS2_I(inode);
 	i_gl = ip->i_gl;
-- 
2.30.2

