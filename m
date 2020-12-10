Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AE82D6000
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391367AbgLJOku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:40:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391328AbgLJOkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:40:43 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.9 66/75] gfs2: Dont freeze the file system during unmount
Date:   Thu, 10 Dec 2020 15:27:31 +0100
Message-Id: <20201210142609.277415349@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

commit f39e7d3aae2934b1cfdd209b54c508e2552e9531 upstream.

GFS2's freeze/thaw mechanism uses a special freeze glock to control its
operation. It does this with a sync glock operation (glops.c) called
freeze_go_sync. When the freeze glock is demoted (glock's do_xmote) the
glops function causes the file system to be frozen. This is intended. However,
GFS2's mount and unmount processes also hold the freeze glock to prevent other
processes, perhaps on different cluster nodes, from mounting the frozen file
system in read-write mode.

Before this patch, there was no check in freeze_go_sync for whether a freeze
in intended or whether the glock demote was caused by a normal unmount.
So it was trying to freeze the file system it's trying to unmount, which
ends up in a deadlock.

This patch adds an additional check to freeze_go_sync so that demotes of the
freeze glock are ignored if they come from the unmount process.

Fixes: 20b329129009 ("gfs2: Fix regression in freeze_go_sync")
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/glops.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -551,7 +551,8 @@ static int freeze_go_sync(struct gfs2_gl
 	 * Once thawed, the work func acquires the freeze glock in
 	 * SH and everybody goes back to thawed.
 	 */
-	if (gl->gl_state == LM_ST_SHARED && !gfs2_withdrawn(sdp)) {
+	if (gl->gl_state == LM_ST_SHARED && !gfs2_withdrawn(sdp) &&
+	    !test_bit(SDF_NORECOVERY, &sdp->sd_flags)) {
 		atomic_set(&sdp->sd_freeze_state, SFS_STARTING_FREEZE);
 		error = freeze_super(sdp->sd_vfs);
 		if (error) {


