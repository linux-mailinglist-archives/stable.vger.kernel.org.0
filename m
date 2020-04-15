Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE691AA44F
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408877AbgDOLe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408862AbgDOLes (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:34:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A70FB2076D;
        Wed, 15 Apr 2020 11:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950488;
        bh=KRZAghm7iDCJ9oOC4iVP6sgv81VCrYacbdcmBmkgHT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n9xY7nQWC5TtpoURT+5I89b4mXIe+bZeGl3YfBqAe22vB2S2Oyw7Tw4CaI9nOR88J
         p7cBLL6SfWl73zED+XgkdDAXXFwIhg1LBaFWkffNvUJTY11D10yh/A/t+EOY5TEJD+
         pESSGIZTKcrsyglWv/mk8smCgrnukRAahLXbmg3s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.6 002/129] gfs2: clear ail1 list when gfs2 withdraws
Date:   Wed, 15 Apr 2020 07:32:37 -0400
Message-Id: <20200415113445.11881-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 30fe70a85a909a23dcbc2c628ca6655b2c85e7a1 ]

This patch fixes a bug in which function gfs2_log_flush can get into
an infinite loop when a gfs2 file system is withdrawn. The problem
is the infinite loop "for (;;)" in gfs2_log_flush which would never
finish because the io error and subsequent withdraw prevented the
items from being taken off the ail list.

This patch tries to clean up the mess by allowing withdraw situations
to move not-in-flight buffer_heads to the ail2 list, where they will
be dealt with later.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/log.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 00a2e721a374f..d295d2a773314 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -104,16 +104,22 @@ __acquires(&sdp->sd_ail_lock)
 		gfs2_assert(sdp, bd->bd_tr == tr);
 
 		if (!buffer_busy(bh)) {
-			if (!buffer_uptodate(bh) &&
-			    !test_and_set_bit(SDF_AIL1_IO_ERROR,
+			if (buffer_uptodate(bh)) {
+				list_move(&bd->bd_ail_st_list,
+					  &tr->tr_ail2_list);
+				continue;
+			}
+			if (!test_and_set_bit(SDF_AIL1_IO_ERROR,
 					      &sdp->sd_flags)) {
 				gfs2_io_error_bh(sdp, bh);
 				*withdraw = true;
 			}
-			list_move(&bd->bd_ail_st_list, &tr->tr_ail2_list);
-			continue;
 		}
 
+		if (gfs2_withdrawn(sdp)) {
+			gfs2_remove_from_ail(bd);
+			continue;
+		}
 		if (!buffer_dirty(bh))
 			continue;
 		if (gl == bd->bd_gl)
@@ -862,6 +868,8 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
 				if (gfs2_ail1_empty(sdp))
 					break;
 			}
+			if (gfs2_withdrawn(sdp))
+				goto out;
 			atomic_dec(&sdp->sd_log_blks_free); /* Adjust for unreserved buffer */
 			trace_gfs2_log_blocks(sdp, -1);
 			log_write_header(sdp, flags);
@@ -874,6 +882,7 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
 			atomic_set(&sdp->sd_freeze_state, SFS_FROZEN);
 	}
 
+out:
 	trace_gfs2_log_flush(sdp, 0, flags);
 	up_write(&sdp->sd_log_flush_lock);
 
-- 
2.20.1

