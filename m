Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301B8328B90
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239802AbhCAShY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:37:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:43158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234882AbhCAS3J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:29:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E3F46528D;
        Mon,  1 Mar 2021 17:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619944;
        bh=xOWbgxp3vEq+RDS7HFsY+tPWOzL+E97JnpPwj0+LSvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLkXqo2UCuRfWxJvHcDStf+qiq7tQQ1TnrciBJ1ycKPaGQvitdCGKOK4CYAqS3ta/
         Au4hrJlgK02bVP7cOCqSFgvwwGX7f/7QdP+aQ7dxpovzim6k9TmHaImcmkZEuXm9rP
         C3yXH6qMvE30F+C70VlpcFeoxeL9OB81J4KblCMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.10 638/663] gfs2: Dont skip dlm unlock if glock has an lvb
Date:   Mon,  1 Mar 2021 17:14:46 +0100
Message-Id: <20210301161213.422467223@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

commit 78178ca844f0eb88f21f31c7fde969384be4c901 upstream.

Patch fb6791d100d1 was designed to allow gfs2 to unmount quicker by
skipping the step where it tells dlm to unlock glocks in EX with lvbs.
This was done because when gfs2 unmounts a file system, it destroys the
dlm lockspace shortly after it destroys the glocks so it doesn't need to
unlock them all: the unlock is implied when the lockspace is destroyed
by dlm.

However, that patch introduced a use-after-free in dlm: as part of its
normal dlm_recoverd process, it can call ls_recovery to recover dead
locks. In so doing, it can call recover_rsbs which calls recover_lvb for
any mastered rsbs. Func recover_lvb runs through the list of lkbs queued
to the given rsb (if the glock is cached but unlocked, it will still be
queued to the lkb, but in NL--Unlocked--mode) and if it has an lvb,
copies it to the rsb, thus trying to preserve the lkb. However, when
gfs2 skips the dlm unlock step, it frees the glock and its lvb, which
means dlm's function recover_lvb references the now freed lvb pointer,
copying the freed lvb memory to the rsb.

This patch changes the check in gdlm_put_lock so that it calls
dlm_unlock for all glocks that contain an lvb pointer.

Fixes: fb6791d100d1 ("GFS2: skip dlm_unlock calls in unmount")
Cc: stable@vger.kernel.org # v3.8+
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/lock_dlm.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -284,7 +284,6 @@ static void gdlm_put_lock(struct gfs2_gl
 {
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
-	int lvb_needs_unlock = 0;
 	int error;
 
 	if (gl->gl_lksb.sb_lkid == 0) {
@@ -297,13 +296,10 @@ static void gdlm_put_lock(struct gfs2_gl
 	gfs2_sbstats_inc(gl, GFS2_LKS_DCOUNT);
 	gfs2_update_request_times(gl);
 
-	/* don't want to skip dlm_unlock writing the lvb when lock is ex */
-
-	if (gl->gl_lksb.sb_lvbptr && (gl->gl_state == LM_ST_EXCLUSIVE))
-		lvb_needs_unlock = 1;
+	/* don't want to skip dlm_unlock writing the lvb when lock has one */
 
 	if (test_bit(SDF_SKIP_DLM_UNLOCK, &sdp->sd_flags) &&
-	    !lvb_needs_unlock) {
+	    !gl->gl_lksb.sb_lvbptr) {
 		gfs2_glock_free(gl);
 		return;
 	}


