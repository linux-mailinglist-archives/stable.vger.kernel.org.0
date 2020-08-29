Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C1D256674
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 11:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgH2J1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Aug 2020 05:27:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38048 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726405AbgH2J1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Aug 2020 05:27:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598693231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IMclwz3FDFLEXCV0HuWWgXmQ0qZFGsbjM6s5/M34Yr8=;
        b=dxmyhL+PX29AiXaLeuXDknCCyUuXBw6JE08WbHeyyly+j+FoRGyOgrTlkkBG8Tu0A51WdC
        LOTq4W2OfO4OMT+e0EPE9jJSmDOJPFnN5SxkM7gHWgYI36X5xRJLm5JogrKg3TdNCirMJa
        0bW6pUKbBAwhAcin+TXw0el1Pfi1dF4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-M8S-mJHtMrSSGcfpdPIEUw-1; Sat, 29 Aug 2020 05:27:08 -0400
X-MC-Unique: M8S-mJHtMrSSGcfpdPIEUw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FA541074656
        for <stable@vger.kernel.org>; Sat, 29 Aug 2020 09:27:07 +0000 (UTC)
Received: from max.home.com (unknown [10.40.194.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A7CC1A268;
        Sat, 29 Aug 2020 09:27:03 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     cluster-devel@redhat.com
Cc:     Andreas Gruenbacher <agruenba@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] gfs2: Make sure we don't miss any delayed withdraws
Date:   Sat, 29 Aug 2020 11:26:56 +0200
Message-Id: <20200829092656.1173430-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit ca399c96e96e changes gfs2_log_flush to not withdraw the
filesystem while holding the log flush lock, but it fails to check if
the filesystem needs to be withdrawn once the log flush lock has been
released.  Likewise, commit f05b86db314d depends on gfs2_log_flush to
trigger for delayed withdraws.  Add that and clean up the code flow
somewhat.

In gfs2_put_super, add a check for delayed withdraws that have been
missed to prevent these kinds of bugs in the future.

Fixes: ca399c96e96e ("gfs2: flesh out delayed withdraw for gfs2_log_flush")
Fixes: f05b86db314d ("gfs2: Prepare to withdraw as soon as an IO error occurs in log write")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/log.c   | 61 +++++++++++++++++++++++++------------------------
 fs/gfs2/super.c |  2 ++
 fs/gfs2/util.h  | 10 ++++++++
 3 files changed, 43 insertions(+), 30 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 3763c9ff1406..93032feb5159 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -954,10 +954,8 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
 		goto out;
 
 	/* Log might have been flushed while we waited for the flush lock */
-	if (gl && !test_bit(GLF_LFLUSH, &gl->gl_flags)) {
-		up_write(&sdp->sd_log_flush_lock);
-		return;
-	}
+	if (gl && !test_bit(GLF_LFLUSH, &gl->gl_flags))
+		goto out;
 	trace_gfs2_log_flush(sdp, 1, flags);
 
 	if (flags & GFS2_LOG_HEAD_FLUSH_SHUTDOWN)
@@ -971,25 +969,25 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
 		if (unlikely (state == SFS_FROZEN))
 			if (gfs2_assert_withdraw_delayed(sdp,
 			       !tr->tr_num_buf_new && !tr->tr_num_databuf_new))
-				goto out;
+				goto out_withdraw;
 	}
 
 	if (unlikely(state == SFS_FROZEN))
 		if (gfs2_assert_withdraw_delayed(sdp, !sdp->sd_log_num_revoke))
-			goto out;
+			goto out_withdraw;
 	if (gfs2_assert_withdraw_delayed(sdp,
 			sdp->sd_log_num_revoke == sdp->sd_log_committed_revoke))
-		goto out;
+		goto out_withdraw;
 
 	gfs2_ordered_write(sdp);
 	if (gfs2_withdrawn(sdp))
-		goto out;
+		goto out_withdraw;
 	lops_before_commit(sdp, tr);
 	if (gfs2_withdrawn(sdp))
