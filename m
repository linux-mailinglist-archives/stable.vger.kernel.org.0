Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2E6404EC8
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244412AbhIIMOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:14:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345785AbhIIMLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:11:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76C5A619F5;
        Thu,  9 Sep 2021 11:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188121;
        bh=hBMpEcqTLqk1Iuuh/VqFCCsSi3SUvQ2kusH5coJhz90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bgbBSDbC+cWT12qEwqWN4sDjUw91z/BSfi42+gJHUguR1bzRd9XoNJOiNfvX3RrG+
         WfieFHKWpCUz+2fhMbAx2AB6ksJMKiOwTgG4jOTaSY9W9HaXosUNjky2qdToCBBpwq
         PiBzW7QDGcpVZcWtLKdIx4TB5KVjHe5ABmQHaJwD+DWSwNoOxClUH8KD816dXa5x/e
         Xn1KVs4/lVZ7/LlNn+wO8tY+DtsSdWi2WNM9zQnSSouHKtkY0mgQOEaHpA/Eg4diHj
         CKp3pSNmE3XAgsWtbWUwCRhpRVFK3kjB8A3Cxc6CWDXrwBSMAPEs+MshjMScaFbrhS
         2GnAZjvmGINsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.13 097/219] gfs2: Fix glock recursion in freeze_go_xmote_bh
Date:   Thu,  9 Sep 2021 07:44:33 -0400
Message-Id: <20210909114635.143983-97-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 9d9b16054b7d357afde69a027514c695092b0d22 ]

We must not call gfs2_consist (which does a file system withdraw) from
the freeze glock's freeze_go_xmote_bh function because the withdraw
will try to use the freeze glock, thus causing a glock recursion error.

This patch changes freeze_go_xmote_bh to call function
gfs2_assert_withdraw_delayed instead of gfs2_consist to avoid recursion.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glops.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 54d3fbeb3002..384565d63eea 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -610,16 +610,13 @@ static int freeze_go_xmote_bh(struct gfs2_glock *gl)
 		j_gl->gl_ops->go_inval(j_gl, DIO_METADATA);
 
 		error = gfs2_find_jhead(sdp->sd_jdesc, &head, false);
-		if (error)
-			gfs2_consist(sdp);
-		if (!(head.lh_flags & GFS2_LOG_HEAD_UNMOUNT))
-			gfs2_consist(sdp);
-
-		/*  Initialize some head of the log stuff  */
-		if (!gfs2_withdrawn(sdp)) {
-			sdp->sd_log_sequence = head.lh_sequence + 1;
-			gfs2_log_pointers_init(sdp, head.lh_blkno);
-		}
+		if (gfs2_assert_withdraw_delayed(sdp, !error))
+			return error;
+		if (gfs2_assert_withdraw_delayed(sdp, head.lh_flags &
+						 GFS2_LOG_HEAD_UNMOUNT))
+			return -EIO;
+		sdp->sd_log_sequence = head.lh_sequence + 1;
+		gfs2_log_pointers_init(sdp, head.lh_blkno);
 	}
 	return 0;
 }
-- 
2.30.2

