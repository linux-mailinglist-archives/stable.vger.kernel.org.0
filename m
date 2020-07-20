Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4008226893
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732447AbgGTQHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:07:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733200AbgGTQHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:07:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55CB42065E;
        Mon, 20 Jul 2020 16:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261264;
        bh=YMUZIXmRmQM73WiM2KMMidzDR/TgwbuvwyLlv6FKZMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v2+vL0bzUXvNcaQ+N8HUzYxhStq8N56xJJL38j1Ww306MUrZ8HjXKzrR1QhOANhsM
         q/ZWdLk7yRR04+Ga5CaQmHaYlcX89U3FF1KqoSw2tBd6jt6PQ30Iunuso8czVINmww
         wlvXJAtezy21oxNjRT1eTRVu3JhBk80q5jCL/wXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 054/244] gfs2: The freeze glock should never be frozen
Date:   Mon, 20 Jul 2020 17:35:25 +0200
Message-Id: <20200720152828.430187312@linuxfoundation.org>
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

[ Upstream commit c860f8ffbea8924de05a281b937128773d30a77c ]

Before this patch, some gfs2 code locked the freeze glock with LM_FLAG_NOEXP
(Do not freeze) flag, and some did not. We never want to freeze the freeze
glock, so this patch makes it consistently use LM_FLAG_NOEXP always.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/ops_fstype.c |  3 ++-
 fs/gfs2/super.c      | 16 +++++++++-------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index a2c0554a18901..6d18d2c91add2 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1140,7 +1140,8 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 		struct gfs2_holder freeze_gh;
 
 		error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED,
-					   GL_EXACT, &freeze_gh);
+					   LM_FLAG_NOEXP | GL_EXACT,
+					   &freeze_gh);
 		if (error) {
 			fs_err(sdp, "can't make FS RO: %d\n", error);
 			goto fail_per_node;
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 3bc76cf382fb9..160bb4598b48b 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -167,7 +167,8 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	if (error)
 		return error;
 
-	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED, GL_EXACT,
+	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED,
+				   LM_FLAG_NOEXP | GL_EXACT,
 				   &freeze_gh);
 	if (error)
 		goto fail_threads;
@@ -429,7 +430,7 @@ static int gfs2_lock_fs_check_clean(struct gfs2_sbd *sdp)
 	}
 
 	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_EXCLUSIVE,
-				   0, &sdp->sd_freeze_gh);
+				   LM_FLAG_NOEXP, &sdp->sd_freeze_gh);
 	if (error)
 		goto out;
 
@@ -612,14 +613,15 @@ int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 	    !gfs2_glock_is_locked_by_me(sdp->sd_freeze_gl)) {
 		if (!log_write_allowed) {
 			error = gfs2_glock_nq_init(sdp->sd_freeze_gl,
-						   LM_ST_SHARED,
-						   LM_FLAG_TRY | GL_EXACT,
+						   LM_ST_SHARED, LM_FLAG_TRY |
+						   LM_FLAG_NOEXP | GL_EXACT,
 						   &freeze_gh);
 			if (error == GLR_TRYFAILED)
 				error = 0;
 		} else {
 			error = gfs2_glock_nq_init(sdp->sd_freeze_gl,
-						   LM_ST_SHARED, GL_EXACT,
+						   LM_ST_SHARED,
+						   LM_FLAG_NOEXP | GL_EXACT,
 						   &freeze_gh);
 			if (error && !gfs2_withdrawn(sdp))
 				return error;
@@ -761,8 +763,8 @@ void gfs2_freeze_func(struct work_struct *work)
 	struct super_block *sb = sdp->sd_vfs;
 
 	atomic_inc(&sb->s_active);
-	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED, GL_EXACT,
-				   &freeze_gh);
+	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED,
+				   LM_FLAG_NOEXP | GL_EXACT, &freeze_gh);
 	if (error) {
 		fs_info(sdp, "GFS2: couldn't get freeze lock : %d\n", error);
 		gfs2_assert_withdraw(sdp, 0);
-- 
2.25.1



