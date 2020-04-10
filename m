Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3BE1A4107
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 06:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgDJDrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:47:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727435AbgDJDr3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:47:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13A1120BED;
        Fri, 10 Apr 2020 03:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490449;
        bh=ILaFXLncLtlLJvpqxOT469RMpi89TpLFQOQJW2lRpX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EooPDU66mAwsF1Jm8H/YyupjN0pvY0Z+PozWp++QSUVSVPy/gyi8HuVhVHGnOLdf2
         u1c8ncOMhoWJe291zQxYq1SnVBLwPDq0zrwcReDxGtKjJ9OeyW7RoqKja3Ij5GIiac
         c/+SXv0H4ZXjHQ8QcdQ37pSQahlnfzc8Se9cr41g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.6 45/68] gfs2: Do log_flush in gfs2_ail_empty_gl even if ail list is empty
Date:   Thu,  9 Apr 2020 23:46:10 -0400
Message-Id: <20200410034634.7731-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034634.7731-1-sashal@kernel.org>
References: <20200410034634.7731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 9ff78289356af640941bbb0dd3f46af2063f0046 ]

Before this patch, if gfs2_ail_empty_gl saw there was nothing on
the ail list, it would return and not flush the log. The problem
is that there could still be a revoke for the rgrp sitting on the
sd_log_le_revoke list that's been recently taken off the ail list.
But that revoke still needs to be written, and the rgrp_go_inval
still needs to call log_flush_wait to ensure the revokes are all
properly written to the journal before we relinquish control of
the glock to another node. If we give the glock to another node
before we have this knowledge, the node might crash and its journal
replayed, in which case the missing revoke would allow the journal
replay to replay the rgrp over top of the rgrp we already gave to
another node, thus overwriting its changes and corrupting the
file system.

This patch makes gfs2_ail_empty_gl still call gfs2_log_flush rather
than returning.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glops.c | 27 ++++++++++++++++++++++++++-
 fs/gfs2/log.c   |  2 +-
 fs/gfs2/log.h   |  1 +
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 061d22e1ceb6e..efc899a3876b4 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -89,8 +89,32 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 	INIT_LIST_HEAD(&tr.tr_databuf);
 	tr.tr_revokes = atomic_read(&gl->gl_ail_count);
 
-	if (!tr.tr_revokes)
+	if (!tr.tr_revokes) {
+		bool have_revokes;
+		bool log_in_flight;
+
+		/*
+		 * We have nothing on the ail, but there could be revokes on
+		 * the sdp revoke queue, in which case, we still want to flush
+		 * the log and wait for it to finish.
+		 *
+		 * If the sdp revoke list is empty too, we might still have an
+		 * io outstanding for writing revokes, so we should wait for
+		 * it before returning.
+		 *
+		 * If none of these conditions are true, our revokes are all
+		 * flushed and we can return.
+		 */
+		gfs2_log_lock(sdp);
+		have_revokes = !list_empty(&sdp->sd_log_revokes);
+		log_in_flight = atomic_read(&sdp->sd_log_in_flight);
+		gfs2_log_unlock(sdp);
+		if (have_revokes)
+			goto flush;
+		if (log_in_flight)
+			log_flush_wait(sdp);
 		return;
+	}
 
 	/* A shortened, inline version of gfs2_trans_begin()
          * tr->alloced is not set since the transaction structure is
@@ -105,6 +129,7 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 	__gfs2_ail_flush(gl, 0, tr.tr_revokes);
 
 	gfs2_trans_end(sdp);
+flush:
 	gfs2_log_flush(sdp, NULL, GFS2_LOG_HEAD_FLUSH_NORMAL |
 		       GFS2_LFC_AIL_EMPTY_GL);
 }
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 00a2e721a374f..08dd6a4302344 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -512,7 +512,7 @@ static void log_pull_tail(struct gfs2_sbd *sdp, unsigned int new_tail)
 }
 
 
-static void log_flush_wait(struct gfs2_sbd *sdp)
+void log_flush_wait(struct gfs2_sbd *sdp)
 {
 	DEFINE_WAIT(wait);
 
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index c0a65e5a126b6..c1cd6ae176597 100644
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -73,6 +73,7 @@ extern void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl,
 			   u32 type);
 extern void gfs2_log_commit(struct gfs2_sbd *sdp, struct gfs2_trans *trans);
 extern void gfs2_ail1_flush(struct gfs2_sbd *sdp, struct writeback_control *wbc);
+extern void log_flush_wait(struct gfs2_sbd *sdp);
 
 extern int gfs2_logd(void *data);
 extern void gfs2_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd);
-- 
2.20.1

