Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFBD2C0921
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387621AbgKWNE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:04:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387623AbgKWMvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:51:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0DB52100A;
        Mon, 23 Nov 2020 12:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135871;
        bh=oJl4LG6MQ2OIRsEDrx9esLEGbQrlRGi1v558KYZP3E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jlsms4L8Q+KHnOVm13Jmn1b2DVxUly7mynkSrEO11Ci/6JCG914vCIL15DiE2FJ6U
         T+zd8fc/u8GgymEG6UZtLN6GyXJeHnrSGRkOct5JvTnPBFvfAMp0rAZgaDyxl86ZEz
         iZyvzExIP3jOIi93h2dk1ZD8v0W1Y6L/sNzyRtRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.9 226/252] gfs2: Fix regression in freeze_go_sync
Date:   Mon, 23 Nov 2020 13:22:56 +0100
Message-Id: <20201123121846.483670194@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

commit 20b329129009caf1c646152abe09b697227e1c37 upstream.

Patch 541656d3a513 ("gfs2: freeze should work on read-only mounts") changed
the check for glock state in function freeze_go_sync() from "gl->gl_state
== LM_ST_SHARED" to "gl->gl_req == LM_ST_EXCLUSIVE".  That's wrong and it
regressed gfs2's freeze/thaw mechanism because it caused only the freezing
node (which requests the glock in EX) to queue freeze work.

All nodes go through this go_sync code path during the freeze to drop their
SHared hold on the freeze glock, allowing the freezing node to acquire it
in EXclusive mode. But all the nodes must freeze access to the file system
locally, so they ALL must queue freeze work. The freeze_work calls
freeze_func, which makes a request to reacquire the freeze glock in SH,
effectively blocking until the thaw from the EX holder. Once thawed, the
freezing node drops its EX hold on the freeze glock, then the (blocked)
freeze_func reacquires the freeze glock in SH again (on all nodes, including
the freezer) so all nodes go back to a thawed state.

This patch changes the check back to gl_state == LM_ST_SHARED like it was
prior to 541656d3a513.

Fixes: 541656d3a513 ("gfs2: freeze should work on read-only mounts")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/glops.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -540,7 +540,18 @@ static int freeze_go_sync(struct gfs2_gl
 	int error = 0;
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
 
-	if (gl->gl_req == LM_ST_EXCLUSIVE && !gfs2_withdrawn(sdp)) {
+	/*
+	 * We need to check gl_state == LM_ST_SHARED here and not gl_req ==
+	 * LM_ST_EXCLUSIVE. That's because when any node does a freeze,
+	 * all the nodes should have the freeze glock in SH mode and they all
+	 * call do_xmote: One for EX and the others for UN. They ALL must
+	 * freeze locally, and they ALL must queue freeze work. The freeze_work
+	 * calls freeze_func, which tries to reacquire the freeze glock in SH,
+	 * effectively waiting for the thaw on the node who holds it in EX.
+	 * Once thawed, the work func acquires the freeze glock in
+	 * SH and everybody goes back to thawed.
+	 */
+	if (gl->gl_state == LM_ST_SHARED && !gfs2_withdrawn(sdp)) {
 		atomic_set(&sdp->sd_freeze_state, SFS_STARTING_FREEZE);
 		error = freeze_super(sdp->sd_vfs);
 		if (error) {


