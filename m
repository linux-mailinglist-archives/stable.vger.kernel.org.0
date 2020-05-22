Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06951DE9D0
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730872AbgEVOvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730528AbgEVOu7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:50:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D141221FF;
        Fri, 22 May 2020 14:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159058;
        bh=Wf9/1WeOqSaAptubgs0TD76hXWpfBaHk8chnXJyMlV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/U5zy4x0dya+w+r1nMndq925yZokslJLwiyD2b7PitpvfChUHKZFWPmFpY42b7N5
         8rG3LUpLDCB6WzUGT4dWrB+sL4aEeS57JZ91yYApe4tT5CbxhuggyFPRBPRgOJqYPS
         a1iMOoIpi/3w0Yuv5+0+kKNW5iFh0+oXpR+fx+Y4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.4 12/32] gfs2: Grab glock reference sooner in gfs2_add_revoke
Date:   Fri, 22 May 2020 10:50:24 -0400
Message-Id: <20200522145044.434677-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522145044.434677-1-sashal@kernel.org>
References: <20200522145044.434677-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit f4e2f5e1a527ce58fc9f85145b03704779a3123e ]

This patch rearranges gfs2_add_revoke so that the extra glock
reference is added earlier on in the function to avoid races in which
the glock is freed before the new reference is taken.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/log.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 47bc27d4169e..110e5c4db819 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -598,13 +598,13 @@ void gfs2_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 	struct buffer_head *bh = bd->bd_bh;
 	struct gfs2_glock *gl = bd->bd_gl;
 
+	sdp->sd_log_num_revoke++;
+	if (atomic_inc_return(&gl->gl_revokes) == 1)
+		gfs2_glock_hold(gl);
 	bh->b_private = NULL;
 	bd->bd_blkno = bh->b_blocknr;
 	gfs2_remove_from_ail(bd); /* drops ref on bh */
 	bd->bd_bh = NULL;
-	sdp->sd_log_num_revoke++;
-	if (atomic_inc_return(&gl->gl_revokes) == 1)
-		gfs2_glock_hold(gl);
 	set_bit(GLF_LFLUSH, &gl->gl_flags);
 	list_add(&bd->bd_list, &sdp->sd_log_revokes);
 }
-- 
2.25.1

