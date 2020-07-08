Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04DB218BE1
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730756AbgGHPms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730610AbgGHPmG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 11:42:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB9C7206DF;
        Wed,  8 Jul 2020 15:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594222926;
        bh=x3TI26fq0rdV96diUqs7jM7Bnoi9nSesyt0CbLUsbv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nGwqecUzCpIpjvEjuRoCZLchSNYikagyA4ydSCsz7td1Hd2IAP8c55O4dGIye4Y9P
         bbrbR4+jZlr5bU5E9+EwVohxX9OOBtMVjIPvqb0SENhMvqvAX7JnMjxaPEZF0XPOwB
         rdDz/4TtgT7H8uKj84z0kLhuQDMVAk/swSddQyTk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.19 7/8] gfs2: read-only mounts should grab the sd_freeze_gl glock
Date:   Wed,  8 Jul 2020 11:41:55 -0400
Message-Id: <20200708154157.3200116-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708154157.3200116-1-sashal@kernel.org>
References: <20200708154157.3200116-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit b780cc615ba4795a7ef0e93b19424828a5ad456a ]

Before this patch, only read-write mounts would grab the freeze
glock in read-only mode, as part of gfs2_make_fs_rw. So the freeze
glock was never initialized. That meant requests to freeze, which
request the glock in EX, were granted without any state transition.
That meant you could mount a gfs2 file system, which is currently
frozen on a different cluster node, in read-only mode.

This patch makes read-only mounts lock the freeze glock in SH mode,
which will block for file systems that are frozen on another node.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/ops_fstype.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index ed77b10bdfb53..9448c8461e576 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1160,7 +1160,17 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
 		goto fail_per_node;
 	}
 
-	if (!sb_rdonly(sb)) {
+	if (sb_rdonly(sb)) {
+		struct gfs2_holder freeze_gh;
+
+		error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED,
+					   GL_EXACT, &freeze_gh);
+		if (error) {
+			fs_err(sdp, "can't make FS RO: %d\n", error);
+			goto fail_per_node;
+		}
+		gfs2_glock_dq_uninit(&freeze_gh);
+	} else {
 		error = gfs2_make_fs_rw(sdp);
 		if (error) {
 			fs_err(sdp, "can't make FS RW: %d\n", error);
-- 
2.25.1

