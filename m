Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E393291F1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243605AbhCAUhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:37:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:48400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239942AbhCAU31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:29:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A90326541D;
        Mon,  1 Mar 2021 18:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622080;
        bh=TFqIPdUDjPW5xQIl2D2AAy/slzU2IEd+9FSUAXhCuK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z8Y10B/jo/GdCaPOZWJGD5XD2ncypoqxl0gq6yZe/2Yh9Us6v/QDLURP8vLeWVQW7
         KGunasT4azHNWWkpqdYY+WZ6Lyp7Nd5y4oj1y4/CukFFhodat85IV4hZRUCSk04qDO
         IJTw67EmVv6IW4CKRPRGRVjUORLqijWYJ2vyA3zA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>
Subject: [PATCH 5.11 749/775] gfs2: fix glock confusion in function signal_our_withdraw
Date:   Mon,  1 Mar 2021 17:15:17 +0100
Message-Id: <20210301161238.321521605@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

commit f5f02fde9f52b2d769c1c2ddfd3d9c4a1fe739a7 upstream.

If go_free is defined, function signal_our_withdraw is supposed to
synchronize on the GLF_FREEING flag of the inode glock, but it
accidentally does that on the live glock. Fix that and disambiguate
the glock variables.

Fixes: 601ef0d52e96 ("gfs2: Force withdraw to replay journals and wait for it to finish")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/util.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -93,9 +93,10 @@ out_unlock:
 
 static void signal_our_withdraw(struct gfs2_sbd *sdp)
 {
-	struct gfs2_glock *gl = sdp->sd_live_gh.gh_gl;
+	struct gfs2_glock *live_gl = sdp->sd_live_gh.gh_gl;
 	struct inode *inode = sdp->sd_jdesc->jd_inode;
 	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_glock *i_gl = ip->i_gl;
 	u64 no_formal_ino = ip->i_no_formal_ino;
 	int ret = 0;
 	int tries;
@@ -141,7 +142,8 @@ static void signal_our_withdraw(struct g
 		atomic_set(&sdp->sd_freeze_state, SFS_FROZEN);
 		thaw_super(sdp->sd_vfs);
 	} else {
-		wait_on_bit(&gl->gl_flags, GLF_DEMOTE, TASK_UNINTERRUPTIBLE);
+		wait_on_bit(&i_gl->gl_flags, GLF_DEMOTE,
+			    TASK_UNINTERRUPTIBLE);
 	}
 
 	/*
@@ -161,15 +163,15 @@ static void signal_our_withdraw(struct g
 	 * on other nodes to be successful, otherwise we remain the owner of
 	 * the glock as far as dlm is concerned.
 	 */
-	if (gl->gl_ops->go_free) {
-		set_bit(GLF_FREEING, &gl->gl_flags);
-		wait_on_bit(&gl->gl_flags, GLF_FREEING, TASK_UNINTERRUPTIBLE);
+	if (i_gl->gl_ops->go_free) {
+		set_bit(GLF_FREEING, &i_gl->gl_flags);
+		wait_on_bit(&i_gl->gl_flags, GLF_FREEING, TASK_UNINTERRUPTIBLE);
 	}
 
 	/*
 	 * Dequeue the "live" glock, but keep a reference so it's never freed.
 	 */
-	gfs2_glock_hold(gl);
+	gfs2_glock_hold(live_gl);
 	gfs2_glock_dq_wait(&sdp->sd_live_gh);
 	/*
 	 * We enqueue the "live" glock in EX so that all other nodes
@@ -208,7 +210,7 @@ static void signal_our_withdraw(struct g
 		gfs2_glock_nq(&sdp->sd_live_gh);
 	}
 
-	gfs2_glock_queue_put(gl); /* drop the extra reference we acquired */
+	gfs2_glock_queue_put(live_gl); /* drop extra reference we acquired */
 	clear_bit(SDF_WITHDRAW_RECOVERY, &sdp->sd_flags);
 
 	/*


