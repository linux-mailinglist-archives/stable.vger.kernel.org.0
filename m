Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2F31ACB73
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896448AbgDPPqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896278AbgDPNeN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:34:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3F2321D91;
        Thu, 16 Apr 2020 13:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044052;
        bh=wJXOZl+ixkbPRgJjZxF3oXta4L06YJHzvoNUdlWUwnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BZX87Xzq8u6WS851cACsWjUd43/Q65PqDOfVHOvj06CnSPllivi4MGdxr6A2eUxno
         oWONtR8hf148XDJoabV/g8p5gC/k+MykmrZjUtUgP6xBrOJ45KhliHkQfk1YY/5yCL
         lpaxwre0XJiXuenMgby54GUUMe5sFJdgjNvmX7Lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 060/257] gfs2: Do log_flush in gfs2_ail_empty_gl even if ail list is empty
Date:   Thu, 16 Apr 2020 15:21:51 +0200
Message-Id: <20200416131333.449922533@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4ede1f18de85e..41542ef428f1a 100644
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
index eb3f2e7b80856..99b33c6f84404 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -516,7 +516,7 @@ static void log_pull_tail(struct gfs2_sbd *sdp, unsigned int new_tail)
 }
 
 
-static void log_flush_wait(struct gfs2_sbd *sdp)
+void log_flush_wait(struct gfs2_sbd *sdp)
 {
 	DEFINE_WAIT(wait);
 
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index 2ff163a8dce1f..76cb79f225996 100644
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



