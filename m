Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC981F2C3A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgFIAWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729812AbgFHXRf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:17:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E936920884;
        Mon,  8 Jun 2020 23:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658255;
        bh=7bdL3LfbgQTpB6p9+mW/YgtWkBdHWnz5N5/nrRUeYB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ah3zpBFn7+Wy7moVnddJCgKY5jWI96oduPPOEeyepoWWwnmRixfB0V5EGBC5HB33q
         wT7TIMw40YNrv6/oBw74MoyRiqcP+8LRzalaI07w2PVYtA9cdEOc5c9BpDNYrStkUF
         UWLmiJaeHx0l0yKOgwMqeons2JtX6pqZUq8Y0MTE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.6 264/606] gfs2: Grab glock reference sooner in gfs2_add_revoke
Date:   Mon,  8 Jun 2020 19:06:29 -0400
Message-Id: <20200608231211.3363633-264-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
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
index 60d911e293e6..2674feda1d7a 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -603,13 +603,13 @@ void gfs2_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
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