-		goto out;
+		goto out_withdraw;
 	gfs2_log_submit_bio(&sdp->sd_log_bio, REQ_OP_WRITE);
 	if (gfs2_withdrawn(sdp))
-		goto out;
+		goto out_withdraw;
 
 	if (sdp->sd_log_head != sdp->sd_log_flush_head) {
 		log_flush_wait(sdp);
@@ -1000,7 +998,7 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
 		log_write_header(sdp, flags);
 	}
 	if (gfs2_withdrawn(sdp))
-		goto out;
+		goto out_withdraw;
 	lops_after_commit(sdp, tr);
 
 	gfs2_log_lock(sdp);
@@ -1020,7 +1018,7 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
 		if (!sdp->sd_log_idle) {
 			empty_ail1_list(sdp);
 			if (gfs2_withdrawn(sdp))
-				goto out;
+				goto out_withdraw;
 			atomic_dec(&sdp->sd_log_blks_free); /* Adjust for unreserved buffer */
 			trace_gfs2_log_blocks(sdp, -1);
 			log_write_header(sdp, flags);
@@ -1033,27 +1031,30 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
 			atomic_set(&sdp->sd_freeze_state, SFS_FROZEN);
 	}
 
-out:
-	if (gfs2_withdrawn(sdp)) {
-		trans_drain(tr);
-		/**
-		 * If the tr_list is empty, we're withdrawing during a log
-		 * flush that targets a transaction, but the transaction was
-		 * never queued onto any of the ail lists. Here we add it to
-		 * ail1 just so that ail_drain() will find and free it.
-		 */
-		spin_lock(&sdp->sd_ail_lock);
-		if (tr && list_empty(&tr->tr_list))
-			list_add(&tr->tr_list, &sdp->sd_ail1_list);
-		spin_unlock(&sdp->sd_ail_lock);
-		ail_drain(sdp); /* frees all transactions */
-		tr = NULL;
-	}
-
+out_end:
 	trace_gfs2_log_flush(sdp, 0, flags);
+out:
 	up_write(&sdp->sd_log_flush_lock);
-
 	gfs2_trans_free(sdp, tr);
+	if (gfs2_withdrawing(sdp))
+		gfs2_withdraw(sdp);
+	return;
+
+out_withdraw:
+	trans_drain(tr);
+	/**
+	 * If the tr_list is empty, we're withdrawing during a log
+	 * flush that targets a transaction, but the transaction was
+	 * never queued onto any of the ail lists. Here we add it to
+	 * ail1 just so that ail_drain() will find and free it.
+	 */
+	spin_lock(&sdp->sd_ail_lock);
+	if (tr && list_empty(&tr->tr_list))
+		list_add(&tr->tr_list, &sdp->sd_ail1_list);
+	spin_unlock(&sdp->sd_ail_lock);
+	ail_drain(sdp); /* frees all transactions */
+	tr = NULL;
+	goto out_end;
 }
 
 /**
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 9f4d9e7be839..19add2da1013 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -702,6 +702,8 @@ static void gfs2_put_super(struct super_block *sb)
 		if (error)
 			gfs2_io_error(sdp);
 	}
+	WARN_ON(gfs2_withdrawing(sdp));
+
 	/*  At this point, we're through modifying the disk  */
 
 	/*  Release stuff  */
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index 6d9157efe16c..d7562981b3a0 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -205,6 +205,16 @@ static inline bool gfs2_withdrawn(struct gfs2_sbd *sdp)
 		test_bit(SDF_WITHDRAWING, &sdp->sd_flags);
 }
 
+/**
+ * gfs2_withdrawing - check if a withdraw is pending
+ * @sdp: the superblock
+ */
+static inline bool gfs2_withdrawing(struct gfs2_sbd *sdp)
+{
+	return test_bit(SDF_WITHDRAWING, &sdp->sd_flags) &&
+	       !test_bit(SDF_WITHDRAWN, &sdp->sd_flags);
+}
+
 #define gfs2_tune_get(sdp, field) \
 gfs2_tune_get_i(&(sdp)->sd_tune, &(sdp)->sd_tune.field)
 
-- 
2.26.2

