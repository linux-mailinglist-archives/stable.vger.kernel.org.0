Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5192A525D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731474AbgKCUtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:49:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:41820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730350AbgKCUtM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:49:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E627F20719;
        Tue,  3 Nov 2020 20:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436551;
        bh=jBdtUyidvY7/tvRSy+a9k2ubj3BOvxHKOAruaIWL+qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IaAtMUPAfeKaYQSzLRQHcmjUL6U53ytPShxHW74qPIERcwUH/Ah1u3oCmxe72MSzx
         w1cnRUAuj/sVdrvL9K2Jh5Febx6KBuOReK6yTzTwqR+LsWrrqej+yy8wEiQglSJv0l
         5EpEsNc1oaDKRHdrdwL4ShOR6G9l4GVXASRP+BHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.9 298/391] gfs2: Make sure we dont miss any delayed withdraws
Date:   Tue,  3 Nov 2020 21:35:49 +0100
Message-Id: <20201103203407.188542811@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 5a61ae1402f15276ee4e003e198aab816958ca69 upstream.

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
Cc: stable@vger.kernel.org # v5.7+: 462582b99b607: gfs2: add some much needed cleanup for log flushes that fail
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/log.c   |   61 ++++++++++++++++++++++++++++----------------------------
 fs/gfs2/super.c |    2 +
 fs/gfs2/util.h  |   10 +++++++++
 3 files changed, 43 insertions(+), 30 deletions(-)

--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -954,10 +954,8 @@ void gfs2_log_flush(struct gfs2_sbd *sdp
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
@@ -971,25 +969,25 @@ void gfs2_log_flush(struct gfs2_sbd *sdp
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
@@ -1000,7 +998,7 @@ void gfs2_log_flush(struct gfs2_sbd *sdp
 		log_write_header(sdp, flags);
 	}
 	if (gfs2_withdrawn(sdp))
-		goto out;
+		goto out_withdraw;
 	lops_after_commit(sdp, tr);
 
 	gfs2_log_lock(sdp);
@@ -1020,7 +1018,7 @@ void gfs2_log_flush(struct gfs2_sbd *sdp
 		if (!sdp->sd_log_idle) {
 			empty_ail1_list(sdp);
 			if (gfs2_withdrawn(sdp))
-				goto out;
+				goto out_withdraw;
 			atomic_dec(&sdp->sd_log_blks_free); /* Adjust for unreserved buffer */
 			trace_gfs2_log_blocks(sdp, -1);
 			log_write_header(sdp, flags);
@@ -1033,27 +1031,30 @@ void gfs2_log_flush(struct gfs2_sbd *sdp
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
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -702,6 +702,8 @@ restart:
 		if (error)
 			gfs2_io_error(sdp);
 	}
+	WARN_ON(gfs2_withdrawing(sdp));
+
 	/*  At this point, we're through modifying the disk  */
 
 	/*  Release stuff  */
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -205,6 +205,16 @@ static inline bool gfs2_withdrawn(struct
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
 


