Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79222266F3
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732942AbgGTQHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:07:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733186AbgGTQHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:07:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC8122176B;
        Mon, 20 Jul 2020 16:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261256;
        bh=0fFDi0+Ipj/zpLJvnaQzODqlbaLDzn5UKSX3MzJV4C4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkxWbEu5CGoIkpSAomYPyjMhLyx82/CqwwIQqnQWX4Rfk5HMINbUBctzjWBemJfVR
         yDxziYXhsxNkF/GMRgCI1z4TqGNZmu2xg30vR5bMn2W/aAlBfvkvwm9vvNJa0Hetv/
         IRhnpuDzQwwySgUKtToTIVr7TgdDb6LCmPboUZkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 051/244] gfs2: freeze should work on read-only mounts
Date:   Mon, 20 Jul 2020 17:35:22 +0200
Message-Id: <20200720152828.287841853@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 541656d3a5136ae830d604e237f29f406d42c592 ]

Before this patch, function freeze_go_sync, called when promoting
the freeze glock, was testing for the SDF_JOURNAL_LIVE superblock flag.
That's only set for read-write mounts. Read-only mounts don't use a
journal, so the bit is never set, so the freeze never happened.

This patch removes the check for SDF_JOURNAL_LIVE for freeze requests
but still checks it when deciding whether to flush a journal.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glops.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 9e9c7a4b8c663..fc97c4d24dc58 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -527,8 +527,7 @@ static int freeze_go_sync(struct gfs2_glock *gl)
 	int error = 0;
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
 
-	if (gl->gl_state == LM_ST_SHARED && !gfs2_withdrawn(sdp) &&
-	    test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags)) {
+	if (gl->gl_req == LM_ST_EXCLUSIVE && !gfs2_withdrawn(sdp)) {
 		atomic_set(&sdp->sd_freeze_state, SFS_STARTING_FREEZE);
 		error = freeze_super(sdp->sd_vfs);
 		if (error) {
@@ -541,8 +540,11 @@ static int freeze_go_sync(struct gfs2_glock *gl)
 			gfs2_assert_withdraw(sdp, 0);
 		}
 		queue_work(gfs2_freeze_wq, &sdp->sd_freeze_work);
-		gfs2_log_flush(sdp, NULL, GFS2_LOG_HEAD_FLUSH_FREEZE |
-			       GFS2_LFC_FREEZE_GO_SYNC);
+		if (test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags))
+			gfs2_log_flush(sdp, NULL, GFS2_LOG_HEAD_FLUSH_FREEZE |
+				       GFS2_LFC_FREEZE_GO_SYNC);
+		else /* read-only mounts */
+			atomic_set(&sdp->sd_freeze_state, SFS_FROZEN);
 	}
 	return 0;
 }
-- 
2.25.1



